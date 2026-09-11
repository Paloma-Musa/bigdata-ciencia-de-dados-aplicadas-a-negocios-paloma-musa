### Usando Rota A — Cluster real

```bash
pyspark
```

```python
df = spark.read.parquet("/user/hive/warehouse/silver_transactions")
```

### Passo 1 — Ver o schema e uma amostra

```python
df.printSchema()
df.show(5)
```

### Passo 2 — Criar a view temporária (para usar SQL puro)

```python
df.createOrReplaceTempView("silver_transactions")
```

### Passo 3 — Repetir a pergunta 1 do EDA (segmentação) em SQL

```python
spark.sql("""
SELECT segment, ROUND(AVG(credit_score), 1) AS score_medio, COUNT(*) AS total
FROM silver_transactions
GROUP BY segment
ORDER BY score_medio
""").show()
```

### Passo 4 — A mesma pergunta, agora com a API de DataFrame

```python
from pyspark.sql import functions as F

(df.groupBy("segment")
   .agg(F.round(F.avg("credit_score"), 1).alias("score_medio"),
        F.count("*").alias("total"))
   .orderBy("score_medio")
   .show())
```

### Passo 5 — Medir o ganho do cache

```python
import time

t0 = time.time()
df.filter(df.is_fraud == True).count()
print("1ª vez (sem cache):", time.time() - t0, "s")

df.cache()
df.count()  # força o cache a materializar

t0 = time.time()
df.filter(df.is_fraud == True).count()
print("2ª vez (com cache):", time.time() - t0, "s")
```

### Passo 6 — Uma agregação mais pesada: fraude por dia da semana

```python
spark.sql("""
SELECT dayofweek(ts) AS dia_semana,
       COUNT(*) AS total,
       SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END) AS fraudes
FROM silver_transactions
GROUP BY dayofweek(ts)
ORDER BY dia_semana
""").show()
```
