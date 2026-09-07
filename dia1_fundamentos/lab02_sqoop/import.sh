## Usando a ROTA A — Cluster real (Sqoop + MySQL)

### Passo 1 — Criar o banco e carregar os dados

sudo mysql -u root << 'EOF'
CREATE DATABASE IF NOT EXISTS bigdata_course;
USE bigdata_course;

CREATE TABLE customers (
  customer_id INT PRIMARY KEY, name VARCHAR(255), cpf VARCHAR(20),
  email VARCHAR(255), segment VARCHAR(50), credit_score INT, created_at DATE
);
CREATE TABLE transactions (
  transaction_id INT PRIMARY KEY, customer_id INT, amount FLOAT,
  transaction_type VARCHAR(50), timestamp DATETIME, status VARCHAR(50),
  risk_score FLOAT, is_fraud VARCHAR(10)
);
EOF

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql -u root << 'EOF'
# > CREATE DATABASE IF NOT EXISTS bigdata_course;
# > USE bigdata_course;
# >
# > CREATE TABLE customers (
# >   customer_id INT PRIMARY KEY, name VARCHAR(255), cpf VARCHAR(20),
# >   email VARCHAR(255), segment VARCHAR(50), credit_score INT, created_at DATE
# > );
# > CREATE TABLE transactions (
# >   transaction_id INT PRIMARY KEY, customer_id INT, amount FLOAT,
# >   transaction_type VARCHAR(50), timestamp DATETIME, status VARCHAR(50),
# >   risk_score FLOAT, is_fraud VARCHAR(10)
# > );
# > EOF

### Passo 1.5 (opcional) — Configurar acesso e permissões do MySQL

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql --local-infile=1 -u root bigdata_course
# Reading table information for completion of table and column names
# You can turn off this feature to get a quicker startup with -A

# Welcome to the MySQL monitor.  Commands end with ; or \g.
# Your MySQL connection id is 14
# Server version: 8.0.46-0ubuntu0.24.04.3 (Ubuntu)

# Copyright (c) 2000, 2026, Oracle and/or its affiliates.

# Oracle is a registered trademark of Oracle Corporation and/or its
# affiliates. Other names may be trademarks of their respective
# owners.

# Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# mysql> SET GLOBAL local_infile = 1;
# Query OK, 0 rows affected (0.00 sec)

# mysql> exit
# Bye

# ----------------------------------------------------------------------------------------------------------------------

### Passo 2 — Carregar os CSVs no MySQL

sudo mysql --local-infile=1 -u root bigdata_course -e "
LOAD DATA LOCAL INFILE 'customers_synthetic.csv'
INTO TABLE customers FIELDS TERMINATED BY ',' IGNORE 1 ROWS;"

sudo mysql --local-infile=1 -u root bigdata_course -e "
LOAD DATA LOCAL INFILE 'transactions_synthetic.csv'
INTO TABLE transactions FIELDS TERMINATED BY ',' IGNORE 1 ROWS;"

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql --local-infile=1 -u root bigdata_course -e "
# > LOAD DATA LOCAL INFILE 'customers_synthetic.csv'
# > INTO TABLE customers FIELDS TERMINATED BY ',' IGNORE 1 ROWS;"

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql --local-infile=1 -u root bigdata_course -e "
# > LOAD DATA LOCAL INFILE 'transactions_synthetic.csv'
# > INTO TABLE transactions FIELDS TERMINATED BY ',' IGNORE 1 ROWS;"

# ----------------------------------------------------------------------------------------------------------------------

### Passo 3 — Conferir a carga

sudo mysql -u root bigdata_course -e "SELECT COUNT(*) FROM customers;"
sudo mysql -u root bigdata_course -e "SELECT COUNT(*) FROM transactions;"

sudo mysql -u root bigdata_course -e "SELECT is_fraud, COUNT(*) FROM transactions GROUP BY is_fraud;"

mysql -h 127.0.0.1 -u root -pPALOMAMUSA bigdata_course -e "SELECT 1;"

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql -u root bigdata_course -e "SELECT COUNT(*) FROM customers;"
# +----------+
# | COUNT(*) |
# +----------+
# |     9993 |
# +----------+
# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql -u root bigdata_course -e "SELECT COUNT(*) FROM transactions;"
# +----------+
# | COUNT(*) |
# +----------+
# |   100000 |
# +----------+

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql -u root bigdata_course -e "SELECT is_fraud, COUNT(*) FROM transactions GROUP BY is_fraud;"
# +----------+----------+
# | is_fraud | COUNT(*) |
# +----------+----------+
# | False    |    98167 |
# | True     |     1833 |
# +----------+----------+

