# 📋 Relatório da Avaliação Final
**Instituição:** UFC

**Curso:** Introdução à Análise em Big Data

**Professor responsável:** Luiz Alexandre Moreira Barros

**Aluno(a):** Paloma Musa Mendes Pereira

**Link do repositório:** https://github.com/Paloma-Musa/bigdata-ciencia-de-dados-aplicadas-a-negocios-paloma-musa.git

# Atividade Final

## 2. Pipeline

## 2.1. Ingestão

A base `avaliacao_transactions.csv` foi gerada com o script `generate_avaliacao_dataset.py`, produzindo 30.000 transações com taxa de fraude geral de 2,50%, variando por canal (maior em `app`, 3,79%), por categoria de comerciante (maior em `viagem`, 5,32%) e por segmento de cliente (maior em `High-Risk`, 9,67%).

O arquivo foi movido para o HDFS através dos comandos `hadoop fs -mkdir -p` (criação da estrutura `/user/avaliacao/{raw,bronze,silver,gold}`) e `hadoop fs -put` (upload do CSV para `/user/avaliacao/raw/`). A escolha de manter a estrutura de pastas separada por camada segue a arquitetura definida na Etapa 1 (APP/WEB/POS/ATM → Sqoop → Raw → Bronze → Silver, com Hive orquestrando a transição Bronze→Silver).

## 2.2. Criação da tabela Raw

A tabela `raw_transactions` foi criada como **tabela externa** no Hive, com todas as colunas tipadas como `STRING`. Essa escolha é proposital: a camada Raw deve preservar o dado exatamente como chegou, sem qualquer conversão de tipo, permitindo reprocessar a partir da fonte original caso algum problema de tipagem seja identificado depois. O parâmetro `skip.header.line.count=1` remove o cabeçalho do CSV automaticamente, e a contagem confirmou 30.000 linhas — igual ao total gerado, validando que a ingestão não perdeu nem duplicou registros nessa etapa.

Um ponto técnico relevante: a coluna `timestamp` do CSV foi renomeada para `txn_timestamp` na definição da tabela, já que `timestamp` é palavra reservada no Hive. Como a tabela usa formato delimitado por posição (`ROW FORMAT DELIMITED FIELDS TERMINATED BY ','`), a renomeação não afeta a leitura dos dados — o que importa é a ordem das colunas, não o nome.

## 2.3. Particionamento

A estratégia de particionamento definida na Etapa 1 — partição mensal — foi aplicada a partir da camada Bronze em diante, usando uma coluna derivada `txn_month` no formato `yyyy-MM`, extraída de `txn_timestamp` com `date_format()`. A Raw não é particionada porque ainda não passou por conversão de tipos (o `timestamp` ainda é `STRING`), então o particionamento por mês só é aplicado a partir do momento em que o dado já está tipado corretamente, na Bronze.

## 2.4. Camada Bronze — limpeza

A camada Bronze aplicou três frentes de tratamento sobre a Raw:

1. **Tipagem**: conversão explícita de `STRING` para os tipos corretos (`INT`, `DECIMAL(12,2)`, `TIMESTAMP`, `BOOLEAN`), permitindo operações numéricas e temporais nas camadas seguintes.
2. **Deduplicação**: uso de `ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY txn_timestamp)`, mantendo apenas a primeira ocorrência de cada `transaction_id`. Isso trata o caso de o mesmo ID de transação aparecer mais de uma vez na fonte.
3. **Remoção de valores impossíveis**: descarte de registros com `amount` negativo, `risk_score` fora do intervalo 0–100, `credit_score` fora do intervalo 300–850 (faixa padrão de score de crédito), ou com campos-chave nulos (`transaction_id`, `customer_id`, `txn_timestamp`).

O resultado: a Bronze ficou com **27.940 linhas**, uma redução de 2.060 registros (aproximadamente 6,9% da base) em relação à Raw. Essa proporção é compatível com um dataset sintético que introduz sujeira proposital para fins de avaliação, e confirma que os filtros de limpeza estão de fato atuando sobre os dados — não apenas copiando a Raw sem alteração.

Os dados foram gravados em formato **Parquet**, particionados por `txn_month`, conforme a arquitetura definida.

