-- Monthly purchase retention by first observed purchase month.
-- Observation window ends on 2011-11-30.
-- Unobserved future months remain NULL.
-- Weighted month-1 retention: 23.34%.
-- Excluding the first observed cohort: 20.97%.

WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', invoice_date)::date AS purchase_month
    FROM public.product_transactions
    WHERE NOT is_cancelled
        AND customer_id IS NOT NULL
        AND invoice_date < DATE '2011-12-01'
),
customer_cohorts AS (
    SELECT
        customer_id,
        purchase_month,
        MIN(purchase_month) OVER (
            PARTITION BY customer_id
        ) AS cohort_month
    FROM customer_months
),
cohort_counts AS (
    SELECT
        cohort_month,
        (
            (EXTRACT(YEAR FROM purchase_month)
             - EXTRACT(YEAR FROM cohort_month)) * 12
            + EXTRACT(MONTH FROM purchase_month)
            - EXTRACT(MONTH FROM cohort_month)
        )::integer AS month_index,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM customer_cohorts
    GROUP BY 1, 2
)
SELECT
    cohort_month,
    MAX(active_customers) FILTER (
        WHERE month_index = 0
    ) AS cohort_size,
    ROUND(
        100.0 * MAX(active_customers) FILTER (WHERE month_index = 1)
        / MAX(active_customers) FILTER (WHERE month_index = 0),
        2
    ) AS month_1_pct,
    ROUND(
        100.0 * MAX(active_customers) FILTER (WHERE month_index = 3)
        / MAX(active_customers) FILTER (WHERE month_index = 0),
        2
    ) AS month_3_pct,
    ROUND(
        100.0 * MAX(active_customers) FILTER (WHERE month_index = 6)
        / MAX(active_customers) FILTER (WHERE month_index = 0),
        2
    ) AS month_6_pct
FROM cohort_counts
GROUP BY cohort_month
ORDER BY cohort_month;