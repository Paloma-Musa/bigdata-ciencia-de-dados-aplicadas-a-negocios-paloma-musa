### Usando Rota A — Cluster real

```bash
pyspark
```

# palomamusa@DESKTOP-NJ8QT5E:~$ pyspark
# Traceback (most recent call last):
#   File "<string>", line 1, in <module>
# ImportError: cannot import name 'spark_connect_mode' from 'pyspark.util' (/opt/spark/python/pyspark/util.py)
# The environment variable SPARK_CONNECT_MODE has unknown value or pyspark.util package is not available:
# Python 3.12.3 (main, Jul 15 2026, 23:46:41) [GCC 13.3.0] on linux
# Type "help", "copyright", "credits" or "license" for more information.
# 26/09/13 18:11:38 WARN Utils: Your hostname, DESKTOP-NJ8QT5E resolves to a loopback address: 127.0.1.1; using 192.168.18.10 instead (on interface wifi0)
# 26/09/13 18:11:38 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
# Setting default log level to "WARN".
# To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
# 26/09/13 18:11:40 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
# Welcome to
#       ____              __
#      / __/__  ___ _____/ /__
#     _\ \/ _ \/ _ `/ __/  '_/
#    /__ / .__/\_,_/_/ /_/\_\   version 3.5.0
#       /_/

# Using Python version 3.12.3 (main, Jul 15 2026 23:46:41)
# Spark context Web UI available at http://192.168.18.10:4040
# Spark context available as 'sc' (master = local[*], app id = local-1789333902271).
# SparkSession available as 'spark'.
# >>>

# ```python
# df = spark.read.parquet("/user/hive/warehouse/silver_transactions")
# ```

```python
df = spark.read.parquet("hdfs://localhost:9000/user/hive/warehouse/silver_transactions")
```

# >>> df = spark.read.parquet("hdfs://localhost:9000/user/hive/warehouse/silver_transactions")

### Passo 1 — Ver o schema e uma amostra

```python
df.printSchema()
df.show(5)
```

# >>> df.printSchema()
# root
#  |-- transaction_id: integer (nullable = true)
#  |-- customer_id: integer (nullable = true)
#  |-- amount: float (nullable = true)
#  |-- transaction_type: string (nullable = true)
#  |-- status: string (nullable = true)
#  |-- risk_score: float (nullable = true)
#  |-- is_fraud: boolean (nullable = true)
#  |-- ts: timestamp (nullable = true)
#  |-- segment: string (nullable = true)
#  |-- credit_score: integer (nullable = true)
#  |-- year: integer (nullable = true)
#  |-- month: integer (nullable = true)
#  |-- day: integer (nullable = true)
#  |-- day_of_week: integer (nullable = true)
#  |-- amount_band: string (nullable = true)

# >>> df.show(5)
# +--------------+-----------+-------+----------------+--------+----------+--------+-------------------+---------+------------+----+-----+---+-----------+-----------+
# |transaction_id|customer_id| amount|transaction_type|  status|risk_score|is_fraud|                 ts|  segment|credit_score|year|month|day|day_of_week|amount_band|
# +--------------+-----------+-------+----------------+--------+----------+--------+-------------------+---------+------------+----+-----+---+-----------+-----------+
# |             2|       9264|822.086|           saque|approved|   37.6309|   false|2023-04-22 00:00:00| Standard|         523|2023|    4| 22|          7|      medio|
# |             3|       5553|93.9353|           saque|approved|   31.9885|   false|2023-03-28 00:00:00|High-Risk|         481|2023|    3| 28|          3|      baixo|
# |             4|       4437|40.2107|          compra|approved|   97.8983|   false|2023-01-20 00:00:00|  Premium|         604|2023|    1| 20|          6|      baixo|
# |             5|       9671|67.0612|   transferencia|approved|   99.7805|   false|2024-06-23 00:00:00|  Premium|         900|2024|    6| 23|          1|      baixo|
# |             6|       4599|17.8488|   transferencia|approved|   6.51272|   false|2023-07-28 00:00:00|  Premium|         622|2023|    7| 28|          6|      baixo|
# +--------------+-----------+-------+----------------+--------+----------+--------+-------------------+---------+------------+----+-----+---+-----------+-----------+
# only showing top 5 rows