## 2.5. Camada Silver — enriquecimento e padronização

A Silver partiu da Bronze (sem novos filtros — o número de linhas se manteve em 27.940, confirmando que essa camada não descarta dados, apenas os transforma) e aplicou:

- **Padronização de texto**: `LOWER(TRIM(...))` em `transaction_type`, `channel`, `merchant_category` e `status`, evitando inconsistências como `"App"` vs `"app"`. O campo `segment` recebeu uma padronização adicional via `CASE`/`LIKE`, normalizando variações de grafia para os três rótulos oficiais (`High-Risk`, `Premium`, `Standard`).
- **Duas colunas derivadas**, conforme pedido no enunciado:
  - `amount_range`: classifica o valor da transação em `baixo` (<50), `medio` (<500), `alto` (<2000) ou `muito_alto` (≥2000).
  - `day_period`: classifica o horário da transação em `manha`, `tarde`, `noite` ou `madrugada`, a partir da função `HOUR(txn_timestamp)`.

Essas duas colunas foram escolhidas porque agregam valor analítico direto às tabelas Gold seguintes — faixa de valor e período do dia são dimensões comuns em análises de comportamento transacional e de risco de fraude.

## 2.6. Camada Gold — agregações

Foram construídas três tabelas Gold, todas a partir da Silver, pensando no que a Etapa 3 provavelmente vai precisar (análise ou modelagem de fraude):

1. **`gold_fraud_by_channel_month`** (48 linhas — combinações de mês × canal): total de transações, contagem e taxa de fraude, ticket médio e score de risco médio, agrupados por mês e canal. Permite identificar se a fraude está concentrada em algum canal específico ou variando ao longo do tempo.
2. **`gold_segment_category_summary`** (18 linhas — 3 segmentos × 6 categorias): volume e valor total transacionado, ticket médio e taxa de fraude, agrupados por segmento de cliente e categoria de comerciante. Permite cruzar o perfil de risco do cliente com o tipo de compra.
3. **`gold_risk_profile_by_period`** (12 linhas — 4 períodos do dia × 3 faixas de score de crédito): taxa de fraude e score de risco médio, agrupados por período do dia e faixa de score de crédito. Essa tabela usa diretamente as colunas derivadas criadas na Silver (`day_period`) e uma nova faixa (`credit_score_range`), evidenciando o valor do enriquecimento feito na etapa anterior.

## 2.7. Resumo dos volumes por camada

| Camada | Linhas | Observação |
|---|---|---|
| Raw | 30.000 | Igual ao total gerado — nenhuma perda na ingestão |
| Bronze | 27.940 | -2.060 linhas (duplicatas + valores impossíveis) |
| Silver | 27.940 | Igual à Bronze — só enriquecimento, sem filtro |
| Gold (channel/mês) | 48 | Agregação |
| Gold (segmento/categoria) | 18 | Agregação |
| Gold (período/score) | 12 | Agregação |

## 2.8. Dificuldades encontradas

Durante a execução, o script foi colado diretamente no shell interativo do Hive (`hive>`) em vez de ser executado como arquivo (`hive -f`). Isso causou corrupção do texto colado — comandos de terminal se misturaram com o SQL, fazendo com que a criação da tabela Bronze falhasse silenciosamente, o que por sua vez deixou a Silver vazia (a tabela era criada, mas o `INSERT` que a povoa dependia da Bronze inexistente). O problema foi resolvido reescrevendo o script inteiro em um único bloco via `cat > arquivo.sql << 'EOF'` e executando-o de forma não interativa com `hive -f`, eliminando o risco de perda de texto no paste. A lição prática: pipelines Hive/SQL extensos devem sempre ser executados a partir de arquivo, nunca colados diretamente no prompt interativo.









## 1. Ingestão

