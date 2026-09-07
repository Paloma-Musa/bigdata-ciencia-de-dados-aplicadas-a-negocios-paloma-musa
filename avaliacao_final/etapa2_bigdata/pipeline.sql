-- ================================================================================
-- Rodando o código para gerar o arquivo CSV com os dados
-- ================================================================================

python3 generate_avaliacao_dataset.py

-- palomamusa@DESKTOP-NJ8QT5E:~$ python3 generate_avaliacao_dataset.py
-- Gerando base de dados da avaliação...
-- ✓ 30000 linhas geradas
--   Taxa de fraude geral: 2.50%
--   Fraude por channel:
-- channel
-- app    3.79%
-- atm    1.80%
-- web    1.74%
-- pos    1.42%
-- Name: is_fraud, dtype: str
--   Fraude por merchant_category:
-- merchant_category
-- viagem         5.32%
-- saude          2.47%
-- alimentacao    2.31%
-- varejo         2.24%
-- servicos       1.97%
-- eletronico     1.96%
-- Name: is_fraud, dtype: str
--   Fraude por segmento:
-- segment
-- High-Risk    9.67%
-- Standard     2.93%
-- Premium      0.95%
-- Name: is_fraud, dtype: str

-- ================================================================================
-- Localizando o arquivo
-- ================================================================================

ls -la /tmp/avaliacao_transactions.csv

-- palomamusa@DESKTOP-NJ8QT5E:~$ ls -la /tmp/avaliacao_transactions.csv
-- -rw-r--r-- 1 palomamusa palomamusa 2742011 Sep  7 17:40 /tmp/avaliacao_transactions.csv

-- ================================================================================
-- Movendo o CSV pra a home
-- 1. **Ingestão** — trazer `avaliacao_transactions.csv` para o ambiente (HDFS ou pasta local)
-- ================================================================================

mv /tmp/avaliacao_transactions.csv ~/
ls -la ~/avaliacao_transactions.csv

-- palomamusa@DESKTOP-NJ8QT5E:~$ mv /tmp/avaliacao_transactions.csv ~/
-- palomamusa@DESKTOP-NJ8QT5E:~$ ls -la ~/avaliacao_transactions.csv
-- -rw-r--r-- 1 palomamusa palomamusa 2742011 Sep  7 17:40 /home/palomamusa/avaliacao_transactions.csv

-- ================================================================================
-- Criando os diretórios raw, bronze, silver e gold no HDFS.
-- ================================================================================

hadoop fs -mkdir -p /user/avaliacao/raw
hadoop fs -mkdir -p /user/avaliacao/bronze
hadoop fs -mkdir -p /user/avaliacao/silver
hadoop fs -mkdir -p /user/avaliacao/gold

-- palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -mkdir -p /user/avaliacao/raw
-- palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -mkdir -p /user/avaliacao/bronze
-- palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -mkdir -p /user/avaliacao/silver
-- palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -mkdir -p /user/avaliacao/gold

-- ================================================================================
-- Subindo o CSV pra camada raw
-- ================================================================================

cd ~
hadoop fs -put avaliacao_transactions.csv /user/avaliacao/raw/

palomamusa@DESKTOP-NJ8QT5E:~$ cd ~
palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -put avaliacao_transactions.csv /user/avaliacao/raw/

-- ================================================================================
-- Conferindo se o arquivo subiu
-- ================================================================================

hadoop fs -ls -R /user/avaliacao

-- palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -ls -R /user/avaliacao
-- drwxr-xr-x   - palomamusa supergroup          0 2026-09-07 19:22 /user/avaliacao/bronze
-- drwxr-xr-x   - palomamusa supergroup          0 2026-09-07 19:23 /user/avaliacao/gold
-- drwxr-xr-x   - palomamusa supergroup          0 2026-09-07 19:23 /user/avaliacao/raw
-- -rw-r--r--   1 palomamusa supergroup    2742011 2026-09-07 19:23 /user/avaliacao/raw/avaliacao_transactions.csv
-- drwxr-xr-x   - palomamusa supergroup          0 2026-09-07 19:22 /user/avaliacao/silver


-- ================================================================================
-- Entrando no ambiente SQL
-- ================================================================================
hive
-- palomamusa@DESKTOP-NJ8QT5E:~$ hive

