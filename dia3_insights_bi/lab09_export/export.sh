# palomamusa@DESKTOP-NJ8QT5E:~$ sudo service ssh start
#  * Starting OpenBSD Secure Shell server sshd                                                                     [ OK ]
# palomamusa@DESKTOP-NJ8QT5E:~$ jps
# 766 Jps
# 447 ResourceManager
# palomamusa@DESKTOP-NJ8QT5E:~$  start-dfs.sh
# Starting namenodes on [localhost]
# Starting datanodes
# Starting secondary namenodes [DESKTOP-NJ8QT5E]
# palomamusa@DESKTOP-NJ8QT5E:~$ start-yarn.sh
# Starting resourcemanager
# resourcemanager is running as process 447.  Stop it first and ensure /tmp/hadoop-palomamusa-resourcemanager.pid file is empty before retry.
# Starting nodemanagers
# palomamusa@DESKTOP-NJ8QT5E:~$ jps
# 1270 SecondaryNameNode
# 1672 NodeManager
# 1992 Jps
# 936 NameNode
# 1054 DataNode
# 447 ResourceManager

## Usando ROTA A — Cluster real

### Opção 1 — Sqoop export (Hive → MySQL)

```bash
# criar a tabela de destino no MySQL
mysql -u root -p bigdata_course -e "
CREATE TABLE fraud_risk_bi (
  segment VARCHAR(50), total_transacoes INT, valor_total FLOAT,
  ticket_medio FLOAT, qtd_fraudes INT, taxa_fraude_pct FLOAT, valor_em_risco FLOAT
);"

sqoop export \
  --connect jdbc:mysql://localhost:3306/bigdata_course \
  --username root --password SUASENHA \
  --table fraud_risk_bi \
  --export-dir /user/hive/warehouse/gold_fraud_risk \
  --input-fields-terminated-by '\001' \
  -m 1
```

# palomamusa@DESKTOP-NJ8QT5E:~$ mysql -u root -p -e "SHOW DATABASES;"
# Enter password:
# +--------------------+
# | Database           |
# +--------------------+
# | bigdata_course     |
# | information_schema |
# | mysql              |
# | performance_schema |
# | sys                |
# +--------------------+
# palomamusa@DESKTOP-NJ8QT5E:~$  mysql -u root -p bigdata_course -e "
# > CREATE TABLE fraud_risk_bi (
# >   segment VARCHAR(50), total_transacoes INT, valor_total FLOAT,
# >   ticket_medio FLOAT, qtd_fraudes INT, taxa_fraude_pct FLOAT, valor_em_risco FLOAT
# > );"
# Enter password:

# palomamusa@DESKTOP-NJ8QT5E:~$ sqoop export \
# >   --connect jdbc:mysql://localhost:3306/bigdata_course \
# >   --username root --password Potter@96 \
# >   --table fraud_risk_bi \
# >   --export-dir /user/hive/warehouse/gold_fraud_risk_text \
# >   --input-fields-terminated-by '\001' \
# >   -m 1
# Warning: /opt/sqoop/../hbase does not exist! HBase imports will fail.
# Please set $HBASE_HOME to the root of your HBase installation.
# Warning: /opt/sqoop/../hcatalog does not exist! HCatalog jobs will fail.
# Please set $HCAT_HOME to the root of your HCatalog installation.
# Warning: /opt/sqoop/../accumulo does not exist! Accumulo imports will fail.
# Please set $ACCUMULO_HOME to the root of your Accumulo installation.
# Warning: /opt/sqoop/../zookeeper does not exist! Accumulo imports will fail.
# Please set $ZOOKEEPER_HOME to the root of your Zookeeper installation.
# 2026-09-13 17:53:02,768 INFO sqoop.Sqoop: Running Sqoop version: 1.4.7
# 2026-09-13 17:53:02,839 WARN tool.BaseSqoopTool: Setting your password on the command-line is insecure. Consider using -P instead.
# 2026-09-13 17:53:02,981 INFO manager.MySQLManager: Preparing to use a MySQL streaming resultset.
# 2026-09-13 17:53:03,008 INFO tool.CodeGenTool: Beginning code generation
# Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
# 2026-09-13 17:53:04,296 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `fraud_risk_bi` AS t LIMIT 1
# 2026-09-13 17:53:04,350 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `fraud_risk_bi` AS t LIMIT 1
# 2026-09-13 17:53:04,362 INFO orm.CompilationManager: HADOOP_MAPRED_HOME is /opt/hadoop
# Note: /tmp/sqoop-palomamusa/compile/574c6a2a7289c129e21c8c64f4a581f9/fraud_risk_bi.java uses or overrides a deprecated API.
# Note: Recompile with -Xlint:deprecation for details.
# 2026-09-13 17:53:19,701 INFO orm.CompilationManager: Writing jar file: /tmp/sqoop-palomamusa/compile/574c6a2a7289c129e21c8c64f4a581f9/fraud_risk_bi.jar
# 2026-09-13 17:53:19,784 INFO mapreduce.ExportJobBase: Beginning export of fraud_risk_bi
# 2026-09-13 17:53:19,785 INFO Configuration.deprecation: mapred.job.tracker is deprecated. Instead, use mapreduce.jobtracker.address
# 2026-09-13 17:53:19,948 INFO Configuration.deprecation: mapred.jar is deprecated. Instead, use mapreduce.job.jar
# 2026-09-13 17:53:21,571 INFO Configuration.deprecation: mapred.reduce.tasks.speculative.execution is deprecated. Instead, use mapreduce.reduce.speculative
# 2026-09-13 17:53:21,582 INFO Configuration.deprecation: mapred.map.tasks.speculative.execution is deprecated. Instead, use mapreduce.map.speculative
# 2026-09-13 17:53:21,584 INFO Configuration.deprecation: mapred.map.tasks is deprecated. Instead, use mapreduce.job.maps
# 2026-09-13 17:53:21,780 INFO client.DefaultNoHARMFailoverProxyProvider: Connecting to ResourceManager at /0.0.0.0:8032
# 2026-09-13 17:53:22,362 INFO mapreduce.JobResourceUploader: Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/palomamusa/.staging/job_1789328741356_0003
# 2026-09-13 17:53:33,029 INFO input.FileInputFormat: Total input files to process : 1
# 2026-09-13 17:53:33,034 INFO input.FileInputFormat: Total input files to process : 1
# 2026-09-13 17:53:33,193 INFO mapreduce.JobSubmitter: number of splits:1
# 2026-09-13 17:53:33,253 INFO Configuration.deprecation: mapred.map.tasks.speculative.execution is deprecated. Instead, use mapreduce.map.speculative
# 2026-09-13 17:53:33,800 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1789328741356_0003
# 2026-09-13 17:53:33,801 INFO mapreduce.JobSubmitter: Executing with tokens: []
# 2026-09-13 17:53:34,263 INFO conf.Configuration: resource-types.xml not found
# 2026-09-13 17:53:34,264 INFO resource.ResourceUtils: Unable to find 'resource-types.xml'.
# 2026-09-13 17:53:34,427 INFO impl.YarnClientImpl: Submitted application application_1789328741356_0003
# 2026-09-13 17:53:34,476 INFO mapreduce.Job: The url to track the job: http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1789328741356_0003/
# 2026-09-13 17:53:34,479 INFO mapreduce.Job: Running job: job_1789328741356_0003
# 2026-09-13 17:53:47,122 INFO mapreduce.Job: Job job_1789328741356_0003 running in uber mode : false
# 2026-09-13 17:53:47,123 INFO mapreduce.Job:  map 0% reduce 0%
# 2026-09-13 17:53:59,606 INFO mapreduce.Job:  map 100% reduce 0%
# 2026-09-13 17:54:02,666 INFO mapreduce.Job: Job job_1789328741356_0003 completed successfully
# 2026-09-13 17:54:02,829 INFO mapreduce.Job: Counters: 33
#         File System Counters
#                 FILE: Number of bytes read=0
#                 FILE: Number of bytes written=284682
#                 FILE: Number of read operations=0
#                 FILE: Number of large read operations=0
#                 FILE: Number of write operations=0
#                 HDFS: Number of bytes read=360
#                 HDFS: Number of bytes written=0
#                 HDFS: Number of read operations=4
#                 HDFS: Number of large read operations=0
#                 HDFS: Number of write operations=0
#                 HDFS: Number of bytes read erasure-coded=0
#         Job Counters
#                 Launched map tasks=1
#                 Data-local map tasks=1
#                 Total time spent by all maps in occupied slots (ms)=9766
#                 Total time spent by all reduces in occupied slots (ms)=0
#                 Total time spent by all map tasks (ms)=9766
#                 Total vcore-milliseconds taken by all map tasks=9766
#                 Total megabyte-milliseconds taken by all map tasks=10000384
#         Map-Reduce Framework
#                 Map input records=3
#                 Map output records=3
#                 Input split bytes=152
#                 Spilled Records=0
#                 Failed Shuffles=0
#                 Merged Map outputs=0
#                 GC time elapsed (ms)=122
#                 CPU time spent (ms)=1940
#                 Physical memory (bytes) snapshot=310317056
#                 Virtual memory (bytes) snapshot=1365261467648
#                 Total committed heap usage (bytes)=308805632
#                 Peak Map Physical memory (bytes)=310317056
#                 Peak Map Virtual memory (bytes)=1365261467648
#         File Input Format Counters
#                 Bytes Read=0
#         File Output Format Counters
#                 Bytes Written=0
# 2026-09-13 17:54:02,897 INFO mapreduce.ExportJobBase: Transferred 360 bytes in 41.2613 seconds (8.7249 bytes/sec)
# 2026-09-13 17:54:02,995 INFO mapreduce.ExportJobBase: Exported 3 records.

