
-- Exploratory RFM segmentation as of 2011-12-01.
-- Thresholds: recency <= 100 days, orders >= 3,
-- net spending >= GBP 835.46.
-- Includes identified customers with at least one positive order.
-- Monetary value includes cancellations.
-- Thresholds are descriptive, not validated business rules.
WITH customer_rfm AS (
    SELECT
        customer_id,
        DATE '2011-12-01' - MAX(invoice_date::date) FILTER (
            WHERE NOT is_cancelled
        ) AS recency_days,
        COUNT(DISTINCT invoice) FILTER (
            WHERE NOT is_cancelled
        ) AS order_count,
        SUM(line_amount) AS net_amount
    FROM public.product_transactions
    WHERE customer_id IS NOT NULL
        AND invoice_date < '2011-12-01'
    GROUP BY customer_id
    HAVING COUNT(*) FILTER (WHERE NOT is_cancelled) > 0
),
customer_segments AS (
    SELECT
        customer_id,
        net_amount,
        CASE
            WHEN net_amount <= 0 THEN 'Review'
            WHEN recency_days <= 100 THEN 'More recent'
            ELSE 'Less recent'
        END AS recency_group,
        CASE
            WHEN order_count >= 3 THEN 'Higher frequency'
            ELSE 'Lower frequency'
        END AS frequency_group,
        CASE
            WHEN net_amount <= 0 THEN 'Non-positive'
            WHEN net_amount >= 835.46 THEN 'Higher value'
            ELSE 'Lower value'
        END AS monetary_group
    FROM customer_rfm
)
SELECT
    recency_group,
    frequency_group,
    monetary_group,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_pct,
    ROUND(SUM(net_amount), 2) AS net_amount,
    ROUND(
        100.0 * SUM(net_amount) / SUM(SUM(net_amount)) OVER (),
        2
    ) AS net_amount_pct
FROM customer_segments
GROUP BY recency_group, frequency_group, monetary_group
ORDER BY net_amount DESC;