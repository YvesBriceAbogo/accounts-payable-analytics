# Project Methodology

## Accounts Payable Analytics
### Supplier Debt Management, Payment Performance & Cash Flow Forecasting

**Author:** Brice Abogo  
**Tools:** SQL Server | Power Query | Power BI | DAX | Power BI Service

---

## 1. Methodological Overview

This project follows a structured financial analytics methodology designed to transform supplier accounting transactions into actionable information for financial management.

The analytical approach combines accounting principles, data quality controls, relational data modeling, financial KPI development, and business intelligence visualization.

The methodology is organized around eight stages:

1. Business problem identification.
2. Financial KPI definition.
3. Data collection and preparation.
4. Financial reconciliation and data validation.
5. Relational data modeling.
6. Analytical measure development.
7. Dashboard design and financial interpretation.
8. Financial recommendations and reporting infrastructure.

---

## 2. Business Problem Identification

Accounts payable management plays a critical role in maintaining adequate liquidity and preserving supplier relationships.

Organizations require reliable information to monitor outstanding liabilities, identify overdue invoices, evaluate payment performance, and anticipate future financial obligations.

The project addresses the following central question:

**How can financial analytics improve supplier debt monitoring, payment performance evaluation, and cash flow forecasting to support working capital management?**

The analytical solution is designed to provide financial managers with a consolidated view of supplier liabilities and payment obligations.

---

## 3. Financial KPI Definition

The project focuses on financial indicators directly relevant to accounts payable management.

### Core Financial KPIs

- Total Purchases.
- Total Supplier Payments.
- Outstanding Accounts Payable.
- Overdue Payables.
- Not-Yet-Due Payables.
- Payment Rate.
- Number of Supplier Invoices.
- Fully Paid Invoices.
- Estimated Days Payable Outstanding (DPO).

### Operational Indicators

- Invoice aging distribution.
- Supplier outstanding balances.
- Top suppliers by financial exposure.
- Monthly purchasing and payment trends.
- Year-to-date financial movements.
- Contractual payment forecasts.

These indicators were selected to support financial monitoring, payment prioritization, and liquidity planning.

---

## 4. Data Collection and Preparation

The main analytical datasets are:

- `DETTES` — Supplier invoices.
- `REGLEMENTS` — Supplier payment transactions.
- `LISTEF` — Supplier master data.

The source data is extracted from a structured Excel workbook.

Power Query is used to clean, standardize, and transform the data.

### Main Transformations

- Verification and conversion of data types.
- Standardization of invoice and supplier identifiers.
- Calculation of contractual payment due dates.
- Aggregation of payments by invoice.
- Reconciliation of invoices and payment records.
- Calculation of outstanding balances.
- Determination of overdue days.

The detailed transformation scripts are available in the Power Query directory.

[View Power Query Scripts](../powerquery/)

---

## 5. Accounting Reconciliation and Data Validation

Financial data reliability is a central requirement of the project.

The analytical process incorporates accounting reconciliation principles to validate the consistency of supplier transactions.

### Outstanding Payables Reconciliation

**Outstanding Payables = Total Purchases − Total Payments**

For the dataset:

```text
Total Purchases       62,320
Total Payments        14,760
Outstanding Payables  47,560
```

Verification:

```text
62,320 - 14,760 = 47,560
```

### Aging Reconciliation

**Overdue Payables + Not-Yet-Due Payables = Outstanding Payables**

```text
43,260 + 4,300 = 47,560
```

These reconciliations provide consistency checks for the financial reporting outputs.

### Data Quality Controls

The project also documents controls for:

- Missing invoice references.
- Duplicate invoice identifiers.
- Unmatched payments.
- Negative outstanding balances.
- Payments exceeding invoice amounts.
- Invalid payment terms.
- Missing contractual due dates.

Potential exceptions require investigation before corrective accounting treatment.

---

## 6. Relational Data Modeling

The Power BI semantic model integrates supplier invoices, payment transactions, supplier master data, and a calendar dimension.

The main relationships support financial analysis by:

- Supplier.
- Supplier category.
- Invoice.
- Transaction date.
- Contractual payment due date.

Active and inactive relationships are used where appropriate to manage different transaction dates.

The `USERELATIONSHIP()` function enables analytical measures to activate inactive relationships when necessary.

### Data Model

![Power BI Relational Data Model](../images/data-model.png)

---

## 7. Financial Measure Development

DAX is used to calculate financial indicators and dynamic time-based measures.

The main analytical calculations include:

- Purchases and payments.
- Outstanding liabilities.
- Invoice aging.
- Payment coverage.
- Dynamic six-month estimated DPO.
- Year-to-date financial indicators.
- Prior-year comparisons.
- Supplier payment forecasts.

### Dynamic Six-Month Estimated DPO

The project uses the following methodology:

```text
Estimated DPO =
((Purchases - Payments) / Purchases)
× Number of Days in the Period
```

The reporting period is determined using the latest recorded supplier payment date.

The calculation automatically selects the six calendar months ending in the reference month.

For example:

```text
Latest Payment Month: September 2026

Reporting Period:
April 1, 2026 - September 30, 2026
```