Essa etapa trouxe o arquivo `avaliacao_transactions.csv` (30.000 transações, geradas com taxa de fraude de 2,50%) do disco local para o HDFS, dentro da estrutura de pastas `/user/avaliacao/{raw,bronze,silver,gold}`. A decisão foi manter uma pasta por camada, separando fisicamente Raw de Bronze/Silver/Gold, o que facilita reprocessamento independente de cada etapa sem misturar dados de estágios diferentes. O problema real encontrado aqui foi de operação, não de dado: ao rodar os comandos Hive logo depois da ingestão, colei o script inteiro direto no prompt interativo (`hive>`), e o terminal misturou texto digitado com a saída de log em tempo real, corrompendo trechos do script. A solução foi recriar o arquivo `.sql` de forma limpa (usando um heredoc `cat > arquivo.sql << 'EOF'`) e executá-lo como arquivo (`hive -f`), nunca colando comando por comando dentro do prompt interativo.

## 2. Criação da tabela Raw

Essa etapa criou a tabela `raw_transactions` como tabela externa no Hive, apontando para o CSV já carregado no HDFS, com **todas as colunas tipadas como STRING**. A decisão de não tipar nada ainda na Raw foi proposital: essa camada deve preservar o dado exatamente como chegou da fonte, sem qualquer interpretação ou conversão — se depois eu perceber que interpretei um tipo errado na Bronze, ainda tenho a fonte intacta para reprocessar. O problema real aqui foi que a coluna `timestamp` do CSV é uma palavra reservada no Hive, e usá-la como nome de coluna quebra o `CREATE TABLE`; resolvi renomeando a coluna para `txn_timestamp` na definição da tabela — o que não afeta a leitura, já que a tabela é delimitada por posição (a ordem das colunas no `CREATE TABLE` precisa bater com a ordem do CSV, não o nome).

## 3. Particionamento

Essa etapa aplicou a estratégia de particionamento mensal definida na Etapa 1, criando a coluna derivada `txn_month` (formato `yyyy-MM`, extraída de `txn_timestamp`) e usando-a como chave de partição a partir da camada Bronze. A decisão foi não particionar a Raw: como lá o timestamp ainda é STRING (sem conversão), não faz sentido derivar uma partição de um campo ainda não confiável — o particionamento só entra depois que o dado já está tipado corretamente. O problema real foi habilitar partição dinâmica no Hive (por padrão ele exige que ao menos uma coluna de partição seja informada estaticamente); resolvi configurando `hive.exec.dynamic.partition.mode=nonstrict` antes dos `INSERT`, permitindo que o Hive decida sozinho, a partir do valor de `txn_month` de cada linha, em qual partição ela cai.

## 4. Camada Bronze — limpeza

Essa etapa converteu os tipos (`STRING` → `INT`/`DECIMAL`/`TIMESTAMP`/`BOOLEAN`), removeu duplicatas e descartou valores impossíveis, gravando o resultado em Parquet particionado por mês. A decisão de deduplicação foi manter apenas a primeira ocorrência de cada `transaction_id` (usando `ROW_NUMBER()` ordenado por timestamp), assumindo que a ocorrência mais antiga é a transação original e qualquer repetição posterior é ruído de ingestão. Para valores impossíveis, defini como regra: `amount` não pode ser negativo, `risk_score` precisa estar entre 0 e 100 (escala do próprio score) e `credit_score` entre 300 e 850 (faixa padrão de score de crédito usada no mercado). O problema real encontrado foi justamente esse: o dataset sintético contém, de propósito, uma quantidade de registros fora dessas faixas — a Bronze descartou 2.060 linhas (30.000 → 27.940, cerca de 6,9% da base), confirmando que a sujeira estava lá e que os filtros funcionaram.

## 5. Camada Silver — enriquecimento e padronização

Essa etapa padronizou texto (removendo variações de caixa e espaços em `transaction_type`, `channel`, `merchant_category`, `status` e `segment`) e criou duas colunas derivadas: `amount_range` (faixa de valor: baixo/médio/alto/muito alto) e `day_period` (período do dia: manhã/tarde/noite/madrugada, a partir da hora do timestamp). A decisão de escolher essas duas colunas — em vez de outras possíveis — foi pensando em dimensões que costumam se relacionar com risco de fraude: horário incomum e valor fora do padrão são sinais clássicos em detecção de fraude transacional. Sobre `channel` e `merchant_category`: **ambas as colunas foram mantidas na Silver**, apenas padronizadas (`lower`/`trim`), porque são justamente as dimensões que a Etapa 1 já identificou como as que mais variam a taxa de fraude (canal `app` e categoria `viagem` concentram os maiores percentuais) — descartá-las na Silver inviabilizaria qualquer agregação por canal ou categoria na Gold. O problema real aqui foi de inconsistência de rótulo, não de tipo: o campo `segment` continha grafias variadas para o mesmo grupo (ex.: variações de caixa em "High-Risk"); resolvi com um `CASE`/`LIKE` que normaliza para os três rótulos oficiais do domínio (`High-Risk`, `Premium`, `Standard`). O total de linhas na Silver se manteve igual ao da Bronze (27.940), confirmando que essa camada só transforma, não filtra.

