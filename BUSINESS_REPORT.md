# Online Retail II: Sales Decline, Repeat Purchasing and Customer Concentration

## Executive summary

This historical analysis identifies three priorities for commercial investigation: understand the April sales decline, measure repeat purchasing with consistent follow-up windows, and review the customers contributing most to recorded sales.

- **April 2011 net sales fell 24.42% year over year.** Lower positive sales explain about 85% of the GBP 156.1k decline; larger cancellation offsets explain the remainder. A major cancellation has evidence of a possible correction, so cancellation value should not automatically be interpreted as lost demand.
- **23.34% of eligible identified customers purchased in the next calendar month.** Excluding the first observed cohort reduces this to 20.97%. These are purchase-activity measures, not acquisition-based retention or churn estimates.
- **32.25% of RFM customers contributed 77.96% of segment net sales.** This supports prioritizing account-level review, but does not show that these customers will remain valuable or respond profitably to an intervention.

Duplicate-removal sensitivity leaves these main findings broadly unchanged. The recommended next step is a focused review of customer purchasing and correction records before launching the test described in the completed [experiment proposal](EXPERIMENT_PROPOSAL.md); the data does not support a blanket discount campaign or a claimed revenue uplift.

## Scope and baseline

The report covers **1 December 2009–30 November 2011**, with customer segmentation measured as of **1 December 2011**. Partial December 2011 is excluded. All amounts are in GBP.

| Baseline metric | Value | Definition |
| --- | ---: | --- |
| Product transaction lines | 1,007,683 | Candidate product sales and cancellations |
| Net sales | 18,539,895.01 | Sum of signed line amounts |
| Positive sales | 19,085,461.19 | Non-cancelled product sales |
| Cancellation amount | -545,566.18 | Signed product cancellation amounts |
| Orders | 38,700 | Distinct non-cancelled invoices |
| Average order value | 493.16 | Positive sales divided by orders |
| Cancellation amount rate | 2.86% | Absolute cancellation amount divided by positive sales |

Net sales here is recorded transaction value, not profit or accounting revenue. Sales include missing customer IDs; retention and RFM use identified customers with qualifying purchases. Their denominators therefore differ. The baseline retains within-sheet duplicates.

Source: [Power BI reconciliation notes](powerbi/powerbi_notes.md) and the saved outputs in [the analysis notebook](01_data_check.ipynb).

## 1. Lower positive sales account for most of the April decline

| April metric | 2010 | 2011 | Change |
| --- | ---: | ---: | ---: |
| Positive sales (GBP) | 648,993.82 | 516,218.12 | -132,775.70 |
| Signed cancellations (GBP) | -10,025.26 | -33,316.91 | -23,291.65 |
| Net sales (GBP) | 638,968.56 | 482,901.21 | -156,067.35 |
| Orders | 1,435 | 1,235 | -200 |
| Average order value (GBP) | 452.26 | 417.99 | -34.27 |
| Days with recorded positive sales | 23 | 21 | -2 |
| Orders per active sales day | 62.39 | 58.81 | -3.58 |

The GBP 132.8k reduction in positive sales accounts for approximately **85.08%** of the net decline; the GBP 23.3k increase in cancellation offsets accounts for **14.92%**. These are arithmetic contributions, not causal estimates. Positive sales fell alongside fewer recorded sales days, fewer orders per active day and lower value per order. Days without recorded sales are not proof that the business was closed.

The United Kingdom recorded the largest country-level reduction in positive sales, at **GBP 92.0k**. Among UK customers purchasing in both Aprils, three customers with large April declines also spent less across March–May 2011. Purchases in the surrounding months did not fully offset their April decline, but the data cannot distinguish changing demand from stock availability, service issues or purchasing cycles.

Cancellation invoice **C550456** recorded GBP 23.0k of negative value. A positive invoice from the same customer followed twelve minutes later, and later zero-value records referenced an incorrect credit. This supports investigating a correction/re-invoicing explanation rather than treating the whole cancellation as lost demand. It does not establish that all cancellations are corrections.

**Recommended action:** review the largest UK customer declines alongside order histories, stock availability and service records, and reconcile the major cancellation with its related invoices. The review should determine whether the issue calls for customer outreach, an operational fix or better transaction classification.

Source: notebook Section 9, **Monthly sales and April diagnostics**; [April SQL diagnostics](sql/04_april_sales_diagnostics.sql).

## 2. Next-month purchasing depends on the cohort definition

| Month-1 purchase measure | Returning customers | Eligible customers | Rate |
| --- | ---: | ---: | ---: |
| All observable cohorts | 1,315 | 5,633 | 23.34% |
| Excluding December 2009 cohort | 982 | 4,682 | 20.97% |

A cohort is the month of a customer's **first observed positive purchase**. Customers already active before the dataset begins can enter the December 2009 cohort, so it cannot be treated as a verified new-customer cohort. Excluding it changes the pooled rate by **2.37 percentage points**; this comparison shows sensitivity to cohort composition, not a deterioration over time.

November 2011 customers have no observable month 1 within the reporting window and are excluded from both denominators. Month 1, 3 and 6 refer to purchases in those specific later calendar months. They are not cumulative measures: a customer may skip a month and return later. A blank future month is not zero retention, and absence in the next month is not confirmed churn. Purchase activity can also count even when a later cancellation offsets its value.

**Recommended action:** use the cohort view to monitor repeat purchasing at comparable customer ages, keeping immature cohorts out of the denominator. Before launching the [proposed reminder experiment](EXPERIMENT_PROPOSAL.md), establish whether the products have a plausible repeat-purchase cycle and whether eligible customers can be contacted. A future test should measure incremental repeat purchasing and net value against a randomized control group; no intervention effect is estimated here.

