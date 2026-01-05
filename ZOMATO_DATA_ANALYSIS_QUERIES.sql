USE l8;

-- User Table 
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    age INT,
    gender VARCHAR(10),
    marital_status VARCHAR(20),
    occupation VARCHAR(50),
    monthly_income VARCHAR(30),
    education VARCHAR(50),
    family_size INT
);

-- restaurant Table 
CREATE TABLE restaurants (
    id INT PRIMARY KEY,
    name VARCHAR(150),
    city VARCHAR(100),
    rating VARCHAR(10),     
    rating_count VARCHAR(20),
    cost INT,
    cuisine VARCHAR(100),
    address VARCHAR(255)
);

-- food Table 
CREATE TABLE food (
    f_id INT PRIMARY KEY,
    item VARCHAR(150),
    veg_or_non_veg VARCHAR(20)
);

--  menu Table 
CREATE TABLE menu (
    menu_id INT PRIMARY KEY,
    r_id INT,
    f_id INT,
    cuisine VARCHAR(100),
    price DECIMAL(8,2)
);

--  orders Table  
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    sales_qty INT,
    sales_amount INT,
    currency VARCHAR(10),
    user_id INT,
    r_id INT
);

-- Adding Foreign Keys to orders 
ALTER TABLE orders
ADD CONSTRAINT fk_orders_user
FOREIGN KEY (user_id)
REFERENCES users(user_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_restaurant
FOREIGN KEY (r_id)
REFERENCES restaurants(id);


-- Adding Foreign Keys to menu 
ALTER TABLE menu
ADD CONSTRAINT fk_menu_restaurant
FOREIGN KEY (r_id)
REFERENCES restaurants(id);

ALTER TABLE menu
ADD CONSTRAINT fk_menu_food
FOREIGN KEY (f_id)
REFERENCES food(f_id);


-- SELECT Query for all table 
SELECT * FROM food;

SELECT * FROM menu;

SELECT * FROM orders;

SELECT * FROM restaurants;

SELECT * FROM users;

-- Q1 Total number of users,restaurants,order
 
SELECT COUNT(user_id) as no_of_user FROM users;
SELECT COUNT(id) as no_of_restaurants FROM restaurants;
SELECT COUNT(order_id) as no_of_orders FROM orders;

-- Q2 Total Sales and quantity sold
SELECT SUM(sales_qty) as total_sales_quantity ,
		SUM(sales_amount) as total_sales 
FROM orders;

-- Q3 no of Restaurants per city
SELECT city,count(*) AS no_of_restaurants 
FROM restaurants 
GROUP BY city 
ORDER BY no_of_restaurants DESC LIMIT 10;

-- Q4 Veg vs Non-Veg food items
SELECT veg_or_non_veg,COUNT(*) as total_food_item 
FROM food 
GROUP BY veg_or_non_veg;

-- Q5 no of restaurants that have rating > 4.5 
SELECT COUNT(*) as no_of_restaurants 
FROM restaurants 
WHERE rating >= 4.5;


SELECT name,rating
FROM restaurants 
ORDER BY rating DESC;

-- Q6 Display the user that have ordered 5 time or more than that
SELECT u.user_id,u.name,COUNT(o.order_id) as total_no_of_order 
FROM users u 
LEFT JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id,u.name 
HAVING total_no_of_order>= 5 
ORDER BY total_no_of_order DESC;

-- Q7 Top 10 restaurant that have highest sales
SELECT r.name,SUM(o.sales_amount) as total_sales 
FROM restaurants r 
JOIN orders o ON o.r_id = r.id 
GROUP BY r.name 
ORDER BY total_sales DESC LIMIT 10;

-- Q8 AVERAGE menu price per restaurant
SELECT r.name,AVG(m.price) as Average_price 
FROM restaurants r 
JOIN menu m ON m.r_id = r.id 
GROUP BY r.name 
ORDER BY Average_price DESC;

-- Q9 Top 10 city by Total no of Orders
SELECT r.city,COUNT(*) as no_of_order 
FROM restaurants r 
JOIN Orders o ON r.id = o.r_id 
GROUP BY r.city 
ORDER BY no_of_order DESC LIMIT 10;

-- Q10 Total Order per city wise and name wise

SELECT r.name,r.city,COUNT(*) as no_of_order 
FROM restaurants r 
JOIN Orders o ON r.id = o.r_id 
GROUP BY r.city,r.name 
ORDER BY no_of_order DESC LIMIT 10;

-- Q11 most popular cuisine based on number of menu items.
SELECT cuisine,COUNT(*) as no_of_item 
FROM menu 
GROUP BY cuisine 
ORDER BY no_of_item DESC LIMIT 10; 

-- Q12 average rating of restaurants city-wise
SELECT city, ROUND(AVG(CAST(rating AS DECIMAL(2,1))),2) AS avg_rating 
FROM restaurants 
WHERE rating LIKE '%.%' OR rating LIKE '%[0-5]%' 
GROUP BY city 
ORDER BY avg_rating DESC; 


-- Q13 Show restaurants that have never received any order.
SELECT r.name 
FROM restaurants r 
LEFT JOIN orders o ON o.r_id = r.id 
WHERE o.order_id IS NULL;

-- Q14 Month wise total sales
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
	SUM(sales_amount) AS total_sales
FROM orders
GROUP BY month
ORDER BY month;

-- Q15 Identify the top 5 highest spending users
SELECT u.user_id,u.name,SUM(o.sales_amount) as total_spend
FROM users u
JOIN Orders o ON o.user_id = u.user_id 
GROUP BY u.user_id,u.name
ORDER BY total_spend DESC LIMIT 5;

-- Q16 Average order per restaurant
SELECT r.name ,AVG(o.sales_amount) as Average_order_value
FROM restaurants r
JOIN Orders o ON o.r_id = r.id
GROUP BY r.name
ORDER BY Average_order_value DESC;

-- Q17 top 10 ordered food item
SELECT f.item ,COUNT(*) as Most_order_item
FROM food f 
JOIN menu m ON m.f_id = f.f_id
JOIN orders o ON m.r_id = o.r_id
GROUP BY f.item
ORDER BY Most_order_item DESC LIMIT 10;

-- Q18 Top 10 cuisine By Revenue generated
SELECT r.cuisine,SUM(o.sales_amount) as total_sales
FROM restaurants r 
JOIN orders o ON r.id = o.r_id
GROUP BY r.cuisine
ORDER BY total_sales DESC LIMIT 10;

-- Q19 users who ordered from more than one city
SELECT u.name 
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN restaurants r ON o.r_id = r.id
GROUP BY u.name
HAVING COUNT(DISTINCT(r.city)) > 1;

-- Q20 restaurants with high rating but low sales
SELECT r.name, r.rating, SUM(o.sales_amount) AS total_sales
FROM restaurants r
LEFT JOIN orders o ON r.id = o.r_id
WHERE r.rating REGEXP '^[4-5]'
GROUP BY r.name, r.rating
HAVING total_sales < 5000
ORDER BY r.rating DESC , total_sales ASC;

-- Q21 Peak ordering Year
SELECT EXTRACT(Year FROM order_date)AS Year,
		SUM(sales_amount) AS Total_sales
FROM orders
GROUP BY Year
ORDER BY Total_sales DESC;

-- Q22 TOP 10 City witch highest Total sales
SELECT r.city,SUM(o.sales_amount) AS total_sales
FROM restaurants r 
JOIN orders o ON r.id = o.r_id
GROUP BY r.city
ORDER BY total_sales DESC LIMIT 10; 

-- Q23 Rank restaurants city-wise by sales
SELECT r.name,r.city , SUM(o.sales_amount) as Total_sales,
RANK() OVER(PARTITION BY r.city ORDER BY SUM(o.sales_amount) DESC ) AS rank_in_city
FROM restaurants r 
JOIN orders o ON r.id = o.r_id
GROUP BY r.city,r.name;

-- Q24 city contributes the highest revenue
SELECT r.city,SUM(o.sales_amount) AS total_sales
FROM restaurants r 
JOIN orders o ON r.id = o.r_id
GROUP BY r.city
ORDER BY total_sales DESC LIMIT 1;  

-- Q25 which cuisine performs best in each city
SELECT r.city,r.cuisine,SUM(o.sales_amount) as total_sales
FROM restaurants r 
JOIN orders o ON r.id = o.r_id
GROUP BY r.cuisine,r.city
ORDER BY total_sales DESC; 

-- Q26 which user age group spends the most
SELECT 
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25'
        WHEN age BETWEEN 26 AND 35 THEN '26–35'
        WHEN age BETWEEN 36 AND 45 THEN '36–45'
        WHEN age BETWEEN 46 AND 60 THEN '46–60'
        ELSE '60+'
    END AS age_group,
    SUM(o.sales_amount) AS total_sales
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY age_group
ORDER BY total_sales DESC;


-- Q27 Veg vs Non-Veg food sales performance 
SELECT f.veg_or_non_veg, SUM(o.sales_amount) AS total_sales
FROM food f
JOIN menu m ON f.f_id = m.f_id
JOIN orders o ON m.r_id = o.r_id
GROUP BY f.veg_or_non_veg;

-- Q28 top restaurant per city by revenue 
SELECT city, name, total_sales
FROM (
		SELECT r.name,r.city , SUM(o.sales_amount) as Total_sales,
		RANK() OVER(PARTITION BY r.city ORDER BY SUM(o.sales_amount) DESC ) AS rank_in_city
		FROM restaurants r 
		JOIN orders o ON r.id = o.r_id
		GROUP BY r.city,r.name
) AS t
WHERE rank_in_city = 1;


-- Q29 customer lifetime value (CLV)
SELECT u.name, SUM(o.sales_amount) AS CLV
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name
ORDER BY CLV DESC LIMIT 10;

-- Q30 restaurants whose average order value is above city average
SELECT r.name
FROM restaurants r
JOIN orders o ON r.id = o.r_id
GROUP BY r.name, r.city
HAVING AVG(o.sales_amount) >
						    (SELECT AVG(o2.sales_amount)
							FROM orders o2
							JOIN restaurants r2 ON o2.r_id = r2.id
							WHERE r2.city = r.city);

-- Q31 Inactive user
SELECT u.name
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;

-- Q32 Total order placed in each year
SELECT YEAR(order_date) AS year, COUNT(*) AS total_orders
FROM orders
GROUP BY year;

-- Q33 Restaurants with highest number of customers
SELECT r.name, COUNT(DISTINCT o.user_id) AS customers
FROM orders o
JOIN restaurants r ON o.r_id = r.id
GROUP BY r.name
ORDER BY customers DESC;
 
-- Q34 top 5 city who contribution to total revenue in Percentage
SELECT r.city,
       SUM(o.sales_amount) AS city_sales,
       ROUND(SUM(o.sales_amount) * 100 / 
            (SELECT SUM(sales_amount) FROM orders), 2) AS contribution_percent
FROM orders o
JOIN restaurants r ON o.r_id = r.id
GROUP BY r.city 
ORDER BY contribution_percent DESC LIMIT 5; 


-- Q35 Find top 5 restaurants by total sales using CTE
WITH restaurant_sales AS (
    SELECT r.id, r.name, SUM(o.sales_amount) AS total_sales
    FROM restaurants r
    JOIN orders o ON r.id = o.r_id
    GROUP BY r.id, r.name
)
SELECT name, total_sales
FROM restaurant_sales
ORDER BY total_sales DESC
LIMIT 5;


-- Q36 Restaurant Rating Category using CASE

SELECT name, rating,
       CASE
           WHEN rating >= 4.5 THEN 'Excellent'
           WHEN rating >= 4.0 THEN 'Good'
           WHEN rating REGEXP '^[0-3.9]' THEN 'Average'
           ELSE 'New / Not Rated'
       END AS rating_category
FROM restaurants;

-- Q37 Sales by Occupation

SELECT u.occupation,
       SUM(o.sales_amount) AS total_sales
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.occupation
ORDER BY total_sales DESC;

-- Q38 Sales by Marital Status
SELECT u.marital_status,
       SUM(o.sales_amount) AS total_sales
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.marital_status
ORDER BY total_sales DESC;
 
 
-- Q39 Year-wise + Month-wise Growth
SELECT year, month, total_sales,
       total_sales - LAG(total_sales) 
       OVER (PARTITION BY year ORDER BY month) AS monthly_growth
FROM (
    SELECT YEAR(order_date) AS year,
           MONTH(order_date) AS month,
           SUM(sales_amount) AS total_sales
    FROM orders
    GROUP BY year, month
) t;

-- Q40 Customer repeat rate restaurant wise
SELECT 
    r.name AS restaurant_name,
    ROUND(
        (COUNT(CASE WHEN order_count >= 2 THEN 1 END) * 100.0) 
        / COUNT(*),
    2) AS repeat_customer_rate
FROM (
    SELECT 
        r_id,
        user_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY r_id, user_id
) t
JOIN restaurants r ON t.r_id = r.id
GROUP BY r.name
ORDER BY repeat_customer_rate DESC;
