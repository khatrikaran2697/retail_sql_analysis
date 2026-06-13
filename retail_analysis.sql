-- 1. Write a query to identify the number of duplicates in "sales_transaction" table. 
-- Also, create a separate table containing the unique values and remove the the original 
-- table from the databases and replace the name of the new table with the original name.

SELECT 
    TransactionID,
    COUNT(*) AS `count(*)`
FROM sales_transaction
GROUP BY TransactionID
HAVING COUNT(*) > 1;

CREATE TABLE sales_transaction_clean AS
SELECT DISTINCT *
FROM sales_transaction;

DROP TABLE sales_transaction;

ALTER TABLE sales_transaction_clean
RENAME TO sales_transaction;

SELECT * 
FROM sales_transaction;


-- 2.Write a query to identify the discrepancies in the price of 
-- the same product in "sales_transaction" and "product_inventory" tables. 
-- Also, update those discrepancies to match the price in both the tables

select s.TransactionID,s.Price as TransactionPrice
,p.Price InventoryPrice
from sales_transaction s
join ⁠product_inventory p on s.productID=p.ProductID
where s.Price <> p.Price;

update sales_transaction s
join ⁠product_inventory p 
on s.productID=p.ProductID
set s.Price = p.Price
where s.Price <> p.Price;

select*
from sales_transaction;

-- 3.Write a SQL query to identify the null values in the dataset and 
-- replace those by “Unknown”.


select count(*)
from customer_profiles
where 
Age is null or trim(Age)=''
or Gender is null or trim(Gender)=''
or Location is null or trim(Location)=''
or JoinDate is null or trim(JoinDate)='';

UPDATE customer_profiles
SET 
    Gender = COALESCE(NULLIF(TRIM(Gender), ''), 'unknown'),
    Location = COALESCE(NULLIF(TRIM(Location), ''), 'unknown'),
    JoinDate = COALESCE(NULLIF(TRIM(JoinDate), ''), 'unknown');

select*
from customer_profiles;


-- 4.Write a SQL query to clean the DATE column in the dataset.

create table sales_transaction_clean as 
select*,
str_to_date(TransactionDate,"%Y-%m-%d") TransactionDate_updated
from sales_transaction;

Drop table sales_transaction;

alter table sales_transaction_clean
rename TO sales_transaction;


-- 5.Write a SQL query to summarize the total sales and 
-- quantities sold per product by the company.

select*
from sales_transaction;

select ProductID,sum(QuantityPurchased) as TotalUnitsSold,
sum(Price * QuantityPurchased) as TotalSales
from sales_transaction
group by ProductID
order by TotalSales desc;


-- 6.Write a SQL query to count the number of transactions per customer 
-- to understand purchase frequency.

select CustomerID, count(*) as NumberOfTransactions
from sales_transaction
group by CustomerID
order by NumberOfTransactions desc;

-- 7.Write a SQL query to evaluate the performance of the product categories based on the 
-- total sales which help us understand the product categories 
-- which needs to be promoted in the marketing campaigns.


select p.Category, sum(s.QuantityPurchased) as TotalUnitsSold,
sum(s.QuantityPurchased * s.price) as TotalSale
from sales_transaction s
join product_inventory p on s.ProductID=p.ProductID
group by p.Category
order by TotalSale desc;

-- 8.Write a SQL query to find the top 10 products with the highest 
-- total sales revenue from the sales transactions. This will help the company to identify 
-- the High sales products which needs to be focused to increase the revenue of the company.


select ProductID,
sum(QuantityPurchased * Price) as TotalRevenue
from sales_transaction
group by ProductID
order by TotalRevenue desc
limit 10;

-- 9.Write a SQL query to find the ten products with the least amount of units sold 
-- from the sales transactions, provided that at least one unit was sold for those products.

select ProductID,
sum(QuantityPurchased) as TotalUnitsSold
from sales_transaction
group by ProductID
having sum(QuantityPurchased) > 0
order by TotalUnitsSold
limit 10;


-- 10. Write a SQL query to identify the sales trend to understand the revenue pattern of the company.

select date_format(TransactionDate,"%Y-%m-%d") as DATETRANS,
count(*)as Transaction_count,
sum(QuantityPurchased) as TotalUnitsSold,
round(sum(QuantityPurchased * Price),2) as TotalSales
from sales_transaction
group by date_format(TransactionDate,"%Y-%m-%d")
order by DATETRANS desc;

-- 11.Write a SQL query to understand the month on month growth rate of sales of 
-- the company which will help understand the growth trend of the company.
with cte as( 
select month(TransactionDate) as month,
round(sum(QuantityPurchased * Price),2) as total_sales
from sales_transaction
group by month(TransactionDate))

select month,total_sales,
lag(total_sales) over(order by month) as previous_month_sales,
round((total_sales - lag(total_sales) over(order by month))/lag(total_sales) over(order by month)* 100,2)
as mom_growth_percentange
from cte;

-- 12 Write a SQL query that describes the number of transaction along with the total amount spent by 
-- each customer which are on the higher side and will help us understand the 
-- customers who are the high frequency purchase customers in the company.

select CustomerID, count(*) as NumberOfTransactions, 
sum(QuantityPurchased * Price) as TotalSpent
from sales_transaction
group by CustomerID
having count(*) > 10 
and sum(QuantityPurchased * Price) > 1000
order by TotalSpent desc;


-- 13. Write a SQL query that describes the number of transaction along with the 
-- total amount spent by each customer, which will help us understand 
-- the customers who are occasional customers or have low purchase frequency in the company.

select CustomerID,
count(*) as NumberOfTransactions,
sum(QuantityPurchased * Price) as TotalSpent
from sales_transaction
group by CustomerID
having count(*) <= 2
order by NumberOfTransactions,
TotalSpent desc;

-- 14. Write a SQL query that describes the total number of purchases made by each customer 
-- against each productID to understand the repeat customers in the company.

select CustomerID,ProductID,
count(*) as TimesPurchased
from sales_transaction
group by CustomerID,ProductID
having count(*) > 1
order by TimesPurchased desc;	


-- 14.Write a SQL query that describes the duration between the first and the last purchase of the customer 
-- in that particular company to understand the loyalty of the customer.

select CustomerID,
date_format(min(str_to_date(TransactionDate,"%Y-%m-%d")),"%Y-%m-%d") as FirstPurchase,
date_format(Max(str_to_date(TransactionDate,"%Y-%m-%d")),"%Y-%m-%d") as LastPurchase,
datediff(Max(str_to_date(TransactionDate,"%Y-%m-%d")),min(str_to_date(TransactionDate,"%Y-%m-%d"))) DaysBetweenPurchases
from sales_transaction
group by CustomerID
having datediff(Max(str_to_date(TransactionDate,"%Y-%m-%d")),min(str_to_date(TransactionDate,"%Y-%m-%d"))) > 0
order by DaysBetweenPurchases desc;


-- 15.Write an SQL query that segments customers based on the total quantity 
-- of products they have purchased. Also, count the number of customers in each 
-- segment which will help us target a particular segment for marketing.


with cte as (
select CustomerID,
case when sum(QuantityPurchased) between 1 and 10 then 'Low'
	when sum(QuantityPurchased) between 11 and 30 then 'Med'
    else 'High' end as CustomerSegment
from sales_transaction
group by CustomerID)

select CustomerSegment,
count(*) customer_count
from cte
group by CustomerSegment;







































