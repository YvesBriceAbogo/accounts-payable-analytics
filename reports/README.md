# Power BI Financial Dashboard

## Accounts Payable Analytics
### Supplier Debt Management, Payment Performance & Cash Flow Forecasting

**Author:** Brice Abogo  
**Reporting Tool:** Microsoft Power BI  
**Analytical Focus:** Accounts Payable | Supplier Risk | Cash Flow Planning

---

## 1. Report Overview

This directory contains the PDF version of the Accounts Payable Analytics dashboard developed in Microsoft Power BI.

The report provides an interactive analytical framework for monitoring supplier liabilities, payment performance, overdue invoices, and future payment obligations.

The PDF version enables reviewers to examine the dashboard without requiring access to Power BI Service.

---

## 2. Download the Dashboard

[Download Accounts Payable Dashboard (PDF)](accounts-payable-dashboard.pdf)

---

## 3. Dashboard Structure

The report consists of four analytical pages.

### Page 1 — Executive Financial Overview

Provides a consolidated summary of:

- Total purchases and payments.
- Outstanding supplier liabilities.
- Overdue and not-yet-due payables.
- Supplier payment rate.
- Estimated six-month DPO.
- Accounts payable aging.
- Actual versus forecast payments.
- Top suppliers by outstanding balance.
- Oldest outstanding invoices.

### Page 2 — Supplier Debt & Payment Analysis

Includes:

- Monthly supplier payment schedules.
- Actual supplier payments.
- Outstanding balances by supplier.
- Invoice status distribution.
- Cumulative purchases versus outstanding liabilities.

### Page 3 — Monthly Financial Performance

Includes:

- Monthly purchasing trends.
- Monthly payment trends.
- Year-to-date financial movements.
- Outstanding liabilities evolution.
- Monthly estimated DPO.
- Supplier invoice status analysis.

### Page 4 — Detailed Accounts Payable Register

Provides invoice-level information, including:

- Invoice number.
- Supplier name.
- Invoice amount.
- Payments recorded.
- Outstanding balance.
- Overdue liabilities.
- Not-yet-due liabilities.

---

## 4. Key Financial Indicators

| Financial KPI | Result |
|---|---:|
| Total Purchases | 62,320 |
| Total Payments | 14,760 |
| Outstanding Payables | 47,560 |
| Overdue Payables | 43,260 |
| Not-Yet-Due Payables | 4,300 |
| Payment Rate | 23.68% |
| Supplier Invoices | 55 |
| Fully Paid Invoices | 15 |
| Estimated Six-Month DPO | 154.60 days |

Monetary amounts are expressed in the dataset's reporting currency.

---

## 5. Dashboard Screenshots

The main dashboard screenshots are available in the project's image directory.

[View Dashboard Screenshots](../images/)

---

## 6. Power BI Report Availability

The Accounts Payable Analytics dashboard was developed
in Power BI Desktop and published to Power BI Service.

Public interactive access is currently unavailable
due to the sharing restrictions of the Power BI environment.

However, the complete dashboard can be explored through
the PDF report and the dashboard screenshots provided
in this repository.

### Available Resources

[**Download the Complete Dashboard (PDF)**](accounts-payable-dashboard.pdf)

[**View Dashboard Screenshots**](../images/)

The report includes four analytical pages covering
financial KPIs, supplier payment performance,
accounts payable aging, cash flow forecasting,
and detailed supplier invoice analysis.

---

## 7. Data Refresh Infrastructure

The project uses an On-premises Data Gateway (Standard Mode) to establish connectivity between locally hosted financial data and Power BI Service.

The infrastructure supports:

- Local data source connectivity.
- Semantic model management.
- Scheduled refresh configuration.
- Refresh monitoring.

Scheduled refresh requires the gateway and local data sources to remain available.

---

## 8. Methodological Note

The six-month DPO indicator is a customized estimate based on purchases and payments recorded during a dynamic reporting period.

It is not the conventional accounting DPO calculated using average accounts payable and credit purchases.

The detailed methodology is available in:

[Project Methodology](../documentation/methodology.md)

---

## 9. Related Resources

[Financial Insights](../documentation/financial-insights.md)

[DAX Measures](../dax/)

[Power Query Scripts](../powerquery/)

[Return to Main Project](../README.md)

---

**Author:** Brice Abogo  
**Project:** Accounts Payable Analytics
