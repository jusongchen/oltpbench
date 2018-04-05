DROP TABLE ORDER_LINE CASCADE CONSTRAINTS PURGE;
DROP TABLE STOCK CASCADE CONSTRAINTS PURGE;
DROP TABLE ITEM CASCADE CONSTRAINTS PURGE;
DROP TABLE NEW_ORDER CASCADE CONSTRAINTS PURGE;
DROP TABLE OORDER CASCADE CONSTRAINTS PURGE;
DROP TABLE HISTORY CASCADE CONSTRAINTS PURGE;
DROP TABLE CUSTOMER CASCADE CONSTRAINTS PURGE;
DROP TABLE DISTRICT CASCADE CONSTRAINTS PURGE;
DROP TABLE WAREHOUSE CASCADE CONSTRAINTS PURGE;


CREATE TABLE CUSTOMER (
  C_W_ID NUMBER NOT NULL,
  C_D_ID NUMBER NOT NULL,
  C_ID NUMBER NOT NULL,
  C_DISCOUNT NUMBER(4,4) NOT NULL,
  C_CREDIT CHAR(2) NOT NULL,
  C_LAST VARCHAR2(16) NOT NULL,
  C_FIRST VARCHAR2(16) NOT NULL,
  C_CREDIT_LIM NUMBER(12,2) NOT NULL,
  C_BALANCE NUMBER(12,2) NOT NULL,
  C_YTD_PAYMENT FLOAT NOT NULL,
  C_PAYMENT_CNT NUMBER NOT NULL,
  C_DELIVERY_CNT NUMBER NOT NULL,
  C_STREET_1 VARCHAR2(20) NOT NULL,
  C_STREET_2 VARCHAR2(20) NOT NULL,
  C_CITY VARCHAR2(20) NOT NULL,
  C_STATE CHAR(2) NOT NULL,
  C_ZIP CHAR(9) NOT NULL,
  C_PHONE CHAR(16) NOT NULL,
  C_SINCE DATE NOT NULL,
  C_MIDDLE CHAR(2) NOT NULL,
  C_DATA VARCHAR2(500) NOT NULL,
  PRIMARY KEY (C_W_ID,C_D_ID,C_ID)
);
CREATE INDEX IDX_CUSTOMER_NAME ON CUSTOMER (C_W_ID,C_D_ID,C_LAST,C_FIRST);

CREATE TABLE DISTRICT (
  D_W_ID NUMBER NOT NULL,
  D_ID NUMBER NOT NULL,
  D_YTD NUMBER(12,2) NOT NULL,
  D_TAX NUMBER(4,4) NOT NULL,
  D_NEXT_O_ID NUMBER NOT NULL,
  D_NAME VARCHAR2(10) NOT NULL,
  D_STREET_1 VARCHAR2(20) NOT NULL,
  D_STREET_2 VARCHAR2(20) NOT NULL,
  D_CITY VARCHAR2(20) NOT NULL,
  D_STATE CHAR(2) NOT NULL,
  D_ZIP CHAR(9) NOT NULL,
  PRIMARY KEY (D_W_ID,D_ID)
);

CREATE TABLE HISTORY (
  H_C_ID NUMBER NOT NULL,
  H_C_D_ID NUMBER NOT NULL,
  H_C_W_ID NUMBER NOT NULL,
  H_D_ID NUMBER NOT NULL,
  H_W_ID NUMBER NOT NULL,
  H_DATE DATE NOT NULL,
  H_AMOUNT NUMBER(6,2) NOT NULL,
  H_DATA VARCHAR2(24) NOT NULL
);

CREATE TABLE ITEM (
  I_ID NUMBER NOT NULL,
  I_NAME VARCHAR2(24) NOT NULL,
  I_PRICE NUMBER(5,2) NOT NULL,
  I_DATA VARCHAR2(50) NOT NULL,
  I_IM_ID NUMBER NOT NULL,
  PRIMARY KEY (I_ID)
);

CREATE TABLE NEW_ORDER (
  NO_W_ID NUMBER NOT NULL,
  NO_D_ID NUMBER NOT NULL,
  NO_O_ID NUMBER NOT NULL,
  PRIMARY KEY (NO_W_ID,NO_D_ID,NO_O_ID)
);

CREATE TABLE OORDER (
  O_W_ID NUMBER NOT NULL,
  O_D_ID NUMBER NOT NULL,
  O_ID NUMBER NOT NULL,
  O_C_ID NUMBER NOT NULL,
  O_CARRIER_ID NUMBER DEFAULT NULL,
  O_OL_CNT NUMBER(2,0) NOT NULL,
  O_ALL_LOCAL NUMBER(1,0) NOT NULL,
  O_ENTRY_D DATE NOT NULL,
  PRIMARY KEY (O_W_ID,O_D_ID,O_ID),
  UNIQUE (O_W_ID,O_D_ID,O_C_ID,O_ID)
);

CREATE TABLE ORDER_LINE (
  OL_W_ID NUMBER NOT NULL,
  OL_D_ID NUMBER NOT NULL,
  OL_O_ID NUMBER NOT NULL,
  OL_NUMBER NUMBER NOT NULL,
  OL_I_ID NUMBER NOT NULL,
  OL_DELIVERY_D DATE,
  OL_AMOUNT NUMBER(6,2) NOT NULL,
  OL_SUPPLY_W_ID NUMBER NOT NULL,
  OL_QUANTITY NUMBER(2,0) NOT NULL,
  OL_DIST_INFO CHAR(24) NOT NULL,
  PRIMARY KEY (OL_W_ID,OL_D_ID,OL_O_ID,OL_NUMBER)
);

CREATE TABLE STOCK (
  S_W_ID NUMBER NOT NULL,
  S_I_ID NUMBER NOT NULL,
  S_QUANTITY NUMBER(4,0) NOT NULL,
  S_YTD NUMBER(8,2) NOT NULL,
  S_ORDER_CNT NUMBER NOT NULL,
  S_REMOTE_CNT NUMBER NOT NULL,
  S_DATA VARCHAR2(50) NOT NULL,
  S_DIST_01 CHAR(24) NOT NULL,
  S_DIST_02 CHAR(24) NOT NULL,
  S_DIST_03 CHAR(24) NOT NULL,
  S_DIST_04 CHAR(24) NOT NULL,
  S_DIST_05 CHAR(24) NOT NULL,
  S_DIST_06 CHAR(24) NOT NULL,
  S_DIST_07 CHAR(24) NOT NULL,
  S_DIST_08 CHAR(24) NOT NULL,
  S_DIST_09 CHAR(24) NOT NULL,
  S_DIST_10 CHAR(24) NOT NULL,
  PRIMARY KEY (S_W_ID,S_I_ID)
);

CREATE TABLE WAREHOUSE (
  W_ID NUMBER NOT NULL,
  W_YTD NUMBER(12,2) NOT NULL,
  W_TAX NUMBER(4,4) NOT NULL,
  W_NAME VARCHAR2(10) NOT NULL,
  W_STREET_1 VARCHAR2(20) NOT NULL,
  W_STREET_2 VARCHAR2(20) NOT NULL,
  W_CITY VARCHAR2(20) NOT NULL,
  W_STATE CHAR(2) NOT NULL,
  W_ZIP CHAR(9) NOT NULL,
  PRIMARY KEY (W_ID)
);
