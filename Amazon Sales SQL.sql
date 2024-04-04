-- Data Wrangling 
-- 1. Building Database

CREATE DATABASE Amazon_database;
USE Amazon_database;

-- 2. Table creation and data insertion having no Null values

CREATE TABLE Amazon (
Invoice_Id varchar(30) NOT NULL,
Branch varchar(5) NOT NULL,
City varchar(30) NOT NULL,
Customer_type varchar(30) NOT NULL,
Gender varchar(10) NOT NULL,
Product_line varchar(100) NOT NULL,
Unit_price decimal(10,2) NOT NULL,
Quantity int NOT NULL,
VAT float NOT NULL,
Total decimal(10,2) NOT NULL,
Date date NOT NULL,
Time time NOT NULL,
Payment varchar(50) NOT NULL,
cogs decimal(10,2) NOT NULL,
gross_margin_percentage float NOT NULL,
gross_income decimal(10,2) NOT NULL,
Rating float NOT NULL
);

SELECT *
FROM amazon;



-- Feature Engineering
-- 1. Adding new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 

ALTER TABLE amazon                                 # ALTER is part of DDL
ADD COLUMN time_of_day varchar(50);                # New column created name 'time_of_day' 

UPDATE amazon                                      # UPDATE is part of DML
SET time_of_day = CASE                             # Updating column 'time_of_day'
		WHEN HOUR(amazon.Time) >= 0 AND HOUR(amazon.Time) < 12 THEN 'Morning'
		WHEN HOUR(amazon.Time) >= 12 AND HOUR(amazon.Time) < 18 THEN 'Afternoon'
		ELSE 'Evening'
End;

-- 2.  Adding new column named dayname that contains the extracted days of the week on which the given transaction took place.

ALTER TABLE amazon 
ADD COLUMN day_name varchar(50);                   -- New column created named 'day_name'

UPDATE amazon 
SET day_name = DATE_FORMAT(amazon.Date, '%a');     # Column 'day_name' updated with DATE_FORMAT Method of MySQL to get weekday name

-- 3. Add a new column named monthname that contains the extracted months of the year on which the given transaction took place.

ALTER TABLE amazon 
ADD COLUMN month_name varchar(50);               # New column created 'month_name'

UPDATE amazon 
SET month_name = DATE_FORMAT(amazon.Date, '%b'); # Column 'month_name' updated to get first three letters of Months



-- Exploratory Data Analysis (EDA)  (Refer Jupiter Notebook)




-- Business Questions:-

-- 1. What is the count of distinct cities in the dataset?

SELECT COUNT(DISTINCT City) AS City_count       # Distinct to get unique values, Count to get count of values
FROM amazon;

-- Only 3 Distinct cities are present in the dataset.

 
 
-- 2. For each branch, what is the corresponding city?

SELECT DISTINCT Branch, City                  # Distinct to get the unique branch and city
FROM amazon;

-- In the dataset, there are 3 unique branches corresponging to 3 unique cities.



-- 3. What is the count of distinct product lines in the dataset?

SELECT COUNT(DISTINCT Product_line) AS Product_line_count
FROM amazon;

-- In the dataset, there are 6 unique Product lines.



-- 4. Which payment method occurs most frequently?

SELECT MAX(Payment) AS Payment_count              # Max method used to get maximum number of payment types used
FROM amazon;

-- There are 3 unique payment types, in which most frequent is 'Ewallet'.



-- 5. Which product line has the highest sales?

SELECT Product_line, SUM(gross_income) AS High_sales # Sum method to get the sum of all the sales
FROM amazon 
GROUP BY Product_line
ORDER BY High_sales DESC;

-- Above code gives us the highest sale of each distinct product line, in which Food and Beverages consist the 
-- highest cumulative sales.




-- 6. How much revenue is generated each month?

SELECT month_name, SUM(Total) AS monthly_revenue
FROM amazon 
GROUP BY month_name                              
ORDER BY monthly_revenue DESC;

-- Above code displays the cumulative revenue of each month and January received the highest revenue of all three months.



-- 7. In which month did the cost of goods sold reach its peak?

SELECT month_name, MAX(cogs) AS max_cogs
FROM amazon 
GROUP BY month_name
ORDER BY max_cogs DESC;


-- Cost of purchasing and manufacturing the goods reached its peak in the month February, but if we talk about the 
-- cumulative cogs of all the months then its January followed by March.




