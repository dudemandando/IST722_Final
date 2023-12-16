--drop table [fudgemart_test].[DimCustomer], [fudgemart_test].[DimDate],[fudgemart_test].[DimOrders],[fudgemart_test].[DimProductReview],[fudgemart_test].[DimProducts],[fudgemart_test].[OrderReviewByState];

IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;

-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
--CREATE SCHEMA fudgemart_test
GO


/* Drop table fudgemart_test.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_test.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_test.DimDate 
;

/* Create table fudgemart_test.DimDate */
CREATE TABLE fudgemart_test.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_fudgemart_test.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


INSERT INTO fudgemart_test.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart_test].[Date]'))
DROP VIEW [fudgemart_test].[Date]
GO
CREATE VIEW [fudgemart_test].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM fudgemart_test.DimDate
GO

/* Drop table fudgemart_test.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_test.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_test.DimCustomer 
;

/* Create table fudgemart_test.DimCustomer */
CREATE TABLE fudgemart_test.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID] int  NOT NULL
,  [CustomerEmail]  nvarchar(40)   NOT NULL
,  [CustomerName]  nvarchar(30)   NOT NULL
,  [CustomerAddress]  nvarchar(50)   NOT NULL
,  [CusomerZipcode]  nvarchar(50)   NOT NULL
,  [CustomerCity]  nvarchar(50)   NOT NULL
,  [CustomerState]  nvarchar(25)  DEFAULT 'N/A*' NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_fudgemart_test.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey], [CustomerID] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgemart_test.DimCustomer ON
;
INSERT INTO fudgemart_test.DimCustomer (CustomerKey, CustomerID, CustomerEmail, CustomerName, CustomerAddress, CusomerZipcode, CustomerCity, CustomerState, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', '', '', '', 'N/A', '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemart_test.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart_test].[DimCustomer]'))
DROP VIEW [fudgemart_test].[Customer]
GO
CREATE VIEW [fudgemart_test].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerEmail] AS [CustomerEmail]
, [CustomerName] AS [CustomerName]
, [CustomerAddress] AS [CustomerAddress]
, [CusomerZipcode] AS [CusomerZipcode]
, [CustomerCity] AS [CustomerCity]
, [CustomerState] AS [CustomerState]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemart_test.DimCustomer
GO


/* Drop table fudgemart_test.DimOrders */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_test.DimOrders') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_test.DimOrders 
;

/* Create table fudgemart_test.DimOrders */
CREATE TABLE fudgemart_test.DimOrders (
   [OrderKey]  int IDENTITY  NOT NULL
,  [OrdersID]  int   NOT NULL
,  [CustomerID] int  NOT NULL
,  [OrderDate]  datetime   NOT NULL
,  [Shipped date]  datetime   NOT NULL
,  [ProductID]  int  NOT NULL
,  [CustomerZip]  nvarchar(50)   NOT NULL
, CONSTRAINT [PK_fudgemart_test.DimOrders] PRIMARY KEY CLUSTERED 
( [OrderKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgemart_test.DimOrders ON
;
INSERT INTO fudgemart_test.DimOrders (OrderKey, OrdersID, CustomerID, OrderDate, [Shipped date], ProductID, CustomerZip)
VALUES (-1, -1, -1, '', '', -1, '')
;
SET IDENTITY_INSERT fudgemart_test.DimOrders OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart_test].[DimOrderFulfillment]'))
DROP VIEW [fudgemart_test].[DimOrderFulfillment]
GO
CREATE VIEW [fudgemart_test].[DimOrderFulfillment] AS 
SELECT [OrderKey] AS [OrderKey]
, [OrdersID] AS [OrdersID]
, [CustomerID] AS [CustomerID]
, [OrderDate] AS [OrderDate]
, [Shipped date] AS [Shipped date]
, [ProductID] AS [ProductID]
, [CustomerZip] AS [CustomerZip]
FROM fudgemart_test.DimOrders
GO


/* Drop table fudgemart_test.DimProducts */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_test.DimProducts') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_test.DimProducts 
;

/* Create table fudgemart_test.DimProducts */
CREATE TABLE fudgemart_test.DimProducts (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int NOT NULL
,  [ProductName]  nvarchar(100)   NOT NULL
,  [ProductRetailPrice]  money   NOT NULL
,  [ProductWholesalePrice]  money   NOT NULL
,  [ProductCategory]  nvarchar(50)   NOT NULL
,  [ProductDiscontinued]  smallint   NOT NULL
, CONSTRAINT [PK_fudgemart_test.DimProducts] PRIMARY KEY CLUSTERED 
( [ProductKey], [ProductID] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgemart_test.DimProducts ON
;
INSERT INTO fudgemart_test.DimProducts (ProductKey, ProductID, ProductName, ProductRetailPrice, ProductWholesalePrice, ProductCategory, ProductDiscontinued)
VALUES (-1, -1, '', 0.00, 0.00, '', -1)
;
SET IDENTITY_INSERT fudgemart_test.DimProducts OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart_test].[DimCustomer]'))
DROP VIEW [fudgemart_test].[DimCustomer]
GO
CREATE VIEW [fudgemart_test].[DimCustomer] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [ProductRetailPrice] AS [ProductRetailPrice]
, [ProductWholesalePrice] AS [ProductWholesalePrice]
, [ProductCategory] AS [ProductCategory]
, [ProductDiscontinued] AS [ProductDiscontinued]
FROM fudgemart_test.DimProducts
GO


/* Drop table fudgemart_test.DimProductReview */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_test.DimProductReview') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_test.DimProductReview 
;

/* Create table fudgemart_test.DimProductReview */
CREATE TABLE fudgemart_test.DimProductReview (
   [ProductReview]  int IDENTITY  NOT NULL
,  [CustomerID]  int  NOT NULL
,  [ProductID]  int NOT NULL
,  [ReviewDate]  datetime   NOT NULL
,  [ReviewStars]  int   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_fudgemart_test.DimProductReview] PRIMARY KEY CLUSTERED 
( [ProductReview] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgemart_test.DimProductReview ON
;
INSERT INTO fudgemart_test.DimProductReview (ProductReview, CustomerID, ProductID, ReviewDate, ReviewStars, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, -1, '', -1, 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemart_test.DimProductReview OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart_test].[ProductReview]'))
DROP VIEW [fudgemart_test].[ProductReview]
GO
CREATE VIEW [fudgemart_test].[ProductReview] AS 
SELECT [ProductReview] AS [ProductReview]
, [CustomerID] AS [CustomerID]
, [ProductID] AS [ProductID]
, [ReviewDate] AS [ReviewDate]
, [ReviewStars] AS [ReviewStars]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemart_test.DimProductReview
GO


/* Drop table fudgemart_test.OrderReviewByState */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_test.OrderReviewByState') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_test.OrderReviewByState 
;

/* Create table fudgemart_test.OrderReviewByState */
CREATE TABLE fudgemart_test.OrderReviewByState (
   [State]  varchar(50)   NOT NULL
,  [OrderCount]  int   NULL
,  [AverageReview]  float   NULL
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart_test].[OrdersByZip]'))
DROP VIEW [fudgemart_test].[OrdersByZip]
GO
CREATE VIEW [fudgemart_test].[OrdersByZip] AS 
SELECT [State] AS [State]
, [OrderCount] AS [OrderCount]
, [AverageReview] AS [AverageReview]
FROM fudgemart_test.OrderReviewByState
GO
