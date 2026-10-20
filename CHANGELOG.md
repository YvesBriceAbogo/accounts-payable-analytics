# Changelog

All notable changes to the **Accounts Payable Analytics** project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-05-18

### Added
- **Power Query ETL & Accounting Reconciliation (`powerquery/`):**
  - Extraction, cleaning, and standardization of supplier invoices (`DETTES`), supplier payments (`REGLEMENTS`), supplier master data (`LISTEF`), and date dimension (`Calendar`).
  - Invoice-level payment aggregation and automated reconciliation (`62,320` Purchases − `14,760` Payments = `47,560` Outstanding Payables).
  - Contractual due-date calculation, overdue day tracking, and aging status classification (`43,260` Overdue + `4,300` Not-Yet-Due = `47,560` Outstanding).
- **SQL Server Validation (`sql/`):**
  - SQL scripts verifying invoice totals, payment coverage, supplier balances, and aging breakdowns.
- **DAX Financial Measures (`dax/`):**
  - Core Accounts Payable KPIs: Total Purchases, Total Payments, Outstanding Payables, Overdue Payables, Not-Yet-Due Payables, and Payment Rate (`23.68%`).
  - Dynamic 6-month Estimated Days Payable Outstanding (`154.60 days`).
  - Cumulative YTD purchasing/payment trends and short-term cash outflow forecasting based on contractual due dates.
- **4-Page Power BI Dashboard (`reports/` & `images/`):**
  - *Page 1 — Executive Financial Overview:* Headline KPIs, AP aging structure, top 5 oldest invoices, and top 5 supplier exposures (`65.29%` concentration).
  - *Page 2 — Supplier Debt & Payment Analysis:* Monthly payment forecasts, actual payments by supplier, and debt breakdown by invoice status.
  - *Page 3 — Monthly Financial Performance:* Monthly and YTD purchasing/payment trends, outstanding balance evolution, and monthly DPO indicators.
  - *Page 4 — Detailed Accounts Payable Register:* Granular invoice-level reconciliation register (`55` invoices: `15` paid, `36` overdue, `4` not yet due).
- **Documentation & Cloud Deployment (`documentation/`):**
  - End-to-end technical documentation, Power BI Service publication notes, On-Premises Data Gateway setup, and exported PDF dashboard (`reports/accounts-payable-dashboard.pdf`).
