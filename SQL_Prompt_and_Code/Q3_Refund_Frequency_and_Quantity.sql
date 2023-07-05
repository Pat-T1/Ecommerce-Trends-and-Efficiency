-- Q3 Are there certain products that are getting refunded more frequently than others? What are the top 3 most frequently refunded products across all years? What are the top 3 products that have the highest count of refunds?
-- Q3A Top 3 products by refund frequency.
-- The first version of this code did not include a LIMIT clause and revealed inconsistent naming for one product. I used regex and REPLACE to correct this issue without altering the parent dataset.
SELECT
  CASE
    WHEN REPLACE(product_name, '""', '') LIKE '%gaming monitor%' THEN '27in 4K gaming monitor'
    ELSE product_name
  END AS normalized_product_name,
  SUM(CASE
    WHEN status.refund_ts IS NOT NULL THEN 1
    ELSE 0
  END) AS refund_count,
  (SUM(CASE
    WHEN status.refund_ts IS NOT NULL THEN 1
    ELSE 0
  END) / COUNT(DISTINCT orders.id)) AS refund_rate
FROM
  `elist-390902.elist.orders` AS orders
LEFT JOIN
  `elist-390902.elist.order_status` AS status ON orders.id = status.order_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 3

-- Q3B Top 3 refunded products by refund quantity
-- The following code uses the same product name cleaning method, but provides a raw count of refunds per the stakeholder request.
SELECT
  CASE
    WHEN REPLACE(product_name, '""', '') LIKE '%gaming monitor%' THEN '27in 4K gaming monitor'
    ELSE product_name
  END AS normalized_product_name,
  SUM(CASE
    WHEN status.refund_ts IS NOT NULL THEN 1
    ELSE 0
  END) AS refund_count
FROM
  `elist-390902.elist.orders` AS orders
LEFT JOIN
  `elist-390902.elist.order_status` AS status
ON
  orders.id = status.order_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
