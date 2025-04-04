--1. Database setup and loading data
Create database portfolio_project;


--Create a Table Retail Sales Analysis
...
Drop table if exists Retail_Sales;
Create table Retail_Sales(

	transactions_id	int Primary Key,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender varchar(6),
	age	int,
	category varchar(15),	
	quantiy	int,
	price_per_unit	float,
	cogs float,
	total_sale float
);
...
--Imported data from a csv file

ALTER TABLE Retail_Sales
ALTER COLUMN quantiy int NULL;

--Visualize Retail Sales Data in table
Delete from Retail_Sales where quantiy='' ;


--2. Data explorations and clean ups
Select count(*) from Retail_Sales; --record count is matching with excel

Select count(distinct customer_id) as no_of_customers
from Retail_Sales;

Select distinct category 
From Retail_Sales;


--Data analyst

--1.Write a query to retrieve all columns for sales made on '2022-11-05'
		
		Select * 
		from Retail_Sales 
		where sale_date='2022-11-05';

--2.Write a query to retrieve all transactions where category is 'clothing' and the quantity sold is more than 3 in the month of Nov 2022
		
		Select *
		From Retail_Sales 
		where (month(sale_date)='11' and year(sale_date)='2022') and
		(lower(category)='clothing' and quantiy>3);
		

		--to_char(sale_date,'YYYY-MM')='2022-11'
	
--3.Write a query to calculate total sales and total_orders for each category
		
		Select category, sum(total_sale) as total_sales,
		count(*) as total_orders
		From Retail_Sales 
		group by category;
		
		--if total_sale column is not present in table
	
	    Select category,Sum(quantiy*price_per_unit) as total_sales
		From Retail_Sales  group by category;

		
--4.Write a query to find the avg age of customers who purchased items from the beauty category
		
		Select avg(age)  as average_age
		from Retail_Sales
		where lower(category)='beauty';
		
--5.Write a query to find all  transactions where the total sales is greater than 1000
		
		Select *
		From Retail_Sales where total_sale>1000;
		

--6.Write a query to find the total number of transactions(transaction_id) made by each gender in each category
		
		Select category,gender ,count(transactions_id) as no_of_transactions
		from Retail_Sales
		group by category,gender
		order by category;
		
--7.Write a query to calculate the avg sale for each month. Find out best selling month in each year
		
		Select sale_year,sale_month, avg_sales from
		(Select Year(sale_date) as sale_year, month(sale_date) as sale_month,
		avg(total_sale) as avg_sales,
		DENSE_RANK() over (partition by Year(sale_date) order by avg(total_sale) desc) as dn_rnk
		from Retail_Sales
		group by  Year(sale_date),month(sale_date)
		) as a where dn_rnk=1;

--8.Write a query to find the top 5 customers based on the highest total sales
			
		Select * from (
		Select customer_id,
		dense_rank() over (order by sum(total_sale) desc) as dn_rnk
		from Retail_Sales
		group by customer_id) as a where dn_rnk <=5;

--9.Write a query to find the number of unique customers  from each category

		select category, count(distinct customer_id) as  n_of_unq_cust
		from Retail_Sales
		group by category;
	
--10.Write a query to create each shift and number of orders( example morning<=12 afternoon between 12 and 17 and evening >17)

		Select Shifts, count(*) as No_of_orders from 
		(Select case when sale_time <='11:59:00' then 'Morning' 
		when sale_time Between '12:00:00' and '17:00:00' then 'Afternoon'
		else 'Evening' end as Shifts
		from Retail_Sales) 
		as a group by Shifts;
			
--OR Hours(sale_time)<12 
	
		--or
		With Cte_Shifts_details as(
		Select *,case when sale_time <='11:59:00' then 'Morning' 
		when sale_time Between '12:00:00' and '17:00:00' then 'Afternoon'
		else 'Evening' end as Shifts
		from Retail_Sales)

		Select Shifts, Count(*) as no_of_orders
		From Cte_Shifts_details
		group by Shifts;


--Queries written by me to analyze retail sales data

--11. Write a query to find Customer who purchased all 3 caategory

	   select customer_id, count(distinct category) as n_of_unq_cat
	   from Retail_Sales
	   group by customer_id
	   having count(distinct category)= (Select count(distinct category) from Retail_Sales);

--12. Sales team wants to know if male or female who are purchasing more beauty products
	
	   Select top 1 gender,count(*) as total_purchase
	   from Retail_Sales
	   where category='beauty'
	   group by gender 
	   order by total_purchase desc;

--13. Sales team wants to know category wise total sales with ranking them with highest sales on top
	
	   Select * from(Select
	   category, sum(total_sale) as total_sales,
	   dense_rank() over (order by sum(total_sale) desc ) rank_sales
	   From Retail_Sales
	   group by category) as a
	   order by rank_sales asc;


--14. Sales team wants to know the customer who has purchased more(if tie exist list all)
	
	  Select customer_id, total_sales from
	  (Select Customer_id, sum(total_sales) as total_sales,
	  Dense_rank() over (order by sum(total_sales) desc) as dn_rnk
	  from Retail_Sales
	  group by customer_id) 
	  as cust_details where dn_rnk=1;

--15. Sales team wants to know the customer who is inactive(if sale_date is greater than 30 days from current_date).
--Since we have less data considering 5 days window with past current data
	
	  Select customer_id,last_purchase_date, datediff(Day,last_purchase_date,'2024-01-2') as inactive_since_as_days 
	  from
	  (Select customer_id, max(sale_date) as last_purchase_date
	  From Retail_Sales
	  Group by customer_id
	  ) as a 
	  where datediff(Day,last_purchase_date,'2024-01-2')>30;

--16. Sales team wants to know the male and female customer present in dataset(unique)
	
	  Select gender, count(distinct customer_id) as no_of_customer
	  from Retail_Sales
	  group by gender;

--17.Sales team ran a sell for Aug 2022, and wants to know total sale for that period. 

		SELECT  
        CONCAT(MONTH(sale_date), '-', YEAR(sale_date)) AS sale_month_yr,
        SUM(total_sale) AS sale_amt_in_sales
		FROM Retail_Sales
		WHERE YEAR(sale_date) = 2022 AND MONTH(sale_date) = 10
		GROUP BY CONCAT(MONTH(sale_date), '-', YEAR(sale_date));
   
	
--18. sales teams wants to know profit/loss happens for each category and every month each year
-- total_sales-cogs if - then loss /if not - then profit
    
		Select Category,mth_yr, sum(profit_loss_amt) as total_loss_profit
		from
		(Select category,total_sale,cogs, CONCAT(MONTH(sale_date), '-', YEAR(sale_date)) as mth_yr ,
	    (total_sale-cogs) as 'profit_loss_amt' 
		from Retail_Sales 
		) as a
		group by Category,mth_yr
		order by mth_yr asc;
