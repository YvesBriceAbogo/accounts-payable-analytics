# DAX Financial Measures & Time Intelligence

## Accounts Payable Analytics Project

### 1. Overview

This directory contains the DAX measures and calculated tables developed for the Accounts Payable Analytics project.

The calculations transform supplier accounting data into financial performance indicators, supporting accounts payable monitoring, supplier payment analysis, financial reporting, and cash flow planning.

The DAX implementation covers five main analytical areas:

- Core financial KPIs.
- Accounts payable aging analysis.
- Supplier payment performance.
- Financial time intelligence.
- Supplier payment forecasting.

A dedicated calendar dimension supports dynamic reporting periods and time-based calculations.

---

## 2. DAX Scripts

The measures are organized into six files.

| File | Description |
|---|---|
| [01_financial_kpis.dax](01_financial_kpis.dax) | Purchases, payments, outstanding balances and invoice counts |
| [02_invoice_aging.dax](02_invoice_aging.dax) | Overdue and not-yet-due liabilities |
| [03_payment_performance.dax](03_payment_performance.dax) | Payment rate and dynamic six-month estimated DPO |
| [04_time_intelligence.dax](04_time_intelligence.dax) | YTD calculations and prior-year financial comparisons |
| [05_payment_forecasting.dax](05_payment_forecasting.dax) | Supplier payment forecasts based on contractual due dates |
| [06_calendar.dax](06_calendar.dax) | Calendar dimension and date attributes |

---

## 3. Core Financial KPIs

The project calculates the following indicators:

| KPI | Business Definition |
|---|---|
| Total Purchases | Total value of recorded supplier invoices |
| Total Payments | Total supplier payments recorded |
| Outstanding Payables | Difference between supplier purchases and payments |
| Total Invoice Balance | Sum of outstanding balances at invoice level |
| Supplier Invoice Count | Number of distinct supplier invoices |
| Fully Paid Invoices | Number of invoices classified as fully settled |

### Accounting Reconciliation

The fundamental accounting relationship is:

**Outstanding Payables = Total Purchases − Total Payments**

For the dataset:

```text
Total Purchases       62,320
Total Payments        14,760
Outstanding Payables  47,560
```

Therefore:

```text
62,320 - 14,760 = 47,560
```

This reconciliation supports the consistency of the financial information.

---

## 4. Accounts Payable Aging Analysis

The aging measures classify supplier liabilities according to their payment status and overdue period.

The categories include:

- Fully paid.
- Not yet due.
- Overdue: 0–30 days.
- Overdue: 31–60 days.
- Overdue: 61–90 days.
- Overdue: More than 90 days.

The analysis enables financial managers to identify overdue obligations and prioritize supplier payments.

### Financial Results

| Aging Category | Outstanding Balance |
|---|---:|
| Overdue 0–30 Days | 22,600 |
| Overdue 31–60 Days | 1,900 |
| Overdue 61–90 Days | 4,450 |
| Overdue >90 Days | 14,310 |
| Not Yet Due | 4,300 |
| **Total Outstanding Payables** | **47,560** |

Total overdue liabilities:

```text
22,600 + 1,900 + 4,450 + 14,310 = 43,260
```

These measures support accounts payable aging analysis and supplier payment risk assessment.

---

## 5. Supplier Payment Performance

### 5.1. Payment Rate

The payment rate measures the proportion of supplier purchases covered by recorded payments.

**Formula:**

```text
Payment Rate = Total Payments / Total Purchases
```

For the dataset:

```text
14,760 / 62,320 = 23.68%
```

The payment rate provides an indication of payment coverage within the selected reporting context.

It should not automatically be interpreted as the percentage of invoices issued during the period that were fully settled, since payments may relate to invoices from previous periods.

### 5.2. Estimated Days Payable Outstanding

The project uses a customized estimated DPO indicator calculated over a dynamic six-month reporting period.

**Formula:**

```text
Estimated DPO =
((Total Purchases - Total Payments) / Total Purchases)
× Number of Days in the Period
```

The calculation automatically identifies the latest supplier payment date and determines the corresponding six-month reporting period.

For example:

```text
Latest Payment Month: September 2026

Reporting Period:
April 1, 2026 - September 30, 2026
```

### Current Result

**Estimated Six-Month DPO: 154.60 days**

### Methodological Clarification

This indicator is a customized estimate based on purchases and payments recorded during the selected period.

It differs from conventional accounting DPO, which generally uses average accounts payable relative to credit purchases.

