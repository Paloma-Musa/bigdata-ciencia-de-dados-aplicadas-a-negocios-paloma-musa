## Usando ROTA A — Cluster real (Hive)

### Passo 1 — Abrir o Hive
hive

-- palomamusa@DESKTOP-NJ8QT5E:~$ hive
-- SLF4J: Class path contains multiple SLF4J bindings.
-- SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: Found binding in [jar:file:/opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
-- SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
-- Hive Session ID = 450aec60-afb9-4c83-8af1-9bc7986f893b

-- Logging initialized using configuration in jar:file:/opt/hive/lib/hive-common-3.1.3.jar!/hive-log4j2.properties Async: true
-- Hive Session ID = b2e7554f-2d11-4219-a15f-dead22182434
-- Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
-- hive>

# ----------------------------------------------------------------------------------------------------------------------

### Passo 2 — Criar tabela EXTERNAL sobre o raw

```sql
CREATE EXTERNAL TABLE raw_customers (
  customer_id INT, name STRING, cpf STRING, email STRING,
  segment STRING, credit_score INT, created_at STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/bigdata/raw/customers'
TBLPROPERTIES ('skip.header.line.count'='1');
```

-- hive> CREATE EXTERNAL TABLE raw_customers (
--   customer_id INT, name STRING, cpf STRING, email STRING,
--   segment STRING, credit_score INT, created_at ST    > RING
-- )
-- ROW FORMAT DELI    > MITED FIELDS TERMINATED BY ','
-- STORED AS TEXT    > FILE    >
-- LOCATION '/user/bigdata/raw    > /customers'
-- TB    > LPROPERTIES ('skip.header.l    > ine.count'='1');
-- OK
-- Time taken: 1.91 seconds

# ----------------------------------------------------------------------------------------------------------------------

### Passo 3 — Conferir os dados

```sql
SELECT COUNT(*) FROM raw_customers;
SELECT * FROM raw_customers LIMIT 5;
```

-- hive> SELECT COUNT(*) FROM raw_customers;
-- Query ID = palomamusa_20260907000139_7713d3de-536f-4b93-b405-e0ec708d9ce3
-- Total jobs = 1
-- Launching Job 1 out of 1
-- Number of reduce tasks determined at compile time: 1
-- In order to change the average load for a reducer (in bytes):
--   set hive.exec.reducers.bytes.per.reducer=<number>
-- In order to limit the maximum number of reducers:
--   set hive.exec.reducers.max=<number>
-- In order to set a constant number of reducers:
--   set mapreduce.job.reduces=<number>
-- Starting Job = job_1788746338495_0004, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0004/
-- Kill Command = /opt/hadoop/bin/mapred job  -kill job_1788746338495_0004
-- Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
-- 2026-09-07 00:01:52,061 Stage-1 map = 0%,  reduce = 0%
-- 2026-09-07 00:01:59,363 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 4.89 sec
-- SELECT * FROM raw_customers LIMIT 5;
-- 2026-09-07 00:02:06,643 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 7.77 sec
-- MapReduce Total cumulative CPU time: 7 seconds 770 msec
-- Ended Job = job_1788746338495_0004
-- MapReduce Jobs Launched:
-- Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 7.77 sec   HDFS Read: 855796 HDFS Write: 104 SUCCESS
-- Total MapReduce CPU Time Spent: 7 seconds 770 msec
-- OK
-- 9993
-- Time taken: 29.693 seconds, Fetched: 1 row(s)
-- hive> OK
-- 1       Ana Laura Campos        943.065.218-42  igor46@example.com      Premium 426     2026-07-03
-- 2       Mariah Caldeira 586.237.094-38  jose48@example.com      High-Risk       481     2026-06-17
-- 3       Kevin Cavalcante        530.629.814-15  theoda-costa@example.org        Standard        708     2025-11-06
-- 4       Maria Laura Freitas     725.130.864-90  castrolucas@example.org Premium 473     2026-02-07
-- 5       Srta. Mirella Moura     570.814.239-14  emilly20@example.com    Premium 816     2025-10-04
-- Time taken: 0.096 seconds, Fetched: 5 row(s)

### Passo 3.5 (opcional) — Corrigir HADOOP_CLASSPATH antes do INSERT

```bash
hadoop classpath
export HADOOP_CLASSPATH=$(hadoop classpath)
```

```bash
echo 'export HADOOP_CLASSPATH=$(hadoop classpath)' >> ~/.bashrc
source ~/.bashrc
```

-- hive> quit;
-- palomamusa@DESKTOP-NJ8QT5E:~$ hadoop classpath
-- /opt/hadoop/etc/hadoop:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/yarn:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*
-- palomamusa@DESKTOP-NJ8QT5E:~$ export HADOOP_CLASSPATH=$(hadoop classpath)
-- palomamusa@DESKTOP-NJ8QT5E:~$ echo 'export HADOOP_CLASSPATH=$(hadoop classpath)' >> ~/.bashrc
-- palomamusa@DESKTOP-NJ8QT5E:~$ source ~/.bashrc

### Passo 4 — Criar uma tabela MANAGED de teste

```sql
CREATE TABLE teste_managed (id INT, valor STRING);
INSERT INTO teste_managed VALUES (1, 'linha de teste');
SELECT * FROM teste_managed;
```
-- hive> CREATE TABLE teste_managed (id INT, valor STRING);
-- INSERT INTO teste_managed VALUES (1, 'linha de teste');
-- SE2026-09-07 00:08:08,897 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- LECT * FROM teste_managed;
-- 2026-09-07 00:08:08,996 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260907000808_3fcd58bc-6b26-4be9-a94b-3f5aaf661fef): CREATE TABLE teste_managed (id INT, valor STRING)
-- 2026-09-07 00:08:09,380 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:08:09,385 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12123)) - Starting Semantic Analysis
-- 2026-09-07 00:08:09,423 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] sqlstd.SQLStdHiveAccessController (SQLStdHiveAccessController.java:<init>(96)) - Created SQLStdHiveAccessController for session context : HiveAuthzSessionContext [sessionString=778c135c-019f-4eef-9e9d-715460a5f645, clientType=HIVECLI]
-- 2026-09-07 00:08:09,427 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:setAuthorizerV2Config(950)) - METASTORE_FILTER_HOOK will be ignored, since hive.security.authorization.manager is set to instance of HiveAuthorizerFactory.
-- 2026-09-07 00:08:09,428 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStoreClient (HiveMetaStoreClient.java:isCompatibleWith(346)) - Mestastore configuration metastore.filter.hook changed from org.apache.hadoop.hive.metastore.DefaultMetaStoreFilterHookImpl to org.apache.hadoop.hive.ql.security.authorization.plugin.AuthorizationMetaStoreFilterHook
-- 2026-09-07 00:08:09,430 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-07 00:08:09,431 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-07 00:08:09,433 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-07 00:08:09,434 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- 2026-09-07 00:08:09,437 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-07 00:08:09,438 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-07 00:08:09,440 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-07 00:08:09,444 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-07 00:08:09,445 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-07 00:08:09,447 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-07 00:08:09,460 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeCreateTable(12993)) - Creating table default.teste_managed position=13
-- 2026-09-07 00:08:09,482 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-07 00:08:09,483 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-07 00:08:09,488 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-07 00:08:09,489 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-07 00:08:09,493 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-07 00:08:09,494 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-07 00:08:09,495 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-07 00:08:09,521 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
-- 2026-09-07 00:08:09,531 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:null, properties:null)
-- 2026-09-07 00:08:09,539 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260907000808_3fcd58bc-6b26-4be9-a94b-3f5aaf661fef); Time taken: 0.583 seconds
-- 2026-09-07 00:08:09,540 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
-- 2026-09-07 00:08:09,541 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:08:09,542 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260907000808_3fcd58bc-6b26-4be9-a94b-3f5aaf661fef): CREATE TABLE teste_managed (id INT, valor STRING)
-- 2026-09-07 00:08:09,558 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-0:DDL] in serial mode
-- 2026-09-07 00:08:09,560 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStoreClient (HiveMetaStoreClient.java:isCompatibleWith(346)) - Mestastore configuration metastore.filter.hook changed from org.apache.hadoop.hive.ql.security.authorization.plugin.AuthorizationMetaStoreFilterHook to org.apache.hadoop.hive.metastore.DefaultMetaStoreFilterHookImpl
-- 2026-09-07 00:08:09,561 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-07 00:08:09,562 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-07 00:08:09,594 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-07 00:08:09,597 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- 2026-09-07 00:08:10,047 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-07 00:08:10,048 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-07 00:08:10,051 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-07 00:08:10,054 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-07 00:08:10,055 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-07 00:08:10,057 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-07 00:08:10,058 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: create_table: Table(tableName:teste_managed, dbName:default, owner:palomamusa, createTime:1788750489, lastAccessTime:0, retention:0, sd:StorageDescriptor(cols:[FieldSchema(name:id, type:int, comment:null), FieldSchema(name:valor, type:string, comment:null)], location:null, inputFormat:org.apache.hadoop.mapred.TextInputFormat, outputFormat:org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat, compressed:false, numBuckets:-1, serdeInfo:SerDeInfo(name:null, serializationLib:org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe, parameters:{serialization.format=1}), bucketCols:[], sortCols:[], parameters:{}, skewedInfo:SkewedInfo(skewedColNames:[], skewedColValues:[], skewedColValueLocationMaps:{}), storedAsSubDirectories:false), partitionKeys:[], parameters:{totalSize=0, numRows=0, rawDataSize=0, COLUMN_STATS_ACCURATE={"BASIC_STATS":"true","COLUMN_STATS":{"id":"true","valor":"true"}}, numFiles=0, bucketing_version=2}, viewOriginalText:null, viewExpandedText:null, tableType:MANAGED_TABLE, privileges:PrincipalPrivilegeSet(userPrivileges:{palomamusa=[PrivilegeGrantInfo(privilege:INSERT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:SELECT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:UPDATE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:DELETE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true)]}, groupPrivileges:null, rolePrivileges:null), temporary:false, catName:hive, ownerType:USER)
-- 2026-09-07 00:08:10,059 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=create_table: Table(tableName:teste_managed, dbName:default, owner:palomamusa, createTime:1788750489, lastAccessTime:0, retention:0, sd:StorageDescriptor(cols:[FieldSchema(name:id, type:int, comment:null), FieldSchema(name:valor, type:string, comment:null)], location:null, inputFormat:org.apache.hadoop.mapred.TextInputFormat, outputFormat:org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat, compressed:false, numBuckets:-1, serdeInfo:SerDeInfo(name:null, serializationLib:org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe, parameters:{serialization.format=1}), bucketCols:[], sortCols:[], parameters:{}, skewedInfo:SkewedInfo(skewedColNames:[], skewedColValues:[], skewedColValueLocationMaps:{}), storedAsSubDirectories:false), partitionKeys:[], parameters:{totalSize=0, numRows=0, rawDataSize=0, COLUMN_STATS_ACCURATE={"BASIC_STATS":"true","COLUMN_STATS":{"id":"true","valor":"true"}}, numFiles=0, bucketing_version=2}, viewOriginalText:null, viewExpandedText:null, tableType:MANAGED_TABLE, privileges:PrincipalPrivilegeSet(userPrivileges:{palomamusa=[PrivilegeGrantInfo(privilege:INSERT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:SELECT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:UPDATE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:DELETE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true)]}, groupPrivileges:null, rolePrivileges:null), temporary:false, catName:hive, ownerType:USER)
-- 2026-09-07 00:08:10,130 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] utils.FileUtils (FileUtils.java:mkdir(167)) - Creating directory if it doesn't exist: hdfs://localhost:9000/user/hive/warehouse/teste_managed
-- 2026-09-07 00:08:10,337 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260907000808_3fcd58bc-6b26-4be9-a94b-3f5aaf661fef); Time taken: 0.795 seconds
-- OK
-- 2026-09-07 00:08:10,342 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
-- 2026-09-07 00:08:10,342 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- Time taken: 1.392 seconds
-- 2026-09-07 00:08:10,345 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 1.392 seconds
-- 2026-09-07 00:08:10,346 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:08:10,347 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main
-- hive> 2026-09-07 00:08:10,349 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:08:10,349 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- 2026-09-07 00:08:10,352 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260907000810_811e67dd-e98b-4478-97b4-d90e13ebc8a2): INSERT INTO teste_managed VALUES (1, 'linha de teste')
-- 2026-09-07 00:08:10,376 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStoreClient (HiveMetaStoreClient.java:isCompatibleWith(346)) - Mestastore configuration metastore.filter.hook changed from org.apache.hadoop.hive.metastore.DefaultMetaStoreFilterHookImpl to org.apache.hadoop.hive.ql.security.authorization.plugin.AuthorizationMetaStoreFilterHook
-- 2026-09-07 00:08:10,378 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-07 00:08:10,380 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-07 00:08:10,381 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-07 00:08:10,382 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- 2026-09-07 00:08:10,383 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:08:10,384 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12123)) - Starting Semantic Analysis
-- 2026-09-07 00:08:10,392 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-07 00:08:10,393 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-07 00:08:10,396 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-07 00:08:10,398 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-07 00:08:10,399 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-07 00:08:10,401 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-07 00:08:10,404 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:10,405 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:10,948 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12029)) - Completed phase 1 of Semantic Analysis
-- 2026-09-07 00:08:10,949 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:08:10,953 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:08:10,954 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:08:10,956 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:10,956 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:10,971 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12034)) - Completed getting MetaData in Semantic Analysis
-- 2026-09-07 00:08:12,107 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1
-- 2026-09-07 00:08:12,439 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_not_null_constraints : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,441 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_not_null_constraints : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,484 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,485 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,507 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,508 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,513 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_unique_constraints : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,514 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_unique_constraints : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:12,532 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_foreign_keys : parentdb=null parenttbl=null foreigndb=_dummy_database foreigntbl=_dummy_table
-- 2026-09-07 00:08:12,533 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_foreign_keys : parentdb=null parenttbl=null foreigndb=_dummy_database foreigntbl=_dummy_table
-- 2026-09-07 00:08:13,561 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_databases: @hive#
-- 2026-09-07 00:08:13,563 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_databases: @hive#
-- 2026-09-07 00:08:13,578 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_materialized_views_for_rewriting: db=@hive#default
-- 2026-09-07 00:08:13,579 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_materialized_views_for_rewriting: db=@hive#default
-- 2026-09-07 00:08:13,634 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:08:13,635 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:08:13,638 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:08:13,640 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:13,640 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive._dummy_database._dummy_table
-- 2026-09-07 00:08:13,645 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:08:13,646 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:08:13,649 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:08:13,650 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,653 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,666 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1
-- 2026-09-07 00:08:13,715 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] common.FileUtils (FileUtils.java:mkdir(580)) - Creating directory if it doesn't exist: hdfs://localhost:9000/user/hive/warehouse/teste_managed/.hive-staging_hive_2026-09-07_00-08-10_373_6713271316481655311-1
-- 2026-09-07 00:08:13,721 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_not_null_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,721 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_not_null_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,724 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_check_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,725 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_check_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,750 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,751 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,774 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:genAutoColumnStatsGatheringPipeline(7971)) - Generate an operator pipeline to autogather column stats for table default.teste_managed in query INSERT INTO teste_managed VALUES (1, 'linha de teste')
-- 2026-09-07 00:08:13,780 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,781 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,800 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:08:13,801 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,804 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:13,817 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:08:13,818 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:08:13,864 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-13_776_5726722715319876689-1
-- 2026-09-07 00:08:13,882 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] common.FileUtils (FileUtils.java:mkdir(580)) - Creating directory if it doesn't exist: hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-13_776_5726722715319876689-1/-mr-10000/.hive-staging_hive_2026-09-07_00-08-13_776_5726722715319876689-1
-- 2026-09-07 00:08:13,888 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (CalcitePlanner.java:genOPTree(518)) - CBO Succeeded; optimized logical plan.
-- 2026-09-07 00:08:13,916 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for FS(4)
-- 2026-09-07 00:08:13,917 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for FS(11)
-- 2026-09-07 00:08:13,921 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(10)
-- 2026-09-07 00:08:13,922 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for GBY(9)
-- 2026-09-07 00:08:13,923 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for RS(8)
-- 2026-09-07 00:08:13,924 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for GBY(7)
-- 2026-09-07 00:08:13,925 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(6)
-- 2026-09-07 00:08:13,926 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(3)
-- 2026-09-07 00:08:13,929 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for UDTF(2)
-- 2026-09-07 00:08:13,931 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(1)
-- 2026-09-07 00:08:13,932 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(417)) - Processing for TS(0)
-- 2026-09-07 00:08:13,960 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] optimizer.ColumnPrunerProcFactory (ColumnPrunerProcFactory.java:pruneReduceSinkOperator(901)) - RS 8 oldColExprMap: {VALUE._col0=Column[_col0], VALUE._col1=Column[_col1]}
-- 2026-09-07 00:08:13,962 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] optimizer.ColumnPrunerProcFactory (ColumnPrunerProcFactory.java:pruneReduceSinkOperator(950)) - RS 8 newColExprMap: {VALUE._col0=Column[_col0], VALUE._col1=Column[_col1]}
-- 2026-09-07 00:08:14,043 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:14,044 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:14,078 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] optimizer.GenMRFileSink1 (GenMRFileSink1.java:process(112)) - using CombineHiveInputformat for the merge job
-- 2026-09-07 00:08:14,080 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:14,083 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:14,180 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapWork(1849)) - Examining input format to see if vectorization is enabled.
-- 2026-09-07 00:08:14,192 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1035)) - Map vectorization enabled: false
-- 2026-09-07 00:08:14,193 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1037)) - Map vectorized: false
-- 2026-09-07 00:08:14,194 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1044)) - Map vectorizedVertexNum: 0
-- 2026-09-07 00:08:14,197 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1076)) - Map enabledConditionsMet: [hive.vectorized.use.vectorized.input.format IS true]
-- 2026-09-07 00:08:14,198 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1080)) - Map enabledConditionsNotMet: [Could not enable vectorization due to partition column names size 1 is greater than the number of table column names size 0 IS false]
-- 2026-09-07 00:08:14,199 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1085)) - Map inputFileFormatClassNameSet: [org.apache.hadoop.hive.ql.io.NullRowsInputFormat]
-- 2026-09-07 00:08:14,200 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1035)) - Reduce vectorization enabled: false
-- 2026-09-07 00:08:14,201 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1037)) - Reduce vectorized: false
-- 2026-09-07 00:08:14,202 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1044)) - Reduce vectorizedVertexNum: 1
-- 2026-09-07 00:08:14,203 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logReduceWorkExplainVectorization(1096)) - Reducer hive.vectorized.execution.reduce.enabled: true
-- 2026-09-07 00:08:14,204 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logReduceWorkExplainVectorization(1098)) - Reducer engine: mr
-- 2026-09-07 00:08:14,206 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] common.HiveStatsUtils (HiveStatsUtils.java:getNumBitVectorsForNDVEstimation(156)) - Error requested is 20.0%
-- 2026-09-07 00:08:14,207 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] common.HiveStatsUtils (HiveStatsUtils.java:getNumBitVectorsForNDVEstimation(157)) - Choosing 16 bit vectors..
-- 2026-09-07 00:08:14,213 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12343)) - Completed plan generation
-- 2026-09-07 00:08:14,214 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
-- 2026-09-07 00:08:14,215 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:[FieldSchema(name:col1, type:int, comment:null), FieldSchema(name:col2, type:string, comment:null)], properties:null)
-- 2026-09-07 00:08:14,216 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260907000810_811e67dd-e98b-4478-97b4-d90e13ebc8a2); Time taken: 3.864 seconds
-- 2026-09-07 00:08:14,217 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
-- 2026-09-07 00:08:14,219 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:08:14,220 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260907000810_811e67dd-e98b-4478-97b4-d90e13ebc8a2): INSERT INTO teste_managed VALUES (1, 'linha de teste')
-- 2026-09-07 00:08:14,221 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:logMrWarning(2591)) - Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
-- Query ID = palomamusa_20260907000810_811e67dd-e98b-4478-97b4-d90e13ebc8a2
-- 2026-09-07 00:08:14,223 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Query ID = palomamusa_20260907000810_811e67dd-e98b-4478-97b4-d90e13ebc8a2
-- Total jobs = 3
-- 2026-09-07 00:08:14,226 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Total jobs = 3
-- Launching Job 1 out of 3
-- 2026-09-07 00:08:14,379 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Launching Job 1 out of 3
-- 2026-09-07 00:08:14,389 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-1:MAPRED] in serial mode
-- Number of reduce tasks determined at compile time: 1
-- 2026-09-07 00:08:14,390 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Number of reduce tasks determined at compile time: 1
-- In order to change the average load for a reducer (in bytes):
-- 2026-09-07 00:08:14,393 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - In order to change the average load for a reducer (in bytes):
--   set hive.exec.reducers.bytes.per.reducer=<number>
-- 2026-09-07 00:08:14,394 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) -   set hive.exec.reducers.bytes.per.reducer=<number>
-- In order to limit the maximum number of reducers:
-- 2026-09-07 00:08:14,396 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - In order to limit the maximum number of reducers:
--   set hive.exec.reducers.max=<number>
-- 2026-09-07 00:08:14,398 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) -   set hive.exec.reducers.max=<number>
-- In order to set a constant number of reducers:
-- 2026-09-07 00:08:14,402 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - In order to set a constant number of reducers:
--   set mapreduce.job.reduces=<number>
-- 2026-09-07 00:08:14,404 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) -   set mapreduce.job.reduces=<number>
-- 2026-09-07 00:08:14,406 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1
-- 2026-09-07 00:08:14,466 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mr.ExecDriver (ExecDriver.java:execute(299)) - Using org.apache.hadoop.hive.ql.io.CombineHiveInputFormat
-- 2026-09-07 00:08:14,473 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getInputPaths(3298)) - Processing alias $hdt$_0:_dummy_table
-- 2026-09-07 00:08:14,474 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getInputPaths(3336)) - Adding 1 inputs; the first input is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1/dummy_path
-- 2026-09-07 00:08:14,531 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1
-- 2026-09-07 00:08:14,630 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.SerializationUtilities (SerializationUtilities.java:serializePlan(569)) - Serializing MapWork using kryo
-- 2026-09-07 00:08:14,719 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] Configuration.deprecation (Configuration.java:logDeprecation(1442)) - mapred.submit.replication is deprecated. Instead, use mapreduce.client.submit.file.replication
-- 2026-09-07 00:08:14,735 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:setBaseWork(633)) - Serialized plan (via FILE) - name: null size: 7.18KB
-- 2026-09-07 00:08:14,744 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.SerializationUtilities (SerializationUtilities.java:serializePlan(569)) - Serializing ReduceWork using kryo
-- 2026-09-07 00:08:14,771 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:setBaseWork(633)) - Serialized plan (via FILE) - name: null size: 7.97KB
-- 2026-09-07 00:08:14,923 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
-- 2026-09-07 00:08:15,760 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] fs.FSStatsPublisher (FSStatsPublisher.java:init(53)) - created : hdfs://localhost:9000/user/hive/warehouse/teste_managed/.hive-staging_hive_2026-09-07_00-08-10_373_6713271316481655311-1/-ext-10001
-- 2026-09-07 00:08:15,764 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] fs.FSStatsPublisher (FSStatsPublisher.java:init(53)) - created : hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-13_776_5726722715319876689-1/-mr-10000/.hive-staging_hive_2026-09-07_00-08-13_776_5726722715319876689-1/-ext-10002
-- 2026-09-07 00:08:15,822 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
-- 2026-09-07 00:08:15,832 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1/-mr-10004/9b97de93-8a1a-467b-a85f-d95be0dcc563/map.xml
-- 2026-09-07 00:08:15,833 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1/-mr-10004/9b97de93-8a1a-467b-a85f-d95be0dcc563/reduce.xml
-- 2026-09-07 00:08:16,100 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobResourceUploader (JobResourceUploader.java:uploadResourcesInternal(149)) - Hadoop command-line option parsing not performed. Implement the Tool interface and execute your application with ToolRunner to remedy this.
-- 2026-09-07 00:08:16,117 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobResourceUploader (JobResourceUploader.java:disableErasureCodingForPath(907)) - Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/palomamusa/.staging/job_1788746338495_0005
-- 2026-09-07 00:08:16,483 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1/-mr-10004/9b97de93-8a1a-467b-a85f-d95be0dcc563/map.xml
-- 2026-09-07 00:08:16,488 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getNonCombinablePathIndices(477)) - Total number of paths: 1, launching 1 threads to check non-combinable ones.
-- 2026-09-07 00:08:16,502 INFO  [pool-14-thread-1] io.NullRowsInputFormat$NullRowsRecordReader (NullRowsInputFormat.java:configure(190)) - Using null rows input format
-- 2026-09-07 00:08:16,540 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(413)) - CombineHiveInputSplit creating pool for hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1/dummy_path; using filter path hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-10_373_6713271316481655311-1/dummy_path
-- 2026-09-07 00:08:16,618 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] input.FileInputFormat (FileInputFormat.java:listStatus(300)) - Total input files to process : 1
-- 2026-09-07 00:08:16,645 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(467)) - number of splits 1
-- 2026-09-07 00:08:16,646 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getSplits(587)) - Number of all splits 1
-- 2026-09-07 00:08:16,741 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobSubmitter (JobSubmitter.java:submitJobInternal(202)) - number of splits:1
-- 2026-09-07 00:08:16,764 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] Configuration.deprecation (Configuration.java:logDeprecation(1442)) - yarn.resourcemanager.system-metrics-publisher.enabled is deprecated. Instead, use yarn.system-metrics-publisher.enabled
-- 2026-09-07 00:08:16,839 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(298)) - Submitting tokens for job: job_1788746338495_0005
-- 2026-09-07 00:08:16,840 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(299)) - Executing with tokens: []
-- 2026-09-07 00:08:17,163 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.Configuration (Configuration.java:getConfResourceAsInputStream(2854)) - resource-types.xml not found
-- 2026-09-07 00:08:17,167 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] resource.ResourceUtils (ResourceUtils.java:addResourcesFileToConf(476)) - Unable to find 'resource-types.xml'.
-- 2026-09-07 00:08:17,566 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] impl.YarnClientImpl (YarnClientImpl.java:submitApplication(338)) - Submitted application application_1788746338495_0005
-- 2026-09-07 00:08:17,641 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.Job (Job.java:submit(1682)) - The url to track the job: http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0005/
-- Starting Job = job_1788746338495_0005, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0005/
-- 2026-09-07 00:08:17,645 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Starting Job = job_1788746338495_0005, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0005/
-- Kill Command = /opt/hadoop/bin/mapred job  -kill job_1788746338495_0005
-- 2026-09-07 00:08:17,647 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Kill Command = /opt/hadoop/bin/mapred job  -kill job_1788746338495_0005
-- Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
-- 2026-09-07 00:08:27,030 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
-- 2026-09-07 00:08:27,105 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.Counters (AbstractCounters.java:getGroup(235)) - Group org.apache.hadoop.mapred.Task$Counter is deprecated. Use org.apache.hadoop.mapreduce.TaskCounter instead
-- 2026-09-07 00:08:27,095 Stage-1 map = 0%,  reduce = 0%
-- 2026-09-07 00:08:27,108 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-07 00:08:27,095 Stage-1 map = 0%,  reduce = 0%
-- 2026-09-07 00:08:35,582 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 5.13 sec
-- 2026-09-07 00:08:35,582 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-07 00:08:35,582 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 5.13 sec
-- 2026-09-07 00:08:45,111 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 5.13 sec
-- 2026-09-07 00:08:45,112 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-07 00:08:45,111 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 5.13 sec
-- MapReduce Total cumulative CPU time: 8 seconds 70 msec
-- 2026-09-07 00:08:47,229 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - MapReduce Total cumulative CPU time: 8 seconds 70 msec
-- Ended Job = job_1788746338495_0005
-- 2026-09-07 00:08:47,273 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Ended Job = job_1788746338495_0005
-- 2026-09-07 00:08:47,399 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-7:CONDITIONAL] in serial mode
-- Stage-4 is selected by condition resolver.
-- 2026-09-07 00:08:47,404 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Stage-4 is selected by condition resolver.
-- Stage-3 is filtered out by condition resolver.
-- 2026-09-07 00:08:47,406 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Stage-3 is filtered out by condition resolver.
-- Stage-5 is filtered out by condition resolver.
-- 2026-09-07 00:08:47,407 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Stage-5 is filtered out by condition resolver.
-- 2026-09-07 00:08:47,409 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-4:MOVE] in serial mode
-- 2026-09-07 00:08:47,500 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-07 00:08:47,501 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-07 00:08:47,503 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-07 00:08:47,505 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- Moving data to directory hdfs://localhost:9000/user/hive/warehouse/teste_managed/.hive-staging_hive_2026-09-07_00-08-10_373_6713271316481655311-1/-ext-10000
-- 2026-09-07 00:08:47,509 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Moving data to directory hdfs://localhost:9000/user/hive/warehouse/teste_managed/.hive-staging_hive_2026-09-07_00-08-10_373_6713271316481655311-1/-ext-10000 from hdfs://localhost:9000/user/hive/warehouse/teste_managed/.hive-staging_hive_2026-09-07_00-08-10_373_6713271316481655311-1/-ext-10002
-- 2026-09-07 00:08:47,524 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-0:MOVE] in serial mode
-- Loading data to table default.teste_managed
-- 2026-09-07 00:08:47,525 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Loading data to table default.teste_managed from hdfs://localhost:9000/user/hive/warehouse/teste_managed/.hive-staging_hive_2026-09-07_00-08-10_373_6713271316481655311-1/-ext-10000
-- 2026-09-07 00:08:47,528 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-07 00:08:47,529 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-07 00:08:47,531 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-07 00:08:47,534 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-07 00:08:47,535 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-07 00:08:47,538 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-07 00:08:47,539 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:47,541 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:47,612 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:47,614 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:49,317 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: alter_table: hive.default.teste_managed newtbl=teste_managed
-- 2026-09-07 00:08:49,318 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=alter_table: hive.default.teste_managed newtbl=teste_managed
-- 2026-09-07 00:08:49,384 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-2:STATS] in serial mode
-- 2026-09-07 00:08:49,385 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-07 00:08:49,388 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-07 00:08:49,389 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-07 00:08:49,390 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- 2026-09-07 00:08:49,391 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] stats.BasicStatsTask (BasicStatsTask.java:process(96)) - Executing stats task
-- 2026-09-07 00:08:49,426 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] fs.FSStatsPublisher (FSStatsPublisher.java:init(53)) - created : hdfs://localhost:9000/user/hive/warehouse/teste_managed/.hive-staging_hive_2026-09-07_00-08-10_373_6713271316481655311-1/-ext-10001
-- 2026-09-07 00:08:49,517 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-07 00:08:49,518 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-07 00:08:49,522 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-07 00:08:49,524 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-07 00:08:49,525 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-07 00:08:49,526 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-07 00:08:49,527 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:49,528 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:49,563 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] FileOperations (FSStatsAggregator.java:aggregateStats(101)) - Read stats for : default.teste_managed/ numRows 1
-- 2026-09-07 00:08:49,564 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] FileOperations (FSStatsAggregator.java:aggregateStats(101)) - Read stats for : default.teste_managed/ rawDataSize     16
-- 2026-09-07 00:08:49,566 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: alter_table: hive.default.teste_managed newtbl=teste_managed
-- 2026-09-07 00:08:49,568 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=alter_table: hive.default.teste_managed newtbl=teste_managed
-- 2026-09-07 00:08:49,596 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] stats.BasicStatsTask (BasicStatsTask.java:aggregateStats(280)) - Table default.teste_managed stats: [numFiles=1, numRows=1, totalSize=17, rawDataSize=16]
-- 2026-09-07 00:08:49,604 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] Configuration.deprecation (Configuration.java:logDeprecation(1442)) - mapred.input.dir is deprecated. Instead, use mapreduce.input.fileinputformat.inputdir
-- 2026-09-07 00:08:49,610 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapred.FileInputFormat (FileInputFormat.java:listStatus(266)) - Total input files to process : 1
-- 2026-09-07 00:08:49,856 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: write_column_statistics:  table=hive.default.teste_managed
-- 2026-09-07 00:08:49,857 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=write_column_statistics:  table=hive.default.teste_managed
-- 2026-09-07 00:08:49,882 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:writeMTableColumnStatistics(8176)) - Updating table level column statistics for table=hive.default.teste_managed colName=id
-- 2026-09-07 00:08:49,903 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.ObjectStore (ObjectStore.java:writeMTableColumnStatistics(8176)) - Updating table level column statistics for table=hive.default.teste_managed colName=valor
-- MapReduce Jobs Launched:
-- 2026-09-07 00:08:49,909 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - MapReduce Jobs Launched:
-- Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 8.07 sec   HDFS Read: 15455 HDFS Write: 259 SUCCESS
-- 2026-09-07 00:08:49,912 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 8.07 sec   HDFS Read: 15455 HDFS Write: 259 SUCCESS
-- Total MapReduce CPU Time Spent: 8 seconds 70 msec
-- 2026-09-07 00:08:49,914 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Total MapReduce CPU Time Spent: 8 seconds 70 msec
-- 2026-09-07 00:08:49,915 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260907000810_811e67dd-e98b-4478-97b4-d90e13ebc8a2); Time taken: 35.688 seconds
-- OK
-- 2026-09-07 00:08:49,917 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
-- 2026-09-07 00:08:49,917 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- Time taken: 39.566 seconds
-- 2026-09-07 00:08:49,937 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 39.566 seconds
-- 2026-09-07 00:08:49,978 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:08:49,984 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main
-- hive> 2026-09-07 00:08:49,990 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:08:49,992 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- 2026-09-07 00:08:49,998 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260907000849_4c4ba248-4ae3-49c8-b36a-486fb4086e94): SELECT * FROM teste_managed
-- 2026-09-07 00:08:50,030 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:08:50,031 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12123)) - Starting Semantic Analysis
-- 2026-09-07 00:08:50,034 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12029)) - Completed phase 1 of Semantic Analysis
-- 2026-09-07 00:08:50,035 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:08:50,036 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,037 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,049 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:08:50,051 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:08:50,062 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-50_029_3343058628825759630-1
-- 2026-09-07 00:08:50,063 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12034)) - Completed getting MetaData in Semantic Analysis
-- 2026-09-07 00:08:50,145 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] results.QueryResultsCache (QueryResultsCache.java:<init>(367)) - Initializing query results cache at /tmp/hive/_resultscache_
-- 2026-09-07 00:08:50,168 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] results.QueryResultsCache (QueryResultsCache.java:<init>(388)) - Query results cache: cacheDirectory /tmp/hive/_resultscache_/results-fe764a93-4388-4379-8c78-50fd8a4726bc, maxCacheSize 2147483648, maxEntrySize 10485760, maxEntryLifetime 3600000
-- 2026-09-07 00:08:50,172 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_not_null_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,173 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_not_null_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,178 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,179 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,181 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,182 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,185 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_unique_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,187 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_unique_constraints : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,192 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=teste_managed
-- 2026-09-07 00:08:50,193 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=teste_managed
-- 2026-09-07 00:08:50,350 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_databases: @hive#
-- 2026-09-07 00:08:50,352 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_databases: @hive#
-- 2026-09-07 00:08:50,356 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_materialized_views_for_rewriting: db=@hive#default
-- 2026-09-07 00:08:50,357 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_materialized_views_for_rewriting: db=@hive#default
-- 2026-09-07 00:08:50,362 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:08:50,363 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,365 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:08:50,375 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:08:50,376 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:08:50,381 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-50_029_3343058628825759630-1
-- 2026-09-07 00:08:50,383 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] common.FileUtils (FileUtils.java:mkdir(580)) - Creating directory if it doesn't exist: hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-08-50_029_3343058628825759630-1/-mr-10001/.hive-staging_hive_2026-09-07_00-08-50_029_3343058628825759630-1
-- 2026-09-07 00:08:50,395 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (CalcitePlanner.java:genOPTree(518)) - CBO Succeeded; optimized logical plan.
-- 2026-09-07 00:08:50,396 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for FS(2)
-- 2026-09-07 00:08:50,399 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(1)
-- 2026-09-07 00:08:50,400 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(417)) - Processing for TS(0)
-- 2026-09-07 00:08:50,411 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12343)) - Completed plan generation
-- 2026-09-07 00:08:50,412 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:queryCanBeCached(14777)) - Not eligible for results caching - no mr/tez/spark jobs
-- 2026-09-07 00:08:50,416 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
-- 2026-09-07 00:08:50,417 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:[FieldSchema(name:teste_managed.id, type:int, comment:null), FieldSchema(name:teste_managed.valor, type:string, comment:null)], properties:null)
-- 2026-09-07 00:08:50,422 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.TableScanOperator (Operator.java:initialize(344)) - Initializing operator TS[0]
-- 2026-09-07 00:08:50,423 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.SelectOperator (Operator.java:initialize(344)) - Initializing operator SEL[1]
-- 2026-09-07 00:08:50,431 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.SelectOperator (SelectOperator.java:initializeOp(73)) - SELECT struct<id:int,valor:string>
-- 2026-09-07 00:08:50,442 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.ListSinkOperator (Operator.java:initialize(344)) - Initializing operator LIST_SINK[3]
-- 2026-09-07 00:08:50,450 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260907000849_4c4ba248-4ae3-49c8-b36a-486fb4086e94); Time taken: 0.452 seconds
-- 2026-09-07 00:08:50,451 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
-- 2026-09-07 00:08:50,452 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:08:50,453 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260907000849_4c4ba248-4ae3-49c8-b36a-486fb4086e94): SELECT * FROM teste_managed
-- 2026-09-07 00:08:50,455 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260907000849_4c4ba248-4ae3-49c8-b36a-486fb4086e94); Time taken: 0.002 seconds
-- OK
-- 2026-09-07 00:08:50,456 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
-- 2026-09-07 00:08:50,457 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:08:50,464 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapred.FileInputFormat (FileInputFormat.java:listStatus(266)) - Total input files to process : 1
-- 2026-09-07 00:08:50,500 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.TableScanOperator (Operator.java:logStats(1038)) - RECORDS_OUT_INTERMEDIATE:0, RECORDS_OUT_OPERATOR_TS_0:1,
-- 2026-09-07 00:08:50,501 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.SelectOperator (Operator.java:logStats(1038)) - RECORDS_OUT_INTERMEDIATE:0, RECORDS_OUT_OPERATOR_SEL_1:1,
-- 2026-09-07 00:08:50,509 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.ListSinkOperator (Operator.java:logStats(1038)) - RECORDS_OUT_INTERMEDIATE:0, RECORDS_OUT_OPERATOR_LIST_SINK_3:1,
-- 1       linha de teste
-- Time taken: 0.46 seconds, Fetched: 1 row(s)
-- 2026-09-07 00:08:50,536 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 0.46 seconds, Fetched: 1 row(s)
-- 2026-09-07 00:08:50,537 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:08:50,538 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main

