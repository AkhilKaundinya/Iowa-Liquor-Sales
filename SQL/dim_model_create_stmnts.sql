-- Iowa_Liqur_Sales Dimensional Model
-- 2022-11-06, 2022-11-12
-- r sherman
-- SQL Server

CREATE TABLE fct_iowa_liquor_sales_invoice_header(
 
    Invoice_Number_SK int not null identity(1,1),    -- 
	Invoice_Number   varchar(24) NOT NULL,   -- Header
	Invoice_Date     datetime not NULL,
	InvoiceDate_SK   int not null,
	Store_SK int NULL,
	Store_Number int NULL,

	Invoice_Bottles_Sold        int NULL,		
	Invoice_Sale_Dollars        numeric(19,4) NULL,    
	Invoice_Volume_Sold_Liters  numeric(19,4) NULL,
	Invoice_Volume_Sold_Gallons numeric(19,4) NULL,
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Invoice_Number_SK)
);
	
CREATE TABLE fct_iowa_liquor_sales_invoice_lineitem(

	Invoice_Item_Number    varchar(24) NOT NULL,
    Invoice_Number_SK      int not null,
	Invoice_Number         varchar(24) NOT NULL,   -- Header
	Invoice_Number_LineNo  int NULL,
	
    Item_SK                    int                NOT NULL,      
	Item_Number            varchar(24) NULL,
		
    Pack                           int NULL,
	Bottle_Volume_ml       int NULL,
	State_Bottle_Cost      numeric(19,4) NULL,
	State_Bottle_Retail    numeric(19,4) NULL,

	Bottles_Sold           int NULL,		
	Sale_Dollars           numeric(19,4) NULL,
	Volume_Sold_Liters     numeric(19,4) NULL,
	Volume_Sold_Gallons    numeric(19,4) NULL,
	
	
	DI_JobID varchar(20)   NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Invoice_Item_Number)
);

ALTER TABLE fct_iowa_liquor_sales_invoice_lineitem 
ALTER COLUMN Invoice_Number varchar(max);

CREATE TABLE Dim_iowa_liquor_Products (

    Item_SK int NOT NULL,      
	Item_Number int NOT NULL,
	-- Item_Number_C varchar(20) NULL,
	Item_Description varchar(80) NULL,
		
	Category_SK int NULL,
	Vendor_SK int NOT NULL,
	
	Bottle_Volume_ml int NULL,
	Pack int NULL,
	Inner_Pack int NULL,
	Age int NULL,
	Proof int NULL,
	List_Date date NULL,
	
	UPC varchar(20) NULL,
	SCC varchar(20) NULL,
	
	State_Bottle_Cost decimal(19,4) NULL,
	State_Case_Cost decimal(19,4) NULL,
	State_Bottle_Retail decimal(19,4) NULL,
	
	Report_Date date NULL,
	Item_Source char(1) not NULL default 'D',    
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Item_SK)
);


CREATE TABLE Dim_iowa_liquor_Vendors (
	
	Vendor_SK     int NOT NULL,
	Vendor_Number int NOT NULL,
	Vendor_Name   nvarchar(80) NULL,
	Vendor_Source char(1) not NULL default 'D',      -- added 2022-11-10
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Vendor_SK)
);

CREATE TABLE Dim_iowa_liquor_Product_Categories (
	
	Category_SK     int NOT NULL identity(1,1),
	Category_Number int NOT NULL default -99,
	Category_Name   varchar(40) NULL,
	Category_Source char(1) not NULL default 'D',     -- added 2022-11-10
		
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Category_SK)
);

