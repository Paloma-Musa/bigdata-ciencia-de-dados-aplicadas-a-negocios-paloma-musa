## Usando ROTA A — Cluster real

### Opção 2 — CSV direto do Hive

```bash
hive -e "SELECT * FROM gold_fraud_risk" | sed 's/[\t]/,/g' > fraud_risk_export.csv
cat fraud_risk_export.csv
```

### Opção 3 — Spark lendo o Parquet e gravando via JDBC

```python
# pyspark
df = spark.read.parquet("/user/hive/warehouse/gold_fraud_risk")
df.show()

df.write.jdbc(
  url="jdbc:mysql://localhost:3306/bigdata_course",
  table="fraud_risk_bi_spark",
  mode="overwrite",
  properties={"user": "root", "password": "SUASENHA"}
)
```
