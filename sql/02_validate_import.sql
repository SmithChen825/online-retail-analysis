-- Validate the imported data against the Python results.
-- Expected:
-- row_count = 1033062
-- net_amount = 18981261.52
-- missing_customer_id = 227214

SELECT
    COUNT(*) AS row_count,
    ROUND(SUM(line_amount), 2) AS net_amount,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id
FROM public.product_transactions;