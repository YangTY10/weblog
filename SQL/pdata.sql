CREATE DATABASE IF NOT EXISTS PDATA;

USE PDATA;

CREATE TABLE IF NOT EXISTS PDATA.P_WEBLOG               
(                                                                
DT TIMESTAMP COMMENT 'page view datetime'
,URL STRING COMMENT 'page view url'
,UA STRING COMMENT 'user agent'
,UUID STRING COMMENT 'user id'                           
)                                                               
COMMENT 'PDATA page view log'
PARTITIONED BY (PARTITION_MDATE VARCHAR(8) COMMENT 'PDATA partition (YYYYMMDD)', PARTITION_SDATE VARCHAR(2) COMMENT 'PDATA partition (HR)')
STORED AS ORC TBLPROPERTIES("ORC.COMPRESS"="SNAPPY");

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.dynamic.partition=true;

--MDATE: 20170711 (YYYYMMDD)
--SDATE: 13 (HR)
ALTER TABLE PDATA.P_WEBLOG DROP IF EXISTS PARTITION (PARTITION_SDATE='${SDATE}');

INSERT INTO PDATA.P_WEBLOG PARTITION(PARTITION_MDATE, PARTITION_SDATE)
SELECT 
DT
,URL
,UA
,UUID
,PARTITION_MDATE
,PARTITION_SDATE
FROM STAGE.S_WEBLOG
WHERE PARTITION_MDATE='${MDATE}' AND PARTITION_SDATE='${SDATE}';

