-- Q7: For customers who purchased more than 4 orders across all years, what was the order ID, product, and purchase date of their most recent order?
-- This code first isolates customers with 4+ lifetime purchases, then assigns a row number to identify their most recent purchase. Finally, I pull all required fields related to these customers.
WITH four_purchases AS (
  SELECT
    customer_id,
    COUNT(id) AS num_purchases
  FROM
    `elist-390902.elist.orders`
  GROUP BY
    customer_id
  HAVING
    COUNT(id) >= 4
),
numbered_purchases AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY orders.customer_id ORDER BY orders.purchase_ts DESC) AS order_num
  FROM
    `elist-390902.elist.orders` AS orders
)
SELECT
  numbered_purchases.id AS order_id,
  numbered_purchases.product_name AS product,
  numbered_purchases.purchase_ts AS purchase_date
FROM
  four_purchases AS four
INNER JOIN
  numbered_purchases AS numbered_purchases ON four.customer_id = numbered_purchases.customer_id
WHERE
  numbered_purchases.order_num = 1