-- ================================================================================
-- 2. **Criação de tabela raw** — schema definido, tipos corretos
-- Fonte: avaliacao_transactions.csv (30.000 linhas)
-- Colunas: transaction_id, customer_id, amount, transaction_type, channel,
--          merchant_category, timestamp, status, risk_score, segment,
--          credit_score, is_fraud
-- ================================================================================

CREATE DATABASE IF NOT EXISTS avaliacao_techpay;
USE avaliacao_techpay;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.dynamic.partition=true;

-- ================================================================================
-- RAW - tabela externa apontando pro CSV cru no HDFS
-- ================================================================================
DROP TABLE IF EXISTS raw_transactions;

CREATE EXTERNAL TABLE raw_transactions (
    transaction_id     STRING,   -- fica STRING na raw: preserva o dado exatamente como chegou
    customer_id        STRING,
    amount             STRING,
    transaction_type   STRING,
    channel            STRING,
    merchant_category  STRING,
    txn_timestamp      STRING,
    status             STRING,
    risk_score         STRING,
    segment            STRING,
    credit_score       STRING,
    is_fraud           STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/avaliacao/raw/'
TBLPROPERTIES ("skip.header.line.count"="1");

-- ================================================================================
-- Camada Bronze - dados brutos preservados, mas já tipados, deduplicados e
-- sem valores impossíveis. Particionado por mês (txn_month = yyyy-MM).
-- Formato parquet, conforme arquitetura da Etapa 1.
-- ================================================================================
DROP TABLE IF EXISTS bronze_transactions;

CREATE TABLE bronze_transactions (
    transaction_id     INT,
    customer_id        INT,
    amount              DECIMAL(12,2),
    transaction_type   STRING,
    channel            STRING,
    merchant_category  STRING,
    txn_timestamp      TIMESTAMP,
    status             STRING,
    risk_score         DECIMAL(6,2),
    segment            STRING,
    credit_score       INT,
    is_fraud           BOOLEAN
)
PARTITIONED BY (txn_month STRING)
STORED AS PARQUET;

INSERT OVERWRITE TABLE bronze_transactions PARTITION (txn_month)
SELECT
    transaction_id,
    customer_id,
    amount,
    transaction_type,
    channel,
    merchant_category,
    txn_timestamp,
    status,
    risk_score,
    segment,
    credit_score,
    is_fraud,
    date_format(txn_timestamp, 'yyyy-MM') AS txn_month
FROM (
    SELECT
        CAST(transaction_id AS INT)               AS transaction_id,
        CAST(customer_id AS INT)                  AS customer_id,
        CAST(amount AS DECIMAL(12,2))             AS amount,
        transaction_type,
        channel,
        merchant_category,
        CAST(txn_timestamp AS TIMESTAMP)          AS txn_timestamp,
        status,
        CAST(risk_score AS DECIMAL(6,2))          AS risk_score,
        segment,
        CAST(credit_score AS INT)                 AS credit_score,
        CAST(is_fraud AS BOOLEAN)                 AS is_fraud,
        ROW_NUMBER() OVER (
            PARTITION BY transaction_id
            ORDER BY txn_timestamp
        ) AS rn
    FROM raw_transactions
    WHERE transaction_id IS NOT NULL
) typed
WHERE rn = 1                              -- remove duplicatas por transaction_id
  AND transaction_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND txn_timestamp IS NOT NULL
  AND amount IS NOT NULL AND amount >= 0         
  AND risk_score BETWEEN 0 AND 100                 
  AND credit_score BETWEEN 300 AND 850;             

-- ================================================================================
-- Camada Silver - padronização + enriquecimento (dados derivados)
--    Continua particionado por mês, formato parquet.
-- ================================================================================
DROP TABLE IF EXISTS silver_transactions;

CREATE TABLE silver_transactions (
    transaction_id     INT,
    customer_id        INT,
    amount             DECIMAL(12,2),
    amount_range       STRING,   
    transaction_type   STRING,
    channel            STRING,
    merchant_category  STRING,
    txn_timestamp      TIMESTAMP,
    day_period         STRING,   
    status             STRING,
    risk_score         DECIMAL(6,2),
    segment            STRING,
    credit_score       INT,
    is_fraud           BOOLEAN
)
PARTITIONED BY (txn_month STRING)
STORED AS PARQUET;

INSERT OVERWRITE TABLE silver_transactions PARTITION (txn_month)
SELECT
    transaction_id,
    customer_id,
    amount,
    CASE
        WHEN amount < 50    THEN 'baixo'
        WHEN amount < 500   THEN 'medio'
        WHEN amount < 2000  THEN 'alto'
        ELSE 'muito_alto'
    END AS amount_range,
    LOWER(TRIM(transaction_type))  AS transaction_type,
    LOWER(TRIM(channel))           AS channel,
    LOWER(TRIM(merchant_category)) AS merchant_category,
    txn_timestamp,
    CASE
        WHEN HOUR(txn_timestamp) BETWEEN 6  AND 11 THEN 'manha'
        WHEN HOUR(txn_timestamp) BETWEEN 12 AND 17 THEN 'tarde'
        WHEN HOUR(txn_timestamp) BETWEEN 18 AND 23 THEN 'noite'
        ELSE 'madrugada'
    END AS day_period,
    LOWER(TRIM(status))  AS status,
    risk_score,
    -- padroniza os rótulos de segmento (evita "high-risk" vs "High-Risk")
    CASE
        WHEN LOWER(segment) LIKE 'high%'  THEN 'High-Risk'
        WHEN LOWER(segment) LIKE 'prem%'  THEN 'Premium'
        ELSE 'Standard'
    END AS segment,
    credit_score,
    is_fraud,
    txn_month
FROM bronze_transactions;

-- ================================================================================
-- Camada Gold - tabelas agregadas 
-- Gold 1: taxa de fraude e ticket médio por canal e mês
-- ================================================================================

DROP TABLE IF EXISTS gold_fraud_by_channel_month;
CREATE TABLE gold_fraud_by_channel_month
STORED AS PARQUET AS
SELECT
    txn_month,
    channel,
    COUNT(*)                                                       AS total_transactions,
    SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END)                      AS fraud_count,
    ROUND(100.0 * SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                           AS fraud_rate_pct,
    ROUND(AVG(amount), 2)                                          AS avg_amount,
    ROUND(AVG(risk_score), 2)                                      AS avg_risk_score
FROM silver_transactions
GROUP BY txn_month, channel;

-- ================================================================================
-- Gold 2: comportamento por segmento de cliente e categoria de comerciante
-- ================================================================================

DROP TABLE IF EXISTS gold_segment_category_summary;
CREATE TABLE gold_segment_category_summary
STORED AS PARQUET AS
SELECT
    segment,
    merchant_category,
    COUNT(*)                                                       AS total_transactions,
    ROUND(SUM(amount), 2)                                          AS total_amount,
    ROUND(AVG(amount), 2)                                          AS avg_amount,
    SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END)                      AS fraud_count,
    ROUND(100.0 * SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                           AS fraud_rate_pct
FROM silver_transactions
GROUP BY segment, merchant_category;

-- ================================================================================
-- Gold 3 (bônus): perfil de risco por período do dia e faixa de score de crédito
-- ================================================================================

--    útil se a Etapa 3 for construir/avaliar um modelo de detecção de fraude
DROP TABLE IF EXISTS gold_risk_profile_by_period;
CREATE TABLE gold_risk_profile_by_period
STORED AS PARQUET AS
SELECT
    day_period,
    CASE
        WHEN credit_score < 500 THEN 'baixo'
        WHEN credit_score < 700 THEN 'medio'
        ELSE 'alto'
    END AS credit_score_range,
    COUNT(*)                                                       AS total_transactions,
    ROUND(AVG(risk_score), 2)                                      AS avg_risk_score,
    SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END)                      AS fraud_count,
    ROUND(100.0 * SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                           AS fraud_rate_pct
FROM silver_transactions
GROUP BY
    day_period,
    CASE
        WHEN credit_score < 500 THEN 'baixo'
        WHEN credit_score < 700 THEN 'medio'
        ELSE 'alto'
    END;

-- ================================================================================
-- Checagens rápidas (rode manualmente para conferir os números)
-- ================================================================================
-- SELECT COUNT(*) FROM raw_transactions;
-- SELECT COUNT(*) FROM bronze_transactions;
-- SELECT COUNT(*) FROM silver_transactions;
-- SELECT txn_month, COUNT(*) FROM bronze_transactions GROUP BY txn_month;
-- SELECT * FROM gold_fraud_by_channel_month ORDER BY txn_month, channel;