# >>>

### Passo 2 — Criar a view temporária (para usar SQL puro)

```python
df.createOrReplaceTempView("silver_transactions")
```

# >>> df.createOrReplaceTempView("silver_transactions")

### Passo 3 — Repetir a pergunta 1 do EDA (segmentação) em SQL

```python
spark.sql("""
SELECT segment, ROUND(AVG(credit_score), 1) AS score_medio, COUNT(*) AS total
FROM silver_transactions
GROUP BY segment
ORDER BY score_medio
""").show()
```

# >>> spark.sql("""
# ... SELECT segment, ROUND(AVG(credit_score), 1) AS score_medio, COUNT(*) AS total
# ... FROM silver_transactions
# ... GROUP BY segment
# ... ORDER BY score_medio
# ... """).show()
# +---------+-----------+-----+
# |  segment|score_medio|total|
# +---------+-----------+-----+
# | Standard|      643.9|29687|
# |  Premium|      652.7|61155|
# |High-Risk|      659.9| 9154|
# +---------+-----------+-----+

# >>>

### Passo 4 — A mesma pergunta, agora com a API de DataFrame

```python
from pyspark.sql import functions as F

(df.groupBy("segment")
   .agg(F.round(F.avg("credit_score"), 1).alias("score_medio"),
        F.count("*").alias("total"))
   .orderBy("score_medio")
   .show())
```

# >>> from pyspark.sql import functions as F
# >>>
# >>> (df.groupBy("segment")
# ...    .agg(F.round(F.avg("credit_score"), 1).alias("score_medio"),
# ...         F.count("*").alias("total"))
# ...    .orderBy("score_medio")
# ...    .show())
# +---------+-----------+-----+
# |  segment|score_medio|total|
# +---------+-----------+-----+
# | Standard|      643.9|29687|
# |  Premium|      652.7|61155|
# |High-Risk|      659.9| 9154|
# +---------+-----------+-----+

# >>>

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

# >>> import time
# >>>
# >>> t0 = time.time()
# >>> df.filter(df.is_fraud == True).count()
# 1833
# >>> print("1ª vez (sem cache):", time.time() - t0, "s")
# 1ª vez (sem cache): 0.3579704761505127 s
# >>>
# >>> df.cache()
# DataFrame[transaction_id: int, customer_id: int, amount: float, transaction_type: string, status: string, risk_score: float, is_fraud: boolean, ts: timestamp, segment: string, credit_score: int, year: int, month: int, day: int, day_of_week: int, amount_band: string]
# >>> df.count()  # força o cache a materializar
# 99996
# >>>
# >>> t0 = time.time()
# >>> df.filter(df.is_fraud == True).count()
# 1833
# >>> print("2ª vez (com cache):", time.time() - t0, "s")
# 2ª vez (com cache): 3.18643856048584 s
# >>>

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

# >>> spark.sql("""
# ... SELECT dayofweek(ts) AS dia_semana,
# ...        COUNT(*) AS total,
# ...        SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END) AS fraudes
# ... FROM silver_transactions
# ... GROUP BY dayofweek(ts)
# ... ORDER BY dia_semana
# ... """).show()
# +----------+-----+-------+
# |dia_semana|total|fraudes|
# +----------+-----+-------+
# |         1|14034|    257|
# |         2|13939|    283|
# |         3|14222|    262|
# |         4|14336|    234|
# |         5|14452|    263|
# |         6|14483|    261|
# |         7|14530|    273|
# +----------+-----+-------+

# >>>