Consequently, it should not be interpreted as the actual average number of days between invoice issuance and payment.

The detailed calculation is available in:

[03_payment_performance.dax](03_payment_performance.dax)

---

## 6. Financial Time Intelligence

The project includes measures for analyzing financial trends over time.

### Year-to-Date Purchases

Tracks cumulative supplier purchases from the beginning of the calendar year.

### Year-to-Date Payments

Tracks cumulative supplier payments over the same period.

### Year-to-Date Net Payable Movement

Measures the cumulative difference between purchases and payments.

This indicator represents the net movement of supplier obligations during the reporting year, rather than necessarily the historical accounting balance.

### Previous-Year Comparisons

Prior-year measures support comparisons of payment performance across equivalent reporting periods.

The project also includes an estimated DPO calculation for the corresponding six-month period of the preceding year.

These calculations require sufficient historical data and a correctly configured calendar dimension.

---

## 7. Supplier Payment Forecasting

Payment forecasting measures use outstanding invoice balances and contractual payment due dates.

### Forecast Payments

Allocates outstanding supplier liabilities to their contractual due dates.

### Forecast Payments — Next Three Months

Calculates expected supplier payment obligations over the three calendar months following the latest recorded payment.

### Methodological Note

These calculations represent contractual payment schedules.

They do not constitute statistical predictions of actual payment behavior and do not incorporate future invoices that have not yet been recorded.

The detailed measures are available in:

[05_payment_forecasting.dax](05_payment_forecasting.dax)

---

## 8. Calendar Dimension

The Calendar table provides a continuous date dimension supporting financial time intelligence.

It covers relevant invoice dates, payment dates, and contractual due dates.

The dimension includes:

- Date.
- Year.
- Month.
- Month Number.
- Year-Month.
- Quarter.

It supports:

- Monthly and annual financial analysis.
- Year-to-date calculations.
- Prior-year comparisons.
- Rolling six-month calculations.
- Contractual payment forecasting.

The Calendar implementation is available in:

[06_calendar.dax](06_calendar.dax)

---

## 9. Advanced DAX Functions Used

| Function | Analytical Purpose |
|---|---|
| `CALCULATE()` | Modify filter context |
| `FILTER()` | Apply dynamic filtering conditions |
| `ALL()` | Remove filters from selected tables or columns |
| `REMOVEFILTERS()` | Clear filters for global reference calculations |
| `DIVIDE()` | Perform safe division |
| `SUM()` | Aggregate financial amounts |
| `DISTINCTCOUNT()` | Count unique invoices |
| `TOTALYTD()` | Calculate year-to-date financial values |
| `SAMEPERIODLASTYEAR()` | Compare equivalent historical periods |
| `EOMONTH()` | Determine month-end dates |
| `DATEDIFF()` | Calculate reporting period duration |
| `USERELATIONSHIP()` | Activate inactive date relationships |
| `DATE()` | Construct calendar dates |
| `CALENDAR()` | Generate a continuous date dimension |
| `FORMAT()` | Create formatted date attributes |

---

## 10. Financial & Analytical Skills Demonstrated

### Financial Expertise

- Accounts Payable Management.
- Supplier Payment Monitoring.
- Financial KPI Development.
- Working Capital Analysis.
- Cash Flow Planning.
- Invoice Aging Analysis.
- Financial Performance Reporting.
- Accounting Reconciliation.

### Technical Expertise

- DAX Measure Development.
- Filter Context Management.
- Financial Time Intelligence.
- Dynamic Period Calculations.
- Active and Inactive Relationships.
- KPI Optimization.
- Power BI Data Modeling.
- Dashboard Analytics.

---

## 11. Implementation Notes

The DAX scripts are provided for documentation and demonstration purposes.

They should be implemented and tested within a Power BI semantic model containing the required tables and relationships.

Measures should be created individually in Power BI Desktop.

Calculated tables and calculated columns should be created using their respective modeling commands.

The following conditions are important:

- A properly configured Calendar date table.
- Correct relationships between financial transaction dates and the Calendar dimension.
- Consistent invoice identifiers.
- Accurate invoice-payment reconciliation.
- Correct data types.
- Valid payment status classifications.

---

## 12. Related Project Resources

[Power Query ETL Scripts](../powerquery/)

[Dataset Documentation](../data/)

[Dashboard Screenshots](../images/)

[Return to Main Project](../README.md)

---

**Author:** Brice Abogo  
**Project:** Accounts Payable Analytics  
**Specialization:** Financial Analysis | Accounting | Business Intelligence
