Amazon Sales dataset explored to get insight from it.<br>
This dataset contains sales transactions from three different branches of Amazon, respectively located in Mandalay, Yangon and Naypyitaw. <br>


Approach Used<br>

Data Wrangling: This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace missing or NULL values.<br>


1.1          Build a database<br>

1.2          Create a table and insert the data.<br>

1.3          Select columns with null values in them. There are no null values in our database as in creating the tables, we set NOT  NULL for each field, hence null values are filtered out.<br>


Feature Engineering: This will help us generate some new columns from existing ones.<br>


2.1           Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.<br>

2.2          Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.<br>

2.3        Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.<br>


             3. Exploratory Data Analysis (EDA): Exploratory data analysis is done to answer the listed questions and aims of this project.<br>
