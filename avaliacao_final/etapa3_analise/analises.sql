-- =============================================================================================
-- 1. Risco por canal (gold_fraud_by_channel_month)
-- =============================================================================================
USE avaliacao_techpay;
SELECT
    channel,
    SUM(total_transactions) AS total_transactions,
    SUM(fraud_count) AS fraud_count,
    ROUND(100.0 * SUM(fraud_count) / SUM(total_transactions), 2) AS fraud_rate_pct
FROM gold_fraud_by_channel_month
GROUP BY channel
ORDER BY fraud_rate_pct DESC;

-- =============================================================================================
-- 2. Risco por categoria de estabelecimento (gold_segment_category_summary)
-- =============================================================================================
USE avaliacao_techpay;
SELECT
    merchant_category,
    SUM(total_transactions) AS total_transactions,
    SUM(fraud_count) AS fraud_count,
    ROUND(100.0 * SUM(fraud_count) / SUM(total_transactions), 2) AS fraud_rate_pct
FROM gold_segment_category_summary
GROUP BY merchant_category
ORDER BY fraud_rate_pct DESC;

-- =============================================================================================
3. Padrão temporal por período do dia (gold_risk_profile_by_period)
-- =============================================================================================
USE avaliacao_techpay;
SELECT
    day_period,
    SUM(total_transactions) AS total_transactions,
    SUM(fraud_count) AS fraud_count,
    ROUND(100.0 * SUM(fraud_count) / SUM(total_transactions), 2) AS fraud_rate_pct
FROM gold_risk_profile_by_period
GROUP BY day_period
ORDER BY fraud_rate_pct DESC;