# ### Passo 3.5 — Habilitar o root para conexão TCP (necessário para o Sqoop)

sudo mysql -u root -e "SELECT user, host, plugin FROM mysql.user WHERE user='root';"
sudo mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'SUASENHA';
FLUSH PRIVILEGES;

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql -u root -e "SELECT user, host, plugin FROM mysql.user WHERE user='root';"
# +------+-----------+-------------+
# | user | host      | plugin      |
# +------+-----------+-------------+
# | root | localhost | auth_socket |
# +------+-----------+-------------+

# palomamusa@DESKTOP-NJ8QT5E:~$ sudo mysql -u root -p
# Enter password:
# Welcome to the MySQL monitor.  Commands end with ; or \g.
# Your MySQL connection id is 29
# Server version: 8.0.46-0ubuntu0.24.04.3 (Ubuntu)

# Copyright (c) 2000, 2026, Oracle and/or its affiliates.

# Oracle is a registered trademark of Oracle Corporation and/or its
# affiliates. Other names may be trademarks of their respective
# owners.

# Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PALOMAMUSA';
# Query OK, 0 rows affected (0.03 sec)

# mysql> FLUSH PRIVILEGES;
# Query OK, 0 rows affected (0.02 sec)

# mysql> exit
# Bye

# palomamusa@DESKTOP-NJ8QT5E:~$ mysql -h 127.0.0.1 -u root -pPALOMAMUSA bigdata_course -e "SELECT 1;"
# mysql: [Warning] Using a password on the command line interface can be insecure.
# +---+
# | 1 |
# +---+
# | 1 |
# +---+

### Passo 3.6 — Configurar o MapReduce para rodar via YARN
jps
echo $HADOOP_HOME
cat $HADOOP_HOME/etc/hadoop/mapred-site.xml
nano $HADOOP_HOME/etc/hadoop/mapred-site.xml
stop-yarn.sh && start-yarn.sh
jps

# palomamusa@DESKTOP-NJ8QT5E:~$ jps
# 775 DataNode
# 664 NameNode
# 953 SecondaryNameNode
# 3083 Jps
# palomamusa@DESKTOP-NJ8QT5E:~$ echo $HADOOP_HOME
# /opt/hadoop
# palomamusa@DESKTOP-NJ8QT5E:~$ cat $HADOOP_HOME/etc/hadoop/mapred-site.xml
# <?xml version="1.0"?>
# <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
# <!--
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License. See accompanying LICENSE file.
# -->

# <!-- Put site-specific property overrides in this file. -->

# <configuration>

# </configuration>
# palomamusa@DESKTOP-NJ8QT5E:~$ nano $HADOOP_HOME/etc/hadoop/mapred-site.xml
# palomamusa@DESKTOP-NJ8QT5E:~$ stop-yarn.sh && start-yarn.sh
# Stopping nodemanagers
# Stopping resourcemanager
# Starting resourcemanager
# Starting nodemanagers
# palomamusa@DESKTOP-NJ8QT5E:~$ jps
# 3504 NodeManager
# 3397 ResourceManager
# 775 DataNode
# 664 NameNode
# 953 SecondaryNameNode
# 3854 Jps

# ----------------------------------------------------------------------------------------------------------------------

### Passo 4 — Importar via Sqoop

sqoop import \
  --connect jdbc:mysql://localhost:3306/bigdata_course \
  --username root --password SUASENHA \
  --table customers \
  --columns "customer_id,name,cpf,email,segment,credit_score,created_at" \
  --target-dir /user/bigdata/raw/customers \
  --delete-target-dir \
  --null-string '\\N' --null-non-string '\\N' \
  -m 4
hadoop fs -cat /user/bigdata/raw/customers/part-m-00000 | head -3

