--Create Fact_SRCSalesTarget
USE SCHEMA IMT577_DW_NICHOLAS_FANG.PUBLIC;
CREATE OR REPLACE TABLE FACT_SRCSALESTARGET (
    DIMSTOREID              NUMBER CONSTRAINT FK_DIMSTOREID FOREIGN KEY REFERENCES DIM_STORE(DIMSTOREID) NOT NULL
    ,DIMRESELLERID          NUMBER CONSTRAINT FK_DIMRESELLERID FOREIGN KEY REFERENCES DIM_RESELLER(DIMRESELLERID) NOT NULL
    ,DIMCHANNELID           NUMBER CONSTRAINT FK_CHANNELID FOREIGN KEY REFERENCES DIM_CHANNEL(DIMCHANNELID) NOT NULL
    ,DIMTARGETDATEID        NUMBER(9) CONSTRAINT FK_DIMTARGETDATEID FOREIGN KEY REFERENCES DIM_DATE(DATE_PKEY) NOT NULL
    ,SALESTARGETAMOUNT      FLOAT
)

--Load unknowns (no unknown test case in fact table)
/*
INSERT INTO FACT_SRCSALESTARGET (
    DIMSTOREID
    ,DIMRESELLERID
    ,DIMCHANNELID
    ,DIMTARGETDATEID
    ,SALESTARGETAMOUNT
)
VALUES (
    -1
    ,-1
    ,-1
    ,-1
    ,-1
)
*/

--Load data
INSERT INTO FACT_SRCSALESTARGET (
    DIMSTOREID
    ,DIMRESELLERID
    ,DIMCHANNELID
    ,DIMTARGETDATEID
    ,SALESTARGETAMOUNT
)
SELECT
    NVL(s.DIMSTOREID, -1)
    ,NVL(r.DIMRESELLERID, -1) 
    ,NVL(c.DIMCHANNELID, -1)
    ,d.DATE_PKEY
    ,ROUND((t.TARGETSALESAMOUNT/365),2) as SALESTARGETAMOUNT
FROM STAGE_TDCHANNELRESELLERANDSTORE AS t 
LEFT JOIN DIM_CHANNEL AS c 
    on c.CHANNELNAME = t.CHANNELNAME
LEFT JOIN DIM_STORE AS s
    on t.TARGETNAME = s.STORENUMBER -- no 'store number' in dim_store
    --https://stackoverflow.com/questions/14696793/sql-join-on-a-column-like-another-column
    --on t.TARGETNAME LIKE CONCAT('Store Number', s.STORENUMBER)
LEFT JOIN DIM_RESELLER AS r
    on t.TARGETNAME = r.RESELLERNAME
LEFT JOIN DIM_DATE AS d
    on t.YEAR = d.YEAR
--WHERE --DIMSTOREID IS NOT NULL 
    --DIMRESELLERID IS NOT NULL 
    --DIMCHANNELID IS NOT NULL
    --NULL result in a non-nullable column

