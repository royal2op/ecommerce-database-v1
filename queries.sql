--Total Revenue Calculation--
SELECT SUM(amount) AS total_revenue
FROM orders
WHERE status = 'paid';

--Revenue Per Currency --
SELECT currency, SUM(amount) AS revenue
FROM orders
WHERE status = 'paid'
GROUP BY currency;

--Top Selling Products--
SELECT currency, SUM(amount) AS revenue
FROM orders
WHERE status = 'paid'
GROUP BY currency;

--Top Customers--
SELECT currency, SUM(amount) AS revenue
FROM orders
WHERE status = 'paid'
GROUP BY currency;