#----------------------------------------------------------------------------------------------

### Passo 5 — O experimento do DROP (o coração do lab)

hive> -- confira que o arquivo existe no HDFS ANTES de dropar:
!hadoop fs -ls /user/hive/warehouse/teste_managed;

DROP TABLE teste_managed;

-- confira DE NOVO — o que aconteceu?
!hadoop fs -ls /user/hive/warehouse/;

-- hive> 2026-09-07 00:14:47,813 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:14:47,814 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- SLF4J: Class path contains multiple SLF4J bindings.
-- SLF4J: Found binding in [jar:file:/opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
-- SLF4J: Actual binding is of type [org.slf4j.impl.Reload4jLoggerFactory]
-- Found 1 items
-- -rw-r--r--   1 palomamusa supergroup         17 2026-09-07 00:08 /user/hive/warehouse/teste_managed/000000_0
-- 2026-09-07 00:14:52,181 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:14:52,182 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main
-- hive>     > 2026-09-07 00:14:52,184 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:14:52,185 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- 2026-09-07 00:14:52,187 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260907001452_d7395904-e767-405b-88cd-4cf38cac414b): DROP TABLE teste_managed
-- 2026-09-07 00:14:52,212 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:14:52,213 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,216 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,228 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
-- 2026-09-07 00:14:52,228 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:null, properties:null)
-- 2026-09-07 00:14:52,232 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260907001452_d7395904-e767-405b-88cd-4cf38cac414b); Time taken: 0.045 seconds
-- 2026-09-07 00:14:52,233 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
-- 2026-09-07 00:14:52,234 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:14:52,235 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260907001452_d7395904-e767-405b-88cd-4cf38cac414b): DROP TABLE teste_managed
-- 2026-09-07 00:14:52,237 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-0:DDL] in serial mode
-- 2026-09-07 00:14:52,238 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,240 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,252 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,253 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,268 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: drop_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,270 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=drop_table : tbl=hive.default.teste_managed
-- 2026-09-07 00:14:52,803 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260907001452_d7395904-e767-405b-88cd-4cf38cac414b); Time taken: 0.568 seconds
-- OK
-- 2026-09-07 00:14:52,809 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
-- 2026-09-07 00:14:52,814 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- Time taken: 0.633 seconds
-- 2026-09-07 00:14:52,821 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 0.633 seconds
-- 2026-09-07 00:14:52,826 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:14:52,829 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main
-- hive>     >     > 2026-09-07 00:14:52,841 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:14:52,843 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- SLF4J: Class path contains multiple SLF4J bindings.
-- SLF4J: Found binding in [jar:file:/opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
-- SLF4J: Actual binding is of type [org.slf4j.impl.Reload4jLoggerFactory]
-- 2026-09-07 00:14:57,177 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:14:57,179 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main

#-----------------------------------------------------------------------------------------------------

Passo 6 — Repita o experimento com EXTERNAL

DROP TABLE raw_customers;
!hadoop fs -ls /user/bigdata/raw/customers/;

-- hive> DROP TABLE raw_customers;
-- !hadoop fs -ls /us2026-09-07 00:23:45,503 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- er/bigd2026-09-07 00:23:45,505 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- ata/raw/custom2026-09-07 00:23:45,508 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260907002345_ce308847-c7a8-48e2-bc8b-9b1b46fa9eba): DROP TABLE raw_customers
-- ers/;
-- 2026-09-07 00:23:45,534 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:23:45,535 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,536 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,546 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
-- 2026-09-07 00:23:45,546 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:null, properties:null)
-- 2026-09-07 00:23:45,547 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260907002345_ce308847-c7a8-48e2-bc8b-9b1b46fa9eba); Time taken: 0.039 seconds
-- 2026-09-07 00:23:45,547 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
-- 2026-09-07 00:23:45,547 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:23:45,549 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260907002345_ce308847-c7a8-48e2-bc8b-9b1b46fa9eba): DROP TABLE raw_customers
-- 2026-09-07 00:23:45,550 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-0:DDL] in serial mode
-- 2026-09-07 00:23:45,552 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,552 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,563 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,564 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,573 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: drop_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,574 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=drop_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:23:45,605 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260907002345_ce308847-c7a8-48e2-bc8b-9b1b46fa9eba); Time taken: 0.056 secondsOK
-- 2026-09-07 00:23:45,608 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
-- 2026-09-07 00:23:45,611 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- Time taken: 0.104 seconds
-- 2026-09-07 00:23:45,613 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 0.104 seconds
-- 2026-09-07 00:23:45,614 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:23:45,615 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main
-- hive> 2026-09-07 00:23:45,617 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:23:45,617 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- SLF4J: Class path contains multiple SLF4J bindings.
-- SLF4J: Found binding in [jar:file:/opt/hadoop/share/hadoop/common/lib/slf4j-reload4j-1.7.36.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.17.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
-- SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
-- SLF4J: Actual binding is of type [org.slf4j.impl.Reload4jLoggerFactory]
-- Found 5 items
-- -rw-r--r--   1 palomamusa supergroup          0 2026-09-06 23:01 /user/bigdata/raw/customers/_SUCCESS
-- -rw-r--r--   1 palomamusa supergroup     210199 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00000
-- -rw-r--r--   1 palomamusa supergroup     211051 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00001
-- -rw-r--r--   1 palomamusa supergroup     210601 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00002
-- -rw-r--r--   1 palomamusa supergroup     210541 2026-09-06 23:01 /user/bigdata/raw/customers/part-m-00003
-- 2026-09-07 00:23:50,007 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:23:50,011 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main

#---------------------------------------------------------------------------------------------------------------

### Passo 7 — Recriar a tabela raw_customers 

-- hive> SELECT COUNT(*) FROM raw_customers;
-- 2026-09-07 00:32:03,902 INFO  [main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:32:03,903 INFO  [main] session.SessionState (SessionState.java:updateThreadName(441)) - Updating thread name to 778c135c-019f-4eef-9e9d-715460a5f645 main
-- 2026-09-07 00:32:03,905 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260907003203_209f73cd-9e95-448a-a2e5-93c1a9adca9d): SELECT COUNT(*) FROM raw_customers
-- 2026-09-07 00:32:03,930 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:32:03,932 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12123)) - Starting Semantic Analysis
-- 2026-09-07 00:32:03,937 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12029)) - Completed phase 1 of Semantic Analysis
-- 2026-09-07 00:32:03,938 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:32:03,939 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:03,940 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:03,950 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:32:03,951 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:32:03,975 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1
-- 2026-09-07 00:32:03,977 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12034)) - Completed getting MetaData in Semantic Analysis
-- 2026-09-07 00:32:03,985 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_not_null_constraints : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:03,986 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_not_null_constraints : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:03,989 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:03,994 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:03,997 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:03,998 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:04,000 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_unique_constraints : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:04,001 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_unique_constraints : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:04,003 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=raw_customers
-- 2026-09-07 00:32:04,004 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=raw_customers
-- 2026-09-07 00:32:04,166 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_databases: @hive#
-- 2026-09-07 00:32:04,167 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_databases: @hive#
-- 2026-09-07 00:32:04,170 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_materialized_views_for_rewriting: db=@hive#default
-- 2026-09-07 00:32:04,170 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_materialized_views_for_rewriting: db=@hive#default
-- 2026-09-07 00:32:04,179 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-07 00:32:04,184 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:04,185 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa                 ip=unknown-ip-addr       cmd=get_table : tbl=hive.default.raw_customers
-- 2026-09-07 00:32:04,196 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-07 00:32:04,197 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-07 00:32:04,203 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1
-- 2026-09-07 00:32:04,204 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] common.FileUtils (FileUtils.java:mkdir(580)) - Creating directory if it doesn't exist: hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1/-mr-10001/.hive-staging_hive_2026-09-07_00-32-03_929_5998712167936871741-1
-- 2026-09-07 00:32:04,257 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (CalcitePlanner.java:genOPTree(518)) - CBO Succeeded; optimized logical plan.
-- 2026-09-07 00:32:04,259 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for FS(6)
-- 2026-09-07 00:32:04,263 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(5)
-- 2026-09-07 00:32:04,264 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for GBY(4)
-- 2026-09-07 00:32:04,265 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for RS(3)
-- 2026-09-07 00:32:04,266 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for GBY(2)
-- 2026-09-07 00:32:04,267 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(1)
-- 2026-09-07 00:32:04,268 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ppd.OpProcFactory (OpProcFactory.java:process(417)) - Processing for TS(0)
-- 2026-09-07 00:32:04,298 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] optimizer.ColumnPrunerProcFactory (ColumnPrunerProcFactory.java:pruneReduceSinkOperator(901)) - RS 3 oldColExprMap: {VALUE._col0=Column[_col0]}
-- 2026-09-07 00:32:04,300 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] optimizer.ColumnPrunerProcFactory (ColumnPrunerProcFactory.java:pruneReduceSinkOperator(950)) - RS 3 newColExprMap: {VALUE._col0=Column[_col0]}
-- 2026-09-07 00:32:04,306 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] optimizer.StatsOptimizer (StatsOptimizer.java:process(287)) - Table raw_customers is external. Skip StatsOptimizer.
-- 2026-09-07 00:32:04,339 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapWork(1849)) - Examining input format to see if vectorization is enabled.
-- 2026-09-07 00:32:04,351 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapWork(1938)) - Vectorization is enabled for input format(s) [org.apache.hadoop.mapred.TextInputFormat]
-- 2026-09-07 00:32:04,352 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapOperators(1961)) - Validating and vectorizing MapWork... (vectorizedVertexNum 0)
-- 2026-09-07 00:32:04,406 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:validateGroupByOperator(2688)) - Vector GROUP BY operator will use processing mode HASH
-- 2026-09-07 00:32:04,464 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1035)) - Map vectorization enabled: true
-- 2026-09-07 00:32:04,465 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1037)) - Map vectorized: true
-- 2026-09-07 00:32:04,470 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1044)) - Map vectorizedVertexNum: 0
-- 2026-09-07 00:32:04,471 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1076)) - Map enabledConditionsMet: [hive.vectorized.use.vector.serde.deserialize IS true]
-- 2026-09-07 00:32:04,472 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1085)) - Map inputFileFormatClassNameSet: [org.apache.hadoop.mapred.TextInputFormat]
-- 2026-09-07 00:32:04,473 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1035)) - Reduce vectorization enabled: false
-- 2026-09-07 00:32:04,478 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1037)) - Reduce vectorized: false
-- 2026-09-07 00:32:04,479 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1044)) - Reduce vectorizedVertexNum: 1
-- 2026-09-07 00:32:04,480 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logReduceWorkExplainVectorization(1096)) - Reducer hive.vectorized.execution.reduce.enabled: true
-- 2026-09-07 00:32:04,481 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] physical.Vectorizer (Vectorizer.java:logReduceWorkExplainVectorization(1098)) - Reducer engine: mr
-- 2026-09-07 00:32:04,482 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12343)) - Completed plan generation
-- 2026-09-07 00:32:04,483 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] parse.CalcitePlanner (SemanticAnalyzer.java:queryCanBeCached(14789)) - Not eligible for results caching - default.raw_customers is an external table
-- 2026-09-07 00:32:04,484 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
-- 2026-09-07 00:32:04,485 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:[FieldSchema(name:_c0, type:bigint, comment:null)], properties:null)
-- 2026-09-07 00:32:04,486 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.ListSinkOperator (Operator.java:initialize(344)) - Initializing operator LIST_SINK[10]
-- 2026-09-07 00:32:04,487 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260907003203_209f73cd-9e95-448a-a2e5-93c1a9adca9d); Time taken: 0.582 seconds
-- 2026-09-07 00:32:04,488 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
-- 2026-09-07 00:32:04,488 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:32:04,494 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260907003203_209f73cd-9e95-448a-a2e5-93c1a9adca9d): SELECT COUNT(*) FROM raw_customers
-- 2026-09-07 00:32:04,496 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:logMrWarning(2591)) - Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
-- Query ID = palomamusa_20260907003203_209f73cd-9e95-448a-a2e5-93c1a9adca9d
-- 2026-09-07 00:32:04,498 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Query ID = palomamusa_20260907003203_209f73cd-9e95-448a-a2e5-93c1a9adca9d
-- Total jobs = 1
-- 2026-09-07 00:32:04,500 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Total jobs = 1
-- Launching Job 1 out of 1
-- 2026-09-07 00:32:04,501 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Launching Job 1 out of 1
-- 2026-09-07 00:32:04,507 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-1:MAPRED] in serial mode
-- Number of reduce tasks determined at compile time: 1
-- 2026-09-07 00:32:04,510 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Number of reduce tasks determined at compile time: 1
-- In order to change the average load for a reducer (in bytes):
-- 2026-09-07 00:32:04,511 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - In order to change the average load for a reducer (in bytes):
--   set hive.exec.reducers.bytes.per.reducer=<number>
-- 2026-09-07 00:32:04,514 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) -   set hive.exec.reducers.bytes.per.reducer=<number>
-- In order to limit the maximum number of reducers:
-- 2026-09-07 00:32:04,515 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - In order to limit the maximum number of reducers:
--   set hive.exec.reducers.max=<number>
-- 2026-09-07 00:32:04,517 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) -   set hive.exec.reducers.max=<number>
-- In order to set a constant number of reducers:
-- 2026-09-07 00:32:04,519 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - In order to set a constant number of reducers:
--   set mapreduce.job.reduces=<number>
-- 2026-09-07 00:32:04,524 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) -   set mapreduce.job.reduces=<number>
-- 2026-09-07 00:32:04,525 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1
-- 2026-09-07 00:32:04,528 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mr.ExecDriver (ExecDriver.java:execute(299)) - Using org.apache.hadoop.hive.ql.io.CombineHiveInputFormat
-- 2026-09-07 00:32:04,529 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getInputPaths(3298)) - Processing alias raw_customers
-- 2026-09-07 00:32:04,530 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getInputPaths(3336)) - Adding 1 inputs; the first input is hdfs://localhost:9000/user/bigdata/raw/customers
-- 2026-09-07 00:32:04,533 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1
-- 2026-09-07 00:32:04,556 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.SerializationUtilities (SerializationUtilities.java:serializePlan(569)) - Serializing MapWork using kryo
-- 2026-09-07 00:32:04,666 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:setBaseWork(633)) - Serialized plan (via FILE) - name: null size: 6.44KB
-- 2026-09-07 00:32:04,672 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.SerializationUtilities (SerializationUtilities.java:serializePlan(569)) - Serializing ReduceWork using kryo
-- 2026-09-07 00:32:04,819 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:setBaseWork(633)) - Serialized plan (via FILE) - name: null size: 6.50KB
-- 2026-09-07 00:32:04,853 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
-- 2026-09-07 00:32:04,903 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
-- 2026-09-07 00:32:04,905 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1/-mr-10005/df1ed40a-a4cf-4080-87fa-995cda6c28c2/map.xml
-- 2026-09-07 00:32:04,910 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1/-mr-10005/df1ed40a-a4cf-4080-87fa-995cda6c28c2/reduce.xml
-- 2026-09-07 00:32:04,993 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobResourceUploader (JobResourceUploader.java:uploadResourcesInternal(149)) - Hadoop command-line option parsing not performed. Implement the Tool interface and execute your application with ToolRunner to remedy this.
-- 2026-09-07 00:32:05,041 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobResourceUploader (JobResourceUploader.java:disableErasureCodingForPath(907)) - Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/palomamusa/.staging/job_1788746338495_0006
-- 2026-09-07 00:32:05,541 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/778c135c-019f-4eef-9e9d-715460a5f645/hive_2026-09-07_00-32-03_929_5998712167936871741-1/-mr-10005/df1ed40a-a4cf-4080-87fa-995cda6c28c2/map.xml
-- 2026-09-07 00:32:05,542 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getNonCombinablePathIndices(477)) - Total number of paths: 1, launching 1 threads to check non-combinable ones.
-- 2026-09-07 00:32:05,550 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(413)) - CombineHiveInputSplit creating pool for hdfs://localhost:9000/user/bigdata/raw/customers; using filter path hdfs://localhost:9000/user/bigdata/raw/customers
-- 2026-09-07 00:32:05,590 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] input.FileInputFormat (FileInputFormat.java:listStatus(300)) - Total input files to process : 4
-- 2026-09-07 00:32:05,593 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(467)) - number of splits 1
-- 2026-09-07 00:32:05,597 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getSplits(587)) - Number of all splits 1
-- 2026-09-07 00:32:05,834 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobSubmitter (JobSubmitter.java:submitJobInternal(202)) - number of splits:1
-- 2026-09-07 00:32:05,930 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(298)) - Submitting tokens for job: job_1788746338495_0006
-- 2026-09-07 00:32:05,931 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(299)) - Executing with tokens: []
-- 2026-09-07 00:32:06,258 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] impl.YarnClientImpl (YarnClientImpl.java:submitApplication(338)) - Submitted application application_1788746338495_0006
-- 2026-09-07 00:32:06,396 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.Job (Job.java:submit(1682)) - The url to track the job: http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0006/
-- Starting Job = job_1788746338495_0006, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0006/
-- 2026-09-07 00:32:06,404 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Starting Job = job_1788746338495_0006, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788746338495_0006/
-- Kill Command = /opt/hadoop/bin/mapred job  -kill job_1788746338495_0006
-- 2026-09-07 00:32:06,413 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Kill Command = /opt/hadoop/bin/mapred job  -kill job_1788746338495_0006
-- Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
-- 2026-09-07 00:32:20,482 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
-- 2026-09-07 00:32:20,523 WARN  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapreduce.Counters (AbstractCounters.java:getGroup(235)) - Group org.apache.hadoop.mapred.Task$Counter is deprecated. Use org.apache.hadoop.mapreduce.TaskCounter instead
-- 2026-09-07 00:32:20,522 Stage-1 map = 0%,  reduce = 0%
-- 2026-09-07 00:32:20,525 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-07 00:32:20,522 Stage-1 map = 0%,  reduce = 0%
-- 2026-09-07 00:32:33,405 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 5.45 sec
-- 2026-09-07 00:32:33,406 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-07 00:32:33,405 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 5.45 sec
-- 2026-09-07 00:32:48,808 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 8.27 sec
-- 2026-09-07 00:32:48,808 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-07 00:32:48,808 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 8.27 sec
-- MapReduce Total cumulative CPU time: 8 seconds 270 msec
-- 2026-09-07 00:32:51,955 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - MapReduce Total cumulative CPU time: 8 seconds 270 msec
-- Ended Job = job_1788746338495_0006
-- 2026-09-07 00:32:51,969 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.Task (SessionState.java:printInfo(1227)) - Ended Job = job_1788746338495_0006
-- MapReduce Jobs Launched:
-- 2026-09-07 00:32:52,152 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - MapReduce Jobs Launched:
-- Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 8.27 sec   HDFS Read: 855783 HDFS Write: 104 SUCCESS
-- 2026-09-07 00:32:52,156 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 8.27 sec   HDFS Read: 855783 HDFS Write: 104 SUCCESS
-- Total MapReduce CPU Time Spent: 8 seconds 270 msec
-- 2026-09-07 00:32:52,160 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - Total MapReduce CPU Time Spent: 8 seconds 270 msec
-- 2026-09-07 00:32:52,163 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260907003203_209f73cd-9e95-448a-a2e5-93c1a9adca9d); Time taken: 47.658 seconds
-- OK
-- 2026-09-07 00:32:52,172 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
-- 2026-09-07 00:32:52,173 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-07 00:32:52,223 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] mapred.FileInputFormat (FileInputFormat.java:listStatus(266)) - Total input files to process : 1
-- 2026-09-07 00:32:52,322 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] exec.ListSinkOperator (Operator.java:logStats(1038)) - RECORDS_OUT_OPERATOR_LIST_SINK_10:1, RECORDS_OUT_INTERMEDIATE:0,
-- 9993
-- Time taken: 48.27 seconds, Fetched: 1 row(s)
-- 2026-09-07 00:32:52,344 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 48.27 seconds, Fetched: 1 row(s)
-- 2026-09-07 00:32:52,345 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: 778c135c-019f-4eef-9e9d-715460a5f645
-- 2026-09-07 00:32:52,347 INFO  [778c135c-019f-4eef-9e9d-715460a5f645 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main
-- hive>
