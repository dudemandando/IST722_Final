/****** Object:  Database UNKNOWN    Script Date: 12/15/2023 7:01:51 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE UNKNOWN
GO
CREATE DATABASE UNKNOWN
GO
ALTER DATABASE UNKNOWN
SET RECOVERY SIMPLE
GO
*/

IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
--CREATE SCHEMA fudgemart
GO






/* Drop table fudgemart.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.DimDate 
;

/* Create table fudgemart.DimDate */
CREATE TABLE fudgemart.DimDate (
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
, CONSTRAINT [PK_fudgemart.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO fudgemart.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[Date]'))
DROP VIEW [fudgemart].[Date]
GO
CREATE VIEW [fudgemart].[Date] AS 
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
FROM fudgemart.DimDate
GO



/* Drop table fudgemart.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.DimCustomer 
;

/* Create table fudgemart.DimCustomer */
CREATE TABLE fudgemart.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerEmail]  varchar(100)   NOT NULL
,  [CustomerFirstName]  varchar(50)   NOT NULL
,  [CustomerLastName]  varchar(50)   NOT NULL
,  [CusomerZipcode]  varchar(20)   NOT NULL
,  [CustomerCity]  varchar(50)   NOT NULL
,  [CustomerState]  varchar(25)  DEFAULT 'N/A' NOT NULL
,  [RowIsCurrent]  nchar(1)   DEFAULT 'Y' NOT NULL
,  [RowStartDate]  datetime   DEFAULT '12/25/9999' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)  DEFAULT 'N/A' NOT NULL
, CONSTRAINT [PK_fudgemart.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgemart.DimCustomer ON
;
INSERT INTO fudgemart.DimCustomer (CustomerKey, CustomerID, CustomerEmail, CustomerFirstName, CustomerLastName, CusomerZipcode, CustomerCity, CustomerState, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', '', '', '', '', '', '', 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemart.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[DimCustomer]'))
DROP VIEW [fudgemart].[DimCustomer]
GO
CREATE VIEW [fudgemart].[DimCustomer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerEmail] AS [CustomerEmail]
, [CustomerFirstName] AS [CustomerFirstName]
, [CustomerLastName] AS [CustomerLastName]
, [CusomerZipcode] AS [CusomerZipcode]
, [CustomerCity] AS [CustomerCity]
, [CustomerState] AS [CustomerState]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemart.DimCustomer
GO


/* Drop table fudgemart.DimOrders */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.DimOrders') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.DimOrders 
;

