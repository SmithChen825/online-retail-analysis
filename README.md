# Online Retail II — Sales Analytics

How did sales change, how often did customers purchase again, and which customer groups contributed most to net sales? This historical analysis uses **Python, PostgreSQL and Power BI** to answer these questions and identify priorities for further investigation.

**Scope:** December 2009–November 2011 · GBP · RFM snapshot: 1 December 2011.

## Three key findings

- **April 2011 net sales fell 24.42% year over year.** Lower positive sales explain about 85% of the decline; larger cancellation offsets explain the remainder. Correction records need investigation before treating cancellations as lost demand.
- **Weighted next-calendar-month purchase retention was 23.34%.** Excluding the first observed cohort gives 20.97%. These are observed purchase-activity measures, not verified acquisition retention or churn estimates.
- **32.25% of RFM customers contributed 77.96% of segment net sales.** This identifies historical concentration among customers with known IDs and at least one positive order; it does not predict future value.

## Explore the project

[Business report](BUSINESS_REPORT.md) · [Download Power BI dashboard](powerbi/Online_Retail_Dashboard.pbix?raw=true) · [Dashboard notes](powerbi/powerbi_notes.md)

[Analysis notebook](01_data_check.ipynb) · [Validation record](VALIDATION.md) · [Experiment proposal](EXPERIMENT_PROPOSAL.md)

**Status:** historical analysis, three-page dashboard, business report and experiment design completed. No experiment has been executed. Pipeline automation is an optional extension.

## Dashboard preview

