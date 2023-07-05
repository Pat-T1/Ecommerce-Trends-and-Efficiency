-- Q5 What’s the average time between customer registration and placing an order?
-- Q5A: Average customer registration to any order
-- Note: This query does not isolate registration to first order per the stakeholder's request. A second query is written below to ensure stakeholder's question is clearly answered.
SELECT
  AVG(DATE_DIFF(orders.purchase_ts, customers.created_on, DAY)) AS avg_interval_creation_to_purchase_days
FROM
  `elist-390902.elist.orders` AS orders
LEFT JOIN
  `elist-390902.elist.customers` AS customers ON orders.customer_id = customers.id


-- Q5B: Average customer registratrion to FIRST order
-- Note: The stakeholder asked about the average time between registration and placing AN order. This query determines the interval from account creation to their FIRST purchase (the minimum purchase timestamp.)
WITH first_purchase AS (
  SELECT
    orders.customer_id AS customer_id,
    DATE_DIFF(MIN(orders.purchase_ts), MIN(customers.created_on), DAY) AS creation_to_first_purchase
  FROM
    `elist-390902.elist.orders` AS orders
  LEFT JOIN
    `elist-390902.elist.customers` AS customers ON orders.customer_id = customers.id
  GROUP BY
    customer_id
)

SELECT
  AVG(creation_to_first_purchase) AS avg_creation_to_first_purchase
FROM
  first_purchase