/* Create table fudgemart.DimOrders */
CREATE TABLE fudgemart.DimOrders (
   [OrderKey]  int IDENTITY  NOT NULL
,  [OrdersID]  int   NOT NULL
,  [CustomerID]  int   NOT NULL
,  [OrderDate]  datetime   NOT NULL
,  [Shipped date]  datetime   NOT NULL
,  [CustomerZip]  varchar(20)   NOT NULL
,  [TotalRetail]  money   NOT NULL
,  [TotalWholesale]  money   NOT NULL
, CONSTRAINT [PK_fudgemart.DimOrders] PRIMARY KEY CLUSTERED 
( [OrderKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgemart.DimOrders ON
;
INSERT INTO fudgemart.DimOrders (OrderKey, OrdersID, CustomerID, OrderDate, [Shipped date], CustomerZip, [TotalRetail], [TotalWholesale])
VALUES (-1, -1, -1, '', '', -1, 0, 0)
;
SET IDENTITY_INSERT fudgemart.DimOrders OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[DimOrderFulfillment]'))
DROP VIEW [fudgemart].[DimOrderFulfillment]
GO
CREATE VIEW [fudgemart].[DimOrderFulfillment] AS 
SELECT [OrderKey] AS [OrderKey]
, [OrdersID] AS [OrdersID]
, [CustomerID] AS [CustomerID]
, [OrderDate] AS [OrderDate]
, [Shipped date] AS [Shipped date]
, [ProductID] AS [ProductID]
, [CustomerZip] AS [CustomerZip]
FROM fudgemart.DimOrders
GO



/* Drop table fudgemart.DimProducts */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.DimProducts') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.DimProducts 
;

/* Create table fudgemart.DimProducts */
CREATE TABLE fudgemart.DimProducts (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int  NOT NULL
,  [ProductName]  varchar(50)   NOT NULL
,  [ProductRetailPrice]  money   NOT NULL
,  [ProductWholesalePrice]  money   NOT NULL
,  [ProductCategory]  varchar(20)   NOT NULL
,  [ProductDiscontinued]  bit   NOT NULL
, CONSTRAINT [PK_fudgemart.DimProducts] PRIMARY KEY CLUSTERED 
( [ProductKey], [ProductID] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgemart.DimProducts ON
;
INSERT INTO fudgemart.DimProducts (ProductKey, ProductID, ProductName, ProductRetailPrice, ProductWholesalePrice, ProductCategory, ProductDiscontinued)
VALUES (-1, -1, '', -1, -1, '', -1)
;
SET IDENTITY_INSERT fudgemart.DimProducts OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[DimCustomer]'))
DROP VIEW [fudgemart].[DimProducts]
GO
CREATE VIEW [fudgemart].[DimProducts] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [ProductRetailPrice] AS [ProductRetailPrice]
, [ProductWholesalePrice] AS [ProductWholesalePrice]
, [ProductCategory] AS [ProductCategory]
, [ProductDiscontinued] AS [ProductDiscontinued]
FROM fudgemart.DimProducts
GO


/* Drop table fudgemart.DimProductReview */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.DimProductReview') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.DimProductReview 
;

/* Create table fudgemart.DimProductReview */
CREATE TABLE fudgemart.DimProductReview (
   [ProductReview]  int IDENTITY  NOT NULL
,  [CustomerID]  int NOT NULL
,  [ProductID]  int NOT NULL
,  [ReviewDate]  datetime   NOT NULL
,  [ReviewStars]  int   NOT NULL
,  [RowIsCurrent]  nchar(1) DEFAULT 'Y'   NOT NULL
,  [RowStartDate]  datetime DEFAULT  '12/15/9999' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200) DEFAULT 'N/A'   NOT NULL
, CONSTRAINT [PK_fudgemart.DimProductReview] PRIMARY KEY CLUSTERED 
( [ProductReview] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgemart.DimProductReview ON
;
INSERT INTO fudgemart.DimProductReview (ProductReview, CustomerID, ProductID, ReviewDate, ReviewStars, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, -1, '', -1, 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemart.DimProductReview OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[ProductReview]'))
DROP VIEW [fudgemart].[ProductReview]
GO
CREATE VIEW [fudgemart].[ProductReview] AS 
SELECT [ProductReview] AS [ProductReview]
, [CustomerID] AS [CustomerID]
, [ProductID] AS [ProductID]
, [ReviewDate] AS [ReviewDate]
, [ReviewStars] AS [ReviewStars]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemart.DimProductReview
GO



/* Drop table fudgemart.OrderReviewByState */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.OrderReviewByState') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.OrderReviewByState 
;

/* Create table fudgemart.OrderReviewByState */
CREATE TABLE fudgemart.OrderReviewByState (
   [State]  varchar(50)   NOT NULL
,  [OrderCount]  int   NULL
,  [AverageReview]  float   NULL
,  [TotalRetailRevenue]  money NOT  NULL
,  [TotalWholesaleCost]  money NOT  NULL
,  [RevenueWholesaleDifference]  money NOT  NULL
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[OrdersByZip]'))
DROP VIEW [fudgemart].[OrdersByZip]
GO
CREATE VIEW [fudgemart].[OrdersByZip] AS 
SELECT [State] AS [State]
, [OrderCount] AS [OrderCount]
, [AverageReview] AS [AverageReview]
FROM fudgemart.OrderReviewByState
GO


/* Drop table fudgemart.OrderReviewByState */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.SubsByState') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.SubsByState 
;

/* Create table fudgemart.SubsByState */
CREATE TABLE fudgemart.SubsByState (
   [State]  varchar(50)   NOT NULL
,  [SubscriptionCount]  int  NOT NULL
,  [BasicRental]  int   NOT NULL
,  [BasicRentalPlusStreaming]  int   NOT NULL
,  [PremiumRental]  int   NOT NULL
,  [PremiumRentalPlusStreaming]  int   NOT NULL
,  [StreamingOnly]  int   NOT NULL
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[SubsByState]'))
DROP VIEW [fudgemart].[SubsByState]
GO
CREATE VIEW [fudgemart].[SubsByState] AS 
SELECT [State] AS [State]
, [SubscriptionCount] AS [SubscriptionCount]
, [BasicRental] AS [BasicRental]
, [BasicRentalPlusStreaming] AS [BasicRentalPlusStreaming]
, [PremiumRental] AS [PremiumRental]
, [PremiumRentalPlusStreaming] AS [PremiumRentalPlusStreaming]
, [StreamingOnly] AS [StreamingOnly]

FROM fudgemart.SubsByState
GO


/* Drop table fudgemart.DimSubs */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart.DimSubs') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart.DimSubs 
;

/* Create table fudgemart.DimSubs */
CREATE TABLE fudgemart.DimSubs (
   [SubID]  int IDENTITY  NOT NULL
,  [AccountID]  int   NOT NULL
,  [ZipState]  varchar(2)  DEFAULT 'N/A' NOT NULL
,  [PlanName]  varchar(50)  DEFAULT 'N/A' NOT NULL
,  [PlanPrice]  money  DEFAULT 0 NOT NULL
,  [RowIsCurrent]  nchar(1)  DEFAULT 'Y'  NOT NULL
,  [RowStartDate]  datetime DEFAULT '12/15/9999'  NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)  DEFAULT 'N/A'   NOT NULL
, CONSTRAINT [PK_fudgemart.DimSubs] PRIMARY KEY CLUSTERED 
( [SubID] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fudgemart.DimSubs ON
;
INSERT INTO fudgemart.DimSubs (SubID, AccountID, ZipState, PlanName, PlanPrice, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, '', '', 0, 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemart.DimSubs OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgemart].[DimSubs]'))
DROP VIEW [fudgemart].[DimSubs]
GO
CREATE VIEW [fudgemart].[DimSubs] AS 
SELECT [SubID] AS [SubID]
, [AccountID] AS [AccountID]
, [ZipState] AS [ZipState]
, [PlanName] AS [PlanName]
, [PlanPrice] AS [PlanPrice]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgemart.DimSubs
GO
