# SQL Server — Financial Data Analysis & Validation

## Accounts Payable Analytics Project

### 1. Overview

This directory contains SQL Server scripts designed to support the Accounts Payable Analytics project.

The SQL implementation focuses on financial data validation, supplier invoice reconciliation, accounts payable monitoring, payment performance analysis, and financial reporting.

The SQL scripts use the same business tables and naming conventions as the Power BI project to ensure consistency across the analytical environment.

The main Power BI solution currently uses Excel-based data sources transformed through Power Query.

SQL Server provides a complementary analytical implementation of the project's financial calculations and accounting controls.

---

## 2. Business Objectives

The SQL analysis aims to:

1. Validate supplier invoice and payment transactions.
2. Identify accounting and data quality inconsistencies.
3. Reconcile invoices with recorded payments.
4. Calculate outstanding supplier balances.
5. Identify overdue and not-yet-due invoices.
6. Analyze supplier exposure and unpaid liabilities.
7. Monitor purchasing and payment performance.
8. Support reliable financial reporting and cash flow planning.

---

## 3. Database Structure

The SQL implementation is organized around three main tables.

### DETTES — Supplier Invoices

Contains supplier invoice information, including:

| Column | Description |
|---|---|
| id_Achats | Unique invoice transaction identifier |
| Num_Facture | Supplier invoice number |
| Date_facture | Invoice date |
| Nom_Fournisseur | Supplier name |
| Categorie | Supplier category |
| Delai_Reglement | Contractual payment term in days |
| Achats | Original invoice amount |

The following analytical fields may be calculated using SQL:

- `Echeance` — Contractual payment due date.
- `Montant_Regle` — Total payments allocated to the invoice.
- `Solde` — Outstanding invoice balance.
- `Jours_Retard` — Number of days overdue.

### LISTEF — Supplier Master Data

Contains supplier reference information.

| Column | Description |
|---|---|
| id_Fournisseur | Unique supplier identifier |
| Nom_Fournisseur | Supplier name |
| Categorie | Supplier category |
| Telephone | Supplier phone number |
| Adresse | Supplier address |
| Email | Supplier email address |

### REGLEMENTS — Supplier Payments

Contains individual supplier payment transactions.

| Column | Description |
|---|---|
| id_reglement | Unique payment identifier |
| Num_Facture | Related invoice number |
| Nom_Fournisseur | Supplier name |
| Date_Reglement | Actual payment date |
| Montant_Paye | Payment amount |
| Mode_Paiement | Payment method |

---

## 4. Relational Data Model

The relational structure supports the following business relationships:

**Supplier → Invoices**

One supplier may have multiple invoices.

**Supplier → Payments**

One supplier may receive multiple payments.

**Invoice → Payments**

One supplier invoice may be settled through several payment transactions.

### Referential Integrity

Invoice and payment records should be matched using reliable business identifiers.

When invoice numbers are not globally unique, reconciliation should use a composite identifier combining the supplier and invoice number.

This prevents incorrect allocation of payments between suppliers.

---

## 5. Accounting Business Rules

The SQL scripts apply the following financial management rules.

### Contractual Due Date

```text
Due Date = Invoice Date + Contractual Payment Term
```

### Total Payments per Invoice

```text
Total Payments = Sum of Payments Allocated to the Invoice
```

### Outstanding Invoice Balance

```text
Outstanding Balance = Invoice Amount - Total Payments
```

### Payment Rate

```text
Payment Rate = Total Payments / Total Purchases
```

### Overdue Days

```text
Overdue Days = MAX(0, Reference Date - Due Date)
```

### Overdue Invoice

An invoice is considered overdue when:

```text
Outstanding Balance > 0
AND
Due Date < Reporting Reference Date
```

---

## 6. SQL Analysis Areas

### 6.1. Financial Data Validation

The SQL validation framework focuses on identifying:

- Missing invoice references.
- Duplicate invoice identifiers.
- Unmatched supplier records.
- Unmatched payment transactions.
- Negative invoice amounts.
- Negative outstanding balances.
- Payments exceeding invoice amounts.
- Invalid payment dates.
- Inconsistent contractual payment terms.

### 6.2. Supplier Financial Analysis

The supplier analysis includes:

- Outstanding balances by supplier.
- Top suppliers by unpaid liabilities.
- Supplier balances by business category.
- Overdue liabilities by supplier.
- Supplier payment exposure.

### 6.3. Accounts Payable Performance Analysis

The financial analysis includes:

- Total supplier purchases.
- Number of invoices.
- Total supplier payments.
- Outstanding liabilities.
- Overdue and not-yet-due invoices.
- Payment coverage rate.
- Monthly purchasing and payment trends.
- Supplier payment forecasting.

---

## 7. SQL Techniques Demonstrated

The project demonstrates the use of:

| SQL Technique | Application |
|---|---|
| `SELECT` | Data extraction |
| `INNER JOIN` | Match related records |
| `LEFT JOIN` | Identify unmatched transactions |
| `GROUP BY` | Financial aggregation |
| `HAVING` | Identify accounting exceptions |
| `CASE` | Financial classification |
| `COALESCE` | Handle missing values |
| `SUM` | Aggregate financial amounts |
| `COUNT` | Count supplier invoices |
| `DATEADD` | Calculate contractual due dates |
| `DATEDIFF` | Calculate payment delays |
| Common Table Expressions | Structure complex analytical queries |
| Window Functions | Ranking and trend analysis |

---

## 8. SQL Scripts

The directory contains the following analytical scripts.

| File | Description |
|---|---|
| `data-validation.sql` | Accounting reconciliation and data quality checks |
| `supplier-analysis.sql` | Supplier exposure and outstanding balances |
| `accounts-payable-analysis.sql` | Financial KPIs, payment trends and cash flow analysis |

These scripts are designed for Microsoft SQL Server and should be validated against the actual database schema before execution.

---

## 9. Data Processing Architecture

```text
       SUPPLIER FINANCIAL DATA
                  |
                  v
          SQL SERVER TABLES
                  |
       +----------+----------+
       |          |          |
       v          v          v
     DETTES     LISTEF   REGLEMENTS
       |          |          |
       +----------+----------+
                  |
                  v
       DATA VALIDATION & CLEANING
                  |
                  v
       INVOICE-PAYMENT RECONCILIATION
                  |
                  v
       FINANCIAL KPI CALCULATIONS
                  |
                  v
       SUPPLIER & PAYMENT ANALYSIS
                  |
                  v
       FINANCIAL REPORTING
```

---

## 10. Implementation Notes

The SQL scripts are designed to reproduce selected accounting controls and financial analyses performed in Power BI.

The SQL implementation is complementary to the Power Query and DAX calculations used in the dashboard.

The scripts do not automatically modify the existing Power BI data model.

To execute them, the corresponding tables must exist in SQL Server with compatible column names and data types.

The SQL scripts will be reviewed and tested progressively before being considered validated implementations.

---

## 11. Skills Demonstrated

### SQL & Data Analytics

- SQL Server Query Development.
- Relational Data Analysis.
- Financial Data Aggregation.
- Data Quality Validation.
- Data Reconciliation.
- Analytical Query Design.
- Financial Reporting Automation.

### Finance & Accounting

- Accounts Payable Management.
- Supplier Invoice Reconciliation.
- Payment Monitoring.
- Working Capital Analysis.
- Financial KPI Development.
- Invoice Aging Analysis.
- Internal Control.
- Cash Flow Planning.

---

## 12. Related Project Resources

[Power Query Transformation Scripts](../powerquery/)

[DAX Financial Measures](../dax/)

[Dataset Documentation](../data/)

[Dashboard Screenshots](../images/)

[Return to Main Project](../README.md)

---

**Author:** Brice Abogo  
**Project:** Accounts Payable Analytics  
**Specialization:** Accounting | Financial Analysis | Business Intelligence
