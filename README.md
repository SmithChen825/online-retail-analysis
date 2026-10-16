# Online Retail II — Sales Analytics

**Status: work in progress. First public milestone: data quality and exploratory diagnostics.**

A personal portfolio project investigating historical retail transactions with Python/pandas. The goal is to connect data-quality decisions to interpretable sales, customer and product metrics. SQL, a BI dashboard, repeat-purchase analysis and an experiment proposal are planned; they are not completed features.

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
- [ ] Define customer repeat-purchase metrics and observation windows
- [ ] Load data into PostgreSQL and reproduce core metrics in SQL
- [ ] Build a Power BI or Tableau dashboard
- [ ] Write a business report and an A/B test proposal

## Source and attribution

Chen, D. (2012). *Online Retail II* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D. Dataset license: **Creative Commons Attribution 4.0 International (CC BY 4.0)**. Derived tables apply overlap removal, type/whitespace normalization, transaction classification and aggregation as documented in the notebook. The original workbook is distributed by UCI, not this repository.

This project was developed with AI-assisted tutoring, code explanation and publication preparation. The notebook documents the analysis and its unresolved questions.