-- 8. Which product line generated the highest revenue?

SELECT Product_line, SUM(Total) AS high_revenue
FROM amazon 
GROUP BY Product_line
ORDER BY high_revenue DESC
LIMIT 1;

-- Out of 6 unique product line, Food and beverages received the highest revenue in total




-- 9. In which city was the highest revenue recorded?

SELECT  City, SUM(Total) AS high_revenue
FROM amazon 
GROUP BY City
ORDER BY high_revenue DESC;

-- Out of 3 unique cities in the dataset, Naypyitaw or the branch 'C' received the collected the 
-- highest revenue.



-- 10. Which product line incurred the highest Value Added Tax?

SELECT Product_line, SUM(VAT) AS high_vat
FROM amazon 
GROUP BY Product_line
ORDER BY high_vat DESC;

-- As most revenue comes from the Food and beverage product line, means most food and beverage products have 
-- been sold and if there are more quantities of f&b product, and apply 5% of VAT (Value Added Tax), it will
-- give us more VAT value.




-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

SELECT Product_line,
CASE                                                        
    WHEN gross_income > (SELECT AVG(gross_income) FROM amazon) THEN "Good"   
    ELSE "Bad"
END AS sales_performance
FROM amazon;

-- Case statement is used to add a new column named 'sales_performance', in which if a product line receives below average sales then
-- it indicates 'BAD' sales else 'GOOD' sales. Through this we got to know that there are more number of "Bad" sales 
-- as compare to "Good" sales. Means more number of product lines are performing below average sales. 





-- 12. Identify the branch that exceeded the average number of products sold.

SELECT DISTINCT Branch
FROM amazon 
WHERE Quantity > (
SELECT AVG(Quantity)
FROM amazon);

-- All three branches have exceeded the avg number of product sold i.e 5.51



-- 13. Which product line is most frequently associated with each gender?

WITH ranked_product_lines AS (
SELECT Gender, Product_line, COUNT(*) AS product_line_count,
RANK() OVER (PARTITION BY Gender ORDER BY COUNT(*) DESC) AS rank_num
FROM amazon 
GROUP BY Gender, Product_line
)
SELECT Gender, Product_line, product_line_count
FROM ranked_product_lines
WHERE rank_num = 1;

-- CTE used with Windows Rank funcion to get the most frequent product line associated with each gender.




-- 14. Calculate the average rating for each product line.

SELECT Product_line, AVG(Rating) AS avg_rating
FROM amazon 
GROUP BY Product_line;

-- Average method to get avg rating for each product lines in the dataset. From this we can say that
-- Food and beverages get the highest avg rating followed by Fashion accessories and Health and beauty. 



-- 15. Count the sales occurrences for each time of day on every weekday.

SELECT  day_name, time_of_day, COUNT(*) AS sale_occur
FROM amazon
GROUP BY  day_name, time_of_day
ORDER BY day_name, sale_occur DESC;

-- Count method used to get the count of sale occur on a particular weekday and on particular time of that weekday. 
-- We can say that on every weekday most sale occur during the Afternoon time (between 12 to 6 PM)




-- 16. Identify the customer type contributing the highest revenue.

SELECT Customer_type, SUM(Total) AS high_revenue
FROM amazon 
GROUP BY Customer_type
ORDER BY high_revenue DESC;

-- Out of two Customer type, Member customers contribute highest in the revenue. 




-- 17. Determine the city with the highest VAT percentage.

SELECT City, SUM(VAT) AS high_vat, SUM(Total) AS total_rev, (SUM(VAT)/SUM(Total))*100 AS vat_percent
FROM amazon
GROUP BY City
ORDER BY vat_percent DESC;

-- To get the vat percentage, we have divided the total vat with the total revenue, which is around 5% and have very 
-- negligible difference in the vat percent with respect to particular City. 



-- 18. Identify the customer type with the highest VAT payments.

SELECT Customer_type, SUM(VAT) AS high_vat 
FROM amazon
GROUP BY Customer_type
ORDER BY high_vat DESC;

-- Above we saw that Member customers contribute maximum to the revenue and so its obvious that 
-- they pay more VAT also compared to Normal customers. 




-- 19. What is the count of distinct customer types in the dataset?

SELECT COUNT(DISTINCT Customer_type) AS customer_type_count
FROM amazon;

