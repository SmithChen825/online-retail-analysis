-- Net sales concentration among identified customers, through November 2011.
-- Includes cancellation-only customers; the RFM population differs.
WITH customer_value AS (
    SELECT customer_id, SUM(line_amount) AS net_amount
    FROM public.product_transactions
    WHERE customer_id IS NOT NULL AND invoice_date < DATE '2011-12-01'
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT customer_id, net_amount,
        ROW_NUMBER() OVER (ORDER BY net_amount DESC, customer_id) AS customer_rank
    FROM customer_value
)
SELECT
    ROUND(SUM(net_amount), 2) AS identified_net_amount,
    ROUND(SUM(net_amount) FILTER (WHERE customer_rank <= 10), 2) AS top_10_net_amount,
    ROUND(100.0 * SUM(net_amount) FILTER (WHERE customer_rank <= 10)
          / NULLIF(SUM(net_amount), 0), 2) AS top_10_pct,
    ROUND(100.0 * SUM(net_amount) FILTER (WHERE customer_rank <= 50)
          / NULLIF(SUM(net_amount), 0), 2) AS top_50_pct,
    ROUND(100.0 * SUM(net_amount) FILTER (WHERE customer_rank <= 100)
          / NULLIF(SUM(net_amount), 0), 2) AS top_100_pct
FROM ranked_customers;