CREATE TABLE Dim_Iowa_Liquor_Stores (

	Store_SK int NOT NULL,
	Store_ID int NOT NULL,
	Store_Name varchar(80) NULL,
	Store_Status char(1) NULL,
	
	Address varchar(80) NULL,
	Zip_Code int NULL,
    City_SK int NOT NULL,        -- added 2022-11-09
    County_SK int NOT NULL,   -- added 2022-11-09

	-- Geo_SK int  null,    -- use city_sk and county_sk instead 2022-11-09
               --  Store_Address varchar(80) NULL,   -- skip? 2022-11-09
	
	Report_Date datetime NULL,
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Store_SK)
);

CREATE TABLE Dim_Iowa_Liquor_Geo (    -- do not use  2022-11-09
    Geo_SK int not null identity(1,1),
	
    City_SK int NOT NULL,    -- added 2022-11-07
	City     varchar(20) NULL,   
	Zip_Code int NULL,
                County_SK int NOT NULL,   -- added 2022-11-07
	County  varchar(24) NULL,
	State    varchar(20) NULL,
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Geo_SK)
);


CREATE TABLE FCT_iowa_city_population_by_year (

    City_Pop_SK int not null identity(1,1),
	City_SK int not null,
	City varchar(24) NULL,
	FIPS int NULL,
	DataAsOf datetime NULL,
	Population_Year int NULL,
	Population int NULL,
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (City_Pop_SK)
);

CREATE TABLE FCT_iowa_county_population_by_year (

    County_Pop_SK int not null identity(1,1),
	County_SK int not null,
	County varchar(80) NULL,
	FIPS int NULL,
	DateAsOf date NULL,
	Population_Year int NULL,
	Population int NULL,
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (County_Pop_SK)
);

/*
CREATE TABLE Dim_Date(

    Date_SK int not null,  -- YYYMMDD
	Date_NK date NULL,     -- date
	Date_Year int NULL,    -- YYYY

	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (Date_SK)
);
*/
------------------- 2022-11-07

CREATE TABLE Dim_iowa_county (

	County_SK int not null identity(1,1),
	County varchar(80) NULL,
	FIPS int NULL,
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (County_SK)
);

CREATE TABLE Dim_iowa_city(

	City_SK int not null identity(1,1),
	City varchar(24) NULL,
	FIPS int NULL,
	
	DI_JobID varchar(20) NULL,
	DI_CreateDate datetime not NULL default getdate(),
	PRIMARY KEY (City_SK)
);





--relationships

ALTER TABLE dbo.Dim_Iowa_Liquor_Stores
ADD CONSTRAINT fk_Dim_iowa_county_Dim_Iowa_Liquor_Stores FOREIGN
KEY (County_SK)
REFERENCES dbo.Dim_iowa_county (County_SK);

ALTER TABLE dbo.Dim_Iowa_Liquor_Stores
ADD CONSTRAINT fk_Dim_iowa_city_Dim_Iowa_Liquor_Stores FOREIGN
KEY (City_SK)
REFERENCES dbo.Dim_iowa_city (City_SK);


ALTER TABLE FCT_iowa_county_population_by_year
ADD CONSTRAINT fk_Dim_iowa_county_FCT_iowa_county_population_by_year FOREIGN
KEY (County_SK)
REFERENCES dbo.Dim_iowa_county (County_SK);

ALTER TABLE FCT_iowa_city_population_by_year
ADD CONSTRAINT fk_Dim_iowa_city_FCT_iowa_city_population_by_year FOREIGN
KEY (City_SK)
REFERENCES dbo.Dim_iowa_city (City_SK);

ALTER TABLE fct_iowa_liquor_sales_invoice_header
ADD CONSTRAINT fk_Dim_Iowa_Liquor_Stores_fct_iowa_liquor_sales_invoice_header FOREIGN
KEY (Store_SK)
REFERENCES dbo.Dim_Iowa_Liquor_Stores (Store_SK);

ALTER TABLE fct_iowa_liquor_sales_invoice_lineitem
ADD CONSTRAINT fk_fct_iowa_liquor_sales_invoice_header_fct_iowa_liquor_sales_invoice_lineitem FOREIGN
KEY (Invoice_Number_SK)
REFERENCES dbo.fct_iowa_liquor_sales_invoice_header(Invoice_Number_SK);

