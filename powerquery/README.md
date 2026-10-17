# Power Query ETL & Financial Data Transformation

## Accounts Payable Analytics Project

### 1. Overview

This directory contains the Power Query (M language) scripts developed to prepare and transform supplier accounting data for the Accounts Payable Analytics project.

The ETL process integrates supplier invoices, payment transactions, and supplier master data into a structured analytical environment.

The transformations are designed to improve data consistency, support accounting reconciliation, calculate payment deadlines, and prepare reliable information for financial reporting.

The resulting datasets are used to develop financial KPIs, invoice aging analyses, supplier payment monitoring, and cash flow forecasts in Power BI.

---

## 2. ETL Objectives

The Power Query transformation process aims to:

1. Extract structured accounting data from Excel.
2. Apply appropriate data types.
3. Standardize supplier and invoice identifiers.
4. Consolidate multiple payments associated with the same invoice.
5. Calculate contractual payment due dates.
6. Determine overdue periods.
7. Reconcile invoices with recorded payments.
8. Calculate outstanding supplier balances.
9. Identify potential accounting and data quality anomalies.
10. Prepare validated datasets for Power BI modeling.

---

## 3. Power Query Scripts

The ETL process is organized into five scripts.

| Script | Description |
|---|---|
| [01_reglements.pq](01_reglements.pq) | Supplier payment data preparation |
| [02_reglements_groupes.pq](02_reglements_groupes.pq) | Payment aggregation by invoice |
| [03_listef.pq](03_listef.pq) | Supplier master data preparation |
| [04_dettes.pq](04_dettes.pq) | Invoice reconciliation, due dates and outstanding balances |
| [05_data_quality_checks.pq](05_data_quality_checks.pq) | Data quality and accounting exception controls |

---

## 4. Data Transformation Workflow

The transformation process follows this architecture:

```text
                 EXCEL SOURCE WORKBOOK
                          |
             +------------+------------+
             |            |            |
             v            v            v
          DETTES       REGLEMENTS      LISTEF
             |            |            |
             |            v            |
             |      Data Cleaning      |
             |            |            |
             |            v            |
             |    REGLEMENTS GROUPES   |
             |            |            |
             +------------+            |
                    |                  |
                    v                  |
          Invoice-Payment Merge        |
                    |                  |
                    v                  |
          Due Date Calculation         |
                    |                  |
                    v                  |
          Overdue Days Calculation     |
                    |                  |
                    v                  |
          Outstanding Balance          |
                    |                  |
                    v                  v
              DATA QUALITY & VALIDATION
                          |
                          v
                 POWER BI DATA MODEL
                          |
                          v
                    DAX MEASURES
                          |
                          v
                 FINANCIAL DASHBOARDS
```

---

## 5. Accounting Business Rules

The ETL process incorporates several accounting and financial management rules.

### 5.1. Contractual Payment Due Date

The due date is calculated using the invoice date and contractual payment terms.

**Formula:**

```text
Due Date = Invoice Date + Payment Terms (Days)
```

Power Query implementation:

```powerquery
Date.AddDays(
    [Date_facture],
    [Delai_Reglement]
)
```

### 5.2. Payment Aggregation

A supplier invoice may be settled through multiple payments.

Therefore, all payments associated with the same invoice must be consolidated.

**Formula:**

```text
Total Payments per Invoice =
Sum of Payments Allocated to the Invoice
```

Power Query function:

```powerquery
Table.Group()
```

### 5.3. Invoice-Payment Reconciliation

Supplier invoices are reconciled with aggregated payment transactions using invoice identifiers.

Power Query implementation:

```powerquery
Table.NestedJoin()
```

**Important:** Invoice numbers must be unique across suppliers for this matching approach to be reliable.

If different suppliers use identical invoice numbers, a composite key or a unique invoice identifier should be used.

### 5.4. Outstanding Supplier Balance

The remaining liability is calculated as:

```text
Outstanding Balance =
Invoice Amount - Payments Made
```

Power Query implementation:

```powerquery
[Achats] - [Montant Réglé]
```

### 5.5. Overdue Days

Overdue days are determined by comparing the contractual due date with the reporting reference date.

```text
Overdue Days =
MAX(0, Reference Date - Due Date)
```

This calculation supports invoice aging and payment prioritization.

---

## 6. Data Quality & Accounting Controls

The project includes an exception-detection framework designed to identify potential inconsistencies.

The main controls cover:

- Missing invoice numbers.
- Duplicate invoice references.
- Negative invoice amounts.
- Negative outstanding balances.
- Payments exceeding invoice amounts.
- Missing payment due dates.
- Negative contractual payment terms.

These controls support accounting reliability and internal control.

### Important Accounting Consideration

A negative outstanding balance does not necessarily represent an accounting error.

It may result from:

- Supplier advances.
- Credit notes.
- Overpayments.
- Incorrect payment allocation.

Therefore, exceptions require investigation before corrective accounting entries are made.

The data quality checks are documented in:

[05_data_quality_checks.pq](05_data_quality_checks.pq)

---

## 7. Power Query Functions Used

The project demonstrates practical knowledge of the following Power Query M functions:

| Function | Purpose |
|---|---|
| `Excel.Workbook()` | Extract Excel workbook data |
| `File.Contents()` | Access source files |
| `Table.TransformColumnTypes()` | Apply data types |
| `Table.TransformColumns()` | Standardize field values |
| `Text.Trim()` | Remove unnecessary spaces |
| `Text.Clean()` | Remove non-printable characters |
| `Table.SelectColumns()` | Select relevant fields |
| `Table.Group()` | Aggregate payment transactions |
| `Table.NestedJoin()` | Reconcile invoices and payments |
| `Table.ExpandTableColumn()` | Retrieve merged information |
| `Table.ReplaceValue()` | Handle missing payment values |
| `Table.AddColumn()` | Create calculated financial fields |
| `Date.AddDays()` | Calculate contractual due dates |
| `Duration.Days()` | Calculate payment delays |
| `Table.Combine()` | Consolidate accounting exceptions |

---

## 8. Reusability and Maintenance

The scripts use a Power Query parameter named:

```text
pFilePath
```

This parameter stores the location of the source Excel workbook.

Using a parameter instead of a hard-coded file path facilitates:

- Source file relocation.
- Project maintenance.
- Reuse across different environments.
- Protection of local directory information.

The parameter must be configured in Power BI Desktop before executing the scripts.

The scripts are provided for technical documentation and reproducibility.

---

## 9. Skills Demonstrated

### Technical Skills

- Power Query M Programming.
- ETL Development.
- Data Cleaning.
- Data Transformation.
- Data Aggregation.
- Data Integration.
- Data Quality Validation.
- Data Modeling Preparation.

### Financial & Accounting Skills

- Accounts Payable Management.
- Supplier Invoice Reconciliation.
- Payment Allocation.
- Outstanding Balance Calculation.
- Contractual Payment Terms Monitoring.
- Invoice Aging Analysis.
- Accounting Data Validation.
- Internal Control.

---

## 10. Integration with Power BI

The transformed datasets are loaded into Power BI for relational modeling and analytical calculations.

The resulting model supports:

- Financial KPI development.
- Supplier debt monitoring.
- Invoice aging analysis.
- Monthly purchasing and payment trends.
- Estimated DPO calculations.
- Cash flow forecasting.

The complete financial measures are documented in the project's DAX directory.

[View DAX Measures](../dax/)

[Return to Main Project](../README.md)

---

**Author:** Brice Abogo  
**Project:** Accounts Payable Analytics  
**Specialization:** Accounting | Financial Analysis | Business Intelligence
