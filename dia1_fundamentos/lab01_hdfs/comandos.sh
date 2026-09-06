# Usando a rota A
# Passo 1 - Confirmar HDFS de pé
jps

# Passo 2 - Criar estrutura de camadas
hadoop fs -mkdir -p /user/bigdata/raw/customers
hadoop fs -mkdir -p /user/bigdata/raw/transactions
hadoop fs -mkdir -p /user/bigdata/raw/fraud_labels
hadoop fs -mkdir -p /user/bigdata/bronze
hadoop fs -mkdir -p /user/bigdata/silver
hadoop fs -mkdir -p /user/bigdata/gold
