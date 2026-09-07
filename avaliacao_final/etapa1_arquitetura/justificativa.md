# 📋 Relatório da Avaliação Final
**Instituição:** UFC
**Curso:** Introdução à Análise em Big Data
**Professor responsável:** Luiz Alexandre Moreira Barros
**Aluno(a):** Paloma Musa Mendes Pereira
**Link do repositório:** https://github.com/Paloma-Musa/bigdata-ciencia-de-dados-aplicadas-a-negocios-paloma-musa.git

# Atividade Final

## 1. Arquitetura de Big Data

A arquitetura construida para o projeto da Techpay segue lógica simples que possiblita a execução facilitada. O primeiro passo é a identificação da origem das transações da TechPay, a empresa é uma fintech que processa transações via aplicativo(app), site(web), POS(pos) e caixas eletrônicos(atm). Essses dados sao armazendos em planilhas em formato CSV.

Para o processo de coleta e a transferência dos dados brutos para um sistema centralizado de armazenamento, camada de ingestão, foi escolhido o PySpark como ferramenta principal de ingestão e processamento por permitir trabalhar tanto localmente quanto em um ambiente distribuído. Dessa forma, o mesmo código pode ser adaptado de uma execução local para um cluster Spark caso o volume de dados aumente.

Uma alternativa para o PySpark é o Apache Kafka, mas por o projeto ser algo simples com apenas uma banco de dados estático e que possui como objetivo da implementação o batch, além de evitar adição de complexidade desneccessária ao ambiente,foi preferido o PySpark.

Foram descritas as camadas de processamento, a primeira camada é a camada Bronze onde os dados brutos são armazenados e possuem o formato de CSV é convertido para o foarto Parquet, formato colunar eficiente para armazenamento, compressão e consultas analíticas. 

O particionamento dos dados foi realizado por data, mais detalhado por mês, atributo "timestamp", este particionamento por mês é adequado porque consultas de risco frequentemente usam intervalos temporais. Um exmplo prático é a analise de fraudes ocorridas em mês específico do ano observado. "A área de risco deseja analisar todas as fraudes ocorridas durante março de 2025.". Com month=mm, o mecanismo pode usar partition pruning e evitar a leitura das demais partições. A granularidade deve ser equilibrada, isso porque partições pequenas demais podem gerar muitos arquivos e overhead, já partições grandes demais reduzem o benefício.

A segunda camada de processamento é a SILVER ela é usada para tratamento dos registros coletados em dados confiáveis, por tanto são realizados uam séria de processos como correção de tipos, tratamento de nulos e valores inválidos, remoção de duplicidades, padronização de categorias e  criação de atributos derivados como ano, mês, dia e hora

Por fim a camada de processamento GOLD, ela é responsável pela transformação do dado em informação útil para a área de negócios, evitando que o dashboard precise consultar milhões de registros individuais

Para a camada de serving local, foi usado o DuckDB, permite consultar as estruturas Gold com SQL. O Plotly constrói o dashboard para a diretoria.

Alguns pontos da estrutura podem apresentar falha se houver mudanças no conjunto de dados. A estrutura apresentada foi construida para o banco de dados a ser ultilizado no trabalho, arquivo gerado com o tanho de 30.000 registros conforme "N = 30_000" resgisto no código "generate_avaliacao_dataset.py". Alguns pontos de falha podem ser:

| Ponto | Problema ao escalar | Mitigação |
|----------|----------|----------|
| CSV | Arquivo grande e leitura menos eficiente | Parquet + compressão + particionamento |
| Memória do driver | collect() pode trazer muitos dados para a memória | Manter processamento distribuído no Spark |
| Dashboard | Consultar milhões de registros diretamente é lento | Dashboard consulta agregações Gold |
| Ingestão | Um único arquivo pode virar gargalo | Ingestão distribuída, como Kafka, em produção |


 Além da mudanças no banco de dados poderem causar falhas na estrutura é importante frizar que a estrutura desenhada é para o objetivo de  implementação de batch, no caso em que a empresa mude o objetivo desejado, para **detecção de fraude em tempo real**, a estrutura deveráser modificada, por tanto o diagrama não seria integralmente o apresentado.

Para fraude em tempo real, a arquitetura batch seria complementada por um fluxo de streaming. Uma possibilidade é usar Kafka, sugerido como alternaiva anteriormente, para receber eventos e Spark Structured Streaming para processá-los continuamente.
App / Web / POS / ATM
          |
          v
       [ Kafka ]
          |
          v
[ Spark Structured Streaming ]
          |
          +----------------------+
          |                      |  
          v                      v 
   Dados Silver/Gold        Motor de risco
                                  |
                             +----+----+
                             |         |
                             v         v
                          APROVAR   BLOQUEAR

Nesse cenário, o risco pode ser calculado no momento da transação, permitindo aprovar ou bloquear operações rapidamente. O histórico continua sendo armazenado para auditoria, análises e treinamento de modelos.
