-- Q8: For each brand, which month in 2020 had the highest number of refunds, and how many refunds did that month have?
-- This query first uses case/when to organize all products into a brand category and limit to 2020 purchases. Next, it isolates refunded orders under the same structure in a second CTE. 
-- Finally, it joins these two CTE's so refunds can be compared to overall sales by month.
WITH brand_table AS (
  SELECT
    orders.id,
    orders.purchase_ts,
    orders.product_name,
    status.refund_ts,
    CASE
      WHEN LOWER(product_name) LIKE '%apple%' THEN 'Apple'
      WHEN LOWER(product_name) LIKE '%macbook%' THEN 'Apple'
      WHEN LOWER(product_name) LIKE '%samsung%' THEN 'Samsung'
      WHEN LOWER(product_name) LIKE '%thinkpad%' THEN 'IBM'
      WHEN LOWER(product_name) LIKE '%gaming monitor%' THEN 'Generic'
      WHEN LOWER(product_name) LIKE '%bose%' THEN 'Bose'
      ELSE 'Unknown'
    END AS product_brand
  FROM
    `elist-390902.elist.orders` AS orders
  FULL JOIN
    `elist-390902.elist.order_status` AS status ON orders.id = status.order_id
  WHERE
    EXTRACT(YEAR FROM orders.purchase_ts) = 2020
),
refunded_orders AS (
  SELECT
    *
  FROM
    brand_table
  WHERE
    refund_ts IS NOT NULL
)
SELECT
  EXTRACT(MONTH FROM brand_table.purchase_ts) AS month,
  brand_table.product_brand,
  COUNT(refunds.id) AS refund_count,
  COUNT(brand_table.id) AS total_orders
FROM
  brand_table
LEFT JOIN
  refunded_orders AS refunds ON brand_table.id = refunds.id
GROUP BY
  1, 2
ORDER BY
  1, refund_count DESC