### Financial Interpretation

The dashboard currently reports an estimated six-month DPO of:

**154.60 days**

This is a customized payment-period indicator, not the conventional accounting DPO based on average accounts payable.

The detailed DAX implementation is available in:

[DAX Measures](../dax/)

---

## 8. Dashboard Development

The Power BI report consists of four analytical pages.

### Executive Financial Overview

Provides a consolidated summary of financial KPIs, invoice aging, supplier exposure, and payment forecasts.

### Supplier Debt & Payment Analysis

Supports supplier-level monitoring, payment reconciliation, and financial exposure analysis.

### Monthly Financial Performance

Presents purchasing and payment trends, cumulative financial movements, estimated DPO, and invoice status analysis.

### Detailed Accounts Payable Register

Provides invoice-level information for accounting reconciliation and payment monitoring.

The dashboard screenshots are available in:

[Dashboard Images](../images/)

---

## 9. Financial Analysis and Interpretation

The project uses descriptive and diagnostic analytics to identify patterns and financial risks.

### Descriptive Analysis

Summarizes purchases, payments, outstanding liabilities, and supplier invoice status.

### Diagnostic Analysis

Investigates overdue balances, payment performance, and supplier concentration.

### Time-Series Analysis

Examines monthly and cumulative financial trends.

### Forward-Looking Analysis

Uses contractual due dates to estimate future supplier cash requirements.

This approach supports short-term financial planning without relying on statistical prediction models.

---

## 10. Financial Recommendations

The analysis supports five main recommendations.

### Payment Prioritization

Prioritize overdue invoices based on aging, supplier criticality, outstanding balances, and contractual obligations.

### Cash Flow Forecasting

Develop rolling payment schedules based on invoice due dates and outstanding liabilities.

### Supplier Reconciliation

Strengthen periodic reconciliation between supplier invoices, payment transactions, and outstanding balances.

### Supplier Risk Monitoring

Monitor suppliers representing significant outstanding financial exposure.

### Performance Monitoring

Establish measurable targets for payment rates, overdue liabilities, and estimated DPO.

---

## 11. Reporting Infrastructure

The project incorporates Power BI Service and an On-premises Data Gateway.

This infrastructure supports connectivity between locally hosted data sources and cloud-based reporting.

The technical implementation includes:

- Local data source connectivity.
- Semantic model configuration.
- Gateway connection management.
- Scheduled refresh configuration.
- Refresh monitoring.

The availability of scheduled refresh depends on the gateway being online and the source credentials remaining valid.

---

## 12. Technical Architecture

```text
          BUSINESS PROBLEM
                 |
                 v
          FINANCIAL KPI DESIGN
                 |
                 v
          DATA COLLECTION
                 |
                 v
       POWER QUERY TRANSFORMATION
                 |
                 v
       ACCOUNTING RECONCILIATION
                 |
                 v
          DATA VALIDATION
                 |
                 v
       RELATIONAL DATA MODELING
                 |
                 v
          DAX DEVELOPMENT
                 |
                 v
       POWER BI VISUALIZATION
                 |
                 v
       FINANCIAL INTERPRETATION
                 |
                 v
       BUSINESS RECOMMENDATIONS
                 |
                 v
       POWER BI SERVICE & GATEWAY
```

---

## 13. Skills Demonstrated

### Financial & Accounting Skills

- Accounts Payable Management.
- Supplier Account Reconciliation.
- Financial Reporting.
- Working Capital Analysis.
- Cash Flow Planning.
- Invoice Aging Analysis.
- Internal Control.
- Financial Risk Assessment.

### Data Analytics Skills

- Data Preparation and Transformation.
- SQL Query Development.
- Relational Data Modeling.
- DAX Financial Measures.
- Time Intelligence.
- Financial KPI Design.
- Data Visualization.
- Business Intelligence Reporting.

### Technical Infrastructure Skills

- Power BI Service.
- On-premises Data Gateway.
- Semantic Model Configuration.
- Data Source Connectivity.
- Scheduled Refresh Configuration.

---

## 14. Project Limitations

The analysis is subject to several methodological limitations.

- The estimated DPO differs from conventional accounting DPO.
- Payment forecasts are based on contractual due dates rather than statistical prediction.
- Supplier balances assume correct payment allocation.
- Certain advanced accounting adjustments, including supplier advances and credit notes, may require additional treatment.
- The reliability of the results depends on the completeness and accuracy of the source data.

These limitations are documented to ensure transparency and appropriate financial interpretation.

---

## 15. Conclusion

The project demonstrates how accounting expertise and Business Intelligence tools can be combined to improve financial reporting and decision-making.

By integrating data preparation, accounting reconciliation, financial KPI development, interactive dashboards, and reporting infrastructure, the solution provides a structured approach to accounts payable analysis.

The methodology highlights the importance of reliable financial data as a foundation for effective working capital management.

---

**Author:** Brice Abogo  
**Project:** Accounts Payable Analytics  
**Specialization:** Accounting | Financial Analysis | Business Intelligence

[Return to Main Project](../README.md)
