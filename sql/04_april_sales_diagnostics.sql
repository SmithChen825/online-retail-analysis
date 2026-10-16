-- April sales diagnostics: 2010 vs 2011.
-- Cancellation amounts are signed negative values.
-- These comparisons describe changes, not their underlying causes.

-- 1. Separate positive sales and cancellations.
SELECT
    EXTRACT(YEAR FROM invoice_date)::integer AS year,
    ROUND(SUM(
        CASE WHEN NOT is_cancelled THEN line_amount ELSE 0 END
    ), 2) AS positive_amount,
    ROUND(SUM(
        CASE WHEN is_cancelled THEN line_amount ELSE 0 END
    ), 2) AS cancellation_amount,
    ROUND(SUM(line_amount), 2) AS net_amount
FROM public.product_transactions
WHERE EXTRACT(MONTH FROM invoice_date) = 4
GROUP BY EXTRACT(YEAR FROM invoice_date)
ORDER BY year;


-- 2. Compare order counts and average order amounts.
SELECT
    EXTRACT(YEAR FROM invoice_date)::integer AS year,
    COUNT(DISTINCT invoice) AS order_count,
    ROUND(SUM(line_amount), 2) AS positive_amount,
    ROUND(
        SUM(line_amount) / NULLIF(COUNT(DISTINCT invoice), 0),
        2
    ) AS amount_per_order
FROM public.product_transactions
WHERE EXTRACT(MONTH FROM invoice_date) = 4
    AND NOT is_cancelled
GROUP BY EXTRACT(YEAR FROM invoice_date)
ORDER BY year;


-- 3. Identify countries with the largest sales declines.
WITH country_sales AS (
    SELECT
        country,
        SUM(CASE
            WHEN EXTRACT(YEAR FROM invoice_date) = 2010
            THEN line_amount ELSE 0
        END) AS amount_2010,
        SUM(CASE
            WHEN EXTRACT(YEAR FROM invoice_date) = 2011
            THEN line_amount ELSE 0
        END) AS amount_2011
    FROM public.product_transactions
    WHERE EXTRACT(MONTH FROM invoice_date) = 4
        AND EXTRACT(YEAR FROM invoice_date) IN (2010, 2011)
        AND NOT is_cancelled
    GROUP BY country
)
SELECT
    country,
    ROUND(amount_2010, 2) AS amount_2010,
    ROUND(amount_2011, 2) AS amount_2011,
    ROUND(amount_2011 - amount_2010, 2) AS change
FROM country_sales
ORDER BY change, country
LIMIT 10;