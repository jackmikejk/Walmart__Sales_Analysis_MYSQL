-- Feature Engineering
-- adding --columns
-- time_of_day

SELECT Ttime, 
			(CASE
			WHEN Ttime BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
            WHEN Ttime BETWEEN "12:01:00" AND "16:00:00" THEN "NOON"
            ELSE "EVENING"
            END) AS time_of_day
FROM salestable;
        
-- Adding a new column 'time_of_day' to the 'salestable'    
ALTER TABLE salestable ADD COLUMN time_of_day varchar(20);
-- update the values of "Morning", "Noon", "Evening" in the created column
UPDATE salestable
SET time_of_day = 
			(CASE
            WHEN Ttime BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
            WHEN Ttime BETWEEN "12:01:00" AND "16:00:00" THEN "NOON"
            ELSE "EVENING"
            END); 

-- creating 'day_name' column
SELECT ddate,
		DAYNAME(ddate)
FROM salestable;
ALTER TABLE salestable ADD COLUMN day_name VARCHAR(20);  
-- update the values      
UPDATE salestable
SET day_name = DAYNAME(ddate);
        
-- creating 'month_of_the_year' column
SELECT ddate,
	MONTHNAME(ddate)
FROM salestable;

ALTER TABLE salestable ADD COLUMN month_of_the_year VARCHAR(10);

UPDATE salestable
SET month_of_the_year = MONTHNAME(ddate); 	

SELECT * 
FROM salestable;

-- ------------------------------------------------------------------ Exploratory Data Analyis------------------------------------------------------------------
-- ------------------------------------------------------------------Generic Quries------------------------------------------------------------------

-- ------------------------------------------------------------------How many unique cities does the data have?

SELECT DISTINCT city 
FROM salestable;

-- ------------------------------------------------------------------In which city is each branch?

SELECT DISTINCT city, branch 
FROM salestable;

-- ------------------------------------------------------------------Prodcut Analysis------------------------------------------------------------------
-- ------------------------------------------------------------------How many unique product lines does the data have?
SELECT DISTINCT product_line 
FROM salestable;

-- ------------------------------------------------------------------What is the most common payment method?
SELECT payment, COUNT(payment) AS payment_count 
FROM salestable 
GROUP BY payment 
ORDER BY payment_count desc;

-- ------------------------------------------------------------------What is the most selling product line?
SELECT product_line, SUM(quantity) AS qty 
FROM salestable 
GROUP BY product_line 
ORDER BY qty desc;

-- ------------------------------------------------------------------What is the most profitable selling product line? ********(I created this question for myself)********
SELECT product_line, SUM(quantity), SUM(total) as tot 
FROM salestable 
GROUP BY product_line 
ORDER BY tot DESC;

-- ------------------------------------------------------------------What is the total revenue by month
SELECT month_of_the_year AS month, SUM(total) AS total_revenue 
FROM salestable 
GROUP BY month 
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------------What month had the largest COGS?
SELECT month_of_the_year AS month, SUM(cogs) AS largest_cogs 
FROM salestable 
GROUP BY month 
ORDER BY largest_cogs DESC;

-- ------------------------------------------------------------------What is the city with the largest revenue?
SELECT city,branch, SUM(total) AS laregst_revenue 
FROM salestable 
GROUP BY city, branch 
ORDER BY laregst_revenue DESC;

-- ------------------------------------------------------------------What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as tax 
FROM salestable 
GROUP BY product_line 
ORDER BY tax DESC;

-- ------------------------------------------------------------------Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.3 THEN "Good"
        ELSE "Bad"
		END AS remark
FROM salestable
GROUP BY product_line;

-- ------------------------------------------------------------------Which branch sold more products than average product sold?
SELECT branch, 
	   SUM(quantity) as tot_qty
FROM salestable
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM salestable);

-- ------------------------------------------------------------------What is the average rating of each product line?
SELECT product_line,
	   AVG(rating) AS avg_rating
FROM salestable
GROUP BY product_line
ORDER BY avg_rating DESC;    

-- ------------------------------------------------------------------What is the most common product line by gender
SELECT
	product_line,
    gender,
    SUM(quantity) as total_qty
FROM salestable
GROUP BY product_line, gender
ORDER BY total_qty ; 
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------

