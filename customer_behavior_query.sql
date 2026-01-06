

--  Q1. Total revenue by Male vs Female customers
SELECT
    gender,
    SUM(purchase_amount_usd) AS total_revenue
FROM customer
GROUP BY gender;

-- Q2. Customers who used discount & spent more than average purchase amount
SELECT *
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount_usd >
    (SELECT AVG(purchase_amount_usd) FROM customer);

-- Q3. Top 5 products with highest average review rating
SELECT
    item_purchased,
    ROUND(AVG(review_rating::numeric), 2) AS avg_rating
FROM customer
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;

--Q4. Average purchase amount: Standard vs Express Shipping
SELECT
    shipping_type,
    ROUND(AVG(purchase_amount_usd::numeric), 2) AS avg_purchase_amount
FROM customer
GROUP BY shipping_type;

--Q5. Do subscribed customers spend more?
SELECT
    subscription_status,
    ROUND(AVG(purchase_amount_usd::numeric), 2) AS avg_spend,
    SUM(purchase_amount_usd) AS total_revenue
FROM customer
GROUP BY subscription_status;

--Q6. Top 5 products with highest % of discounted purchases
SELECT
    item_purchased,
    ROUND(
        100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

-- Q7. Segment customers into New / Returning / Loyal
--Logic:
--New → 0 previous purchases
--Returning → 1–5
--Loyal → >5

SELECT
    CASE
        WHEN previous_purchases = 0 THEN 'New'
        WHEN previous_purchases BETWEEN 1 AND 5 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_segment,
    COUNT(*) AS customer_count
FROM customer
GROUP BY customer_segment;

-- Q8. Top 3 most purchased products in each category
--(Window Function – Very Important for Interview )

SELECT category, item_purchased, purchase_count
FROM (
    SELECT
        category,
        item_purchased,
        COUNT(*) AS purchase_count,
        RANK() OVER (
            PARTITION BY category
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM customer
    GROUP BY category, item_purchased
) t
WHERE rnk <= 3;

-- Q9. Are repeat buyers (>5 purchases) more likely to subscribe?
SELECT
    subscription_status,
    COUNT(*) AS customer_count
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10. Revenue contribution of each age group
--Age groups:
--<25
--25–34
--35–44
--45+

SELECT age_group,
SUM(purchase_amount_us) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;

