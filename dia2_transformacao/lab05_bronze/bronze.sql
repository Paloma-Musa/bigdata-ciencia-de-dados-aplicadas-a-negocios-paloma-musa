-- ## Usando a ROTA A — Cluster real (Hive)

-- ### Passo 1 — Criar a tabela Bronze de clientes

```sql
CREATE TABLE bronze_customers
STORED AS PARQUET AS
SELECT DISTINCT
  customer_id, name, cpf, email, segment,
  CAST(credit_score AS INT) AS credit_score,
  CAST(created_at AS DATE) AS created_at
FROM raw_customers
WHERE customer_id IS NOT NULL
  AND credit_score BETWEEN 300 AND 900;
```

-- hive> CREATE TABLE bronze_customers
-- STORED AS PA    > RQUET AS
-- SELE    > CT DISTINCT
--       > customer_id, name, cpf, email, segment,
--   CAST(credit_score AS INT) AS credit_score,
--   CAST(created_at AS DATE) AS created_at
-- FROM raw_customers
-- WHERE customer_id IS NOT    >  NULL
--   AND credit_score BETWEEN    >  300 AND 900;    >     >     >
-- 2026-09-09 21:51:46,081 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: d4ba01e2-6a1f-4cad-b97a-5400b73bed15
-- 2026-09-09 21:51:46,353 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:compile(554)) - Compiling command(queryId=palomamusa_20260909215146_20e908e0-16bc-48b7-8bd9-bf975fdaa022): CREATE TABLE bronze_customers
-- STORED AS PARQUET AS
-- SELECT DISTINCT
--   customer_id, name, cpf, email, segment,
--   CAST(credit_score AS INT) AS credit_score,
--   CAST(created_at AS DATE) AS created_at
-- FROM raw_customers
-- WHERE customer_id IS NOT NULL
--   AND credit_score BETWEEN 300 AND 900
-- 2026-09-09 21:51:46,877 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-09 21:51:46,883 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12123)) - Starting Semantic Analysis
-- 2026-09-09 21:51:47,026 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] sqlstd.SQLStdHiveAccessController (SQLStdHiveAccessController.java:<init>(96)) - Created SQLStdHiveAccessController for session context : HiveAuthzSessionContext [sessionString=d4ba01e2-6a1f-4cad-b97a-5400b73bed15, clientType=HIVECLI]
-- 2026-09-09 21:51:47,031 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] session.SessionState (SessionState.java:setAuthorizerV2Config(950)) - METASTORE_FILTER_HOOK will be ignored, since hive.security.authorization.manager is set to instance of HiveAuthorizerFactory.
-- 2026-09-09 21:51:47,032 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStoreClient (HiveMetaStoreClient.java:isCompatibleWith(346)) - Mestastore configuration metastore.filter.hook changed from org.apache.hadoop.hive.metastore.DefaultMetaStoreFilterHookImpl to org.apache.hadoop.hive.ql.security.authorization.plugin.AuthorizationMetaStoreFilterHook
-- 2026-09-09 21:51:47,035 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-09 21:51:47,036 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-09 21:51:47,037 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-09 21:51:47,038 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- 2026-09-09 21:51:47,043 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-09 21:51:47,043 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-09 21:51:47,045 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-09 21:51:47,048 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-09 21:51:47,048 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-09 21:51:47,050 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-09 21:51:47,064 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeCreateTable(12993)) - Creating table default.bronze_customers position=13
-- 2026-09-09 21:51:47,129 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-09 21:51:47,130 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-09 21:51:47,138 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-09 21:51:47,140 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-09 21:51:47,143 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-09 21:51:47,188 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:51:47,192 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:51:47,389 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-09 21:51:47,394 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-09 21:51:47,427 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12029)) - Completed phase 1 of Semantic Analysis
-- 2026-09-09 21:51:47,428 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-09 21:51:47,432 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:47,433 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:48,104 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-09 21:51:48,105 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-09 21:51:48,108 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-09 21:51:48,109 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-09 21:51:48,114 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] common.FileUtils (FileUtils.java:mkdir(580)) - Creating directory if it doesn't exist: hdfs://localhost:9000/user/hive/warehouse/.hive-staging_hive_2026-09-09_21-51-46_418_621801313551385255-1
-- 2026-09-09 21:51:48,223 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:genResolvedParseTree(12034)) - Completed getting MetaData in Semantic Analysis
-- 2026-09-09 21:51:49,331 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_not_null_constraints : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,332 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_not_null_constraints : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,428 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,430 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,465 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,466 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_primary_keys : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,471 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_unique_constraints : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,471 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_unique_constraints : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:49,492 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=raw_customers
-- 2026-09-09 21:51:49,493 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_foreign_keys : parentdb=null parenttbl=null foreigndb=default foreigntbl=raw_customers
-- 2026-09-09 21:51:51,012 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeCreateTable(12993)) - Creating table default.bronze_customers position=13
-- 2026-09-09 21:51:51,017 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:51:51,025 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:51:51,032 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-09 21:51:51,033 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-09 21:51:51,046 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-09 21:51:51,047 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-09 21:51:51,047 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2100)) - Get metadata for source tables
-- 2026-09-09 21:51:51,048 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:51,048 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.raw_customers
-- 2026-09-09 21:51:51,067 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2224)) - Get metadata for subqueries
-- 2026-09-09 21:51:51,068 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-09 21:51:51,069 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:getMetaData(2248)) - Get metadata for destination tables
-- 2026-09-09 21:51:51,071 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-09 21:51:51,074 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-09 21:51:51,166 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-09 21:51:51,167 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-09 21:51:51,172 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (CalcitePlanner.java:genOPTree(518)) - CBO Succeeded; optimized logical plan.
-- 2026-09-09 21:51:51,205 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for FS(8)
-- 2026-09-09 21:51:51,206 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(7)
-- 2026-09-09 21:51:51,209 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for GBY(6)
-- 2026-09-09 21:51:51,210 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for RS(5)
-- 2026-09-09 21:51:51,211 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for GBY(4)
-- 2026-09-09 21:51:51,213 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(3)
-- 2026-09-09 21:51:51,214 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(744)) - Processing for SEL(2)
-- 2026-09-09 21:51:51,215 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(450)) - Processing for FIL(1)
-- 2026-09-09 21:51:51,220 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ppd.OpProcFactory (OpProcFactory.java:process(417)) - Processing for TS(0)
-- 2026-09-09 21:51:51,276 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] optimizer.ColumnPrunerProcFactory (ColumnPrunerProcFactory.java:pruneReduceSinkOperator(901)) - RS 5 oldColExprMap: {KEY._col0=Column[_col0], KEY._col1=Column[_col1], KEY._col2=Column[_col2], KEY._col3=Column[_col3], KEY._col4=Column[_col4], KEY._col5=Column[_col5], KEY._col6=Column[_col6]}
-- 2026-09-09 21:51:51,277 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] optimizer.ColumnPrunerProcFactory (ColumnPrunerProcFactory.java:pruneReduceSinkOperator(950)) - RS 5 newColExprMap: {KEY._col0=Column[_col0], KEY._col1=Column[_col1], KEY._col2=Column[_col2], KEY._col3=Column[_col3], KEY._col4=Column[_col4], KEY._col5=Column[_col5], KEY._col6=Column[_col6]}
-- 2026-09-09 21:51:51,306 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-09 21:51:51,307 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-09 21:51:51,312 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_database: @hive#default
-- 2026-09-09 21:51:51,313 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_database: @hive#default
-- 2026-09-09 21:51:51,464 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapWork(1849)) - Examining input format to see if vectorization is enabled.
-- 2026-09-09 21:51:51,472 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapWork(1938)) - Vectorization is enabled for input format(s) [org.apache.hadoop.mapred.TextInputFormat]
-- 2026-09-09 21:51:51,473 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:validateAndVectorizeMapOperators(1961)) - Validating and vectorizing MapWork... (vectorizedVertexNum 0)
-- 2026-09-09 21:51:51,513 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:validateGroupByOperator(2688)) - Vector GROUP BY operator will use processing mode HASH
-- 2026-09-09 21:51:51,525 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1035)) - Map vectorization enabled: true
-- 2026-09-09 21:51:51,526 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1037)) - Map vectorized: true
-- 2026-09-09 21:51:51,527 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1044)) - Map vectorizedVertexNum: 0
-- 2026-09-09 21:51:51,530 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1076)) - Map enabledConditionsMet: [hive.vectorized.use.vector.serde.deserialize IS true]
-- 2026-09-09 21:51:51,531 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logMapWorkExplainVectorization(1085)) - Map inputFileFormatClassNameSet: [org.apache.hadoop.mapred.TextInputFormat]
-- 2026-09-09 21:51:51,531 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1035)) - Reduce vectorization enabled: false
-- 2026-09-09 21:51:51,532 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1037)) - Reduce vectorized: false
-- 2026-09-09 21:51:51,533 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logExplainVectorization(1044)) - Reduce vectorizedVertexNum: 1
-- 2026-09-09 21:51:51,533 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logReduceWorkExplainVectorization(1096)) - Reducer hive.vectorized.execution.reduce.enabled: true
-- 2026-09-09 21:51:51,534 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] physical.Vectorizer (Vectorizer.java:logReduceWorkExplainVectorization(1098)) - Reducer engine: mr
-- 2026-09-09 21:51:51,543 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] parse.CalcitePlanner (SemanticAnalyzer.java:analyzeInternal(12343)) - Completed plan generation
-- 2026-09-09 21:51:51,546 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:compile(666)) - Semantic Analysis Completed (retrial = false)
-- 2026-09-09 21:51:51,550 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:getSchema(374)) - Returning Hive schema: Schema(fieldSchemas:[FieldSchema(name:customer_id, type:int, comment:null), FieldSchema(name:name, type:string, comment:null), FieldSchema(name:cpf, type:string, comment:null), FieldSchema(name:email, type:string, comment:null), FieldSchema(name:segment, type:string, comment:null), FieldSchema(name:credit_score, type:int, comment:null), FieldSchema(name:created_at, type:date, comment:null)], properties:null)
-- 2026-09-09 21:51:51,557 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:compile(781)) - Completed compiling command(queryId=palomamusa_20260909215146_20e908e0-16bc-48b7-8bd9-bf975fdaa022); Time taken: 5.29 seconds
-- 2026-09-09 21:51:51,557 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] reexec.ReExecDriver (ReExecDriver.java:run(156)) - Execution #1 of query
-- 2026-09-09 21:51:51,558 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- 2026-09-09 21:51:51,559 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:execute(2255)) - Executing command(queryId=palomamusa_20260909215146_20e908e0-16bc-48b7-8bd9-bf975fdaa022): CREATE TABLE bronze_customers
-- STORED AS PARQUET AS
-- SELECT DISTINCT
--   customer_id, name, cpf, email, segment,
--   CAST(credit_score AS INT) AS credit_score,
--   CAST(created_at AS DATE) AS created_at
-- FROM raw_customers
-- WHERE customer_id IS NOT NULL
--   AND credit_score BETWEEN 300 AND 900
-- 2026-09-09 21:51:51,567 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:logMrWarning(2591)) - Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
-- Query ID = palomamusa_20260909215146_20e908e0-16bc-48b7-8bd9-bf975fdaa022
-- 2026-09-09 21:51:51,569 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (SessionState.java:printInfo(1227)) - Query ID = palomamusa_20260909215146_20e908e0-16bc-48b7-8bd9-bf975fdaa022
-- Total jobs = 1
-- 2026-09-09 21:51:51,570 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (SessionState.java:printInfo(1227)) - Total jobs = 1
-- Launching Job 1 out of 1
-- 2026-09-09 21:51:51,592 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (SessionState.java:printInfo(1227)) - Launching Job 1 out of 1
-- 2026-09-09 21:51:51,604 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-1:MAPRED] in serial mode
-- 2026-09-09 21:51:54,037 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:getInputSummaryWithPool(2555)) - Cache Content Summary for hdfs://localhost:9000/user/bigdata/raw/customers length: 842392 file count: 5  directory count: 1
-- 2026-09-09 21:51:54,044 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:estimateNumberOfReducers(3136)) - BytesPerReducer=256000000 maxReducers=1009 totalInputFileSize=842392
-- Number of reduce tasks not specified. Estimated from input data size: 1
-- 2026-09-09 21:51:54,048 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - Number of reduce tasks not specified. Estimated from input data size: 1
-- In order to change the average load for a reducer (in bytes):
-- 2026-09-09 21:51:54,050 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - In order to change the average load for a reducer (in bytes):
--   set hive.exec.reducers.bytes.per.reducer=<number>
-- 2026-09-09 21:51:54,051 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) -   set hive.exec.reducers.bytes.per.reducer=<number>
-- In order to limit the maximum number of reducers:
-- 2026-09-09 21:51:54,053 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - In order to limit the maximum number of reducers:
--   set hive.exec.reducers.max=<number>
-- 2026-09-09 21:51:54,054 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) -   set hive.exec.reducers.max=<number>
-- In order to set a constant number of reducers:
-- 2026-09-09 21:51:54,056 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - In order to set a constant number of reducers:
--   set mapreduce.job.reduces=<number>
-- 2026-09-09 21:51:54,057 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) -   set mapreduce.job.reduces=<number>
-- 2026-09-09 21:51:54,063 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/d4ba01e2-6a1f-4cad-b97a-5400b73bed15/hive_2026-09-09_21-51-46_418_621801313551385255-1
-- 2026-09-09 21:51:54,078 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mr.ExecDriver (ExecDriver.java:execute(299)) - Using org.apache.hadoop.hive.ql.io.CombineHiveInputFormat
-- 2026-09-09 21:51:54,084 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:getInputPaths(3298)) - Processing alias $hdt$_0:raw_customers
-- 2026-09-09 21:51:54,085 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:getInputPaths(3336)) - Adding 1 inputs; the first input is hdfs://localhost:9000/user/bigdata/raw/customers
-- 2026-09-09 21:51:54,087 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Context (Context.java:getMRScratchDir(548)) - New scratch dir is hdfs://localhost:9000/tmp/hive/palomamusa/d4ba01e2-6a1f-4cad-b97a-5400b73bed15/hive_2026-09-09_21-51-46_418_621801313551385255-1
-- 2026-09-09 21:51:54,262 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.SerializationUtilities (SerializationUtilities.java:serializePlan(569)) - Serializing MapWork using kryo
-- 2026-09-09 21:51:54,971 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] Configuration.deprecation (Configuration.java:logDeprecation(1442)) - mapred.submit.replication is deprecated. Instead, use mapreduce.client.submit.file.replication
-- 2026-09-09 21:51:54,982 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:setBaseWork(633)) - Serialized plan (via FILE) - name: null size: 8.32KB
-- 2026-09-09 21:51:55,018 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.SerializationUtilities (SerializationUtilities.java:serializePlan(569)) - Serializing ReduceWork using kryo
-- 2026-09-09 21:51:55,079 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:setBaseWork(633)) - Serialized plan (via FILE) - name: null size: 9.15KB
-- 2026-09-09 21:51:55,266 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
-- 2026-09-09 21:51:56,006 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] fs.FSStatsPublisher (FSStatsPublisher.java:init(53)) - created : hdfs://localhost:9000/user/hive/warehouse/.hive-staging_hive_2026-09-09_21-51-46_418_621801313551385255-1/-ext-10003
-- 2026-09-09 21:51:56,065 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] client.DefaultNoHARMFailoverProxyProvider (DefaultNoHARMFailoverProxyProvider.java:init(64)) - Connecting to ResourceManager at /0.0.0.0:8032
-- 2026-09-09 21:51:56,075 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/d4ba01e2-6a1f-4cad-b97a-5400b73bed15/hive_2026-09-09_21-51-46_418_621801313551385255-1/-mr-10005/e806d2b9-18b7-4a04-ab98-c05cb4e7a7dc/map.xml
-- 2026-09-09 21:51:56,075 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/d4ba01e2-6a1f-4cad-b97a-5400b73bed15/hive_2026-09-09_21-51-46_418_621801313551385255-1/-mr-10005/e806d2b9-18b7-4a04-ab98-c05cb4e7a7dc/reduce.xml
-- 2026-09-09 21:51:56,564 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mapreduce.JobResourceUploader (JobResourceUploader.java:uploadResourcesInternal(149)) - Hadoop command-line option parsing not performed. Implement the Tool interface and execute your application with ToolRunner to remedy this.
-- 2026-09-09 21:51:56,581 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mapreduce.JobResourceUploader (JobResourceUploader.java:disableErasureCodingForPath(907)) - Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/palomamusa/.staging/job_1788992848033_0007
-- 2026-09-09 21:51:57,510 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Utilities (Utilities.java:getBaseWork(429)) - PLAN PATH = hdfs://localhost:9000/tmp/hive/palomamusa/d4ba01e2-6a1f-4cad-b97a-5400b73bed15/hive_2026-09-09_21-51-46_418_621801313551385255-1/-mr-10005/e806d2b9-18b7-4a04-ab98-c05cb4e7a7dc/map.xml
-- 2026-09-09 21:51:57,512 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getNonCombinablePathIndices(477)) - Total number of paths: 1, launching 1 threads to check non-combinable ones.
-- 2026-09-09 21:51:57,529 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(413)) - CombineHiveInputSplit creating pool for hdfs://localhost:9000/user/bigdata/raw/customers; using filter path hdfs://localhost:9000/user/bigdata/raw/customers
-- 2026-09-09 21:51:57,634 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] input.FileInputFormat (FileInputFormat.java:listStatus(300)) - Total input files to process : 4
-- 2026-09-09 21:51:57,683 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getCombineSplits(467)) - number of splits 1
-- 2026-09-09 21:51:57,685 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] io.CombineHiveInputFormat (CombineHiveInputFormat.java:getSplits(587)) - Number of all splits 1
-- 2026-09-09 21:51:58,718 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mapreduce.JobSubmitter (JobSubmitter.java:submitJobInternal(202)) - number of splits:1
-- 2026-09-09 21:51:58,768 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] Configuration.deprecation (Configuration.java:logDeprecation(1442)) - yarn.resourcemanager.system-metrics-publisher.enabled is deprecated. Instead, use yarn.system-metrics-publisher.enabled
-- 2026-09-09 21:51:58,834 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(298)) - Submitting tokens for job: job_1788992848033_0007
-- 2026-09-09 21:51:58,835 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mapreduce.JobSubmitter (JobSubmitter.java:printTokens(299)) - Executing with tokens: []
-- 2026-09-09 21:51:59,162 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] conf.Configuration (Configuration.java:getConfResourceAsInputStream(2854)) - resource-types.xml not found
-- 2026-09-09 21:51:59,166 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] resource.ResourceUtils (ResourceUtils.java:addResourcesFileToConf(476)) - Unable to find 'resource-types.xml'.
-- 2026-09-09 21:51:59,342 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] impl.YarnClientImpl (YarnClientImpl.java:submitApplication(338)) - Submitted application application_1788992848033_0007
-- 2026-09-09 21:51:59,477 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mapreduce.Job (Job.java:submit(1682)) - The url to track the job: http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788992848033_0007/
-- Starting Job = job_1788992848033_0007, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788992848033_0007/
-- 2026-09-09 21:51:59,481 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - Starting Job = job_1788992848033_0007, Tracking URL = http://DESKTOP-NJ8QT5E.localdomain:8088/proxy/application_1788992848033_0007/
-- Kill Command = /opt/hadoop/bin/mapred job  -kill job_1788992848033_0007
-- 2026-09-09 21:51:59,483 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - Kill Command = /opt/hadoop/bin/mapred job  -kill job_1788992848033_0007
-- Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
-- 2026-09-09 21:52:12,064 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
-- 2026-09-09 21:52:12,181 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] mapreduce.Counters (AbstractCounters.java:getGroup(235)) - Group org.apache.hadoop.mapred.Task$Counter is deprecated. Use org.apache.hadoop.mapreduce.TaskCounter instead
-- 2026-09-09 21:52:12,171 Stage-1 map = 0%,  reduce = 0%
-- 2026-09-09 21:52:12,184 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-09 21:52:12,171 Stage-1 map = 0%,  reduce = 0%
-- 2026-09-09 21:52:21,704 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 7.03 sec
-- 2026-09-09 21:52:21,705 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-09 21:52:21,704 Stage-1 map = 100%,  reduce = 0%, Cumulative CPU 7.03 sec
-- 2026-09-09 21:52:32,229 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 12.37 sec
-- 2026-09-09 21:52:32,229 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - 2026-09-09 21:52:32,229 Stage-1 map = 100%,  reduce = 100%, Cumulative CPU 12.37 sec
-- MapReduce Total cumulative CPU time: 12 seconds 370 msec
-- 2026-09-09 21:52:34,345 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - MapReduce Total cumulative CPU time: 12 seconds 370 msec
-- Ended Job = job_1788992848033_0007
-- 2026-09-09 21:52:34,386 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - Ended Job = job_1788992848033_0007
-- 2026-09-09 21:52:34,494 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-0:MOVE] in serial mode
-- 2026-09-09 21:52:34,518 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-09 21:52:34,519 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-09 21:52:34,522 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-09 21:52:34,523 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- Moving data to directory hdfs://localhost:9000/user/hive/warehouse/bronze_customers
-- 2026-09-09 21:52:34,526 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] exec.Task (SessionState.java:printInfo(1227)) - Moving data to directory hdfs://localhost:9000/user/hive/warehouse/bronze_customers from hdfs://localhost:9000/user/hive/warehouse/.hive-staging_hive_2026-09-09_21-51-46_418_621801313551385255-1/-ext-10002
-- 2026-09-09 21:52:34,584 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-3:DDL] in serial mode
-- 2026-09-09 21:52:34,591 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-09 21:52:34,592 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-09 21:52:34,593 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-09 21:52:34,596 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-09 21:52:34,597 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-09 21:52:34,599 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-09 21:52:34,600 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: create_table: Table(tableName:bronze_customers, dbName:default, owner:palomamusa, createTime:1789001554, lastAccessTime:0, retention:0, sd:StorageDescriptor(cols:[FieldSchema(name:customer_id, type:int, comment:null), FieldSchema(name:name, type:string, comment:null), FieldSchema(name:cpf, type:string, comment:null), FieldSchema(name:email, type:string, comment:null), FieldSchema(name:segment, type:string, comment:null), FieldSchema(name:credit_score, type:int, comment:null), FieldSchema(name:created_at, type:date, comment:null)], location:null, inputFormat:org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat, outputFormat:org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat, compressed:false, numBuckets:-1, serdeInfo:SerDeInfo(name:null, serializationLib:org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe, parameters:{serialization.format=1}), bucketCols:[], sortCols:[], parameters:{}, skewedInfo:SkewedInfo(skewedColNames:[], skewedColValues:[], skewedColValueLocationMaps:{}), storedAsSubDirectories:false), partitionKeys:[], parameters:{bucketing_version=2}, viewOriginalText:null, viewExpandedText:null, tableType:MANAGED_TABLE, privileges:PrincipalPrivilegeSet(userPrivileges:{palomamusa=[PrivilegeGrantInfo(privilege:INSERT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:SELECT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:UPDATE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:DELETE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true)]}, groupPrivileges:null, rolePrivileges:null), temporary:false, catName:hive, ownerType:USER)
-- 2026-09-09 21:52:34,601 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=create_table: Table(tableName:bronze_customers, dbName:default, owner:palomamusa, createTime:1789001554, lastAccessTime:0, retention:0, sd:StorageDescriptor(cols:[FieldSchema(name:customer_id, type:int, comment:null), FieldSchema(name:name, type:string, comment:null), FieldSchema(name:cpf, type:string, comment:null), FieldSchema(name:email, type:string, comment:null), FieldSchema(name:segment, type:string, comment:null), FieldSchema(name:credit_score, type:int, comment:null), FieldSchema(name:created_at, type:date, comment:null)], location:null, inputFormat:org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat, outputFormat:org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat, compressed:false, numBuckets:-1, serdeInfo:SerDeInfo(name:null, serializationLib:org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe, parameters:{serialization.format=1}), bucketCols:[], sortCols:[], parameters:{}, skewedInfo:SkewedInfo(skewedColNames:[], skewedColValues:[], skewedColValueLocationMaps:{}), storedAsSubDirectories:false), partitionKeys:[], parameters:{bucketing_version=2}, viewOriginalText:null, viewExpandedText:null, tableType:MANAGED_TABLE, privileges:PrincipalPrivilegeSet(userPrivileges:{palomamusa=[PrivilegeGrantInfo(privilege:INSERT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:SELECT, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:UPDATE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true), PrivilegeGrantInfo(privilege:DELETE, createTime:-1, grantor:palomamusa, grantorType:USER, grantOption:true)]}, groupPrivileges:null, rolePrivileges:null), temporary:false, catName:hive, ownerType:USER)
-- 2026-09-09 21:52:34,612 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] utils.MetaStoreUtils (MetaStoreUtils.java:updateTableStatsSlow(703)) - Updating table stats for bronze_customers
-- 2026-09-09 21:52:34,613 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] utils.MetaStoreUtils (MetaStoreUtils.java:updateTableStatsSlow(705)) - Updated size of table bronze_customers to 718985
-- 2026-09-09 21:52:35,413 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:52:35,414 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:52:35,435 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:launchTask(2662)) - Starting task [Stage-2:STATS] in serial mode
-- 2026-09-09 21:52:35,436 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Cleaning up thread local RawStore...
-- 2026-09-09 21:52:35,438 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Cleaning up thread local RawStore...
-- 2026-09-09 21:52:35,441 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: Done cleaning up thread local RawStore
-- 2026-09-09 21:52:35,442 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=Done cleaning up thread local RawStore
-- 2026-09-09 21:52:35,444 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:newRawStoreForConf(719)) - 0: Opening raw store with implementation class:org.apache.hadoop.hive.metastore.ObjectStore
-- 2026-09-09 21:52:35,445 WARN  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:correctAutoStartMechanism(639)) - datanucleus.autoStartMechanismMode is set to unsupported value null . Setting it to value: ignored
-- 2026-09-09 21:52:35,446 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:initializeHelper(482)) - ObjectStore, initialize called
-- 2026-09-09 21:52:35,448 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.MetaStoreDirectSql (MetaStoreDirectSql.java:<init>(186)) - Using direct SQL, underlying DB is DERBY
-- 2026-09-09 21:52:35,449 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.ObjectStore (ObjectStore.java:setConf(397)) - Initialized ObjectStore
-- 2026-09-09 21:52:35,450 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.RetryingMetaStoreClient (RetryingMetaStoreClient.java:<init>(97)) - RetryingMetaStoreClient proxy=class org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient ugi=palomamusa (auth:SIMPLE) retries=1 delay=1 lifetime=0
-- 2026-09-09 21:52:35,451 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:52:35,452 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=get_table : tbl=hive.default.bronze_customers
-- 2026-09-09 21:52:35,467 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] stats.BasicStatsTask (BasicStatsTask.java:process(96)) - Executing stats task
-- 2026-09-09 21:52:35,470 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] fs.FSStatsPublisher (FSStatsPublisher.java:init(53)) - created : hdfs://localhost:9000/user/hive/warehouse/.hive-staging_hive_2026-09-09_21-51-46_418_621801313551385255-1/-ext-10003
-- 2026-09-09 21:52:36,102 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] FileOperations (FSStatsAggregator.java:aggregateStats(101)) - Read stats for : default.bronze_customers/      numRows 9993
-- 2026-09-09 21:52:36,104 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] FileOperations (FSStatsAggregator.java:aggregateStats(101)) - Read stats for : default.bronze_customers/      rawDataSize     69951
-- 2026-09-09 21:52:36,108 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] metastore.HiveMetaStore (HiveMetaStore.java:logInfo(897)) - 0: alter_table: hive.default.bronze_customers newtbl=bronze_customers
-- 2026-09-09 21:52:36,109 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] HiveMetaStore.audit (HiveMetaStore.java:logAuditEvent(349)) - ugi=palomamusa  ip=unknown-ip-addr      cmd=alter_table: hive.default.bronze_customers newtbl=bronze_customers
-- 2026-09-09 21:52:36,183 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] stats.BasicStatsTask (BasicStatsTask.java:aggregateStats(280)) - Table default.bronze_customers stats: [numFiles=1, numRows=9993, totalSize=718985, rawDataSize=69951]
-- MapReduce Jobs Launched:
-- 2026-09-09 21:52:36,187 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (SessionState.java:printInfo(1227)) - MapReduce Jobs Launched:
-- Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 12.37 sec   HDFS Read: 860314 HDFS Write: 719070 SUCCESS
-- 2026-09-09 21:52:36,189 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (SessionState.java:printInfo(1227)) - Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 12.37 sec   HDFS Read: 860314 HDFS Write: 719070 SUCCESS
-- Total MapReduce CPU Time Spent: 12 seconds 370 msec
-- 2026-09-09 21:52:36,191 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (SessionState.java:printInfo(1227)) - Total MapReduce CPU Time Spent: 12 seconds 370 msec
-- 2026-09-09 21:52:36,192 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:execute(2531)) - Completed executing command(queryId=palomamusa_20260909215146_20e908e0-16bc-48b7-8bd9-bf975fdaa022); Time taken: 44.628 seconds
-- OK
-- 2026-09-09 21:52:36,194 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (SessionState.java:printInfo(1227)) - OK
-- 2026-09-09 21:52:36,195 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] ql.Driver (Driver.java:checkConcurrency(285)) - Concurrency mode is disabled, not creating a lock manager
-- Time taken: 49.931 seconds
-- 2026-09-09 21:52:36,210 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] CliDriver (SessionState.java:printInfo(1227)) - Time taken: 49.931 seconds
-- 2026-09-09 21:52:36,215 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] conf.HiveConf (HiveConf.java:getLogIdVar(5043)) - Using the default value passed in for log id: d4ba01e2-6a1f-4cad-b97a-5400b73bed15
-- 2026-09-09 21:52:36,217 INFO  [d4ba01e2-6a1f-4cad-b97a-5400b73bed15 main] session.SessionState (SessionState.java:resetThreadName(452)) - Resetting thread name to  main

### Passo 2 — Conferir quantas linhas sobraram

```sql
SELECT COUNT(*) FROM bronze_customers;
SELECT COUNT(*) FROM raw_customers;
```

### Passo 3 — Criar a tabela Bronze de transações

```sql
CREATE TABLE bronze_transactions
STORED AS PARQUET AS
SELECT DISTINCT
  transaction_id, customer_id,
  CAST(amount AS FLOAT) AS amount,
  transaction_type, status,
  CAST(risk_score AS FLOAT) AS risk_score,
  CASE WHEN is_fraud = 'True' THEN true ELSE false END AS is_fraud,
  CAST(ts AS TIMESTAMP) AS ts
FROM raw_transactions
WHERE amount > 0
  AND customer_id IS NOT NULL;
```

### Passo 4 — Validar tipos e ranges

```sql
SELECT MIN(amount), MAX(amount), COUNT(*) FROM bronze_transactions;
SELECT is_fraud, COUNT(*) FROM bronze_transactions GROUP BY is_fraud;
```

### Passo 5 — Checar duplicatas removidas

```sql
SELECT transaction_id, COUNT(*) c
FROM bronze_transactions
GROUP BY transaction_id
HAVING c > 1;
```
