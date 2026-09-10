## Usando a ROTA A

# ----------------------------------------------------------
# Passo 1 - Confirmar HDFS de pé

jps

# palomamusa@DESKTOP-NJ8QT5E:~$ jps
# 1154 Jps
# 775 DataNode
# 664 NameNode
# 953 SecondaryNameNode

# ----------------------------------------------------------
# Passo 2 - Criar estrutura de camadas
hadoop fs -mkdir -p /user/bigdata/raw/customers
hadoop fs -mkdir -p /user/bigdata/raw/transactions
hadoop fs -mkdir -p /user/bigdata/raw/fraud_labels
hadoop fs -mkdir -p /user/bigdata/bronze
hadoop fs -mkdir -p /user/bigdata/silver
hadoop fs -mkdir -p /user/bigdata/gold

# ----------------------------------------------------------
# Passo 3 - Conferir a estrutura
hadoop fs -ls -R /user/bigdata

# drwxr-xr-x   - palomamusa supergroup          0 2026-08-22 11:03 /user/bigdata/bronze
# drwxr-xr-x   - palomamusa supergroup          0 2026-08-22 11:04 /user/bigdata/gold
# drwxr-xr-x   - palomamusa supergroup          0 2026-08-22 11:03 /user/bigdata/raw
# drwxr-xr-x   - palomamusa supergroup          0 2026-08-22 11:45 /user/bigdata/raw/customers
# -rw-r--r--   1 palomamusa supergroup     842452 2026-08-22 11:45 /user/bigdata/raw/customers/customers_synthetic.csv
# drwxr-xr-x   - palomamusa supergroup          0 2026-08-22 11:45 /user/bigdata/raw/fraud_labels
# -rw-r--r--   1 palomamusa supergroup     218901 2026-08-22 11:45 /user/bigdata/raw/fraud_labels/fraud_labels.csv
# drwxr-xr-x   - palomamusa supergroup          0 2026-08-22 11:45 /user/bigdata/raw/transactions
# -rw-r--r--   1 palomamusa supergroup    8139649 2026-08-22 11:45 /user/bigdata/raw/transactions/transactions_synthetic.csv
# drwxr-xr-x   - palomamusa supergroup          0 2026-08-22 11:03 /user/bigdata/silver

# ----------------------------------------------------------
# Passo 4 - Subir os 3 datasets
hadoop fs -put customers_synthetic.csv /user/bigdata/raw/customers/
hadoop fs -put transactions_synthetic.csv /user/bigdata/raw/transactions/
hadoop fs -put fraud_labels.csv /user/bigdata/raw/fraud_labels/

# ----------------------------------------------------------
# Passo 5 -  Verificar a replicação 3×
hdfs fsck /user/bigdata/raw/transactions/transactions_synthetic.csv -files -blocks -locations

Connecting to namenode via http://localhost:9870/fsck?ugi=palomamusa&files=1&blocks=1&locations=1&path=%2Fuser%2Fbigdata%2Fraw%2Ftransactions%2Ftransactions_synthetic.csv
# FSCK started by palomamusa (auth:SIMPLE) from /127.0.0.1 for path /user/bigdata/raw/transactions/transactions_synthetic.csv at Sun Sep 06 19:21:18 BRT 2026

# /user/bigdata/raw/transactions/transactions_synthetic.csv 8139649 bytes, replicated: replication=1, 1 block(s):  OK
# 0. BP-322092371-127.0.1.1-1787404245219:blk_1073741826_1002 len=8139649 Live_repl=1  [DatanodeInfoWithStorage[127.0.0.1:9866,DS-e4d9337e-c564-4d10-98ab-1ffd38c31a55,DISK]]


# Status: HEALTHY
#  Number of data-nodes:  1
#  Number of racks:               1
#  Total dirs:                    0
#  Total symlinks:                0

# Replicated Blocks:
#  Total size:    8139649 B
#  Total files:   1
#  Total blocks (validated):      1 (avg. block size 8139649 B)
#  Minimally replicated blocks:   1 (100.0 %)
#  Over-replicated blocks:        0 (0.0 %)
#  Under-replicated blocks:       0 (0.0 %)
#  Mis-replicated blocks:         0 (0.0 %)
#  Default replication factor:    1
#  Average block replication:     1.0
#  Missing blocks:                0
#  Corrupt blocks:                0
#  Missing replicas:              0 (0.0 %)
#  Blocks queued for replication: 0

# Erasure Coded Block Groups:
#  Total size:    0 B
#  Total files:   0
#  Total block groups (validated):        0
#  Minimally erasure-coded block groups:  0
#  Over-erasure-coded block groups:       0
#  Under-erasure-coded block groups:      0
#  Unsatisfactory placement block groups: 0
#  Average block group size:      0.0
#  Missing block groups:          0
#  Corrupt block groups:          0
#  Missing internal blocks:       0
#  Blocks queued for replication: 0
# FSCK ended at Sun Sep 06 19:21:19 BRT 2026 in 325 milliseconds


# The filesystem under path '/user/bigdata/raw/transactions/transactions_synthetic.csv' is HEALTHY

# ----------------------------------------------------------
# Passo 6 - Contar as linhas direto do HDFS
hadoop fs -cat /user/bigdata/raw/customers/*.csv | wc -l

# palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -cat /user/bigdata/raw/customers/*.csv | wc -l
#9995

hadoop fs -cat /user/bigdata/raw/transactions/*.csv | wc -l

# palomamusa@DESKTOP-NJ8QT5E:~$hadoop fs -cat /user/bigdata/raw/transactions/*.csv | wc -l
#100002