## 6. Camada Gold — agregações

Essa etapa criou três tabelas agregadas a partir da Silver, todas pensando no que a Etapa 3 provavelmente vai precisar (análise ou modelagem de detecção de fraude): `gold_fraud_by_channel_month` (taxa de fraude, ticket médio e score de risco médio por mês e canal — 48 linhas), `gold_segment_category_summary` (volume, valor total, ticket médio e taxa de fraude por segmento de cliente e categoria de comerciante — 18 linhas) e `gold_risk_profile_by_period` (taxa de fraude e score de risco médio por período do dia e faixa de score de crédito — 12 linhas). A decisão de escolher essas três combinações de dimensões — canal×mês, segmento×categoria, período×score de crédito — foi para cobrir três ângulos diferentes de análise de risco (temporal/operacional, perfil de cliente, e comportamento de crédito), já que a Etapa 3 precisa de variáveis agregadas que sirvam como possíveis features para um modelo de fraude, não apenas números soltos por transação. O problema real aqui foi mais sutil: como as tabelas Gold dependem da Silver, na primeira tentativa em que a Silver ficou vazia (por causa do problema de paste corrompido descrito na etapa 1), as três Gold foram criadas com 0 linhas sem erro aparente — o `CREATE TABLE ... AS SELECT` simplesmente gerou uma tabela vazia, sem lançar exceção. Só percebi o problema ao conferir o `COUNT(*)` manualmente, o que reforça a importância de sempre validar volumes entre camadas, e não assumir sucesso só porque o comando não deu erro.

## Perguntas específicas

**1. Quantas linhas sobreviveram da Bronze em diante? Alguma foi descartada — por quê?**
Da Raw (30.000 linhas) para a Bronze, sobreviveram **27.940 linhas** — foram descartadas **2.060 linhas** (≈6,9%) por dois motivos: (a) duplicatas de `transaction_id` (mantida apenas a primeira ocorrência) e (b) valores fora de faixas fisicamente/logicamente possíveis (`amount` negativo, `risk_score` fora de 0–100, `credit_score` fora de 300–850, ou campos-chave nulos). Da Bronze para a Silver não houve mais descarte — as 27.940 linhas se mantiveram, já que a Silver só enriquece e padroniza, não filtra.

**2. Sua Silver layer usa as colunas `channel` e `merchant_category`? Justifique.**
Sim, as duas colunas foram mantidas na Silver (com padronização de texto, mas sem serem descartadas). A justificativa é que ambas são dimensões-chave de análise de fraude já identificadas na Etapa 1: a taxa de fraude varia de forma relevante entre canais (`app` tem quase o triplo da taxa de `pos`) e entre categorias de comerciante (`viagem` tem mais que o dobro da média geral). Remover essas colunas na Silver impediria qualquer agregação por canal ou categoria nas tabelas Gold, que são justamente as análises mais úteis para a Etapa 3.

**3. Que agregações você colocou na Gold, e por que essas?**
Três: (1) fraude e ticket médio por **canal × mês**, respondendo "onde e quando a fraude está concentrada operacionalmente"; (2) volume, valor e fraude por **segmento de cliente × categoria de comerciante**, respondendo "que perfil de cliente combinado com que tipo de compra tem mais risco"; e (3) risco e fraude por **período do dia × faixa de score de crédito**, respondendo "que combinação de horário e histórico de crédito é mais associada a fraude". As três foram escolhidas para dar à Etapa 3 candidatas a features agregadas (não apenas dados brutos por transação) cobrindo os três eixos mais relevantes para um modelo de fraude: tempo/canal, perfil de cliente, e comportamento de crédito.
