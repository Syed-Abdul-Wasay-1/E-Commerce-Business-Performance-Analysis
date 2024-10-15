-- Customer and Seller Analysis

-- 1. What are the top 10 cities with the most customers?
SELECT 
    customer_city, 
    COUNT(customer_unique_id) AS total_customers  -- Count of unique customers in each city
FROM 
    olist_customers  -- Customer data table
GROUP BY 
    customer_city    -- Grouping by city to get the count per city
ORDER BY 
    total_customers DESC  -- Ordering by the highest number of customers
LIMIT 10;  -- Limiting the result to the top 10 cities

-- 2. What are the top 10 states with the most customers?
SELECT 
    customer_state, 
    COUNT(customer_unique_id) AS total_customers  -- Count of unique customers in each state
FROM 
    olist_customers  -- Customer data table
GROUP BY 
    customer_state   -- Grouping by state to get the count per state
ORDER BY 
    total_customers DESC  -- Ordering by the highest number of customers
LIMIT 10;  -- Limiting the result to the top 10 states

-- 3. Find the top 10 cities with the most customers and their respective states.
WITH top_customer_cities AS (  -- Using a CTE to organize the result for ranking cities
    SELECT 
        customer_state, 
        customer_city, 
        COUNT(customer_unique_id) AS total_customers,  -- Count of customers in each city
        ROW_NUMBER() OVER (ORDER BY COUNT(customer_unique_id) DESC) AS city_rank  -- Ranking cities by the number of customers
    FROM 
        olist_customers  -- Customer data table
    GROUP BY 
        customer_state, customer_city  -- Grouping by both state and city to aggregate the data
)
SELECT 
    customer_state, 
    customer_city, 
    total_customers  -- Displaying the state, city, and the total number of customers
FROM 
    top_customer_cities  -- Using the CTE to select the top cities
WHERE 
    city_rank <= 10  -- Filtering only the top 10 cities
ORDER BY 
    total_customers DESC;  -- Ordering by the number of customers

-- 4. What are the top 10 cities with the most sellers?
SELECT 
    seller_city, 
    COUNT(seller_id) AS total_sellers  -- Count of sellers in each city
FROM 
    olist_seller  -- Seller data table
GROUP BY 
    seller_city    -- Grouping by city to get the count per city
ORDER BY 
    total_sellers DESC  -- Ordering by the highest number of sellers
LIMIT 10;  -- Limiting the result to the top 10 cities

-- 5. What are the top 10 states with the most sellers?
SELECT 
    seller_state, 
    COUNT(seller_id) AS total_sellers  -- Count of sellers in each state
FROM 
    olist_sellers  -- Seller data table
GROUP BY 
    seller_state   -- Grouping by state to get the count per state
ORDER BY 
    total_sellers DESC  -- Ordering by the highest number of sellers
LIMIT 10;  -- Limiting the result to the top 10 states

-- 6. Find the top 10 cities with the most sellers and their respective states.
WITH top_seller_cities AS (  -- Using a CTE to organize the result for ranking cities
    SELECT 
        seller_state, 
        seller_city, 
        COUNT(seller_id) AS total_sellers,  -- Count of sellers in each city
        ROW_NUMBER() OVER (ORDER BY COUNT(seller_id) DESC) AS city_rank  -- Ranking cities by the number of sellers
    FROM 
        olist_seller  -- Seller data table
    GROUP BY 
        seller_state, seller_city  -- Grouping by both state and city to aggregate the data
)
SELECT 
    seller_state, 
    seller_city, 
    total_sellers  -- Displaying the state, city, and the total number of sellers
FROM 
    top_seller_cities  -- Using the CTE to select the top cities
WHERE 
    city_rank <= 10  -- Filtering only the top 10 cities
ORDER BY 
    total_sellers DESC;  -- Ordering by the number of sellers
