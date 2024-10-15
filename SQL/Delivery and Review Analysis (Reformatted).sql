-- Delivery and Review Analysis

-- 1. Find the average time it takes after the purchase for the payment to be approved.
SELECT 
    AVG(order_approved_at - order_purchase_timestamp) AS avg_time_to_approval  -- Average time for payment approval
FROM 
    olist_orders
WHERE 
    order_status = 'delivered';  -- Considering only delivered orders

-- 2. Find the slowest and fastest delivery times.

-- Slowest delivery time
SELECT 
    MAX(order_delivered_customer_date - order_purchase_timestamp) AS slowest_delivery_time  -- Max difference between delivery and purchase
FROM 
    olist_orders
WHERE 
    order_status = 'delivered';

-- Fastest delivery time
SELECT 
    MIN(order_delivered_customer_date - order_purchase_timestamp) AS fastest_delivery_time  -- Min difference between delivery and purchase
FROM 
    olist_orders
WHERE 
    order_status = 'delivered';

-- 3. Find the average delivery time.
SELECT 
    AVG(order_delivered_customer_date - order_purchase_timestamp) AS avg_delivery_time  -- Average time taken for delivery
FROM 
    olist_orders
WHERE 
    order_status = 'delivered';

-- 4. Find the average, max, and min difference between actual delivery and estimated delivery.

-- Maximum difference between estimated and actual delivery dates
SELECT 
    MAX(order_estimated_delivery_date - order_delivered_customer_date) AS max_delivery_diff  -- Maximum delay
FROM 
    olist_orders
WHERE 
    order_status = 'delivered';

-- Minimum difference between estimated and actual delivery dates
SELECT 
    MIN(order_estimated_delivery_date - order_delivered_customer_date) AS min_delivery_diff  -- Minimum delay or early delivery
FROM 
    olist_orders
WHERE 
    order_status = 'delivered';

-- Average difference between estimated and actual delivery dates
SELECT 
    AVG(order_estimated_delivery_date - order_delivered_customer_date) AS avg_delivery_diff  -- Average delay or early delivery
FROM 
    olist_orders
WHERE 
    order_status = 'delivered';

-- 5. Find the count of all review scores and the percentage for each review score.

WITH review_counts AS (
    -- Step 1: Count the number of reviews for each score
    SELECT 
        review_score, 
        COUNT(order_id) AS score_count  -- Count of reviews per score
    FROM 
        olist_order_reviews
    GROUP BY 
        review_score
),
total_reviews AS (
    -- Step 2: Calculate the total number of reviews
    SELECT 
        COUNT(order_id) AS total_count  -- Total number of reviews
    FROM 
        olist_order_reviews
)
SELECT 
    rc.review_score, 
    rc.score_count, 
    (rc.score_count::FLOAT / tr.total_count) * 100 AS percentage  -- Percentage calculation
FROM 
    review_counts rc, total_reviews tr
ORDER BY 
    rc.review_score DESC;  -- Order by review score

-- 6. Find the relation between delivery time and review score.

-- Relation for delivery time < 14 days
WITH relation_delivery_reviews AS (
    SELECT 
        orders.order_id, 
        (orders.order_delivered_customer_date - orders.order_purchase_timestamp) AS delivery_time,  -- Delivery time calculation
        reviews.review_score
    FROM 
        olist_orders AS orders
    JOIN 
        olist_order_reviews AS reviews
    ON 
        reviews.order_id = orders.order_id
    WHERE 
        orders.order_status = 'delivered' AND orders.order_delivered_customer_date IS NOT NULL
)
SELECT 
    AVG(review_score) AS avg_review_score_14_days  -- Average review score for deliveries < 14 days
FROM 
    relation_delivery_reviews
WHERE 
    delivery_time < INTERVAL '14 days';

-- Relation for delivery time between 14 and 21 days
WITH relation_delivery_reviews AS (
    SELECT 
        orders.order_id, 
        (orders.order_delivered_customer_date - orders.order_purchase_timestamp) AS delivery_time,
        reviews.review_score
    FROM 
        olist_orders AS orders
    JOIN 
        olist_order_reviews AS reviews
    ON 
        reviews.order_id = orders.order_id
    WHERE 
        orders.order_status = 'delivered' AND orders.order_delivered_customer_date IS NOT NULL
)
SELECT 
    AVG(review_score) AS avg_review_score_14_to_21_days  -- Average review score for deliveries between 14 and 21 days
FROM 
    relation_delivery_reviews
WHERE 
    delivery_time BETWEEN INTERVAL '14 days' AND INTERVAL '21 days';

-- Relation for delivery time between 21 and 28 days
WITH relation_delivery_reviews AS (
    SELECT 
        orders.order_id, 
        (orders.order_delivered_customer_date - orders.order_purchase_timestamp) AS delivery_time,
        reviews.review_score
    FROM 
        olist_orders AS orders
    JOIN 
        olist_order_reviews AS reviews
    ON 
        reviews.order_id = orders.order_id
    WHERE 
        orders.order_status = 'delivered' AND orders.order_delivered_customer_date IS NOT NULL
)
SELECT 
    AVG(review_score) AS avg_review_score_21_to_28_days  -- Average review score for deliveries between 21 and 28 days
FROM 
    relation_delivery_reviews
WHERE 
    delivery_time BETWEEN INTERVAL '21 days' AND INTERVAL '28 days';

-- Relation for delivery time > 35 days
WITH relation_delivery_reviews AS (
    SELECT 
        orders.order_id, 
        (orders.order_delivered_customer_date - orders.order_purchase_timestamp) AS delivery_time,
        reviews.review_score
    FROM 
        olist_orders AS orders
    JOIN 
        olist_order_reviews AS reviews
    ON 
        reviews.order_id = orders.order_id
    WHERE 
        orders.order_status = 'delivered' AND orders.order_delivered_customer_date IS NOT NULL
)
SELECT 
    AVG(review_score) AS avg_review_score_above_35_days  -- Average review score for deliveries over 35 days
FROM 
    relation_delivery_reviews
WHERE 
    delivery_time > INTERVAL '35 days';
