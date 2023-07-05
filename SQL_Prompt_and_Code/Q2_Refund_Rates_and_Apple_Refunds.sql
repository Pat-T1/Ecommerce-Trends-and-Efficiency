-- Q2 What was the monthly refund rate for purchases made in 2020? How many refunds did we have each month in 2021 for Apple products?
-- Q2A - Monthly refund rates for 2020
-- This code uses case/when to assign a 1 to any orders with non-null refund timestamps, allowing user to quantify refunds and divide by total order count to determine refund rate.
SELECT
    EXTRACT(MONTH FROM orders.purchase_ts) AS month,
    COUNT(DISTINCT orders.id) AS order_count,
    SUM(CASE WHEN refund_ts IS NOT NULL THEN 1 ELSE 0 END) AS refund_count,
    SUM(CASE WHEN refund_ts IS NOT NULL THEN 1 ELSE 0 END) / COUNT(DISTINCT orders.id) AS refund_rate
FROM
    `elist-390902.elist.orders` AS orders
LEFT JOIN
    `elist-390902.elist.order_status` AS status
    ON status.order_id = orders.id
WHERE
    EXTRACT(YEAR FROM orders.purchase_ts) = 2020
GROUP BY
    1
ORDER BY
    1

-- Q2B - 2021 Apple Product Refund Count
-- This code uses the presence of non-null refund timestamps to identify product returns, and basic regex to identify Apple and Mac products.
SELECT
    EXTRACT(MONTH FROM orders.purchase_ts) AS month,
    COUNT(DISTINCT orders.id) AS apple_refunds
FROM
    `elist-390902.elist.orders` AS orders
LEFT JOIN
    `elist-390902.elist.order_status` AS status
    ON orders.id = status.order_id
WHERE
    EXTRACT(YEAR FROM orders.purchase_ts) = 2021
    AND status.refund_ts IS NOT NULL
    AND (LOWER(orders.product_name) LIKE '%apple%'
         OR LOWER(orders.product_name) LIKE '%macbook%')
GROUP BY
    1
ORDER BY
    1

-- Q2C - 2021 Apple Product Total Orders
-- This code simply drops the NULL requirement for the previous query, allowing stakeholders to also see the overall refund rate for the period of study and products mentioned in Q2B.
SELECT
    EXTRACT(MONTH FROM orders.purchase_ts) AS month,
    COUNT(DISTINCT orders.id) AS apple_purchases
FROM
    `elist-390902.elist.orders` AS orders
LEFT JOIN
    `elist-390902.elist.order_status` AS status
    ON orders.id = status.order_id
WHERE
    EXTRACT(YEAR FROM orders.purchase_ts) = 2021
    AND (LOWER(orders.product_name) LIKE '%apple%'
         OR LOWER(orders.product_name) LIKE '%macbook%')
GROUP BY
    1
ORDER BY
    1