-- There are two types of types customers in the dataset- Member and Normal customers. 




-- 20. What is the count of distinct payment methods in the dataset?

SELECT COUNT(DISTINCT Payment) AS payment_method_count
FROM amazon;

-- There are 3 distinct types of payment methods - Ewallet, Cash and Credit Card. 



-- 21. Which customer type occurs most frequently?

SELECT Customer_type, COUNT(*) AS most_freq
FROM amazon 
GROUP BY Customer_type;

-- Members type customers occurs to purchase more frequently.



-- 22. Identify the customer type with the highest purchase frequency.

SELECT Customer_type, SUM(Quantity) AS high_pur_freq
FROM amazon
GROUP BY Customer_type
ORDER BY high_pur_freq DESC
LIMIT 1;

-- Member type of customers purchase goods more frequently. 



-- 23. Determine the predominant gender among customers.

SELECT Gender, COUNT(*) customer_count
FROM amazon
GROUP BY Gender
ORDER BY customer_count DESC
LIMIT 1;

-- Although there is not much difference in gender contribution but yes 'Female' contributes more than 'Males'. 



-- 24. Examine the distribution of genders within each branch.

SELECT Branch, Gender, COUNT(Gender) AS gender_dist
FROM amazon
GROUP BY Branch, Gender
ORDER BY Branch, gender_dist DESC;

-- Branch wise contribution of gender says that in Branch A and B 'Males' are prominent but in Branch C 'Females'
-- contributes more. 




-- 25. Identify the time of day when customers provide the most ratings.

SELECT time_of_day, COUNT(Rating) AS rating_count
FROM amazon
GROUP BY time_of_day
ORDER BY rating_count DESC;

-- Most number of rating are provided during Afternoon. 



-- 26. Determine the time of day with the highest customer ratings for each branch.

SELECT Branch, time_of_day, COUNT(Rating) AS rating_count
FROM amazon
GROUP BY Branch, time_of_day
ORDER BY Branch;

-- For all the three branches Afternoon is the time when they get their most number of ratings. 



-- 27. Identify the day of the week with the highest average ratings.

SELECT day_name, AVG(Rating) AS avg_rating
FROM amazon
GROUP BY day_name
ORDER BY avg_rating DESC
LIMIT 1;

-- In all the Weekdays, Monday is the day when highest avg ratings received. 



-- 28. Determine the day of the week with the highest average ratings for each branch.

WITH branch_high_rating AS 
(SELECT Branch, day_name, AVG(Rating) AS avg_rating,
RANK() OVER(PARTITION BY Branch ORDER BY AVG(Rating) Desc) AS rank_num
FROM amazon
GROUP BY Branch, day_name)
SELECT Branch, day_name, avg_rating
FROM branch_high_rating
WHERE rank_num = 1;

-- To get the average rating for each branch with the weekday name, CTE is used with Windows Rank function. 
-- From above code we can say that, For branch B, Monday is the day which gets higest avg rating and for 
-- branch A and C its Friday. 


-- CONCLUSION:-

-- For Product Analysis:

# 1. The dataset consists of 6 unique product lines, with 'Food and Beverages' generating the highest cumulative sales.
# 2. 'Food and Beverages' also receives the highest revenue in total, suggesting a high demand for food-related products.
# 3. It can be inferred that focusing on food and beverage products could potentially lead to higher sales and revenue.



-- For Sales Analysis:

# 1. 'Naypyitaw' (Branch C) generates the highest revenue among the three cities, indicating a significant market presence 
--     or higher purchasing power in that location.
# 2. 'Ewallet' is the most frequent payment method, suggesting a preference for digital transactions among customers.
--    Can form policies which give incentives for customers using Ewallets(like coupons).
# 3. 'Member' customers contribute the most to revenue, indicating the importance of loyalty programs or incentives to 
--     retain customers.



-- For Customer Analysis:


# 1. Despite a relatively balanced gender distribution, females contribute slightly more to revenue than males, 
--    implying potential opportunities for targeted marketing or product offerings.
# 2. Branch-wise analysis reveals variations in gender contribution, with males being more prominent in Branches A and B, 
--    while females contribute more in Branch C. This insight could inform branch-specific marketing strategies.
# 3. Afternoon is the time when most ratings are provided across all branches, suggesting that customers are actively 
--    engaging with the products or services during this time period.


 











