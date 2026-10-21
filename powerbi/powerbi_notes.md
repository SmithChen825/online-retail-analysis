# Power BI Dashboard — Technical and Analytical Notes

## Purpose and scope

This report translates the Online Retail II SQL analysis into three interactive pages: sales performance, customer retention, and customer value. It is a historical portfolio analysis, not a live operational reporting service.

- **Observation window:** 1 December 2009–30 November 2011.
- **RFM snapshot:** 1 December 2011.
- **Currency:** GBP. Currency formatting does not perform foreign-exchange conversion.
- **Source:** [UCI Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii), processed through the project's Python and PostgreSQL workflow.
- **Excluded period:** December 2011 is incomplete and is excluded from the dashboard's transaction import and SQL summaries.

## Deliverables

| File | Purpose |
|---|---|
| [Online_Retail_Dashboard.pbix](Online_Retail_Dashboard.pbix) | Power BI Desktop report and imported model |
| [sales_overview.png](sales_overview.png) | Sales page preview |
| [customer_retention.png](customer_retention.png) | Retention page preview |
| [customer_value.png](customer_value.png) | Customer segmentation page preview |

The Validation page retains development reconciliation figures. It is intended to be hidden from the main presentation, rather than deleted.

## Data sources and model

| Model table | Source | Grain |
|---|---|---|
| `Transactions` | PostgreSQL `online_retail.public.product_transactions` | Product transaction line |
| `Calendar` | DAX calendar, 2009-01-01 through 2011-12-31 | One date |
| `CohortRetention` | `../data/processed/cohort_retention_summary.csv` | One first-observed-purchase month; 24 rows |
| `CustomerSegmentation` | `../data/processed/customer_segmentation_summary.csv` | One RFM group combination; 9 rows |

`Transactions` uses Import mode. The development connection is `localhost:5432`; another user must provide their own PostgreSQL connection and credentials. The transaction table contains cleaned product sales and cancellations, rather than every record from the raw workbook. Refer to the notebook and SQL for upstream exclusions and duplicate handling.

`Calendar[Date]` has an active one-to-many relationship to `Transactions[Invoice Date]`, with single-direction filtering from Calendar to Transactions. `Invoice Date` removes the time component of `invoice_date`. Calendar is marked as the date table; `Year Month` is sorted by `Year Month Sort`.

The two CSV summary tables are deliberately disconnected. They do not contain the customer-level or country-level detail needed to respond correctly to transaction filters. Sales-page country or transaction-date selections therefore do **not** recalculate cohort retention or RFM membership. These pages represent fixed SQL snapshots; country slicers must not be presented as controlling them.

Sales measures are grouped under Transactions; retention measures are grouped under CohortRetention. A measure's home table is organizational and does not itself create a relationship.

## Metric definitions

### Sales Overview

| Metric | Definition |
|---|---|
| Transaction Rows | Count of imported transaction lines, not orders |
| Net Sales | Sum of signed `line_amount`, including cancellations |
| Positive Sales | Sum of `line_amount` where `is_cancelled = FALSE()` |
| Orders | Distinct invoice count where `is_cancelled = FALSE()` |
| Average Order Value | Positive Sales / Orders |
| Cancellation Amount | Signed sum where `is_cancelled = TRUE()` |
| Cancellation Amount Rate | -Cancellation Amount / Positive Sales; an amount ratio, not an order cancellation rate |
| Net Sales LY | Net Sales evaluated using `SAMEPERIODLASTYEAR(Calendar[Date])` |
| Net Sales YoY % | (Net Sales - Net Sales LY) / Net Sales LY; blank when either period is missing |

Sales include transactions without a customer ID. The monthly comparison visual is restricted to dates >= 2009-12-01 and < 2011-12-01, preventing an out-of-window month from appearing solely because it has a prior-year value. The country chart uses Top 10 by Net Sales in the current filter context.

### Customer Retention

The source query is [05_customer_retention.sql](../sql/05_customer_retention.sql). Customers require a non-null ID and at least one non-cancelled purchase. Cohort month is the first qualifying purchase month **observed in this dataset**, not necessarily the customer's actual acquisition month.

Month 1, 3, and 6 retention measure purchase activity in the specific calendar month that many months after cohort entry. They are not cumulative retention or continuous monthly survival rates. A customer can return after skipping earlier months, so later retention can exceed earlier retention.

Power Query replaces literal CSV `NULL` with null, converts rate columns to numeric, divides by 100 once, and assigns percentage types. Unobservable periods remain blank and are colored white; all three heatmap columns use a common 0–50% color scale.

Weighted month-1 retention excludes cohorts without an observable month 1. Its numerator is retained customers and its denominator is eligible cohort customers. It is not an unweighted average of cohort percentages.

The current CSV contains rounded percentages rather than retained counts. The report reconstructs each cohort's month-1 count using `ROUND(cohort_size * month_1_pct, 0)` after conversion to fractional percentages, then sums those counts. For this export, the largest cohort is 951: percentage rounding introduces less than 0.05 customer of error per cohort, allowing the original integer count to be recovered. This assumption must be revisited if cohort sizes increase. A future export should include integer retained counts directly.

The sensitivity measure also excludes December 2009, because the first observed cohort may include established customers. November 2011 remains excluded from both month-1 calculations because December is outside the observation window.

