# 📋 Relatório da Avaliação Final
**Instituição:** UFC

**Curso:** Introdução à Análise em Big Data

**Professor responsável:** Luiz Alexandre Moreira Barros

**Aluno(a):** Paloma Musa Mendes Pereira

**Link do repositório:** https://github.com/Paloma-Musa/bigdata-ciencia-de-dados-aplicadas-a-negocios-paloma-musa.git

# Atividade Final

## 2. Pipeline

Antecedendo a etapa de Ingestão do projeto foi gerada a base avaliacao_transactions.csv com o script generate_avaliacao_dataset.py, produzindo 30.000 transações com taxa de fraude geral de 2,50%, variando por canal (maior em app, 3,79%), por categoria de comerciante (maior em viagem, 5,32%) e por segmento de cliente (maior em High-Risk, 9,67%).

O arquivo foi movido para o HDFS, respeitando a estrutura de pastas separada por camada que segue a arquitetura definida na etapa 1 (APP/WEB/POS/ATM → HDFS CLI → Raw → Bronze → Silver, com Hive orquestrando a transição Bronze→Silver).

A tabela raw_transactions foi criada como tabela externa no Hive, com todas as colunas tipadas como STRING. A não tipagem na camada Raw é proposital, pois a preservação do dado exatamente como chegou, sem qualquer conversão de tipo, permite recuperar o dado a partir da fonte original caso algum problema de tipagem seja identificado depois na camada Bronze.

É importante pontuar que a coluna “timestamp” do CSV foi renomeada para “txn_timestamp” na definição da tabela, já que timestamp é palavra reservada no Hive. Como a tabela usa formato delimitado por posição, a renomeação não afeta a leitura dos dados, o que realmente importa é a ordem das colunas, não o nome.

Na etapa do particionamento foi aplicada a estratégia de particionamento mensal definida na etapa do diagrama, para isso foi criada uma coluna derivada “txn_month” no formato yyyy-MM, extraída de txn_timestamp, para ser usada como chave de partição a partir da camada Bronze. Isso porque a Raw passou por conversão de tipos, então o particionamento por mês só é aplicado a partir do momento em que o dado já está tipado corretamente, o que só acontece na camada Bronze.

A Camada Bronze é responsável pelo primeiro tratamento dos dados provenientes da camada Raw. Os dados brutos foram tipados, deduplicados e submetidos a regras básicas de validação, preparando-os assim para o processamento e enriquecimento nas camadas seguintes.

O primeiro tratamento realizado foi a tipagem, conversão dos tipos de dados, onde os valores originalmente armazenados como `STRING` foram convertidos para os tipos adequados, como inteiro, decimal, data e boolean. Em seguida, foi realizada a deduplicação das transações, uma remoção de possíveis registros duplicados, foi mantido apenas a primeira ocorrência de cada transação, considerando a ocorrência mais antiga como a transação original e as demais como possíveis duplicações decorrentes do processo de ingestão.

Também foram aplicadas regras para a remoção de valores impossíveis ou inválidos. Foram descartados registros que apresentassem `amount` negativo, `risk_score` fora do intervalo de 0 a 100, `credit_score` fora do intervalo de 300 a 900, além de registros com campos essenciais nulos, como `transaction_id`, `customer_id` e `txn_timestamp`.

Como resultado desses tratamentos, a base passou de 30.000 registros na Raw para 27.940 registros na Bronze. Portanto, 2.060 registros foram descartados, aproximadamente 6,9% da base original. Esses registros foram removidos por não atenderem às regras de qualidade definidas para a camada Bronze, seja por duplicidade, valores inválidos ou ausência de informações essenciais.

Após a limpeza, os dados foram armazenados em formato Parquet, organizados em partições pelo campo mês (“txn_month”). Essa estratégia facilitou o armazenamento e o processamento dos dados, permitindo que consultas que utilizem um determinado período possam acessar apenas as partições correspondentes.

A partir desse processo, a Bronze passa a representar uma versão mais confiável e estruturada dos dados originalmente recebidos na Raw. Na etapa seguinte, a **Camada Silver** utiliza os 27.940 registros restantes para realizar processos de padronização e enriquecimento, sem realizar novos descartes de registros.

A Camada Silver parte dos dados já tratados na Bronze sem realizar novos descartes, nessa camada foi realizada a padronização e enriquecimento das informações, preparando a base para as análises realizadas na Camada Gold.

O primeiro tratamento realizado foi a padronização dos campos de texto, onde foram aplicadas funções (`LOWER()` e `TRIM()`) nas colunas “transaction_type”, “channel”, “merchant_category” e “status”, para eliminar diferenças causadas por espaços desnecessários e variações de letras maiúsculas e minúsculas. Dessa forma, valores como as variações`"App"`, `"APP"` e `" app "` passam a ser escritos de uma maneira uniforme.

O campo `segment` recebeu um tratamento adicional. Como o dataset apresentava diferentes grafias ou variações de caixa para um mesmo grupo, foi utilizado um `CASE` combinado com `LIKE` para normalizar os valores e garantir que todos fossem representados por apenas três rótulos oficiais do domínio: **High-Risk, Premium e Standard**. Essa padronização evita que o mesmo segmento seja contabilizado como categorias diferentes durante as agregações realizadas posteriormente.

Além da padronização dos dados existentes, foram criadas duas novas colunas derivadas, como sugerido na orientação sobre o enriquecimento dos dados, “faixa de valor” (amount_range) e “período do dia” (day_period). 