### Opção 2 — CSV direto do Hive

```bash
INSERT OVERWRITE LOCAL DIRECTORY '/home/palomamusa/export_gold_fraud_risk'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM gold_fraud_risk;
```

```bash
cat /home/palomamusa/export_gold_fraud_risk/* > fraud_risk_export.csv
cat fraud_risk_export.csv
```

# palomamusa@DESKTOP-NJ8QT5E:~$ hive
# SLF4J: Class path contains multiple SLF4J bindings.
# SLF4J: Found binding in [jar:file:/opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar!/org/slf4j/impl/StaticLoggerBinder.class]
# SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
# SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
# SLF4J: Actual binding is of type [org.slf4j.impl.Reload4jLoggerFactory]
# 2026-09-13 17:01:04,026 INFO  [main] conf.HiveConf (HiveConf.java:findConfigFile(187)) - Found configuration file null
# 2026-09-13 17:01:10,463 WARN  [main] common.LogUtils (LogUtils.java:logConfigLocation(192)) - hive-site.xml not found on CLASSPATH
# Hive Session ID = 5d3fe91d-2e25-491e-aab7-e120c4a49038
# 2026-09-13 17:01:10,604 INFO  [main] SessionState (SessionState.java:printInfo(1227)) - Hive Session ID = 5d3fe91d-2e25-491e-aab7-e120c4a49038

# Logging initialized using configuration in jar:file:/opt/hive/lib/hive-common-3.1.3.jar!/hive-log4j2.properties Async: true
# 2026-09-13 17:01:11,180 INFO  [main] SessionState (SessionState.java:printInfo(1227)) -
# Logging initialized using configuration in jar:file:/opt/hive/lib/hive-common-3.1.3.jar!/hive-log4j2.properties Async: true
# 2026-09-13 17:01:15,311 INFO  [main] session.SessionState (SessionState.java:createPath(790)) - Created HDFS directory: /tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038
# 2026-09-13 17:01:15,380 INFO  [main] session.SessionState (SessionState.java:createPath(790)) - Created local directory: /tmp/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038
# 2026-09-13 17:01:15,390 INFO  [main] session.SessionState (SessionState.java:createPath(790)) - Created HDFS directory: /tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038/_tmp_space.db
# 2026-09-13 17:01:15,441 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 5d3fe91d-2e25-491e-aab7-e120c4a49038
# 2026-09-13 17:01:15,443 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 5d3fe91d-2e25-491e-aab7-e120c4a49038 main
# 2026-09-13 17:01:18,057 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
# 2026-09-13 17:01:18,139 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
# 2026-09-13 17:01:18,165 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
# 2026-09-13 17:01:18,177 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.MetastoreConf (MetastoreConf.java:findConfigFile(1233)) - Unable to find config file hive-site.xml
# 2026-09-13 17:01:18,179 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.MetastoreConf (MetastoreConf.java:findConfigFile(1240)) - Found configuration file null
# 2026-09-13 17:01:18,188 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.MetastoreConf (MetastoreConf.java:findConfigFile(1233)) - Unable to find config file hivemetastore-site.xml
# 2026-09-13 17:01:18,189 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.MetastoreConf (MetastoreConf.java:findConfigFile(1240)) - Found configuration file null
# 2026-09-13 17:01:18,196 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.MetastoreConf (MetastoreConf.java:findConfigFile(1233)) - Unable to find config file metastore-site.xml
# 2026-09-13 17:01:18,198 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.MetastoreConf (MetastoreConf.java:findConfigFile(1240)) - Found configuration file null
# 2026-09-13 17:01:18,773 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.Persistence (Log4JLogger.java:info(77)) - Property datanucleus.cache.level2 unknown - will be ignored
# 2026-09-13 17:01:20,157 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] hikari.HikariDataSource (HikariDataSource.java:<init>(71)) - HikariPool-1 - Starting...
# 2026-09-13 17:01:20,170 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] util.DriverDataSource (DriverDataSource.java:<init>(68)) - Registered driver with driverClassName=org.apache.derby.jdbc.EmbeddedDriver was not found, trying direct instantiation.
# 2026-09-13 17:01:22,168 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] pool.PoolBase (PoolBase.java:getAndSetNetworkTimeout(503)) - HikariPool-1 - Driver does not support get/set network timeout for connections. (Feature not implemented: No details.)
# 2026-09-13 17:01:22,180 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] hikari.HikariDataSource (HikariDataSource.java:<init>(73)) - HikariPool-1 - Start completed.
# 2026-09-13 17:01:22,371 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] hikari.HikariDataSource (HikariDataSource.java:<init>(71)) - HikariPool-2 - Starting...
# 2026-09-13 17:01:22,373 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] util.DriverDataSource (DriverDataSource.java:<init>(68)) - Registered driver with driverClassName=org.apache.derby.jdbc.EmbeddedDriver was not found, trying direct instantiation.
# 2026-09-13 17:01:22,382 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] pool.PoolBase (PoolBase.java:getAndSetNetworkTimeout(503)) - HikariPool-2 - Driver does not support get/set network timeout for connections. (Feature not implemented: No details.)
# 2026-09-13 17:01:22,384 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] hikari.HikariDataSource (HikariDataSource.java:<init>(73)) - HikariPool-2 - Start completed.
# 2026-09-13 17:01:23,549 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:getPMF(671)) - Setting MetaStore object pin classes with hive.metastore.cache.pinobjtypes="Table,StorageDescriptor,SerDeInfo,Partition,Database,Type,FieldSchema,Order"
# 2026-09-13 17:01:24,294 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
# 2026-09-13 17:01:24,299 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
# 2026-09-13 17:01:24,960 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:24,964 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:24,968 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:24,970 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:24,972 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:24,974 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:35,203 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:35,207 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:35,210 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:35,212 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:35,215 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:35,219 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] DataNucleus.MetaData (Log4JLogger.java:warn(96)) - Metadata has jdbc-type of null yet this is not valid. Ignored
# 2026-09-13 17:01:50,782 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:createDefaultRoles_core(814)) - Added admin role in metastore
# 2026-09-13 17:01:50,786 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:createDefaultRoles_core(823)) - Added public role in metastore
# 2026-09-13 17:01:50,960 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:addAdminUsers_core(863)) - No user is added in admin role, since config is empty
# 2026-09-13 17:01:51,442 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
# 2026-09-13 17:01:51,481 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_all_functions
# 2026-09-13 17:01:51,487 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_all_functions
# Hive Session ID = a8ebbd9c-6731-4667-96ae-a04aebdfcf24
# Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.2026-09-13 17:01:51,705 INFO  [pool-9-thread-1] SessionState (SessionState.java:printInfo(1227)) - Hive Session ID = a8ebbd9c-6731-4667-96ae-a04aebdfcf24

