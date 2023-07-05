-- 1 What are the monthly and quarterly sales trends for Macbooks sold in North America across all years?
-- 1A: Quarterly Sales. This code extracts the quarter from purchase timestamp and uses a join to the customers table to isolate North American transactions.
SELECT
  EXTRACT(QUARTER FROM orders.purchase_ts) AS purchase_quarter,
  geo.region,
  COUNT(orders.id) AS sales_count,
  ROUND(SUM(USD_price), 2) AS revenue,
  ROUND(AVG(USD_price), 2) AS AOV
FROM
  `elist-390902.elist.orders` AS orders
JOIN
  `elist-390902.elist.customers` AS customers ON orders.customer_id = customers.id
JOIN
  `elist-390902.elist.geo_lookup` AS geo ON customers.country_code = geo.country
WHERE
  LOWER(product_name) LIKE '%macbook%'
  AND LOWER(region) = 'na'
GROUP BY
  1, 2
ORDER BY
  1, 2

-- 1B: Monthly Sales. This code uses the same structure, but extracts and groups by purchase month.
SELECT
  EXTRACT(MONTH FROM orders.purchase_ts) AS purchase_month,
  geo.region,
  COUNT(orders.id) AS sales_count,
  ROUND(SUM(USD_price), 2) AS revenue,
  ROUND(AVG(USD_price), 2) AS AOV
FROM
  `elist-390902.elist.orders` AS orders
JOIN
  `elist-390902.elist.customers` AS customers ON orders.customer_id = customers.id
JOIN
  `elist-390902.elist.geo_lookup` AS geo ON customers.country_code = geo.country
WHERE
  LOWER(product_name) LIKE '%macbook%'
  AND LOWER(region) = 'na'
GROUP BY
  1, 2
ORDER BY
  1, 2

-- 1C Monthly Averages. This code follows the same structure as 1A and 1B, but goes an additional step by findings the monthly averages for key performance indicators.
WITH monthly_sales AS (
  SELECT  
    EXTRACT(MONTH FROM orders.purchase_ts) AS purchase_month,
    geo.region,
    COUNT(orders.id) AS sales_count,
    ROUND(SUM(USD_price), 2) AS revenue,
    ROUND(AVG(USD_price), 2) AS AOV
  FROM
    `elist-390902.elist.orders` AS orders
  JOIN
    `elist-390902.elist.customers` AS customers ON orders.customer_id = customers.id
  JOIN
    `elist-390902.elist.geo_lookup` AS geo ON customers.country_code = geo.country
  WHERE
    LOWER(product_name) LIKE '%macbook%'
    AND LOWER(region) = 'na'
  GROUP BY
    1, 2
  ORDER BY
    1, 2
)

SELECT
  region,
  AVG(sales_count) AS avg_monthly_sales_count,
  ROUND(AVG(revenue), 2) AS avg_monthly_revenue,
  ROUND(AVG(AOV), 2) AS avg_monthly_AOV
FROM
  monthly_sales
GROUP BY
  1

