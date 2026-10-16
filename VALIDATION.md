# First milestone validation

Validated on 2026-10-16 using Python 3.13.2, pandas 3.0.6 and openpyxl 3.1.5 against the original UCI workbook.

- Notebook schema validated with nbformat.
- All 88 code cells executed sequentially in a fresh IPython process; outputs were regenerated and saved. No cell errors or warning outputs occurred.
- Reconciled combined rows (1,044,848), candidate product transaction rows (1,033,062), candidate net amount (GBP 18,981,261.52), monthly-scope rows (1,007,683) and 24 monthly observations.
- Original desktop notebook preserved. This publication copy adds headings, scope notes, a rerunnable name merge and reconciliation assertions; it omits the package-installation cell and its logs.

Validation used in-process IPython because the separate Jupyter kernel launch did not complete in the publishing environment. An IPython history-file write warning occurred on process shutdown after results were saved; it did not affect computations. The recommended local workflow remains Restart & Run All in Jupyter/VS Code.

This validates execution and the stated reconciliations, not every business interpretation. Final metric sensitivity, invoice-link validation, SQL replication, plots and dashboard review remain future work. Tables are retained as an audit trail in this first exploratory milestone.
