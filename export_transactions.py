"""Run in the notebook kernel after executing 01_data_check.ipynb:
%run export_transactions.py
"""
from pathlib import Path

columns = ["Invoice", "StockCode", "Description", "product_name", "Quantity",
           "InvoiceDate", "Price", "Customer ID", "Country", "is_cancelled",
           "line_amount", "source_sheet"]
rename = {"Invoice": "invoice", "StockCode": "stock_code",
          "Description": "description", "Quantity": "quantity",
          "InvoiceDate": "invoice_date", "Price": "unit_price",
          "Customer ID": "customer_id", "Country": "country"}
transactions_export = product_transactions[columns].rename(columns=rename).copy()
output = Path("data/processed/product_transactions.csv")
output.parent.mkdir(parents=True, exist_ok=True)
transactions_export.to_csv(output, index=False, encoding="utf-8")
print(f"Saved {len(transactions_export):,} rows to {output.resolve()}")
