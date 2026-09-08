# Etapa 2 — Big Data: Execução do Pipeline (TECHPAY)

## 1. Ingestão

A base `avaliacao_transactions.csv` foi gerada com o script `generate_avaliacao_dataset.py`, produzindo 30.000 transações com taxa de fraude geral de 2,50%, variando por canal (maior em `app`, 3,79%), por categoria de comerciante (maior em `viagem`, 5,32%) e por segmento de cliente (maior em `High-Risk`, 9,67%).

O arquivo foi movido para o HDFS através dos comandos `hadoop fs -mkdir -p` (criação da estrutura `/user/avaliacao/{raw,bronze,silver,gold}`) e `hadoop fs -put` (upload do CSV para `/user/avaliacao/raw/`). A escolha de manter a estrutura de pastas separada por camada segue a arquitetura definida na Etapa 1 (APP/WEB/POS/ATM → Sqoop → Raw → Bronze → Silver, com Hive orquestrando a transição Bronze→Silver).

## 2. Criação da tabela Raw

A tabela `raw_transactions` foi criada como **tabela externa** no Hive, com todas as colunas tipadas como `STRING`. Essa escolha é proposital: a camada Raw deve preservar o dado exatamente como chegou, sem qualquer conversão de tipo, permitindo reprocessar a partir da fonte original caso algum problema de tipagem seja identificado depois. O parâmetro `skip.header.line.count=1` remove o cabeçalho do CSV automaticamente, e a contagem confirmou 30.000 linhas — igual ao total gerado, validando que a ingestão não perdeu nem duplicou registros nessa etapa.

Um ponto técnico relevante: a coluna `timestamp` do CSV foi renomeada para `txn_timestamp` na definição da tabela, já que `timestamp` é palavra reservada no Hive. Como a tabela usa formato delimitado por posição (`ROW FORMAT DELIMITED FIELDS TERMINATED BY ','`), a renomeação não afeta a leitura dos dados — o que importa é a ordem das colunas, não o nome.

## 3. Particionamento

A estratégia de particionamento definida na Etapa 1 — partição mensal — foi aplicada a partir da camada Bronze em diante, usando uma coluna derivada `txn_month` no formato `yyyy-MM`, extraída de `txn_timestamp` com `date_format()`. A Raw não é particionada porque ainda não passou por conversão de tipos (o `timestamp` ainda é `STRING`), então o particionamento por mês só é aplicado a partir do momento em que o dado já está tipado corretamente, na Bronze.

## 4. Camada Bronze — limpeza

A camada Bronze aplicou três frentes de tratamento sobre a Raw:

1. **Tipagem**: conversão explícita de `STRING` para os tipos corretos (`INT`, `DECIMAL(12,2)`, `TIMESTAMP`, `BOOLEAN`), permitindo operações numéricas e temporais nas camadas seguintes.
2. **Deduplicação**: uso de `ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY txn_timestamp)`, mantendo apenas a primeira ocorrência de cada `transaction_id`. Isso trata o caso de o mesmo ID de transação aparecer mais de uma vez na fonte.
3. **Remoção de valores impossíveis**: descarte de registros com `amount` negativo, `risk_score` fora do intervalo 0–100, `credit_score` fora do intervalo 300–850 (faixa padrão de score de crédito), ou com campos-chave nulos (`transaction_id`, `customer_id`, `txn_timestamp`).

O resultado: a Bronze ficou com **27.940 linhas**, uma redução de 2.060 registros (aproximadamente 6,9% da base) em relação à Raw. Essa proporção é compatível com um dataset sintético que introduz sujeira proposital para fins de avaliação, e confirma que os filtros de limpeza estão de fato atuando sobre os dados — não apenas copiando a Raw sem alteração.

Os dados foram gravados em formato **Parquet**, particionados por `txn_month`, conforme a arquitetura definida.

## 5. Camada Silver — enriquecimento e padronização

A Silver partiu da Bronze (sem novos filtros — o número de linhas se manteve em 27.940, confirmando que essa camada não descarta dados, apenas os transforma) e aplicou:

- **Padronização de texto**: `LOWER(TRIM(...))` em `transaction_type`, `channel`, `merchant_category` e `status`, evitando inconsistências como `"App"` vs `"app"`. O campo `segment` recebeu uma padronização adicional via `CASE`/`LIKE`, normalizando variações de grafia para os três rótulos oficiais (`High-Risk`, `Premium`, `Standard`).
- **Duas colunas derivadas**, conforme pedido no enunciado:
  - `amount_range`: classifica o valor da transação em `baixo` (<50), `medio` (<500), `alto` (<2000) ou `muito_alto` (≥2000).
  - `day_period`: classifica o horário da transação em `manha`, `tarde`, `noite` ou `madrugada`, a partir da função `HOUR(txn_timestamp)`.

Essas duas colunas foram escolhidas porque agregam valor analítico direto às tabelas Gold seguintes — faixa de valor e período do dia são dimensões comuns em análises de comportamento transacional e de risco de fraude.

## 6. Camada Gold — agregações

Foram construídas três tabelas Gold, todas a partir da Silver, pensando no que a Etapa 3 provavelmente vai precisar (análise ou modelagem de fraude):

1. **`gold_fraud_by_channel_month`** (48 linhas — combinações de mês × canal): total de transações, contagem e taxa de fraude, ticket médio e score de risco médio, agrupados por mês e canal. Permite identificar se a fraude está concentrada em algum canal específico ou variando ao longo do tempo.
2. **`gold_segment_category_summary`** (18 linhas — 3 segmentos × 6 categorias): volume e valor total transacionado, ticket médio e taxa de fraude, agrupados por segmento de cliente e categoria de comerciante. Permite cruzar o perfil de risco do cliente com o tipo de compra.
3. **`gold_risk_profile_by_period`** (12 linhas — 4 períodos do dia × 3 faixas de score de crédito): taxa de fraude e score de risco médio, agrupados por período do dia e faixa de score de crédito. Essa tabela usa diretamente as colunas derivadas criadas na Silver (`day_period`) e uma nova faixa (`credit_score_range`), evidenciando o valor do enriquecimento feito na etapa anterior.

## 7. Resumo dos volumes por camada

| Camada | Linhas | Observação |
|---|---|---|
| Raw | 30.000 | Igual ao total gerado — nenhuma perda na ingestão |
| Bronze | 27.940 | -2.060 linhas (duplicatas + valores impossíveis) |
| Silver | 27.940 | Igual à Bronze — só enriquecimento, sem filtro |
| Gold (channel/mês) | 48 | Agregação |
| Gold (segmento/categoria) | 18 | Agregação |
| Gold (período/score) | 12 | Agregação |

## 8. Dificuldades encontradas

Durante a execução, o script foi colado diretamente no shell interativo do Hive (`hive>`) em vez de ser executado como arquivo (`hive -f`). Isso causou corrupção do texto colado — comandos de terminal se misturaram com o SQL, fazendo com que a criação da tabela Bronze falhasse silenciosamente, o que por sua vez deixou a Silver vazia (a tabela era criada, mas o `INSERT` que a povoa dependia da Bronze inexistente). O problema foi resolvido reescrevendo o script inteiro em um único bloco via `cat > arquivo.sql << 'EOF'` e executando-o de forma não interativa com `hive -f`, eliminando o risco de perda de texto no paste. A lição prática: pipelines Hive/SQL extensos devem sempre ser executados a partir de arquivo, nunca colados diretamente no prompt interativo.
