# Online Retail II — Sales Analytics

A historical retail analysis using **Python, PostgreSQL and Power BI** to examine sales trends, repeat purchasing and customer value.

**Data period:** December 2009–November 2011 · **Currency:** GBP · **RFM snapshot:** 1 December 2011

## 🔎 Overview

This project follows retail transactions from source workbook through Python analysis, PostgreSQL summaries and a three-page Power BI dashboard. It includes a business report, validation record and proposed experiment design.

**Status:** Analysis, dashboard, report and experiment proposal are complete. No experiment has been run. Pipeline automation remains an optional extension.

## 💼 Business Issue

The analysis asks three practical questions:

- How did net sales change over time, and what contributed to the April 2011 year-over-year decline?
- How often did customers make a purchase in the next calendar month?
- How concentrated were net sales among identified customers, and which historical RFM groups contributed most?

The data supports historical purchase activity and sales analysis. It does not verify customer acquisition dates, future value, profit or customer churn.

## 🧰 Solution

The work uses this flow:

**Excel workbook → Python notebook → transaction CSV → PostgreSQL → SQL summaries → Power BI**

The notebook prepares and validates transaction-level data. PostgreSQL scripts calculate monthly sales, April diagnostics, customer retention, customer value and exploratory RFM segments. The dashboard presents the resulting sales and customer views.

Database import, SQL-summary export and Power BI refresh are manual steps.

## 📊 Dashboard

[Download the Power BI dashboard](powerbi/Online_Retail_Dashboard.pbix?raw=true) · [Dashboard notes](powerbi/powerbi_notes.md)

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

## 📌 Key Findings

- **April 2011 net sales fell 24.42% year over year.** Lower positive sales explain about 85% of the decline; larger cancellation offsets explain the remainder. Correction records need investigation before treating cancellations as lost demand.
- **Weighted next-calendar-month purchase retention was 23.34%.** Excluding the first observed cohort gives 20.97%. These measure observed purchase activity; they are not verified acquisition retention or churn estimates.
- **32.25% of RFM customers contributed 77.96% of segment net sales.** This describes historical concentration among customers with known IDs and at least one positive order; it does not predict future value.

See the [business report](BUSINESS_REPORT.md) for interpretation and recommendations, and the [experiment proposal](EXPERIMENT_PROPOSAL.md) for a test design that has not yet been executed.

## 🧪 Definitions, Validation and Limitations

Net sales sum signed product line amounts, including cancellations; they are not profit. Sales include missing customer IDs, while customer analyses require identified customers. Partial December 2011 is excluded from dashboard metrics but included in full-period import checks.

Exact within-sheet duplicates remain in the baseline because matching fields alone do not establish an error. In the sensitivity scenario, removing them changes net sales by -0.2853%, leaves purchase retention unchanged and moves 12 of 5,824 customers (0.21%) between fixed-threshold RFM segments.

See the [metric definitions](powerbi/powerbi_notes.md#metric-definitions), [business report](BUSINESS_REPORT.md) and [validation record](VALIDATION.md) for details. Validation includes a fresh Python replay and manual SQL/dashboard reconciliation. It does not establish a clean-database end-to-end integration test or an automated PBIX refresh.

## 🗂️ Project Structure

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

## 📚 Data Source and Attribution

Chen, D. (2012). *[Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii)* [Dataset]. UCI Machine Learning Repository. [DOI: 10.24432/C5CG6D](https://doi.org/10.24432/C5CG6D).

The dataset is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/legalcode). Derived tables apply overlap removal, type and whitespace normalization, transaction classification and aggregation as documented in the [analysis notebook](01_data_check.ipynb). The original workbook is not redistributed here.
