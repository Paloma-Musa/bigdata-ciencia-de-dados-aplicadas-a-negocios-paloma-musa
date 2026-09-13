### Usando a Rota A — Cluster real

# ```python
# # dentro do pyspark
# df = spark.read.parquet("/user/hive/warehouse/silver_transactions")
# ```

df = spark.read.parquet("hdfs://localhost:9000/user/hive/warehouse/silver_transactions")

# >>> df = spark.read.parquet("hdfs://localhost:9000/user/hive/warehouse/silver_transactions")

### Passo 1 — Preparar as features

```python
from pyspark.ml.feature import StringIndexer, VectorAssembler
from pyspark.ml.classification import LogisticRegression
from pyspark.ml import Pipeline

# transformar segment (texto) em número
indexer = StringIndexer(inputCol="segment", outputCol="segment_idx")

# juntar as features numéricas num único vetor
assembler = VectorAssembler(
    inputCols=["amount", "risk_score", "credit_score", "segment_idx"],
    outputCol="features"
)
```

# >>> from pyspark.ml.feature import StringIndexer, VectorAssembler
# >>> from pyspark.ml.classification import LogisticRegression
# >>> from pyspark.ml import Pipeline
# >>>
# >>> # transformar segment (texto) em número
# >>> indexer = StringIndexer(inputCol="segment", outputCol="segment_idx")
# >>>
# >>> # juntar as features numéricas num único vetor
# >>> assembler = VectorAssembler(
# ...     inputCols=["amount", "risk_score", "credit_score", "segment_idx"],
# ...     outputCol="features"
# ... )

### Passo 2 — Separar treino e teste

```python
df_ml = df.withColumn("label", df.is_fraud.cast("integer"))
train, test = df_ml.randomSplit([0.8, 0.2], seed=42)

print("treino:", train.count(), "· teste:", test.count())
```

# >>> df_ml = df.withColumn("label", df.is_fraud.cast("integer"))
# >>> train, test = df_ml.randomSplit([0.8, 0.2], seed=42)
# >>>
# >>> print("treino:", train.count(), "· teste:", test.count())
# treino: 79897 · teste: 20099
# >>>

### Passo 3 — Montar o pipeline e treinar

```python
lr = LogisticRegression(featuresCol="features", labelCol="label")
pipeline = Pipeline(stages=[indexer, assembler, lr])

modelo = pipeline.fit(train)
print("Modelo treinado.")
```

# >>> lr = LogisticRegression(featuresCol="features", labelCol="label")
# >>> pipeline = Pipeline(stages=[indexer, assembler, lr])
# >>>
# >>> modelo = pipeline.fit(train)
# 26/09/13 19:17:22 WARN InstanceBuilder: Failed to load implementation from:dev.ludovic.netlib.blas.JNIBLAS
# >>> print("Modelo treinado.")
# Modelo treinado.
# >>>

### Passo 4 — Avaliar no conjunto de teste

```python
from pyspark.ml.evaluation import BinaryClassificationEvaluator

predicoes = modelo.transform(test)
avaliador = BinaryClassificationEvaluator(labelCol="label")
auc = avaliador.evaluate(predicoes)
print(f"AUC no teste: {auc:.3f}")
```

# >>> from pyspark.ml.evaluation import BinaryClassificationEvaluator
# >>>
# >>> predicoes = modelo.transform(test)
# >>> avaliador = BinaryClassificationEvaluator(labelCol="label")
# >>> auc = avaliador.evaluate(predicoes)
# >>> print(f"AUC no teste: {auc:.3f}")
# AUC no teste: 0.755

### Passo 5 — Olhar exemplos de predição

```python
predicoes.select("transaction_id", "amount", "segment", "label", "prediction", "probability").show(10, truncate=False)
```

# >>> predicoes.select("transaction_id", "amount", "segment", "label", "prediction", "probability").show(10, truncate=False)
# +--------------+-------+---------+-----+----------+-----------------------------------------+
# |transaction_id|amount |segment  |label|prediction|probability                              |
# +--------------+-------+---------+-----+----------+-----------------------------------------+
# |4             |40.2107|Premium  |0    |0.0       |[0.9852950329913439,0.014704967008656089]|
# |8             |48.9623|High-Risk|0    |0.0       |[0.9201822377417221,0.07981776225827786] |
# |10            |13.3099|Premium  |0    |0.0       |[0.9958673794695525,0.004132620530447495]|
# |15            |12.8251|Standard |0    |0.0       |[0.9646295050366102,0.03537049496338984] |
# |21            |74.4865|High-Risk|0    |0.0       |[0.8546750390365726,0.1453249609634274]  |
# |25            |357.133|Premium  |0    |0.0       |[0.9896416465193476,0.010358353480652394]|
# |31            |394.827|Standard |0    |0.0       |[0.9823006473535603,0.017699352646439737]|
# |37            |25.4103|Standard |0    |0.0       |[0.9894672485893247,0.010532751410675334]|
# |47            |54.1594|Premium  |0    |0.0       |[0.9969330046263899,0.003066995373610104]|
# |48            |30.5097|Standard |0    |0.0       |[0.9840581830594853,0.015941816940514664]|
# +--------------+-------+---------+-----+----------+-----------------------------------------+
# only showing top 10 rows


### Passo 6 — Feature importance (via coeficientes da regressão)

```python
lr_model = modelo.stages[-1]  # último estágio do pipeline = o modelo treinado
coefs = lr_model.coefficients

nomes = ["amount", "risk_score", "credit_score", "segment_idx"]
for nome, coef in zip(nomes, coefs):
    print(f"{nome}: {coef:.4f}")
```

# >>> lr_model = modelo.stages[-1]
# >>> coefs = lr_model.coefficients
# >>>
# >>> nomes = ["amount", "risk_score", "credit_score", "segment_idx"]
# >>> for nome, coef in zip(nomes, coefs):
# ...     print(f"{nome}: {coef:.4f}")
# amount: -0.0001
# risk_score: 0.0167
# credit_score: 0.0000
# segment_idx: 1.2025
# >>>
