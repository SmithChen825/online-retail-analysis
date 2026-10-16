-- Monthly net sales and year-over-year growth.
-- Exclude December 2011 because it is incomplete.
-- Months are consecutive, so LAG(..., 12) gives the prior-year month.
-- Expected: 24 rows; April 2011 YoY = -24.42%.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', invoice_date)::date AS month,
        SUM(line_amount) AS net_amount
    FROM public.product_transactions
    WHERE invoice_date < DATE '2011-12-01'
    GROUP BY DATE_TRUNC('month', invoice_date)::date
),
monthly_comparison AS (
    SELECT
        month,
        net_amount,
        LAG(net_amount, 12) OVER (
            ORDER BY month
        ) AS previous_year_amount
    FROM monthly_sales
)
SELECT
    month,
    ROUND(net_amount, 2) AS net_amount,
    ROUND(previous_year_amount, 2) AS previous_year_amount,
    ROUND(
        (net_amount - previous_year_amount)
        / NULLIF(previous_year_amount, 0) * 100,
        2
    ) AS yoy_pct
FROM monthly_comparison
ORDER BY month;