A variável “faixa de valor” classifica o valor da transação em quatro faixas: `baixo` para valores menores que 50, `medio` para valores menores que 500, `alto` para valores menores que 2.000 e `muito_alto` para valores iguais ou superiores a 2.000. 

Já a variável “período do dia” classifica a transação de acordo com o horário em que ocorreu, utilizando a função `HOUR(txn_timestamp)`. Os registros são agrupados nos períodos `manha`, `tarde`, `noite` e `madrugada`.

A escolha dessas duas colunas derivadas foi feita considerando seu valor analítico para as etapas seguintes, especialmente para as análises relacionadas ao comportamento transacional e à detecção de possíveis fraudes. O horário da transação e o valor movimentado são dimensões que podem ajudar a identificar comportamentos fora do padrão. Por exemplo, uma transação de valor muito elevado ou realizada em um horário incomum pode apresentar características relevantes para uma análise de risco.

As colunas **`channel`** e **`merchant_category`** também foram mantidas na Silver, sendo apenas padronizadas. Essas variáveis possuem relevância direta para a análise de fraude realizada nas etapas anteriores. Foi identificado que a taxa de fraude varia significativamente entre os canais e também entre as categorias de comerciantes, com destaque para a categoria de `viagem`.

Portanto, remover “channel” ou “merchant_category” nessa etapa faria com que essas variáveis deixassem de estar disponíveis para as agregações da Camada Gold. Mantê-las na Silver permite posteriormente gerar métricas de fraude por canal, categoria de comerciante, faixa de valor e período do dia, possibilitando uma análise mais detalhada do comportamento das transações.

Como resultado, a Silver manteve os 27.940 registros provenientes da Bronze, sem novos filtros ou descartes. A principal transformação dessa camada foi a padronização dos dados existentes e a criação de novas dimensões analíticas, deixando a base estruturada para a construção das tabelas e indicadores da Camada Gold.

A Camada Gold é responsável por transformar os dados já padronizados e enriquecidos da Silver em **tabelas agregadas e orientadas à análise**. Foram construídas três tabelas Gold, todas derivadas da Silver, com foco nas necessidades da Etapa 3, especialmente nas análises e na possível modelagem para detecção de fraude.

A primeira tabela, **`gold_fraud_by_channel_month`**, possui **48 linhas**, correspondentes às combinações entre mês e canal. Ela apresenta o total de transações, a quantidade e a taxa de fraude, o ticket médio e o score de risco médio, agrupados por mês e canal. Essa agregação permite analisar **onde e quando a fraude está mais concentrada**, possibilitando identificar padrões temporais e diferenças de comportamento entre os canais de transação.

A segunda tabela, **`gold_segment_category_summary`**, possui **18 linhas**, resultantes da combinação de três segmentos de clientes com seis categorias de comerciantes. Ela reúne informações como volume de transações, valor total transacionado, ticket médio e taxa de fraude, agrupadas por segmento de cliente e categoria de comerciante. Essa visão permite analisar **quais combinações entre perfil de cliente e tipo de compra apresentam maior risco**, relacionando características do consumidor ao contexto da transação.

A terceira tabela, **`gold_risk_profile_by_period`**, possui **12 linhas**, correspondentes às combinações entre os quatro períodos do dia e três faixas de score de crédito. Ela apresenta a taxa de fraude e o score de risco médio para cada combinação. Essa tabela utiliza diretamente a coluna derivada `day_period`, criada na Silver, e também uma nova classificação denominada `credit_score_range`. Dessa forma, é possível analisar **como o horário da transação e o perfil de crédito se relacionam com a ocorrência de fraude**.

A escolha dessas três agregações foi feita para contemplar diferentes dimensões relevantes para a análise de risco: **tempo e canal de operação, perfil do cliente e comportamento relacionado ao crédito**. Em conjunto, elas permitem responder a perguntas diferentes sobre o comportamento das transações: em quais canais e períodos a fraude se concentra, quais perfis de clientes e categorias de comerciantes apresentam maior risco e quais combinações entre horário e score de crédito estão mais associadas à fraude.

Além de servirem para análises exploratórias e geração de indicadores, essas tabelas podem fornecer **variáveis agregadas potencialmente úteis como features para uma etapa posterior de modelagem de fraude**. A intenção, portanto, não foi apenas produzir números consolidados, mas organizar informações que possam contribuir para a identificação de padrões de comportamento e risco.

Durante a construção das tabelas Gold, também foi identificado um problema importante no processo. Em uma primeira tentativa, a Camada Silver estava vazia devido ao problema de paste corrompido ocorrido em uma etapa anterior. Como as tabelas Gold foram criadas utilizando `CREATE TABLE ... AS SELECT`, os comandos foram executados sem apresentar erro, porém as tabelas resultaram em **0 linhas**, pois a consulta de origem não possuía registros.

O problema só foi identificado após a realização de uma validação manual utilizando `COUNT(*)`. Esse caso demonstrou a importância de **validar o volume de dados entre as diferentes camadas da arquitetura**, pois a execução bem-sucedida de um comando não garante, por si só, que os dados tenham sido processados corretamente.

Após a correção da Silver e a nova execução das consultas, as três tabelas Gold passaram a apresentar os volumes esperados: **48 linhas em `gold_fraud_by_channel_month`, 18 linhas em `gold_segment_category_summary` e 12 linhas em `gold_risk_profile_by_period`**.

Assim, a arquitetura final estabelece um fluxo em que a Raw fornece os dados brutos, a Bronze realiza a limpeza e validação inicial, a Silver padroniza e enriquece os dados e a Gold os transforma em **informações agregadas e orientadas à análise**, deixando a estrutura preparada para a etapa de análise e modelagem de fraude.

