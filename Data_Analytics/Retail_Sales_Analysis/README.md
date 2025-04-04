# Retail Sales Analysis SQL Project
## Project Overview

**Project Title**: `Retail Sales Analysis`  
**Level**: Beginner  
**Database**:`portfolio_project`


This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a portfolio_project database, creating table and importing data from the CSV file, performing  data analysis, and answering specific business questions through SQL queries.

## **Project Structure:**  
## 1. Database Setup  
- **Database Creation:** Creating a database named `portfolio_project`  
- **Table Creation:** Creating a table named `Retail_Sales` which will store sales data. Table structure include transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
Create database portfolio_project;

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
```

## 2.Data Exploration and Cleaning  
- **Record Count**: Find the total number of records in the dataset.  
- **Unique Customer Count**: Find number of unique customer present in the dataset.  
- **Category Count**: Identify all unique category present in the dataset.  
- **Null value check**: Check for any null values in the dataset and replace them with 'Not Available'

```sql
Select count(*) from Retail_Sale;  

Select count(distinct customer_id) as no_of_customers
from Retail_Sales;

Select distinct category 
From Retail_Sales;

Select coalesce(cogs,'Not Available') as cogs
From Retail_Sales;
```

## 3. Data Analysis  
Below SQL queries were developed to answer specific business questions.  

### 1. Write a query to retrieve all columns for sales made on '2022-11-05'
```sql
Select * 
from Retail_Sales 
where sale_date='2022-11-05';
```

### 2.Write a query to retrieve all transactions where category is 'clothing' and the quantity sold is more than 3 in the month of Nov 2022
```sql
Select *
From Retail_Sales 
where (month(sale_date)='11' and
year(sale_date)='2022') and
(lower(category)='clothing' and quantiy>3);
```

### 3.Write a query to calculate total sales and total_orders for each category
```sql
Select category, sum(total_sale) as total_sales,
count(*) as total_orders
From Retail_Sales 
group by category;
```

### 4.Write a query to find the avg age of customers who purchased items from the beauty category
```sql
Select avg(age)  as average_age
from Retail_Sales
where lower(category)='beauty';
```
```sql

```

### 5.Write a query to find all  transactions where the total sales is greater than 1000
```sql
Select *
from Retail_Sales where total_sale>1000;
```

### 6.Write a query to find the total number of transactions(transaction_id) made by each gender in each category
```sql
Select category,gender ,count(transactions_id) as no_of_transactions
from Retail_Sales
group by category,gender
order by category;
```

#### 7.Write a query to calculate the avg sale for each month. Find out best selling month in each year
```sql
Select sale_year,sale_month, avg_sales from
(Select Year(sale_date) as sale_year, month(sale_date) as sale_month,
avg(total_sale) as avg_sales,
DENSE_RANK() over (partition by Year(sale_date) order by avg(total_sale) desc) as dn_rnk
from Retail_Sales
group by  Year(sale_date),month(sale_date)
) as a where dn_rnk=1;
```

