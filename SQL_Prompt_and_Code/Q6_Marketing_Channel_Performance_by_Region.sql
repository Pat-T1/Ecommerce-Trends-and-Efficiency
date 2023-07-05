-- Q6: Which marketing channels perform the best in each region? Does the top channel differ across regions?
-- Note: Because the stakeholder did not outline what metrics would illustrate the "best" performance, I chose to review revenue, order count, and AOV.
SELECT
  geo.region AS region,
  customers.marketing_channel AS marketing_channel,
  SUM(orders.usd_price) AS total_revenue,
  COUNT(orders.id) AS order_count
FROM
  `elist-390902.elist.orders` AS orders
JOIN
  `elist-390902.elist.customers` AS customers ON orders.customer_id = customers.id
JOIN
  `elist-390902.elist.geo_lookup` AS geo ON customers.country_code = geo.country
WHERE
  geo.region IS NOT NULL
  AND customers.marketing_channel IS NOT NULL
  AND LOWER(customers.marketing_channel) != 'unknown'
GROUP BY
  region, marketing_channel
ORDER BY
  region, total_revenue DESC, order_count DESC