# 2026-09-13 17:01:51,709 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] CliDriver (SessionState.java:printInfo(1227)) - Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
# 2026-09-13 17:01:51,743 INFO  [pool-9-thread-1] session.SessionState (SessionState.java:createPath(790)) - Created HDFS directory: /tmp/hive/palomamusa/a8ebbd9c-6731-4667-96ae-a04aebdfcf24
# 2026-09-13 17:01:51,750 INFO  [pool-9-thread-1] session.SessionState (SessionState.java:createPath(790)) - Created local directory: /tmp/palomamusa/a8ebbd9c-6731-4667-96ae-a04aebdfcf24
# 2026-09-13 17:01:51,769 INFO  [pool-9-thread-1] session.SessionState (SessionState.java:createPath(790)) - Created HDFS directory: /tmp/hive/palomamusa/a8ebbd9c-6731-4667-96ae-a04aebdfcf24/_tmp_space.db
# 2026-09-13 17:01:51,774 INFO  [pool-9-thread-1] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 1: get_databases: @hive#
# 2026-09-13 17:01:51,776 INFO  [pool-9-thread-1] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa    ip=unknown-ip-addr      cmd=get_databases: @hive#
# 2026-09-13 17:01:51,785 INFO  [pool-9-thread-1] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 1: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
# 2026-09-13 17:01:51,788 INFO  [pool-9-thread-1] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
# 2026-09-13 17:01:51,798 INFO  [pool-9-thread-1] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
# 2026-09-13 17:01:51,801 INFO  [pool-9-thread-1] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
# 2026-09-13 17:01:51,824 INFO  [pool-9-thread-1] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 1: get_tables_by_type: db=@hive#avaliacao_techpay pat=.*,type=MATERIALIZED_VIEW
# 2026-09-13 17:01:51,827 INFO  [pool-9-thread-1] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa    ip=unknown-ip-addr      cmd=get_tables_by_type: db=@hive#avaliacao_techpay pat=.*,type=MATERIALIZED_VIEW
# 2026-09-13 17:01:52,181 INFO  [pool-9-thread-1] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 1: get_multi_table : db=avaliacao_techpay tbls=
# 2026-09-13 17:01:52,183 INFO  [pool-9-thread-1] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa    ip=unknown-ip-addr      cmd=get_multi_table : db=avaliacao_techpay tbls=
# 2026-09-13 17:01:52,190 INFO  [pool-9-thread-1] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 1: get_tables_by_type: db=@hive#default pat=.*,type=MATERIALIZED_VIEW
# 2026-09-13 17:01:52,192 INFO  [pool-9-thread-1] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa    ip=unknown-ip-addr      cmd=get_tables_by_type: db=@hive#default pat=.*,type=MATERIALIZED_VIEW
# 2026-09-13 17:01:52,210 INFO  [pool-9-thread-1] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 1: get_multi_table : db=default tbls=
# 2026-09-13 17:01:52,211 INFO  [pool-9-thread-1] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa    ip=unknown-ip-addr      cmd=get_multi_table : db=default tbls=
# 2026-09-13 17:01:52,217 INFO  [pool-9-thread-1] metadata.HiveMaterializedViewsRegistry (HiveMaterializedViewsRegistry.java:run(171)) - Materialized views registry has been initialized
# hive> INSERT OVERWRITE LOCAL DIRECTORY '/home/palomamusa/export_gold_fraud_risk'
# ROW FORMAT DELIMIT    > ED FIELDS TERMINATED BY ','
#     > SELECT * FROM gold_fraud_risk;
# 2026-09-13 17:02:47,482 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 5d3fe91d-2e25-491e-aab7-e120c4a49038
# 2026-09-13 17:02:47,883 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260913170247_dd8c7ff4-055e-4620-90c0-c526abde6097): INSERT OVERWRITE LOCAL DIRECTORY '/home/palomamusa/export_gold_fraud_risk'
# ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
# SELECT * FROM gold_fraud_risk
# 2026-09-13 17:02:48,853 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
# 2026-09-13 17:02:48,862 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12123)) - Starting Semantic Analysis
# 2026-09-13 17:02:48,958 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] sqlstd.SQLStdHiveAccessController (SQLStdHiveAccessController.java:<init>(96)) - Created SQLStdHiveAccessController for session context : HiveAuthzSessionContext [sessionString=5d3fe91d-2e25-491e-aab7-e120c4a49038, clientType=HIVECLI]
# 2026-09-13 17:02:48,966 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] session.SessionState (SessionState.java:setAuthorizerV2Config(950)) - METASTORE_FILTER_HOOK will be ignored, since hive.security.authorization.manager is set to instance of HiveAuthorizerFactory.
# 2026-09-13 17:02:48,968 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStoreClient (HiveMetaStoreClient.java:isCompatibleWith(346)) - Mestastore configuration metastore.filter.hook changed from org.apache.hadoop.hive.metastore.DefaultMetaStoreFilterHookImpl to org.apache.hadoop.hive.ql.security.authorization.plugin.AuthorizationMetaStoreFilterHook
# 2026-09-13 17:02:48,973 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
# 2026-09-13 17:02:48,974 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
# 2026-09-13 17:02:48,976 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
# 2026-09-13 17:02:48,978 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
# 2026-09-13 17:02:48,986 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
# 2026-09-13 17:02:48,987 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
# 2026-09-13 17:02:48,990 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
# 2026-09-13 17:02:48,993 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
# 2026-09-13 17:02:48,994 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
# 2026-09-13 17:02:48,999 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
# 2026-09-13 17:02:49,012 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12029)) - Completed phase 1 of Semantic Analysis
# 2026-09-13 17:02:49,014 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
# 2026-09-13 17:02:49,019 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
# 2026-09-13 17:02:49,020 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
# 2026-09-13 17:02:49,024 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
# 2026-09-13 17:02:49,026 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
# 2026-09-13 17:02:49,031 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
# 2026-09-13 17:02:49,047 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:49,050 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:52,117 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
# 2026-09-13 17:02:52,157 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
# 2026-09-13 17:02:52,164 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12034)) - Completed getting MetaData in Semantic Analysis
# 2026-09-13 17:02:52,222 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] results.QueryResultsCache (QueryResultsCache.java:<init>(367)) - Initializing query results cache at /tmp/hive/_resultscache_
# 2026-09-13 17:02:52,268 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] results.QueryResultsCache (QueryResultsCache.java:<init>(388)) - Query results cache: cacheDirectory /tmp/hive/_resultscache_/results-42b53e70-4d30-467f-a21b-65aea145f174, maxCacheSize 2147483648, maxEntrySize 10485760, maxEntryLifetime 3600000
# 2026-09-13 17:02:54,418 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_not_null_constraints : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:54,421 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_not_null_constraints : tbl=hive.default.gold_fraud_risk

