# Online Retail II — Sales Analytics

**Status: work in progress. Second public milestone: PostgreSQL analysis, retention and customer segmentation.**

A personal portfolio project investigating historical retail transactions with Python/pandas. The goal is to connect data-quality decisions to interpretable sales, customer and product metrics. PostgreSQL analysis now covers sales diagnostics, observed repeat purchasing, cohort retention and exploratory customer segmentation. A BI dashboard and an experiment proposal remain planned.

## Start here

Open [01_data_check.ipynb](01_data_check.ipynb) for the executed investigation and its limitations. It covers overlapping source sheets, missing customer IDs, duplicate sensitivity, special transaction codes, monthly amounts and an April 2011 diagnostic.

## Early findings

- Source-sheet overlap is verified at record and occurrence-count level. The combined table contains 1,044,848 rows.
- The current candidate product scope contains 1,033,062 rows and GBP 18,981,261.52 net recorded amount over the full observed period.
- Missing customer IDs represent 22.35% of candidate positive lines and 13.08% of their amount. Customer-level results cover only identified customers.
- April 2011 net recorded product amount fell 24.42% year over year. Lower positive amounts and greater cancellation offsets both contribute arithmetically.
- A GBP 22,998.40 cancellation is followed by a GBP 21,535.90 positive invoice for the same customer 12 minutes later. This is evidence to investigate a correction/re-invoicing hypothesis, not proof of lost demand.

These are descriptive, provisional findings from historical data, not current-market claims or causal conclusions.

## Reproduce

1. Download **online_retail_II.xlsx** from the [UCI source](https://archive.ics.uci.edu/dataset/502/online+retail+ii) and place it beside the notebook. Preserve both sheets.
2. Use Python 3.13 and install dependencies:

   ```bash
   python -m pip install -r requirements.txt
   ```

3. Open the notebook in JupyterLab or VS Code, select that Python environment, then **Restart & Run All**. Run from the repository directory. Loading approximately one million Excel rows takes time and requires several GB of free RAM.

The workbook and local environments are ignored by Git. The notebook contains small derived outputs for review. The notebook is a sequential learning/diagnostic artifact; individual later cells depend on earlier cells.

## Metric boundaries

- Grain: invoice line. Currency: GBP. Net recorded amount is positive line amounts plus signed cancellation amounts; it is not profit or recognized revenue.
- Known postage, adjustments, manual entries, bank/platform fees, commissions, samples, tests and gift vouchers are classified separately. Remaining codes are product candidates.
- December 2011 is partial and excluded from full-month comparisons. Cancellations remain in their recorded month and are not systematically matched to original orders.
- Exact within-sheet duplicates are retained pending sensitivity analysis; raw-amount deduplication changes the total by GBP 54,228.42. This is not a final-metric robustness result.
- Stock-code case is preserved; inconsistent descriptions and correction records need further review. Display names use the most frequent candidate-sale description, with a fallback for cancellation-only codes.
- Shared-April customer comparisons are selected descriptive cohorts, not retention or churn estimates. No production deployment or real experiment is claimed.

## Roadmap

- [x] Inspect source schema, missingness, overlap and unusual transactions
- [x] Build candidate transaction flags and initial monthly diagnostics
- [ ] Consolidate cleaning pipeline and complete sensitivity checks
- [x] Define customer repeat-purchase metrics and observation windows
- [x] Load data into PostgreSQL and reproduce core metrics in SQL
- [ ] Build a Power BI or Tableau dashboard
- [ ] Write a business report and an A/B test proposal

## PostgreSQL milestone

Run the numbered files in [sql/](sql/) using PostgreSQL 18 and pgAdmin. Small exported tables are in [results/](results/).

1. Execute the notebook, then run `%run export_transactions.py` in the same notebook kernel, from the repository directory.
2. Create a database named `online_retail`, connect to it, and run `sql/01_create_tables.sql` once.
3. Import `data/processed/product_transactions.csv` into `public.product_transactions`: CSV, UTF8, header enabled, comma delimiter, double quote for both quote and escape, all 12 columns in table order. Empty customer IDs import as NULL. Import once into the empty table; importing again appends duplicates.
4. Run `02_validate_import.sql`: expect 1,033,062 rows, GBP 18,981,261.52 net amount and 227,214 missing customer IDs.
5. Run scripts 03–07. Script 04 contains three separate statements. The full-period import check includes partial December 2011; monthly and customer analyses end before 2011-12-01.

| Script | Output |
| --- | --- |
| 03_monthly_yoy.sql | Monthly net sales and year-over-year growth |
| 04_april_sales_diagnostics.sql | April amount, order and country comparisons |
| 05_customer_retention.sql | Cohort sizes and month 1, 3 and 6 purchase retention |
| 06_customer_value.sql | Top 10, 50 and 100 customer net-sales shares |
| 07_customer_segmentation.sql | Exploratory RFM segment sizes and contribution |

### Customer findings and definitions

- Observed repeat purchasing: 4,177 of 5,824 identified positive-order customers placed at least two distinct positive invoices (71.72%). This is not monthly retention and gives later customers less follow-up time.
- Weighted next-calendar-month purchase retention is 1,315 / 5,633 = 23.34%; excluding the first observed cohort gives 982 / 4,682 = 20.97%. November 2011 is excluded from these denominators. These two figures are documented session results; script 05 outputs the cohort matrix, not these pooled calculations.
- A cohort is the month of first observed positive purchase, not verified acquisition. Purchases count even if a later cancellation occurs; these are gross purchase-activity retention measures. Future unobserved months remain NULL. In this dataset all observed cohort-month combinations have activity; a general zero-activity dataset would require a calendar grid before distinguishing zero from unobserved.
- Top 10 / 50 / 100 customers contribute 16.23% / 29.56% / 36.68% of identified net sales. This denominator includes cancellation-only customers.
- RFM includes 5,824 identified customers with at least one positive order. As of 2011-12-01, descriptive thresholds are recency <= 100 days, frequency >= 3 orders and net spending >= GBP 835.46. Non-positive net spending is marked for review (19 customers). Thresholds are exploratory, not validated targeting rules.
- The more-recent, higher-frequency, higher-value segment contains 1,878 customers (32.25%) and 77.96% of RFM-population net sales. Historical contribution does not predict future spending; customer tenure affects frequency and spending.

SQL was executed interactively by the author in pgAdmin. Published scripts were reviewed against those results and exported tables; this release does not claim an automated fresh-database integration test. The original notebook remains the first-milestone executed artifact; the export helper bridges it to SQL.

## Source and attribution

Chen, D. (2012). *Online Retail II* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D. Dataset license: **Creative Commons Attribution 4.0 International (CC BY 4.0)**. Derived tables apply overlap removal, type/whitespace normalization, transaction classification and aggregation as documented in the notebook. The original workbook is distributed by UCI, not this repository.

This project was developed with AI-assisted tutoring, code explanation and publication preparation. The notebook documents the analysis and its unresolved questions.
