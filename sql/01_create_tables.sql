-- Create the table before importing product_transactions.csv.
-- Column order matches the exported CSV.
-- Customer IDs may be NULL.
-- Invoice is not unique: each invoice can contain multiple products.

CREATE TABLE public.product_transactions (
    invoice       TEXT NOT NULL,
    stock_code    TEXT NOT NULL,
    description   TEXT,
    product_name  TEXT,
    quantity      INTEGER NOT NULL,
    invoice_date  TIMESTAMP NOT NULL,
    unit_price    NUMERIC(12, 4) NOT NULL,
    customer_id   TEXT,
    country       TEXT,
    is_cancelled  BOOLEAN NOT NULL,
    line_amount   NUMERIC(16, 4) NOT NULL,
    source_sheet  TEXT
);