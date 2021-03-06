--Create table
USE SCHEMA IMT577_DW_NICHOLAS_FANG.PUBLIC;
create or replace table DIM_PRODUCT (
    DIMPRODUCTID                INT IDENTITY (1,1) CONSTRAINT PK_DIMPRODUCTID PRIMARY KEY NOT NULL,
    SOURCEPRODUCTID             INT NOT NULL,
    SOURCEPRODUCTTYPEID         INT NOT NULL,
    SOURCEPRODUCTCATEGORYID     INT NOT NULL,
    PRODUCTNAME                 VARCHAR(255),
    PRODUCTTYPE                 VARCHAR(255),
    PRODUCTCATEGORY             VARCHAR(255),
    PRODUCTRETAILPRICE          FLOAT,
    PRODUCTWHOLESALEPRICE       FLOAT,
    PRODUCTCOST                 FLOAT,
    PRODUCTRETAILPROFIT         FLOAT,
    PRODUCTWHOLESALEUNITPROFIT  FLOAT,
    PRODUCTPROFITMARGINUNITPERCENT  FLOAT
);

--Load unknown
INSERT INTO DIM_PRODUCT (
    DIMPRODUCTID,
    SOURCEPRODUCTID,
    SOURCEPRODUCTTYPEID,
    SOURCEPRODUCTCATEGORYID, 
    PRODUCTNAME, 
    PRODUCTTYPE,
    PRODUCTCATEGORY,
    PRODUCTRETAILPRICE,
    PRODUCTWHOLESALEPRICE,
    PRODUCTCOST,
    PRODUCTRETAILPROFIT,
    PRODUCTWHOLESALEUNITPROFIT,
    PRODUCTPROFITMARGINUNITPERCENT
)
VALUES (
    -1,
    -1,
    -1,
    -1,
    'NA',
    'NA',
    'NA',
    -1,
    -1,
    -1,
    -1,
    -1,
    -1
);

INSERT INTO DIM_PRODUCT (
    --DIMPRODUCTID,
    SOURCEPRODUCTID,
    SOURCEPRODUCTTYPEID,
    SOURCEPRODUCTCATEGORYID, 
    PRODUCTNAME, 
    PRODUCTTYPE,
    PRODUCTCATEGORY,
    PRODUCTRETAILPRICE,
    PRODUCTWHOLESALEPRICE,
    PRODUCTCOST,
    PRODUCTRETAILPROFIT,
    PRODUCTWHOLESALEUNITPROFIT,
    PRODUCTPROFITMARGINUNITPERCENT
)
SELECT DISTINCT
    --DIMPRODUCTID
    p.PRODUCTID AS SOURCEPRODUCTID, 
    p.PRODUCTTYPEID AS SOURCEPRODUCTTYPEID,
    pt.PRODUCTCATEGORYID AS SOURCEPRODUCTCATEGORYID,
    p.PRODUCT AS PRODUCTNAME,
    pt.PRODUCTTYPE,
    pc.PRODUCTCATEGORY,
    p.PRICE AS PRODUCTRETAILPRICE,
    p.WHOLESALEPRICE AS PRODUCTWHOLESALEPRICE,
    p.COST AS PRODUCTCOST,

    CAST((PRODUCTRETAILPRICE - PRODUCTCOST) * p.UNITOFMEASURE AS DECIMAL(10,2)) AS PRODUCTRETAILPROFIT, -- (P-C)*Q
    CAST((PRODUCTWHOLESALEPRICE - PRODUCTCOST) * p.UNITOFMEASURE AS DECIMAL(10,2)) AS PRODUCTWHOLESALEUNITPROFIT,
    CAST((PRODUCTRETAILPRICE - PRODUCTWHOLESALEPRICE - PRODUCTCOST) / (PRODUCTRETAILPRICE - PRODUCTWHOLESALEPRICE) AS DECIMAL(10,2)) AS PRODUCTPROFITMARGINUNITPERCENT -- (P-C)/P

FROM STAGE_PRODUCT AS p
INNER JOIN STAGE_PPRODUCTTYPE AS pt --spelling error on staging table
    ON (p.PRODUCTTYPEID = pt.PRODUCTTYPEID)
INNER JOIN STAGE_PRODUCTCATEGORY AS pc
    USING (PRODUCTCATEGORYID)
--INNER JOIN STAGE_SALESDETAIL AS s
--    USING (PRODUCTID)
--LEFT JOIN STAGE_SALESHEADER AS sh
--    USING (SALESHEADERID)
