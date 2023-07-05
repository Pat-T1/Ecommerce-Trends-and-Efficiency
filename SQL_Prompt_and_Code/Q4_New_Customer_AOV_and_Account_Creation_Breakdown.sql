-- Q4: What’s the average order value across different account creation methods in the first two months of 2022? Which method had the most new customers in this time?

--Q4A: AOV for new customer accounts in Jan/Feb '22
-- This code counts total orders and tallies AOV (revenue/order count) while filtering out customers with unknown account creation methods
SELECT
  customers.account_creation_method as acct_creation_method,
  COUNT(distinct orders.id) as order_count,
  SUM(orders.usd_price)/COUNT(distinct orders.id) as AOV
FROM `elist-390902.elist.customers` as customers
JOIN `elist-390902.elist.orders` as orders
  ON customers.id = orders.customer_id
WHERE orders.purchase_ts BETWEEN '2022-01-01' AND '2022-02-28' AND
customers.account_creation_method IS NOT NULL AND
customers.account_creation_method != 'unknown'
GROUP BY 1
ORDER BY 3 DESC, 2 DESC

-- Q4B: Quantifying new customers by creation method (with purchase)
-- This query specifically quantifies new accounts with purchase activity during the period of study (i.e. purchase timestamp within period of study)
SELECT
  customers.account_creation_method AS acct_creation_method,
  COUNT(DISTINCT customers.id) AS accounts_created
FROM
  `elist-390902.elist.customers` AS customers
JOIN
  `elist-390902.elist.orders` AS orders ON customers.id = orders.customer_id
WHERE
  orders.purchase_ts BETWEEN '2022-01-01' AND '2022-02-28'
  AND customers.created_on BETWEEN '2022-01-01' AND '2022-02-28'
  AND customers.account_creation_method IS NOT NULL
  AND customers.account_creation_method != 'unknown'
GROUP BY 1
ORDER BY 2 DESC

--Q4C: Quantifying new customers by creation method (regardless of purchase activity)
-- This code drops the purchase timestamp requirement to more literally answer the stakeholder's second question.
SELECT
  customers.account_creation_method AS acct_creation_method,
  COUNT(DISTINCT customers.id) AS accounts_created
FROM
  `elist-390902.elist.customers` AS customers
JOIN
  `elist-390902.elist.orders` AS orders ON customers.id = orders.customer_id
WHERE
  customers.created_on BETWEEN '2022-01-01' AND '2022-02-28'
  AND customers.account_creation_method IS NOT NULL
  AND customers.account_creation_method != 'unknown'
GROUP BY
  acct_creation_method
ORDER BY
  accounts_created DESC
