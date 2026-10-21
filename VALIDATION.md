# Validation record

## Manual SQL and dashboard reconciliation

Evidence: user-supplied pgAdmin and Power BI screenshots during the final local walkthrough. The user operated the desktop applications and reported exporting the SQL summaries. Screenshots supplied after the refresh instructions were checked for displayed values; the refresh operation and final PBIX save were not independently observed by the reviewer.

| Check | Observed result |
| --- | --- |
| Existing PostgreSQL transaction table | 1,033,062 rows; GBP 18,981,261.52 net amount; 227,214 missing customer IDs |
| SQL 05 rerun | 24 cohort rows, December 2009–November 2011; first cohort 951 customers; November 2011 191 customers with NULL retention |
| SQL 07 rerun | 9 RFM groups; 5,824 customers; leading group 1,878 customers and GBP 12,532,025.65 |
| Sales Overview | Net Sales GBP 18,539,895.01; Orders 38,700; AOV GBP 493.16; Cancellation Amount Rate 2.86% |
| Customer Retention | 5,824 customers; weighted month-1 retention 23.34%; excluding first cohort 20.97%; unobservable cells blank |
| Customer Value | Leading group 32.25% of customers and 77.96% of segment net sales; Review group 19 customers and GBP -1,549.46 |

These checks passed against the documented baseline. This walkthrough validated the existing database and reran SQL 05/07; it did not recreate the database, reimport transactions, rerun every SQL script, or repeat the earlier interaction tests. No GitHub upload or Power BI service publication was performed. The owner should save the final PBIX with cleared selections before handover.


## Reproducibility and documentation review — 21 October 2026

The current 99-code-cell notebook was also replayed in a fresh IPython process from an isolated project copy using Python 3.13.2, pandas 3.0.6 and openpyxl 3.1.5. The installation cell was skipped because those packages were already installed; all 98 analysis/export cells completed without execution errors. The regenerated export reconciled to 1,033,062 rows, GBP 18,981,261.52 net amount and 227,214 missing customer IDs. Original saved notebook outputs were preserved. IPython emitted a read-only history-database warning on process exit after successful calculation/export; this was not a notebook-cell failure. Dependency installation and a separate Jupyter-kernel launch were not tested in this run.

Local Markdown file links and notebook format validation passed. The published reference snapshots contain 24 cohorts and 9 RFM groups, each covering 5,824 customers. The desktop SQL 06 file had duplicated the RFM query; it was restored to the customer-concentration query. An independent pandas aggregation of the existing transaction CSV reproduced Top 10 / 50 / 100 shares of 16.23% / 29.56% / 36.68%. This checks the intended calculation, not PostgreSQL execution.

README now distinguishes the automatic notebook export from the optional kernel-dependent helper, and reference CSV snapshots from newly executed SQL results. The business report and experiment proposal are linked with accurate completion status. No new PostgreSQL import, PBIX refresh, experiment execution or GitHub publication was performed during this review. Notebook visual rendering was not re-inspected; its source and saved outputs were left unchanged.


## Duplicate sensitivity milestone — 21 October 2026

Evidence: the saved outputs and code in [01_data_check.ipynb](01_data_check.ipynb), under **Dashboard-scope duplicate sensitivity**. The saved notebook has sequential execution counts 1–99 and no error outputs. This publication review checked those saved results and the cell order; it did not independently rerun the workbook or refresh PostgreSQL or Power BI. To reproduce, place the UCI workbook at `sql/online_retail_II.xlsx`, start from the repository root and use **Restart & Run All** in Jupyter or VS Code.

### Method and scope

The comparison uses product-sale and product-cancellation candidates before 1 December 2011, matching the dashboard window. The baseline retains within-sheet duplicates. The alternative keeps the first occurrence matching `Invoice`, `StockCode`, `Description`, `Quantity`, `InvoiceDate`, `Price`, `Customer ID`, `Country` and `source_sheet`, after the existing type and whitespace normalization. Derived fields are not part of the duplicate key. Source-sheet overlap removal is a separate, earlier step.