ALTER TABLE dbo.Dim_iowa_liquor_Products
ADD CONSTRAINT fk_Dim_iowa_liquor_Product_Categories_Dim_iowa_liquor_Products FOREIGN
KEY (Category_SK)
REFERENCES dbo.Dim_iowa_liquor_Product_Categories (Category_SK)

ALTER TABLE dbo.Dim_iowa_liquor_Products
ADD CONSTRAINT fk_Dim_iowa_liquor_Vendors_Dim_iowa_liquor_Products FOREIGN
KEY (Vendor_SK)
REFERENCES dbo.Dim_iowa_liquor_Vendors (Vendor_SK)

ALTER TABLE fct_iowa_liquor_sales_invoice_lineitem
ADD CONSTRAINT fk_Dim_iowa_liquor_Products_fct_iowa_liquor_sales_invoice_lineitem FOREIGN
KEY (Item_SK)
REFERENCES dbo.Dim_iowa_liquor_Products (Item_SK);


-->loading dim date

CREATE TABLE Dim_Date (
date_sk int not null primary key
,date_nk date NOT NULL unique
,datetime_value datetime NOT NULL unique
,QtrYear_SK int not null
,QtrYear_Name varchar(20) not null
,MonthYear_SK int not null
,MonthYear_Name varchar(20) not null
,Day_in_Month int NOT NULL
,Day_in_Year int NOT NULL
,Day_Count int NOT NULL
,Day_Name varchar(20) not null
,Day_Abr char(3) not null
,Week_in_Year int NOT NULL
,Week_Count int NOT NULL
,Month_ID int NOT NULL
,Month_Name varchar(20) not null
,Month_Abr char(3) not null
,Month_Count int NOT NULL
,First_Day_of_Month date NOT NULL
,Last_Day_of_Month date NOT NULL
,Qtr_ID int NOT NULL
,Date_Year int NOT NULL
)
;

declare @startDay datetime,
@endDay datetime,
@CounterDay int,
@currentDay datetime,
@CounterMonth int,
@CurrentMonth int,
@PreviousMonth int,
@CounterWeek int,
@CurrentWeek int,
@PreviousWeek int
select @startDay = '1/1/2012',
@endDay = '12/31/2030',
@CounterDay = 1,
@currentDay = @startDay,
@CounterMonth = 1,
@CurrentMonth = datepart(month,@currentDay),
@PreviousMonth = datepart(month,@currentDay),
@CounterWeek = 1,
@CurrentWeek = datepart(week,@currentDay),
@PreviousWeek = datepart(week,@currentDay)
--begin transaction
while @currentDay <= @endDay
begin
insert into Dim_Date
(
date_sk,
date_nk,
datetime_value,
QtrYear_SK,
QtrYear_name,
MonthYear_SK,
MonthYear_Name,
Day_in_Month,
Day_in_Year,
Day_Count,
Day_Name,
Day_Abr,
Week_in_Year ,
Week_Count,
Month_ID ,
Month_Name,
Month_Abr,
Month_Count,
First_Day_of_Month,
Last_Day_of_Month,
Qtr_ID ,
Date_Year
)
select
(datepart(year, @currentDay)* 10000)
+ (datepart(month,@currentDay)* 100)
+ (datepart(day,@currentDay)), -- date_sk
@currentDay, -- date_value
@currentDay, -- datetime_value
( (datepart(year, @currentDay)*100)+ ( (datepart(month,@currentDay) / 4 ) +
1 ) ),
datename(year, @currentDay)+' Q'+cast((datepart(month,@currentDay) / 4) + 1 as
char(1)),
datepart(year, @currentDay)*100+datepart(month,@currentDay),
datename(year, @currentDay)+' '+cast((datepart(month,@currentDay))as
char(2) ),
datepart(day,@currentDay) as Day_in_Month,
datepart(dayofyear,@currentDay) as Day_in_Year,
@CounterDay,
datename(dw,@currentDay) as Month_Name,
cast (datename(dw,@currentDay) as CHAR(3)) as Month_Abr,
datepart(week,@currentDay) as Week_in_Year,
@CounterWeek,
datepart(month,@currentDay) as Month_ID,
datename(month,@currentDay) as Month_Name,
cast (datename(month,@currentDay) as CHAR(3)) as Month_Abr,
@CounterMonth,
CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@currentDay)-1),@currentDay),101) as
First_Day_of_Month,
CONVERT(VARCHAR(25),DATEADD(dd,-
(DAY(DATEADD(mm,1,@currentDay))),DATEADD(mm,1,@currentDay)),101) as
Last_Day_of_Month,
datepart(quarter ,@currentDay) as Qtr_ID,
datepart(year, @currentDay) as Date_Year
set @currentDay = dateadd(day,1,@currentDay)
set @CounterDay = @CounterDay + 1
set @CurrentMonth = datepart(month,@currentDay)
set @CurrentWeek = datepart(week,@currentDay)
if @CurrentMonth <> @PreviousMonth
begin
set @CounterMonth = @CounterMonth + 1
set @PreviousMonth = @CurrentMonth
-- print ' Add a month to count'
end
if @CurrentWeek <> @PreviousWeek
begin
set @CounterWeek = @CounterWeek + 1
set @PreviousWeek = @CurrentWeek
-- print ' Add a month to count'
end
--end
--go
set @currentDay = dateadd(day,1,@currentDay)
set @CounterDay = @CounterDay + 1
end
;