Source: [cohort SQL](sql/05_customer_retention.sql), [cohort results](results/cohort_retention_summary.csv) and [Power BI measure definitions](powerbi/powerbi_notes.md). Pooled returning counts are reconstructed from the rounded cohort rates as documented in those notes.

## 3. A relatively small customer group accounts for most segment sales

RFM groups customers by **recency** of purchase, **frequency** of orders and **monetary** value. The sample-based thresholds are recency <= 100 days, at least 3 orders and net spending >= GBP 835.46.

| Selected RFM group | Customers | Customer share | Net sales (GBP) | Share of RFM net sales |
| --- | ---: | ---: | ---: | ---: |
| More recent / Higher frequency / Higher value | 1,878 | 32.25% | 12,532,025.65 | 77.96% |
| Less recent / Higher frequency / Higher value | 737 | 12.65% | 2,016,386.35 | 12.54% |
| Review / Lower frequency / Non-positive | 19 | 0.33% | -1,549.46 | -0.01% |

The table shows selected groups from the full nine-group segmentation. Its population is **5,824 identified customers with at least one positive order**. Monetary value includes their cancellations; cancellation-only customers are outside the population. Sales shares do not use total dashboard sales as the denominator.

This concentration means changes in the spending of the largest contributing group can materially affect aggregate results. The less-recent, higher-frequency, higher-value group is a reasonable candidate for account review, but recency over 100 days does not by itself prove that a customer is lost. Customer tenure also affects both frequency and accumulated spending.

**Recommended action:** prioritize understanding the needs and service experience of major contributors, and investigate less-recent repeat purchasers before selecting a reactivation audience. Review the non-positive group for transaction corrections or returns. Do not treat historical spending as predicted lifetime value or assume that incentives would generate profitable incremental sales; margin, contactability and experimental evidence are missing.

Source: [RFM SQL](sql/07_customer_segmentation.sql) and [complete segment results](results/customer_segmentation_summary.csv).

## 4. Duplicate sensitivity supports the findings within a defined scenario

Removing 11,511 matching product rows within source sheets, using the same reporting cutoff, produces the following differences:

| Check | Result |
| --- | --- |
| Net sales | Decrease of GBP 52,895.50 (0.2853%) |
| April 2011 net-sales YoY | -24.42% becomes -24.24%; +0.1832 percentage points before display rounding |
| Customer-month purchase activity | Identical 24,889 pairs; no additions or removals |
| RFM membership | 12 of 5,824 customers (0.21%) change groups |
| Largest contributing group's sales share | 77.9637% becomes 77.9830% |

Identical purchase activity preserves cohorts and purchase retention under the same observation rules. RFM uses the original fixed thresholds in both scenarios; it does not recalculate medians after deduplication. Tiny monetary residuals below GBP 1e-8 in absolute value are normalized to zero before classifying non-positive customers.

These results support retaining the main interpretations under this particular alternative. They do not prove that matching rows are erroneous or that every cleaning choice is immaterial. The published dashboard continues to use the retained-duplicate baseline. Full methods and verification history are in [VALIDATION.md](VALIDATION.md).

## Limitations and decision boundaries

- Missing customer IDs limit customer-level coverage. In the notebook's full-period candidate positive-sales scope, they account for 22.35% of lines and 13.08% of positive value; these are not recalculated dashboard-window coverage rates.
- Product records are candidates after known non-product codes are separated. Ambiguous descriptions and correction records still require business context.
- Cancellations remain in their recorded month and are not systematically matched back to original purchases. Both monthly comparisons and customer monetary values reflect this policy.
- Customer acquisition dates, margins, inventory availability, marketing exposure and service history are unavailable. The report cannot establish causes, profitability, lifetime value or campaign impact.
- This report synthesizes saved notebook outputs, SQL exports and documented dashboard checks. It does not claim a new database execution, a refreshed PBIX or an independent end-to-end production test.

## Suggested sequence of work

1. **Explain the largest observed changes:** reconcile the major correction records and review declining UK accounts with operational context.
2. **Define an eligible intervention population:** use purchase cycles, contactability and customer history to narrow a potential repeat-purchase or reactivation test.
3. **Validate the proposal before rollout:** the [experiment proposal](EXPERIMENT_PROPOSAL.md) already defines randomization, outcomes, observation windows and guardrails. Confirm eligibility and operational feasibility, then finalize the minimum detectable effect, sample size and analysis plan using suitable pilot or operational data. No experiment has been run.

These are proposed next steps for a historical portfolio case study, not actions taken or measured commercial outcomes.

## Evidence and report navigation

- [Experiment proposal](EXPERIMENT_PROPOSAL.md): completed test design and requirements before launch; no experimental results.
- [Validation record](VALIDATION.md): execution evidence, manual reconciliation and remaining test boundaries.

- [Analysis notebook](01_data_check.ipynb): source quality checks, transaction definitions, sensitivity results and April investigation.
- [Power BI workbook](powerbi/Online_Retail_Dashboard.pbix): saved interactive presentation; [technical notes](powerbi/powerbi_notes.md) document definitions and reconciliation checks.
- [Sales overview](powerbi/sales_overview.png), [cohort retention](powerbi/customer_retention.png) and [customer value](powerbi/customer_value.png): report-page previews.
- [SQL analyses](sql/): reproducible analytical definitions; [results](results/): exported cohort and segmentation tables.

Dataset: Chen, D. (2012), *Online Retail II*, UCI Machine Learning Repository, DOI: 10.24432/C5CG6D. See the project README for attribution and reproduction instructions.