Sales include missing customer IDs. Customer analyses require an identified customer with at least one positive purchase. Monetary value includes signed product sales and cancellations for those customers. The RFM snapshot is 1 December 2011; both scenarios use the original fixed thresholds: recency <= 100 days, frequency >= 3 distinct orders and monetary >= GBP 835.46. Medians are not recalculated after deduplication.

### Results

| Check | Baseline | Deduplicated | Change |
| --- | ---: | ---: | ---: |
| Product transaction rows | 1,007,683 | 996,172 | -11,511 (-1.1423%) |
| Net sales (GBP) | 18,539,895.01 | 18,486,999.51 | -52,895.50 (-0.2853%) |
| Positive sales (GBP) | 19,085,461.19 | 19,029,370.72 | -56,090.47 (-0.2939%) |
| Non-cancelled orders | 38,700 | 38,700 | 0 |
| Average order value (GBP) | 493.16 | 491.72 | -1.45 before display rounding |
| April 2011 net-sales YoY | -24.4249% | -24.2417% | +0.1832 percentage points |
| Distinct customer-month purchase pairs | 24,889 | 24,889 | No additions or removals |
| RFM customer population | 5,824 | 5,824 | Identical customer IDs |
| More recent / Higher frequency / Higher value customers | 1,878 | 1,874 | -4 |
| That segment's share of RFM net sales | 77.9637% | 77.9830% | +0.0193 percentage points |
| Review / Non-positive customers | 19 | 19 | 0 |

Customer last-purchase dates and distinct-order frequencies are unchanged; 1,578 customers have a net-spending change greater than GBP 0.01. Twelve customers (0.21%) move from Higher value to Lower value: seven in the less-recent/higher-frequency group, one in less-recent/lower-frequency and four in more-recent/higher-frequency.

Identical customer-month purchase activity implies unchanged first-observed-purchase cohorts and month 1/3/6 purchase retention under the same observation rules. This check compares purchase activity sets rather than rerunning the Power BI measures.

### Floating-point handling

Sixteen baseline customers have net spending close to zero. Binary floating-point residuals previously put five effectively zero customers in positive-value groups. Before segmentation, absolute monetary values below GBP 0.00000001 (`1e-8`) are normalized to zero in both RFM tables. This restores the 19-customer Review group and baseline agreement with the published SQL/dashboard summary. This is a numerical tolerance, not a GBP 0.01 business threshold or rounding of all spending.

### Interpretation and boundaries

The April sales-decline, purchase-retention and customer-concentration findings are stable under this specific duplicate-removal scenario. This does not prove that matching rows are erroneous, test recalculated RFM thresholds, or validate other cleaning alternatives. Baseline exports, SQL results and the PBIX continue to retain the records.

The earlier full-period raw-data check removed 11,812 rows and changed recorded amount by GBP 54,228.42. It precedes the product and dashboard-window restrictions and must not be substituted for the results above.

## Earlier validation history

On 16 October 2026, the first publication copy was validated with nbformat and all 88 code cells were executed sequentially in a fresh IPython process using Python 3.13.2, pandas 3.0.6 and openpyxl 3.1.5. That run reconciled 1,044,848 combined rows, 1,033,062 candidate product rows, GBP 18,981,261.52 full-period net amount, 1,007,683 monthly-scope rows and 24 monthly observations. These execution details describe the earlier artifact, not an independent fresh run of the current 99-cell version.

The earlier run used in-process IPython because a separate Jupyter kernel launch did not complete; an IPython history-file warning occurred after results were saved. SQL was subsequently executed interactively in pgAdmin and dashboard checks were performed manually, as documented in [Power BI notes](powerbi/powerbi_notes.md). No automated fresh-database or PBIX integration test is claimed.

The [business report](BUSINESS_REPORT.md) and [experiment proposal](EXPERIMENT_PROPOSAL.md) are complete. No experiment has been executed. Pipeline automation and broader correction/invoice-link investigation remain optional extensions. The later manual walkthrough is recorded above. A clean-database import remains untested; Python execution alone does not establish a PBIX refresh.