create view Dim_InvoiceDate as
SELECT
	date_sk as InvoiceDate_SK,
	date_nk as Invoice_Date,
   	Date_Year as Invoice_Year
FROM dbo.Dim_Date;

--end of changes by divyesh




-- Insert null rows dimensons -------------------

SET IDENTITY_INSERT Dim_iowa_city ON;
INSERT INTO Dim_iowa_city
(City_SK,City, FIPS, DI_JobID, DI_CreateDate)
VALUES(-99, 'No Value', -99, 'ManualInput', (getdate()));
SET IDENTITY_INSERT Dim_iowa_city OFF;

SET IDENTITY_INSERT Dim_iowa_county ON;
INSERT INTO Dim_iowa_county
(county_SK,county, FIPS, DI_JobID, DI_CreateDate)
VALUES(-99, 'No Value', -99, 'ManualInput', (getdate()));
SET IDENTITY_INSERT Dim_iowa_county OFF;

SET IDENTITY_INSERT Dim_iowa_liquor_Product_Categories ON;
INSERT INTO Dim_iowa_liquor_Product_Categories
(Category_SK, Category_Number, Category_Name, Category_Source, DI_JobID, DI_CreateDate)
VALUES(-99,-99, 'No Value', ('D'), 'ManualInput', (getdate()));
SET IDENTITY_INSERT Dim_iowa_liquor_Product_Categories OFF;

INSERT INTO Dim_iowa_liquor_Products
(Item_SK, Item_Number,  Item_Description, Category_SK, Vendor_SK, DI_JobID, DI_CreateDate)
VALUES(-99, -99,  'No Value', -99, -99, 'ManualInput', (getdate()));

INSERT INTO Dim_Iowa_Liquor_Stores
(Store_SK, Store_ID, Store_Name, city_SK, county_sk, DI_JobID, DI_CreateDate)
VALUES(-99, -99,  'No Value', -99,-99, 'Manual Input', (getdate()));

INSERT INTO Dim_iowa_liquor_Vendors
(Vendor_SK, Vendor_Number, Vendor_Name, Vendor_Source, DI_JobID, DI_CreateDate)
VALUES(-99, -99,  'No Value', ('D'), 'Manual Input', (getdate()));


