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