# 2026-09-13 17:02:54,633 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:54,638 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:54,693 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:54,696 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:54,702 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_unique_constraints : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:54,704 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_unique_constraints : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:54,748 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=gold_fraud_risk
# 2026-09-13 17:02:54,751 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=gold_fraud_risk
# 2026-09-13 17:02:56,011 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_databases: @hive#
# 2026-09-13 17:02:56,014 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_databases: @hive#
# 2026-09-13 17:02:56,026 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_materialized_views_for_rewriting: db=@hive#avaliacao_techpay
# 2026-09-13 17:02:56,028 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_materialized_views_for_rewriting: db=@hive#avaliacao_techpay
# 2026-09-13 17:02:56,048 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_materialized_views_for_rewriting: db=@hive#default
# 2026-09-13 17:02:56,050 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_materialized_views_for_rewriting: db=@hive#default
# 2026-09-13 17:02:56,251 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
# 2026-09-13 17:02:56,254 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:56,257 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.gold_fraud_risk
# 2026-09-13 17:02:56,284 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
# 2026-09-13 17:02:56,287 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
# 2026-09-13 17:02:56,554 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038/hive_2026-09-13_17-02-47_957_1865919439222160742-1
# 2026-09-13 17:02:56,664 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] common.FileUtils (FileUtils.java:mkdir(580)) - Creating directory if it doesn't exist: hdfs://localhost:9000/home/palomamusa/export_gold_fraud_risk/.hive-staging_hive_2026-09-13_17-02-47_957_1865919439222160742-1
# 2026-09-13 17:02:56,680 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (CalcitePlanner.java:genOPTree(518)) - CBO Succeeded; optimized logical plan.
# 2026-09-13 17:02:56,787 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for FS(2)
# 2026-09-13 17:02:56,789 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(1)
# 2026-09-13 17:02:56,793 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ppd.OpProcFactory (OpProcFactory.java:process(417)) - Processing for TS(0)
# 2026-09-13 17:02:57,235 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapWork(1849)) - Examining input format to see if vectorization is enabled.
# 2026-09-13 17:02:57,272 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapWork(1938)) - Vectorization is enabled for input format(s) [org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat]
# 2026-09-13 17:02:57,274 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapOperators(1961)) - Validating and vectorizing MapWork... (vectorizedVertexNum 0)
# 2026-09-13 17:02:57,363 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1035)) - Map vectorization enabled: true
# 2026-09-13 17:02:57,365 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1037)) - Map vectorized: true
# 2026-09-13 17:02:57,371 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1044)) - Map vectorizedVertexNum: 0
# 2026-09-13 17:02:57,375 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1076)) - Map enabledConditionsMet: [hive.vectorized.use.vectorized.input.format IS true]
# 2026-09-13 17:02:57,378 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1085)) - Map inputFileFormatClassNameSet: [org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat]
# 2026-09-13 17:02:57,394 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12343)) - Completed plan generation
# 2026-09-13 17:02:57,396 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] parse.CalcitePlanner (SemanticAnalyzer.java:queryCanBeCached(14771)) - Not eligible for results caching - no fetch task
# 2026-09-13 17:02:57,398 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
# 2026-09-13 17:02:57,451 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:[FieldSchema(name:gold_fraud_risk.segment, type:string, comment:null), FieldSchema(name:gold_fraud_risk.total_transacoes, type:bigint, comment:null), FieldSchema(name:gold_fraud_risk.valor_total, type:double, comment:null), FieldSchema(name:gold_fraud_risk.ticket_medio, type:double, comment:null), FieldSchema(name:gold_fraud_risk.qtd_fraudes, type:bigint, comment:null), FieldSchema(name:gold_fraud_risk.taxa_fraude_pct, type:decimal(26,2), comment:null), FieldSchema(name:gold_fraud_risk.valor_em_risco, type:double, comment:null)], properties:null)
# 2026-09-13 17:02:57,481 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260913170247_dd8c7ff4-055e-4620-90c0-c526abde6097); Time taken: 9.728 seconds
# 2026-09-13 17:02:57,488 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
# 2026-09-13 17:02:57,493 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
# 2026-09-13 17:02:57,496 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260913170247_dd8c7ff4-055e-4620-90c0-c526abde6097): INSERT OVERWRITE LOCAL DIRECTORY '/home/palomamusa/export_gold_fraud_risk'
# ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
# SELECT * FROM gold_fraud_risk
# 2026-09-13 17:02:57,511 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:logMrWarning(2591)) - Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
# Query ID = palomamusa_20260913170247_dd8c7ff4-055e-4620-90c0-c526abde6097
# 2026-09-13 17:02:57,516 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (SessionState.java:printInfo(1227)) - Query ID = palomamusa_20260913170247_dd8c7ff4-055e-4620-90c0-c526abde6097
# Total jobs = 1
# 2026-09-13 17:02:57,520 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (SessionState.java:printInfo(1227)) - Total jobs = 1
# Launching Job 1 out of 1
# 2026-09-13 17:02:57,581 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (SessionState.java:printInfo(1227)) - Launching Job 1 out of 1
# 2026-09-13 17:02:57,600 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-1:MAPRED] in serial mode
# Number of reduce tasks is set to 0 since there's no reduce operator
# 2026-09-13 17:02:57,603 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - Number of reduce tasks is set to 0 since there's no reduce operator
# 2026-09-13 17:02:57,608 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038/hive_2026-09-13_17-02-47_957_1865919439222160742-1
# 2026-09-13 17:02:57,660 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mr.ExecDriver (ExecDriver.java:execute(299)) - Using org.apache.hadoop.hive.ql.io.CombineHiveInputFormat
# 2026-09-13 17:02:57,672 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Utilities (Utilities.java:getInputPaths(3298)) - Processing alias gold_fraud_risk
# 2026-09-13 17:02:57,674 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Utilities (Utilities.java:getInputPaths(3336)) - Adding 1 inputs; the first input is hdfs://localhost:9000/user/hive/warehouse/gold_fraud_risk
# 2026-09-13 17:02:58,036 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038/hive_2026-09-13_17-02-47_957_1865919439222160742-1
# 2026-09-13 17:02:58,713 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.SerializationUtilities (SerializationUtilities.java:serializePlan(569)) - Serializing MapWork using kryo
# 2026-09-13 17:03:00,294 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] Configuration.deprecation (Configuration.java:logDeprecation(1442)) - mapred.submit.replication is deprecated. Instead, use mapreduce.client.submit.file.replication
# 2026-09-13 17:03:00,345 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Utilities (Utilities.java:setBaseWork(633)) - Serialized plan (via FILE) - name: null size: 5.96KB
# 2026-09-13 17:03:00,913 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
# 2026-09-13 17:03:02,098 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
# 2026-09-13 17:03:02,147 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038/hive_2026-09-13_17-02-47_957_1865919439222160742-1/-mr-10003/3de8c634-fbec-42ed-b428-1bdcca2e821e/map.xml
# 2026-09-13 17:03:02,932 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mapreduce.JobResourceUploader (JobResourceUploader.java:uploadResourcesInternal(149)) - Hadoop command-line option parsing not performed. Implement the Tool interface and execute your application with ToolRunner to remedy this.
# 2026-09-13 17:03:03,014 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mapreduce.JobResourceUploader (JobResourceUploader.java:disableErasureCodingForPath(907)) - Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/palomamusa/.staging/job_1789328741356_0001
# 2026-09-13 17:03:04,154 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038/hive_2026-09-13_17-02-47_957_1865919439222160742-1/-mr-10003/3de8c634-fbec-42ed-b428-1bdcca2e821e/map.xml
# 2026-09-13 17:03:04,157 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getNonCombinablePathIndices(477)) - Total number of paths: 1, launching 1 threads to check non-combinable ones.
# 2026-09-13 17:03:04,187 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(413)) - CombineHiveInputSplit creating pool for hdfs://localhost:9000/user/hive/warehouse/gold_fraud_risk; using filter path hdfs://localhost:9000/user/hive/warehouse/gold_fraud_risk
# 2026-09-13 17:03:04,577 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] input.FileInputFormat (FileInputFormat.java:listStatus(300)) - Total input files to process : 1
# 2026-09-13 17:03:04,722 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(467)) - number of splits 1
# 2026-09-13 17:03:04,729 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getSplits(587)) - Number of all splits 1
# 2026-09-13 17:03:04,859 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mapreduce.JobSubmitter (JobSubmitter.java:submitJobInternal(202)) - number of splits:1
# 2026-09-13 17:03:04,907 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] Configuration.deprecation (Configuration.java:logDeprecation(1442)) - yarn.resourcemanager.system-metrics-publisher.enabled is deprecated. Instead, use yarn.system-metrics-publisher.enabled
# 2026-09-13 17:03:05,004 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(298)) - Submitting tokens for job: job_1789328741356_0001
# 2026-09-13 17:03:05,007 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(299)) - Executing with tokens: []
# 2026-09-13 17:03:05,929 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.Configuration (Configuration.java:getConfResourceAsInputStream(2854)) - resource-types.xml not found
# 2026-09-13 17:03:05,936 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] resource.ResourceUtils (ResourceUtils.java:addResourcesFileToConf(476)) - Unable to find 'resource-types.xml'.
# 2026-09-13 17:03:07,252 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] impl.YarnClientImpl (YarnClientImpl.java:submitApplication(338)) - Submitted application application_1789328741356_0001
# 2026-09-13 17:03:07,630 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mapreduce.Job (Job.java:submit(1682)) - The url to track the job: http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1789328741356_0001/
# Starting Job = job_1789328741356_0001, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1789328741356_0001/
# 2026-09-13 17:03:07,638 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - Starting Job = job_1789328741356_0001, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1789328741356_0001/
# Kill Command = /opt/hadoop/bin/mapred job  -kill job_1789328741356_0001
# 2026-09-13 17:03:07,641 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - Kill Command = /opt/hadoop/bin/mapred job  -kill job_1789328741356_0001
# Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 0
# 2026-09-13 17:03:50,335 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 0
# 2026-09-13 17:03:50,554 WARN  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] mapreduce.Counters (AbstractCounters.java:getGroup(235)) - Group org.apache.hadoop.mapred.Task$Counter is deprecated. Use org.apache.hadoop.mapreduce.TaskCounter instead
# 2026-09-13 17:03:50,521 Stage-1 map = 0%,  reduce = 0%
# 2026-09-13 17:03:50,562 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-13 17:03:50,521 Stage-1 map = 0%,  reduce = 0%
# 2026-09-13 17:04:21,055 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 7.31 sec
# 2026-09-13 17:04:21,056 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-13 17:04:21,055 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 7.31 sec
# MapReduce Total cumulative CPU time: 7 seconds 310 msec
# 2026-09-13 17:04:25,428 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - MapReduce Total cumulative CPU time: 7 seconds 310 msec
# Ended Job = job_1789328741356_0001
# 2026-09-13 17:04:25,536 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - Ended Job = job_1789328741356_0001
# 2026-09-13 17:04:25,688 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-0:MOVE] in serial mode
# 2026-09-13 17:04:25,757 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
# 2026-09-13 17:04:25,759 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
# 2026-09-13 17:04:25,763 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
# 2026-09-13 17:04:25,765 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
# Moving data to local directory /home/palomamusa/export_gold_fraud_risk
# 2026-09-13 17:04:25,768 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] exec.Task (SessionState.java:printInfo(1227)) - Moving data to local directory /home/palomamusa/export_gold_fraud_risk from hdfs://localhost:9000/tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038/hive_2026-09-13_17-02-47_957_1865919439222160742-1/-mr-10000
# 2026-09-13 17:04:25,771 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] common.FileUtils (FileUtils.java:mkdir(580)) - Creating directory if it doesn't exist: /home/palomamusa/export_gold_fraud_risk
# MapReduce Jobs Launched:
# 2026-09-13 17:04:26,159 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (SessionState.java:printInfo(1227)) - MapReduce Jobs Launched:
# Stage-Stage-1: Map: 1   Cumulative CPU: 7.31 sec   HDFS Read: 8730 HDFS Write: 205 SUCCESS
# 2026-09-13 17:04:26,162 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (SessionState.java:printInfo(1227)) - Stage-Stage-1: Map: 1   Cumulative CPU: 7.31 sec   HDFS Read: 8730 HDFS Write: 205 SUCCESS
# Total MapReduce CPU Time Spent: 7 seconds 310 msec
# 2026-09-13 17:04:26,165 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (SessionState.java:printInfo(1227)) - Total MapReduce CPU Time Spent: 7 seconds 310 msec
# 2026-09-13 17:04:26,167 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260913170247_dd8c7ff4-055e-4620-90c0-c526abde6097); Time taken: 88.662 seconds
# OK
# 2026-09-13 17:04:26,170 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
# 2026-09-13 17:04:26,172 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
# Time taken: 98.433 seconds
# 2026-09-13 17:04:26,181 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 98.433 seconds
# 2026-09-13 17:04:26,184 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 5d3fe91d-2e25-491e-aab7-e120c4a49038
# 2026-09-13 17:04:26,186 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main
# hive> quit;
# 2026-09-13 17:05:29,489 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 5d3fe91d-2e25-491e-aab7-e120c4a49038
# 2026-09-13 17:05:29,490 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 5d3fe91d-2e25-491e-aab7-e120c4a49038 main
# 2026-09-13 17:05:29,518 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] session.SessionState (SessionState.java:dropPathAndUnregisterDeleteOnExit(885)) - Deleted directory: /tmp/hive/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038 on fs with scheme hdfs
# 2026-09-13 17:05:29,521 INFO  [5d3fe91d-2e25-491e-aab7-e120c4a49038 main] session.SessionState (SessionState.java:dropPathAndUnregisterDeleteOnExit(885)) - Deleted directory: /tmp/palomamusa/5d3fe91d-2e25-491e-aab7-e120c4a49038 on fs with scheme file
# palomamusa@DESKTOP-NJ8QT5E:~$ cat /home/palomamusa/export_gold_fraud_risk/* > fraud_risk_export.csv
# palomamusa@DESKTOP-NJ8QT5E:~$ cat fraud_risk_export.csv
# High-Risk,9154,1664576.8214797974,181.84,705,7.70,126451.06381320953
# Premium,61155,1.1235017883358955E7,183.71,473,0.77,81308.43419742584
# Standard,29687,5478679.74229908,184.55,655,2.21,106828.44038963318






