# Experiment Proposal: Does a Purchase Reminder Increase Repeat Purchasing?

**Status: proposed design only. No customers have been contacted, no experiment has run, and no uplift is claimed.**

## 1. Decision and rationale

Test whether a single, non-discount purchase reminder increases the probability of another purchase among eligible recent purchasers. The decision is whether to expand the reminder program after accounting for customer experience and incremental value.

The [business report](BUSINESS_REPORT.md) found weighted next-calendar-month purchase retention of 23.34%, or 20.97% after excluding the first observed cohort. These descriptive results motivate investigating repeat purchasing; they do not establish that reminders work or that customers need one.

The historical retention figures are **not the control baseline for this experiment**. They measure a specific calendar month after first observed purchase, whereas this proposal follows customers for 30 days after assignment and uses a narrower eligibility definition. Neither 5,824 historical customers nor any historical RFM group is an estimate of the available experiment sample.

## 2. Hypothesis and intervention

**Hypothesis:** among eligible customers, receiving one useful purchase reminder increases the 30-day repeat-purchase rate compared with receiving no experimental reminder.

| Arm | Experience |
| --- | --- |
| Control | Existing business-as-usual experience, without the experimental reminder |
| Treatment | The same experience plus one reminder at assignment, linking to relevant available products; no discount |

Use one approved message and a fixed product-selection rule. Hold prices, incentives and eligibility rules constant across arms. Record other campaigns and apply the same campaign policy to both arms. Do not let assignment trigger additional follow-up messages during the measurement window.

This tests the reminder package as a whole. It does not separately identify the effect of wording, timing or product recommendations.

## 3. Eligibility and assignment

The following are **proposed design choices**, to be checked against purchase cycles and operational feasibility before launch:

- An identified customer reaches 30 days after a qualifying purchase and has made no later qualifying purchase by the assignment time.
- The customer has a deliverable, permitted marketing contact channel and is not opted out or suppressed.
- The triggering order is fulfilled and is not known to be fully cancelled or returned at assignment; no unresolved order complaint is present.
- Relevant products are available. Exclude staff/test accounts and customers already in a conflicting campaign using rules fixed before assignment.
- Each customer enters once. Eligibility uses only information available before assignment; later purchases or cancellations do not retroactively remove a customer.

Randomize eligible customers **1:1 at customer level**, using a reproducible assignment process. Assign a timestamp to both arms, even though control receives no reminder. Persist the assignment so retries or later orders cannot change the arm. If several customer IDs belong to one account, resolve that identity before randomization to prevent cross-arm exposure.

For rolling enrollment, randomize within enrollment-week blocks to limit calendar imbalance. Assignment should be independent of marketing staff judgment. Use customer-level analysis, not invoice-line analysis.

The 30-day trigger is not derived from the RFM recency threshold of 100 days. Historical product purchase intervals must first show that a reminder at this point is plausible. If they do not, revise the trigger and planning baseline before launch.

## 4. Metrics and observation windows

### Primary metric: 30-day repeat-purchase rate

For each randomized customer, define an outcome of 1 if they place at least one qualifying positive product order during **[assignment time, assignment time + 30 days)**, and 0 otherwise. Count purchases across all observable channels, not just orders attributed to a reminder click.

`Repeat-purchase rate = customers with outcome 1 / all randomized customers in the arm`

The primary effect is treatment rate minus control rate, expressed in **percentage points**. Also report relative lift, with its denominator stated. Multiple orders still contribute only one success to this metric. This is a purchase-activity outcome: a later return does not reverse the primary outcome, but is reflected in the financial and cancellation measures below.

### Secondary and guardrail metrics

| Metric | Definition and purpose |
| --- | --- |
| Orders per randomized customer | Number of qualifying orders in the 30-day window divided by all assigned customers |
| Net order value per randomized customer | Positive value of orders placed in the window, less linked cancellations/returns observed by day 60 after assignment, divided by all assigned customers |
| Contribution per randomized customer | Net order value less product, fulfillment, return and messaging costs, when those costs are available |
| Cancellation/return value rate | Absolute linked cancellation/return value divided by positive value of window orders; report numerator and denominator separately |
| Unsubscribe and complaint rates | Customers with each event during the 30-day window divided by all randomized customers; treatment recipient-based rates may additionally support delivery diagnostics |
| Delivery rate | Delivered reminders divided by treatment customers; an implementation diagnostic, not the primary success criterion |

Customers with no orders contribute zero to order and value averages. Do not restrict financial comparisons to purchasers, because purchasing can itself be affected by treatment. An arm with no positive order value has an undefined cancellation value rate, not a zero rate.

The financial metric requires reliable order-to-adjustment linkage. It deliberately differs from the dashboard's recorded-month signed net sales. Day 60 provides at least 30 days of adjustment follow-up for orders placed near the end of the purchase window; later returns remain outside this proposed horizon and must be disclosed. Confirm that this horizon fits actual return practices before launch.

## 5. Sample size and duration

No defensible sample-size number is available from the current published summaries alone. Before launch:

1. Reconstruct historical eligibility using the same 30-day trigger and complete subsequent follow-up, without using future information to select customers.
2. Estimate the matched 30-day control purchase rate and the weekly number of eligible, contactable customers. Check variation across calendar periods.
3. Set the smallest absolute improvement worth detecting based on expected contribution and messaging cost, rather than selecting an effect merely because it needs fewer customers.
4. Calculate a two-independent-proportion sample size for equal allocation, **two-sided 5% significance and 80% power**. Document the chosen baseline, minimum detectable effect, method and required number per arm. Assess whether the financial guardrails can be estimated with useful precision too.
5. Estimate enrollment time from that sample and eligible volume, then add 30 days for the last customer's purchase outcome and wait until day 60 for their financial follow-up.

Use a fixed sample target and a predeclared maximum enrollment period. If the eligible volume cannot support a useful effect size, revise the design or run a feasibility pilot explicitly without an effectiveness claim. Do not use 23.34% as a plug-in baseline or the entire historical customer population as an available mailing list.

## 6. Analysis plan

Analyze by **intention to treat**: every randomized customer remains in the assigned arm, including treatment customers whose reminder fails to deliver or is never opened. Opens, clicks and delivered-only comparisons are exploratory because those subsets are selected after assignment.

- Report arm sizes, observed purchase rates, the absolute difference and a 95% confidence interval using a prespecified two-proportion method. Use the single primary outcome for the main hypothesis test.
- Respect the enrollment blocks in the analysis; prespecify the block-adjusted estimator and variance method before launch. Show the unadjusted arm rates for transparency.
- For customer-level value outcomes, report means and their difference with customer-level uncertainty estimates. Inspect large orders and corrections without deleting valid high-value customers after seeing the result.
- Inspect assignment ratios, duplicate assignments, missing outcomes, delivery failures and accidental control exposure. Investigate a sample-ratio mismatch or broken tracking before interpreting uplift.
- Keep cohort or RFM subgroup comparisons exploratory unless separately powered and prespecified. Do not select a winning subgroup from many comparisons and present it as the overall result.

Wait for the planned sample and follow-up before the effectiveness analysis. Do not stop early because a significance threshold is crossed. Operational safety monitoring can pause sends for complaints or implementation failures under predeclared rules; such a pause does not establish effectiveness. Missing transaction coverage is a data-quality issue, not evidence that affected customers made no purchases.

## 7. Decision rules

Before launch, record a minimum worthwhile effect, a minimum acceptable incremental contribution, and maximum tolerable increases in complaint, unsubscribe and cancellation measures. Set these with business context; the historical dataset cannot supply them.

| Outcome | Decision |
| --- | --- |
| Credible positive primary effect, economically useful magnitude, and acceptable value/customer-experience guardrails | Consider a controlled expansion with continued monitoring |
| Confidence interval includes both no improvement and a worthwhile effect | Inconclusive; do not label the reminder successful or ineffective |
| Results rule out a worthwhile improvement, or economics are unfavorable | Do not scale the tested reminder |
| Material customer harm, assignment failure or unreliable measurement | Pause and investigate; resolve the issue before drawing an effectiveness conclusion |

Statistical significance alone is not a rollout decision. Guardrails should be assessed against their predeclared tolerances and uncertainty, rather than treating a non-significant harm estimate as proof of safety. If costs or linked returns are missing, a higher purchase rate alone does not demonstrate profitable growth.

## 8. Required data and launch checklist

The current Online Retail II file contains transaction records, not an experiment-ready marketing dataset. Additional operational data is required:

| Data | Minimum fields or evidence |
| --- | --- |
| Assignment | Experiment ID, customer/account ID, arm, assignment timestamp, enrollment block and eligibility-rule version |
| Eligibility snapshot | Triggering order, fulfillment status, contact permission, suppression status and relevant product availability at assignment |
| Exposure | Reminder attempt, delivery/failure timestamp, message version and other campaign exposure |
| Outcomes | Customer-linked orders from all measured channels, timestamps, product value and linked returns/cancellations |
| Economics and experience | Relevant costs, unsubscribe events, complaints and their timestamps |

Before launching, verify that the assignment log is unique and immutable, both arms have equivalent outcome coverage, control cannot receive the experimental message, and all timing uses one documented timezone. Freeze the eligibility, metric, sample-size and decision rules before viewing treatment effects.

This proposal sends no messages and creates no campaign. A future implementation requires a live eligible population, operational review and a separately authorized launch.

## Evidence and project links

- [Business report](BUSINESS_REPORT.md): commercial findings and proposed next steps.
- [Analysis notebook](01_data_check.ipynb): transaction definitions and descriptive checks.
- [Power BI notes](powerbi/powerbi_notes.md): cohort definitions, denominators and dashboard limits.
- [Validation record](VALIDATION.md): duplicate sensitivity, which supports the descriptive findings but does not validate an intervention effect.

The deliverable is a testable experiment design. There are no fabricated treatment assignments, p-values, confidence intervals, sample-size estimates or results.