### Customer Value

The source query is [07_customer_segmentation.sql](../sql/07_customer_segmentation.sql). The population is identified customers with at least one non-cancelled purchase before 2011-12-01.

| Dimension | Calculation | Higher/recent group threshold |
|---|---|---|
| Recency | Days from last non-cancelled purchase to 2011-12-01 | <= 100 days |
| Frequency | Distinct non-cancelled invoice count in the observation window | >= 3 orders |
| Monetary | Signed net sales including cancellations | >= GBP 835.46 |

Thresholds come from sample medians and are descriptive, not validated marketing rules. Customers with net sales <= 0 are flagged as `Review` / `Non-positive`; their negative contribution is retained. These flags override the usual recency and monetary labels.

`Segment` concatenates the three group labels. Charts use `CustomerSegmentation[net_amount]`, not the disconnected Transactions Net Sales measure. Customer Share and Net Sales Share are relative to the segmentation population. They do not use total dashboard sales as their denominator. Customers with only cancellation records are outside this population.

In Power Query, `net_amount` uses fixed decimal type without scaling. Only the two percentage columns are divided by 100. Display percentages with two decimal places and amounts as GBP. Rounded shares may not sum to exactly 100%.

## Reconciliation and interaction checks

The following values were checked during the Desktop walkthrough against the project SQL results. These are manual checks, not an automated test of the PBIX binary.

| Check | Expected result |
|---|---|
| Imported lines through November 2011 | 1,007,683 |
| Net Sales | GBP 18,539,895.01 |
| Positive Sales | GBP 19,085,461.19 |
| Cancellation Amount | GBP -545,566.18 |
| Orders | 38,700 |
| Average Order Value | GBP 493.16 |
| Cancellation Amount Rate | 2.86% |
| April 2010 / April 2011 Net Sales | GBP 638,968.56 / GBP 482,901.21 |
| April 2011 YoY | -24.42% |
| Cohort customers | 5,824 |
| Weighted month-1 retention | 1,315 / 5,633 = 23.34% |
| Month-1 retention excluding first cohort | 982 / 4,682 = 20.97% |
| More recent / Higher frequency / Higher value | 1,878 customers; 32.25% of customers; GBP 12,532,025.65; 77.96% of segment net sales |
| Non-positive group | 19 customers; GBP -1,549.46 |

Displayed currency is rounded to two decimal places; underlying sums may retain additional decimal places.

Interaction checks performed:

- Selecting United Kingdom changes sales cards and the monthly chart; the observed Net Sales is GBP 15,821,767.81 and Orders is 35,440.
- Selecting the highest-value RFM group filters the detail table to the matching 1,878-customer row.
- Selecting January 2010 in the cohort table produces 368 customers and 21.47% on both month-1 cards.
- Selecting November 2011 produces 191 customers and blank month-1 cards, rather than 0%.

Clear selections before saving the presentation state. Narrative text boxes are static and should be labeled as overall findings where they describe all groups.

## Refresh and handover

1. Prepare the PostgreSQL table using the project's documented Python export and SQL import workflow. Avoid importing the same CSV twice.
2. Re-run SQL 05 and 07 and export their results to the two summary CSVs. Refreshing Power BI alone does not execute these SQL files or regenerate the exports.
3. In Power BI Desktop, update the PostgreSQL source and local CSV paths through data source settings / Power Query as needed. Supply credentials locally; do not put passwords in documentation or the repository.
4. Verify the transaction cutoff and Power Query transformations. In particular, keep cancellation amounts signed, preserve nulls, and divide percentage columns by 100 exactly once.
5. Refresh the model and repeat the reconciliation checks above. Keep the snapshot date and observation window aligned across the transaction import and both CSV exports.
6. Clear visual selections, save the PBIX, and update all three screenshots from that saved state.

The PBIX includes imported data. A reviewer can inspect its saved results without access to the development database, but refreshing requires a working database and accessible CSV files. Scheduled service refresh and gateway deployment are not configured as part of this milestone.

## Interpretation and remaining limitations

- This is a historical, descriptive analysis. No causal effect, profit, lifetime value, or implemented commercial uplift is claimed.
- RFM uses a fixed snapshot and unequal customer observation lengths; newer customers have had less time to accumulate orders and spend.
- A non-cancelled invoice counts as purchase activity even if a later cancellation offsets its value. Cancellation dates are used as recorded, rather than reallocating adjustments to the original sale date.
- Missing customer IDs are retained in sales analysis but excluded from customer-based analyses.
- Within-sheet duplicate sensitivity has been assessed in the notebook for the dashboard window. Removing 11,511 matching product rows reduces net sales by GBP 52,895.50 (0.2853%); customer-month purchase activity is identical and 12 of 5,824 customers (0.21%) change fixed-threshold RFM segment. The dashboard retains the baseline records and does not independently deduplicate. See [validation details](../VALIDATION.md) for matching fields, floating-point handling and limitations.
- The current retention SQL is suitable for the observed export, but a generalized refresh must distinguish an observable month with zero purchasers from a future month. A cohort-month calendar grid is needed if zero-activity combinations are absent from future exports.
- The current release is a three-page dashboard milestone. Further visual polish, direct retained-count exports, and customer-level dynamic segmentation are follow-up work, not prerequisites for documenting this version.