Open the PBIX in Power BI Desktop to explore its saved data. Refresh requires PostgreSQL and local summary CSVs; see the [refresh instructions](powerbi/powerbi_notes.md#refresh-and-handover). This is a historical portfolio report, not a live hosted dashboard.

### Sales Overview

![Sales Overview dashboard with sales KPIs, monthly trends and country comparisons](powerbi/sales_overview.png)

<details>
<summary>Customer Retention — cohort heatmap and retention cards</summary>

![Customer Retention dashboard with cohort heatmap and weighted retention cards](powerbi/customer_retention.png)

Blank cells represent months that are not yet observable, not zero retention. Cohorts use first observed purchase, not verified acquisition.

</details>

<details>
<summary>Customer Value — RFM segments and sales contribution</summary>

![Customer Value dashboard with RFM segment table and net-sales bar chart](powerbi/customer_value.png)

RFM means Recency, Frequency and Monetary value. Segment shares use identified customers with at least one positive order, rather than all dashboard transactions.

</details>

## Reproduce

**Excel → Notebook → transaction CSV → PostgreSQL → SQL summaries → Power BI**

The notebook generates the transaction CSV. Database import, SQL-summary export and Power BI refresh are manual steps.

1. Download the [UCI workbook](https://archive.ics.uci.edu/dataset/502/online+retail+ii) and place it at `sql/online_retail_II.xlsx`, relative to the repository root. Preserve both sheets.
2. Use Python 3.13 and install dependencies:

   ```bash
   python -m pip install -r requirements.txt
   ```

3. Open [01_data_check.ipynb](01_data_check.ipynb) in JupyterLab or VS Code, select that environment and **Restart & Run All** from the repository directory. Allow several GB of free RAM.
4. The final cells export `data/processed/product_transactions.csv`. Follow the PostgreSQL steps below, then refresh Power BI using the [dashboard notes](powerbi/powerbi_notes.md#refresh-and-handover).

<details>
<summary>Detailed PostgreSQL import, SQL exports and Power BI handover</summary>

Run the numbered files in [sql/](sql/) using PostgreSQL 18 and pgAdmin. Small exported tables are in [results/](results/).

1. Execute the notebook through its final export cell. To repeat only the export, `%run export_transactions.py` is an optional helper in that same populated kernel. It requires `product_transactions` and cannot run as a standalone Python script.
2. Create a database named `online_retail`, connect to it, and run `sql/01_create_tables.sql` once.
3. Import `data/processed/product_transactions.csv` into `public.product_transactions`: CSV, UTF8, header enabled, comma delimiter, double quote for both quote and escape, all 12 columns in table order. Empty customer IDs import as NULL. Import once into the empty table; importing again appends duplicates.
4. Run `02_validate_import.sql`: expect 1,033,062 rows, GBP 18,981,261.52 net amount and 227,214 missing customer IDs.
5. Run scripts 03–07. Script 04 contains three separate statements. The full-period import check includes partial December 2011; monthly and customer analyses end before 2011-12-01.
6. Export SQL 05 and 07 query results as UTF-8 CSV with headers to `data/processed/cohort_retention_summary.csv` and `data/processed/customer_segmentation_summary.csv`. Expect 24 cohort rows and 9 segment rows. Preserve NULL retention cells as empty values and the SQL percentage scale (for example, `35.02`, not `0.3502`). The published `results/` files are reference snapshots; copying them to these paths permits a snapshot-based setup but does not validate a fresh SQL run.
7. Open the PBIX, update PostgreSQL credentials and CSV paths, and refresh. Follow the [Power BI reconciliation checks](powerbi/powerbi_notes.md#reconciliation-and-interaction-checks), clear selections and save. The disconnected customer summaries must be regenerated separately when source data changes.

| Script | Output |
| --- | --- |
| 03_monthly_yoy.sql | Monthly net sales and year-over-year growth |
| 04_april_sales_diagnostics.sql | April amount, order and country comparisons |
| 05_customer_retention.sql | Cohort sizes and month 1, 3 and 6 purchase retention |
| 06_customer_value.sql | Top 10, 50 and 100 customer net-sales shares |
| 07_customer_segmentation.sql | Exploratory RFM segment sizes and contribution |

</details>

## Definitions and validation

Net sales sum signed product line amounts, including cancellations; they are not profit. Sales include missing customer IDs, while customer analyses require identified customers. Partial December 2011 is excluded from dashboard metrics but included in full-period import checks.

Exact within-sheet duplicates remain in the baseline because matching fields alone do not establish an error. Removing them in the sensitivity scenario changes net sales by only -0.2853%, leaves purchase retention unchanged and moves 12 of 5,824 customers (0.21%) between fixed-threshold RFM segments.

See [metric definitions](powerbi/powerbi_notes.md#metric-definitions), [business interpretation and limitations](BUSINESS_REPORT.md), and [validation evidence](VALIDATION.md) for details. Validation includes a fresh Python replay and manual SQL/dashboard reconciliation; it does not establish a clean-database end-to-end integration test or an automated PBIX refresh.

## Project layout

| Location | Contents |
| --- | --- |
| [01_data_check.ipynb](01_data_check.ipynb) | Analysis, data-quality checks and baseline CSV export |
| [sql/](sql/) | Numbered PostgreSQL analyses |
| [results/](results/) | Small aggregate reference CSVs |
| [powerbi/](powerbi/) | PBIX, screenshots and technical notes |
| [BUSINESS_REPORT.md](BUSINESS_REPORT.md), [EXPERIMENT_PROPOSAL.md](EXPERIMENT_PROPOSAL.md) | Findings and proposed test design |
| [VALIDATION.md](VALIDATION.md) | Completed checks and their boundaries |
| [requirements.txt](requirements.txt), [export_transactions.py](export_transactions.py) | Dependencies and optional same-kernel export helper |

Raw Excel, large transaction exports in `data/processed/`, local environments and backups in `archive/` are excluded from Git. The original workbook is kept under `sql/` locally for compatibility.

## Source and attribution

Chen, D. (2012). *[Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii)* [Dataset]. UCI Machine Learning Repository. [DOI: 10.24432/C5CG6D](https://doi.org/10.24432/C5CG6D).

The dataset is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/legalcode). Derived tables apply overlap removal, type/whitespace normalization, transaction classification and aggregation as documented in the [analysis notebook](01_data_check.ipynb). Download the original workbook from the linked UCI dataset page; it is not redistributed here.

The [notebook](01_data_check.ipynb) and [validation record](VALIDATION.md) document the analysis and the checks performed.
