-- Sales And Revenue Analysis

-- 1. Find the top 10 most expensive product categories by average product price
SELECT 
    prod.product_category_name,
    trans.product_category_name_english,
    AVG(items.price) AS avg_price  -- Calculating average price of products
FROM 
    olist_order_items items
JOIN 
    olist_products prod ON items.product_id = prod.product_id
JOIN 
    olist_product_name_translation trans ON trans.product_category_name = prod.product_category_name
GROUP BY 
    prod.product_category_name, 
    trans.product_category_name_english
ORDER BY 
    avg_price DESC  -- Ordering by the most expensive
LIMIT 10;  -- Limiting to top 10

-- 1b. Find the top 10 cheapest product categories by average product price
SELECT 
    prod.product_category_name,
    trans.product_category_name_english,
    AVG(items.price) AS avg_price  -- Calculating average price of products
FROM 
    olist_order_items items
JOIN 
    olist_products prod ON items.product_id = prod.product_id
JOIN 
    olist_product_name_translation trans ON trans.product_category_name = prod.product_category_name
GROUP BY 
    prod.product_category_name, 
    trans.product_category_name_english
ORDER BY 
    avg_price ASC  -- Ordering by the cheapest
LIMIT 10;

-- 2. Find the top 10 most ordered product categories
SELECT 
    prod.product_category_name,
    trans.product_category_name_english,
    COUNT(items.product_id) AS total_orders  -- Counting the number of orders per category
FROM 
    olist_order_items items
JOIN 
    olist_products prod ON items.product_id = prod.product_id
JOIN 
    olist_product_name_translation trans ON trans.product_category_name = prod.product_category_name
GROUP BY 
    prod.product_category_name, 
    trans.product_category_name_english
ORDER BY 
    total_orders DESC  -- Ordering by the most ordered
LIMIT 10;

-- 3. Find the most used payment method for orders
WITH order_payments AS (
    SELECT 
        order_id, 
        payment_type
    FROM 
        olist_order_payments
),
order_items AS (
    SELECT 
        order_id, 
        product_id
    FROM 
        olist_order_items
),
order_products AS (
    SELECT 
        product_id, 
        product_category_name
    FROM 
        olist_products
),
english_names AS (
    SELECT 
        product_category_name, 
        product_category_name_english
    FROM 
        olist_product_name_translation
)
SELECT 
    payments.payment_type, 
    COUNT(payments.payment_type) AS total_usage  -- Counting the usage of each payment method
FROM 
    order_payments payments
JOIN 
    order_items items ON payments.order_id = items.order_id
JOIN 
    order_products products ON items.product_id = products.product_id
JOIN 
    english_names names ON products.product_category_name = names.product_category_name
GROUP BY 
    payments.payment_type
ORDER BY 
    total_usage DESC;  -- Ordering by the most used payment type

-- 4. Find the distribution of payment installments
WITH PaymentInstallmentsCount AS (
    SELECT 
        payment_installments, 
        COUNT(order_id) AS installment_count  -- Counting the number of orders with each installment option
    FROM 
        olist_order_payments
    GROUP BY 
        payment_installments
    ORDER BY 
        payment_installments ASC
),
TotalOrders AS (
    SELECT 
        COUNT(order_id) AS total_order_count  -- Counting the total number of orders
    FROM 
        olist_order_payments
)
SELECT 
    installments.payment_installments, 
    installments.installment_count, 
    (installments.installment_count::FLOAT / total.total_order_count) * 100 AS percentage  -- Calculating percentage of orders using each installment option
FROM 
    PaymentInstallmentsCount installments, 
    TotalOrders total;

-- 5. Find the total number of orders per year and month
SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,  -- Extracting the year from the order date
    EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,  -- Extracting the month from the order date
    COUNT(order_id) AS total_orders  -- Counting the total number of orders
FROM 
    olist_orders
GROUP BY 
    order_year, order_month
ORDER BY 
    order_year, order_month;  -- Ordering by year and month

-- 6. Find the total sales revenue per year and month
SELECT 
    SUM(payments.payment_value) AS total_sales_revenue,  -- Summing up the total payments for sales revenue
    EXTRACT(YEAR FROM orders.order_purchase_timestamp) AS order_year,  -- Extracting the year from the order date
    EXTRACT(MONTH FROM orders.order_purchase_timestamp) AS order_month  -- Extracting the month from the order date
FROM 
    olist_order_payments payments
JOIN 
    olist_orders orders ON payments.order_id = orders.order_id
GROUP BY 
    order_year, order_month
ORDER BY 
    order_year, order_month;  -- Ordering by year and month

-- 7. Find the average freight paid by customers
SELECT 
    AVG(freight_value) AS avg_freight_cost  -- Calculating the average freight cost per order
FROM 
    olist_order_items;