# palomamusa@DESKTOP-NJ8QT5E:~$ sqoop import \
# >   --connect jdbc:mysql://localhost:3306/bigdata_course \
# >   --username root --password PALOMAMUSA \
# >   --table customers \
# >   --columns "customer_id,name,cpf,email,segment,credit_score,created_at" \
# >   --target-dir /user/bigdata/raw/customers \
# >   --delete-target-dir \
# >   --null-string '\\N' --null-non-string '\\N' \
# >   -m 4
# Warning: /opt/sqoop/../hbase does not exist! HBase imports will fail.
# Please set $HBASE_HOME to the root of your HBase installation.
# Warning: /opt/sqoop/../hcatalog does not exist! HCatalog jobs will fail.
# Please set $HCAT_HOME to the root of your HCatalog installation.
# Warning: /opt/sqoop/../accumulo does not exist! Accumulo imports will fail.
# Please set $ACCUMULO_HOME to the root of your Accumulo installation.
# Warning: /opt/sqoop/../zookeeper does not exist! Accumulo imports will fail.
# Please set $ZOOKEEPER_HOME to the root of your Zookeeper installation.
# 2026-09-06 22:59:59,724 INFO sqoop.Sqoop: Running Sqoop version: 1.4.7
# 2026-09-06 22:59:59,789 WARN tool.BaseSqoopTool: Setting your password on the command-line is insecure. Consider using -P instead.
# 2026-09-06 22:59:59,909 INFO manager.MySQLManager: Preparing to use a MySQL streaming resultset.
# 2026-09-06 22:59:59,909 INFO tool.CodeGenTool: Beginning code generation
# Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
# 2026-09-06 23:00:01,039 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `customers` AS t LIMIT 1
# 2026-09-06 23:00:01,127 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `customers` AS t LIMIT 1
# 2026-09-06 23:00:01,138 INFO orm.CompilationManager: HADOOP_MAPRED_HOME is /opt/hadoop
# Note: /tmp/sqoop-palomamusa/compile/c28536585b0aad15236baeedd3415ada/customers.java uses or overrides a deprecated API.
# Note: Recompile with -Xlint:deprecation for details.
# 2026-09-06 23:00:09,797 INFO orm.CompilationManager: Writing jar file: /tmp/sqoop-palomamusa/compile/c28536585b0aad15236baeedd3415ada/customers.jar
# 2026-09-06 23:00:11,825 INFO tool.ImportTool: Destination directory /user/bigdata/raw/customers deleted.
# 2026-09-06 23:00:11,825 WARN manager.MySQLManager: It looks like you are importing from mysql.
# 2026-09-06 23:00:11,826 WARN manager.MySQLManager: This transfer can be faster! Use the --direct
# 2026-09-06 23:00:11,827 WARN manager.MySQLManager: option to exercise a MySQL-specific fast path.
# 2026-09-06 23:00:11,827 INFO manager.MySQLManager: Setting zero DATETIME behavior to convertToNull (mysql)
# 2026-09-06 23:00:11,853 INFO mapreduce.ImportJobBase: Beginning import of customers
# 2026-09-06 23:00:11,855 INFO Configuration.deprecation: mapred.job.tracker is deprecated. Instead, use mapreduce.jobtracker.address
# 2026-09-06 23:00:11,861 INFO Configuration.deprecation: mapred.jar is deprecated. Instead, use mapreduce.job.jar
# 2026-09-06 23:00:11,879 INFO Configuration.deprecation: mapred.map.tasks is deprecated. Instead, use mapreduce.job.maps
# 2026-09-06 23:00:11,975 INFO client.DefaultNoHARMFailoverProxyProvider: Connecting to ResourceManager at /0.0.0.0:8032
# 2026-09-06 23:00:12,696 INFO mapreduce.JobResourceUploader: Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/palomamusa/.staging/job_1788746338495_0001
# 2026-09-06 23:00:23,807 INFO db.DBInputFormat: Using read commited transaction isolation
# 2026-09-06 23:00:23,808 INFO db.DataDrivenDBInputFormat: BoundingValsQuery: SELECT MIN(`customer_id`), MAX(`customer_id`) FROM `customers`
# 2026-09-06 23:00:23,812 INFO db.IntegerSplitter: Split size: 2499; Num splits: 4 from: 1 to: 10000
# 2026-09-06 23:00:24,676 INFO mapreduce.JobSubmitter: number of splits:4
# 2026-09-06 23:00:25,309 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1788746338495_0001
# 2026-09-06 23:00:25,310 INFO mapreduce.JobSubmitter: Executing with tokens: []
# 2026-09-06 23:00:25,843 INFO conf.Configuration: resource-types.xml not found
# 2026-09-06 23:00:25,844 INFO resource.ResourceUtils: Unable to find 'resource-types.xml'.
# 2026-09-06 23:00:26,607 INFO impl.YarnClientImpl: Submitted application application_1788746338495_0001
# 2026-09-06 23:00:26,653 INFO mapreduce.Job: The url to track the job: http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0001/
# 2026-09-06 23:00:26,655 INFO mapreduce.Job: Running job: job_1788746338495_0001
# 2026-09-06 23:00:53,176 INFO mapreduce.Job: Job job_1788746338495_0001 running in uber mode : false
# 2026-09-06 23:00:53,350 INFO mapreduce.Job:  map 0% reduce 0%
# 2026-09-06 23:01:44,674 INFO mapreduce.Job:  map 100% reduce 0%
# 2026-09-06 23:01:55,870 INFO mapreduce.Job: Job job_1788746338495_0001 completed successfully
# 2026-09-06 23:01:56,232 INFO mapreduce.Job: Counters: 33
#         File System Counters
#                 FILE: Number of bytes read=0
#                 FILE: Number of bytes written=1139628
#                 FILE: Number of read operations=0
#                 FILE: Number of large read operations=0
#                 FILE: Number of write operations=0
#                 HDFS: Number of bytes read=487
#                 HDFS: Number of bytes written=842392
#                 HDFS: Number of read operations=24
#                 HDFS: Number of large read operations=0
#                 HDFS: Number of write operations=8
#                 HDFS: Number of bytes read erasure-coded=0
#         Job Counters
#                 Launched map tasks=4
#                 Other local map tasks=4
#                 Total time spent by all maps in occupied slots (ms)=184471
#                 Total time spent by all reduces in occupied slots (ms)=0
#                 Total time spent by all map tasks (ms)=184471
#                 Total vcore-milliseconds taken by all map tasks=184471
#                 Total megabyte-milliseconds taken by all map tasks=188898304
#         Map-Reduce Framework
#                 Map input records=9993
#                 Map output records=9993
#                 Input split bytes=487
#                 Spilled Records=0
#                 Failed Shuffles=0
#                 Merged Map outputs=0
#                 GC time elapsed (ms)=1005
#                 CPU time spent (ms)=18780
#                 Physical memory (bytes) snapshot=1063546880
#                 Virtual memory (bytes) snapshot=4205812862976
#                 Total committed heap usage (bytes)=805830656
#                 Peak Map Physical memory (bytes)=300961792
#                 Peak Map Virtual memory (bytes)=1090477379584
#         File Input Format Counters
#                 Bytes Read=0
#         File Output Format Counters
#                 Bytes Written=842392
# 2026-09-06 23:01:56,483 INFO mapreduce.ImportJobBase: Transferred 822.6484 KB in 104.5154 seconds (7.8711 KB/sec)
# 2026-09-06 23:01:56,494 INFO mapreduce.ImportJobBase: Retrieved 9993 records.

# palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -cat /user/bigdata/raw/customers/part-m-00000 | head -3
# 1,Ana Laura Campos,943.065.218-42,igor46@example.com,Premium,426,2026-07-03
# 2,Mariah Caldeira,586.237.094-38,jose48@example.com,High-Risk,481,2026-06-17
# 3,Kevin Cavalcante,530.629.814-15,theoda-costa@example.org,Standard,708,2025-11-06
# cat: Unable to write to output stream.

# ----------------------------------------------------------------------------------------------------------------------

### Passo 5 — Repetir para transactions

sqoop import \
  --connect jdbc:mysql://localhost:3306/bigdata_course \
  --username root --password SUASENHA \
  --table transactions \
  --columns "transaction_id,customer_id,amount,transaction_type,timestamp,status,risk_score,is_fraud" \
  --target-dir /user/bigdata/raw/transactions \
  --delete-target-dir \
  --null-string '\\N' --null-non-string '\\N' \
  -m 4
  
hadoop fs -cat /user/bigdata/raw/transactions/part-m-00000 | head -3

# palomamusa@DESKTOP-NJ8QT5E:~$ sqoop import \
# >   --connect jdbc:mysql://localhost:3306/bigdata_course \
# >   --username root --password PALOMAMUSA \
# >   --table transactions \
# >   --columns "transaction_id,customer_id,amount,transaction_type,timestamp,status,risk_score,is_fraud" \
# >   --target-dir /user/bigdata/raw/transactions \
# >   --delete-target-dir \
# >   --null-string '\\N' --null-non-string '\\N' \
# >   -m 4
# Warning: /opt/sqoop/../hbase does not exist! HBase imports will fail.
# Please set $HBASE_HOME to the root of your HBase installation.
# Warning: /opt/sqoop/../hcatalog does not exist! HCatalog jobs will fail.
# Please set $HCAT_HOME to the root of your HCatalog installation.
# Warning: /opt/sqoop/../accumulo does not exist! Accumulo imports will fail.
# Please set $ACCUMULO_HOME to the root of your Accumulo installation.
# Warning: /opt/sqoop/../zookeeper does not exist! Accumulo imports will fail.
# Please set $ZOOKEEPER_HOME to the root of your Zookeeper installation.
# 2026-09-06 23:05:25,419 INFO sqoop.Sqoop: Running Sqoop version: 1.4.7
# 2026-09-06 23:05:25,592 WARN tool.BaseSqoopTool: Setting your password on the command-line is insecure. Consider using -P instead.
# 2026-09-06 23:05:25,713 INFO manager.MySQLManager: Preparing to use a MySQL streaming resultset.
# 2026-09-06 23:05:25,714 INFO tool.CodeGenTool: Beginning code generation
# Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
# 2026-09-06 23:05:26,992 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `transactions` AS t LIMIT 1
# 2026-09-06 23:05:27,323 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `transactions` AS t LIMIT 1
# 2026-09-06 23:05:27,336 INFO orm.CompilationManager: HADOOP_MAPRED_HOME is /opt/hadoop
# Note: /tmp/sqoop-palomamusa/compile/6cde3d0899b2c3e599f1f5583640f6eb/transactions.java uses or overrides a deprecated API.
# Note: Recompile with -Xlint:deprecation for details.
# 2026-09-06 23:05:36,806 INFO orm.CompilationManager: Writing jar file: /tmp/sqoop-palomamusa/compile/6cde3d0899b2c3e599f1f5583640f6eb/transactions.jar
# 2026-09-06 23:05:38,820 INFO tool.ImportTool: Destination directory /user/bigdata/raw/transactions deleted.
# 2026-09-06 23:05:38,821 WARN manager.MySQLManager: It looks like you are importing from mysql.
# 2026-09-06 23:05:38,822 WARN manager.MySQLManager: This transfer can be faster! Use the --direct
# 2026-09-06 23:05:38,825 WARN manager.MySQLManager: option to exercise a MySQL-specific fast path.
# 2026-09-06 23:05:38,825 INFO manager.MySQLManager: Setting zero DATETIME behavior to convertToNull (mysql)
# 2026-09-06 23:05:38,937 INFO mapreduce.ImportJobBase: Beginning import of transactions
# 2026-09-06 23:05:38,968 INFO Configuration.deprecation: mapred.job.tracker is deprecated. Instead, use mapreduce.jobtracker.address
# 2026-09-06 23:05:38,976 INFO Configuration.deprecation: mapred.jar is deprecated. Instead, use mapreduce.job.jar
# 2026-09-06 23:05:38,997 INFO Configuration.deprecation: mapred.map.tasks is deprecated. Instead, use mapreduce.job.maps
# 2026-09-06 23:05:39,430 INFO client.DefaultNoHARMFailoverProxyProvider: Connecting to ResourceManager at /0.0.0.0:8032
# 2026-09-06 23:05:40,088 INFO mapreduce.JobResourceUploader: Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/palomamusa/.staging/job_1788746338495_0002
# 2026-09-06 23:05:49,674 INFO db.DBInputFormat: Using read commited transaction isolation
# 2026-09-06 23:05:49,677 INFO db.DataDrivenDBInputFormat: BoundingValsQuery: SELECT MIN(`transaction_id`), MAX(`transaction_id`) FROM `transactions`
# 2026-09-06 23:05:49,842 INFO db.IntegerSplitter: Split size: 24999; Num splits: 4 from: 1 to: 100000
# 2026-09-06 23:05:50,293 INFO mapreduce.JobSubmitter: number of splits:4
# 2026-09-06 23:05:50,745 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1788746338495_0002
# 2026-09-06 23:05:50,746 INFO mapreduce.JobSubmitter: Executing with tokens: []
# 2026-09-06 23:05:51,227 INFO conf.Configuration: resource-types.xml not found
# 2026-09-06 23:05:51,228 INFO resource.ResourceUtils: Unable to find 'resource-types.xml'.
# 2026-09-06 23:05:51,410 INFO impl.YarnClientImpl: Submitted application application_1788746338495_0002
# 2026-09-06 23:05:51,567 INFO mapreduce.Job: The url to track the job: http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0002/
# 2026-09-06 23:05:51,569 INFO mapreduce.Job: Running job: job_1788746338495_0002
# 2026-09-06 23:06:10,003 INFO mapreduce.Job: Job job_1788746338495_0002 running in uber mode : false
# 2026-09-06 23:06:10,008 INFO mapreduce.Job:  map 0% reduce 0%
# 2026-09-06 23:06:37,427 INFO mapreduce.Job:  map 50% reduce 0%
# 2026-09-06 23:07:09,874 INFO mapreduce.Job:  map 100% reduce 0%
# 2026-09-06 23:07:13,972 INFO mapreduce.Job: Job job_1788746338495_0002 completed successfully
# 2026-09-06 23:07:14,140 INFO mapreduce.Job: Counters: 34
#         File System Counters
#                 FILE: Number of bytes read=0
#                 FILE: Number of bytes written=1139812
#                 FILE: Number of read operations=0
#                 FILE: Number of large read operations=0
#                 FILE: Number of write operations=0
#                 HDFS: Number of bytes read=518
#                 HDFS: Number of bytes written=7196116
#                 HDFS: Number of read operations=24
#                 HDFS: Number of large read operations=0
#                 HDFS: Number of write operations=8
#                 HDFS: Number of bytes read erasure-coded=0
#         Job Counters
#                 Killed map tasks=2
#                 Launched map tasks=6
#                 Other local map tasks=6
#                 Total time spent by all maps in occupied slots (ms)=186414
#                 Total time spent by all reduces in occupied slots (ms)=0
#                 Total time spent by all map tasks (ms)=186414
#                 Total vcore-milliseconds taken by all map tasks=186414
#                 Total megabyte-milliseconds taken by all map tasks=190887936
#         Map-Reduce Framework
#                 Map input records=100000
#                 Map output records=100000
#                 Input split bytes=518
#                 Spilled Records=0
#                 Failed Shuffles=0
#                 Merged Map outputs=0
#                 GC time elapsed (ms)=594
#                 CPU time spent (ms)=23730
#                 Physical memory (bytes) snapshot=1524244480
#                 Virtual memory (bytes) snapshot=4641710678016
#                 Total committed heap usage (bytes)=1263009792
#                 Peak Map Physical memory (bytes)=414859264
#                 Peak Map Virtual memory (bytes)=1665205006336
#         File Input Format Counters
#                 Bytes Read=0
#         File Output Format Counters
#                 Bytes Written=7196116
# 2026-09-06 23:07:14,197 INFO mapreduce.ImportJobBase: Transferred 6.8628 MB in 95.1747 seconds (73.8374 KB/sec)
# 2026-09-06 23:07:14,201 INFO mapreduce.ImportJobBase: Retrieved 100000 records.
# palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -cat /user/bigdata/raw/transactions/part-m-00000 | head -3
# 1,7549,331.965,pagamento,2023-10-20 00:00:00.0,approved,95.8582,False
# 2,9264,822.086,saque,2023-04-22 00:00:00.0,approved,37.6309,False
# 3,5553,93.9353,saque,2023-03-28 00:00:00.0,approved,31.9885,False
# cat: Unable to write to output stream.

# ----------------------------------------------------------------------------------------------------------------------

### Passo 6 — Conferir os arquivos gerados

hadoop fs -ls /user/bigdata/raw/customers/

# palomamusa@DESKTOP-NJ8QT5E:~$ hadoop fs -ls /user/bigdata/raw/customers/
# Found 5 items
# -rw-r--r--   1 palomamusa supergroup          0 2026-09-06 23:01 /user/bigdata/raw/customers/_SUCCESS
# -rw-r--r--   1 palomamusa supergroup     210199 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00000
# -rw-r--r--   1 palomamusa supergroup     211051 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00001
# -rw-r--r--   1 palomamusa supergroup     210601 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00002
# -rw-r--r--   1 palomamusa supergroup     210541 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00003
