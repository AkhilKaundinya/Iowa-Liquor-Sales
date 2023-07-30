--Yearly Sales
select year(Invoice_Date) 'Year', round(sum(Invoice_Sale_Dollars),2) as 'Total Sales'
from fct_iowa_liquor_sales_invoice_header
group by year(Invoice_Date)
order by [Year] DESC



-- Top 20 Stores all time
select TOP 20 fct1.Store_Number, dm.Store_Name , round(sum(Invoice_Sale_Dollars),2) as 'Total Sales'
from fct_iowa_liquor_sales_invoice_header fct1 inner join Dim_Iowa_Liquor_Stores dm
on fct1.Store_SK= dm.Store_SK
group by fct1.Store_Number,  dm.Store_Name  
order by [Total Sales] DESC


--Top 20 cities all time
select TOP 20 dm2.City, round (sum(Invoice_Sale_Dollars),2) as 'Total Sales'
from fct_iowa_liquor_sales_invoice_header fct1 inner join Dim_Iowa_Liquor_Stores dm
on fct1.Store_SK= dm.Store_SK inner join Dim_iowa_city dm2
on dm.City_SK = dm2.City_SK
group by dm2.City  
order by [Total Sales] DESC


--Top 10 counties all time
select TOP 20 dm2.County, round (sum(Invoice_Sale_Dollars),2) as 'Total Sales'
from fct_iowa_liquor_sales_invoice_header fct1 inner join Dim_Iowa_Liquor_Stores dm
on fct1.Store_SK= dm.Store_SK inner join Dim_iowa_county dm2
on dm.County_SK = dm2.County_SK
where dm2.County <> 'No Value'
group by dm2.County  
order by [Total Sales] DESC


--Top 20 category all time
select top 20 Category_Name, sum(Sale_Dollars) as total_sales
from 
Dim_iowa_liquor_Product_Categories pc JOIN Dim_iowa_liquor_Products lp
	ON pc.Category_SK = lp.Category_SK
JOIN fct_iowa_liquor_sales_invoice_lineitem il
	ON lp.Item_SK = il.Item_SK
GROUP BY Category_Name
ORDER BY total_sales DESC

--TOP 50 Items of all time
select top 50 Item_Description, sum(Sale_Dollars) as total_sales
from 
Dim_iowa_liquor_Product_Categories pc JOIN Dim_iowa_liquor_Products lp
	ON pc.Category_SK = lp.Category_SK
JOIN fct_iowa_liquor_sales_invoice_lineitem il
	ON lp.Item_SK = il.Item_SK
GROUP BY lp.Item_Number, Item_Description
ORDER BY total_sales DESC

--TOP 20 Vendor
select top 20 lv.Vendor_Name, sum(Sale_Dollars) as total_sales
from
Dim_iowa_liquor_Vendors lv JOIN Dim_iowa_liquor_Products lp
	ON lv.Vendor_SK = lp.Vendor_SK
JOIN fct_iowa_liquor_sales_invoice_lineitem il
	ON lp.Item_SK = il.Item_SK
GROUP BY lv.Vendor_Name
ORDER BY total_sales DESC





