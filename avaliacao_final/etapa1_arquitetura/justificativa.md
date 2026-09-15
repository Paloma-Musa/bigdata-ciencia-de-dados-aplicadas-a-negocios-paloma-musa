# 📋 Relatório da Avaliação Final
**Instituição:** UFC

**Curso:** Introdução à Análise em Big Data

**Professor responsável:** Luiz Alexandre Moreira Barros

**Alunas:** Paloma Musa Mendes Pereira e Larissa Rocha Fonteles Vieira

**Link do repositório:** https://github.com/Paloma-Musa/bigdata-ciencia-de-dados-aplicadas-a-negocios-paloma-musa.git

# Atividade Final

## 1. Arquitetura de Big Data

A arquitetura construída para o projeto da TechPay segue uma lógica simples que possibilita a execução facilitada. O primeiro passo é a identificação da origem das transações. A TechPay é uma fintech que processa transações via aplicativo (app), site (web), POS (pos) e caixas eletrônicos (atm). Esses dados são armazenados em planilhas em formato CSV.

Para o processo de coleta e transferência dos dados brutos para um sistema centralizado de armazenamento (camada de ingestão), a origem dos dados é um arquivo CSV gerado a partir das transações da TechPay — não um banco de dados relacional. Por isso, a ingestão foi feita por cópia direta do arquivo para o HDFS, usando o comando hadoop fs -put, que move o CSV da máquina local para a camada raw do cluster. Após a ingestão, os dados brutos ficam armazenados na camada raw do HDFS, servindo de base para as camadas de processamento seguintes.

Uma alternativa mais robusta ao hadoop fs -put seria o uso de uma ferramenta de ingestão dedicada, como o Apache NiFi ou o Flume, que ofereceria esteira automatizada, monitoramento e reprocessamento em caso de falha. Contudo, como o projeto trabalha com uma carga única e estática de um arquivo CSV, essa complexidade adicional não se justifica — o hadoop fs -put é suficiente para o volume e a frequência de ingestão deste cenário, evitando overhead desnecessário no ambiente.

Descrevendo as camadas de processamento, a primeira é a camada Bronze, onde os dados brutos são armazenados e convertidos do formato CSV para Parquet, um formato colunar eficiente para armazenamento, compressão e consultas analíticas, usando o Hive como motor de transformação.

O particionamento dos dados foi realizado por data (atributo "timestamp"), mais detalhado por mês. Este particionamento mensal é adequado porque consultas de análise de risco frequentemente utilizam intervalos temporais. Um exemplo prático é a análise de fraudes ocorridas em um mês: "A área de risco deseja analisar todas as fraudes ocorridas durante março de 2025." Com month=mm, o mecanismo de busca executa o partition pruning, evitando a leitura desnecessária das demais partições. Vale ressaltar que a granularidade deve ser equilibrada: partições pequenas demais geram excesso de arquivos e overhead, enquanto partições grandes demais reduzem os benefícios do particionamento.

A segunda camada de processamento é a Silver, responsável pelo tratamento dos registros coletados para transformá-los em dados confiáveis. Nela, são executados processos como correção de tipos, tratamento de valores nulos e inválidos, remoção de duplicidades, padronização de categorias e criação de atributos derivados (como ano, mês, dia e hora), também via Hive.

Por fim, a camada de processamento Gold é responsável por transformar o dado em informação útil para a área de negócios, evitando que os dashboards precisem consultar milhões de registros individuais — essa camada concentra tabelas já agregadas.

Para a camada de serving, foi usado o Hive, permitindo consultar as estruturas da camada Gold via SQL diretamente sobre o HDFS, enquanto o Plotly constrói o dashboard para a diretoria a partir dos resultados dessas consultas.

Alguns pontos da estrutura podem apresentar falhas caso haja mudanças significativas no conjunto de dados. A arquitetura apresentada foi desenhada considerando o conjunto de dados do trabalho, gerado com 30.000 registros conforme a instrução N = 30_000 no código generate_avaliacao_dataset.py. Os principais pontos de atenção são:

| Ponto | Problema ao escalar | Mitigação |
|----------|----------|----------|
| CSV | Arquivo grande e leitura menos eficiente | Parquet + compressão + particionamento |
| Single-node HDFS | Sem replicação real, sem tolerância a falha de disco | Cluster com múltiplos DataNodes em produção |
| Dashboard | Consultar milhões de registros diretamente é lento | Dashboard consulta agregações Gold |
|Ingestão	| Uma cópia manual via HDFS CLI não escala nem se recupera de falhas sozinha | Ingestão automatizada e distribuída/incremental, como Kafka ou NiFi, em produção|

Além das alterações no volume de dados, é importante frisar que a estrutura atual atende ao objetivo de processamento em batch. Caso a empresa mude seu objetivo para **detecção de fraudes em tempo real**, a arquitetura precisará ser modificada e o diagrama não será exatamente o mesmo.

Para a detecção de fraudes em tempo real, a arquitetura em batch deve ser complementada por um fluxo de streaming. Uma solução viável é utilizar o Apache Kafka para o recebimento de eventos e o Spark Structured Streaming para o processamento contínuo:

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

Nesse cenário, o risco pode ser calculado no momento da transação, permitindo aprovar ou bloquear operações rapidamente, enquanto o histórico permanece armazenado para auditorias, análises retrospectivas e treinamento de modelos.
