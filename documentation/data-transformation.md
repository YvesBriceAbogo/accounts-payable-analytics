# Data Transformation & Accounting Reconciliation

## Accounts Payable Analytics Project

**Author:** Brice Abogo  
**Technologies:** Power Query (M) | Microsoft Excel | Power BI

---

## 1. Overview

This document describes the Extract, Transform, and Load (ETL) methodology supporting the Accounts Payable Analytics project.

The transformation process converts raw supplier accounting data into structured datasets suitable for financial analysis, payment reconciliation, invoice aging, and cash flow forecasting.

Power Query is used to integrate supplier invoices, payment transactions, and supplier master data while applying accounting rules and data quality controls.

The process emphasizes data consistency, traceability, and financial reporting reliability.

---

## 2. Source Data

The original dataset consists of three structured Excel tables.

| Table | Description |
|---|---|
| DETTES | Supplier invoices and purchasing transactions |
| REGLEMENTS | Supplier payment transactions |
| LISTEF | Supplier master data |

An additional query, `REGLEMENTS GROUPES`, aggregates payment transactions by invoice.

The Calendar dimension is subsequently generated using DAX.

---

## 3. ETL Architecture

The transformation workflow is organized as follows:

```text
                  EXCEL WORKBOOK
                        |
             +----------+----------+
             |          |          |
             v          v          v
           DETTES    REGLEMENTS   LISTEF
             |          |          |
             |          v          |
             |     Data Cleaning   |
             |          |          |
             |          v          |
             |   Payment Aggregation
             |          |
             +----------+
                  |
                  v
        Invoice-Payment Reconciliation
                  |
                  v
        Contractual Due Date Calculation
                  |
                  v
          Overdue Days Calculation
                  |
                  v
        Outstanding Balance Calculation
                  |
                  v
          Data Quality Controls
                  |
                  v
            Power BI Data Model
                  |
                  v
           DAX Financial Measures
                  |
                  v
          Interactive Dashboards
```

---

## 4. Data Extraction

The data is extracted from an Excel workbook using Power Query.

The extraction relies on:

```powerquery
Excel.Workbook(
    File.Contents(pFilePath),
    null,
    true
)
```

The parameter `pFilePath` identifies the location of the source workbook.

This approach improves maintainability and avoids hard-coded file paths in the published scripts.

The source tables are extracted individually to preserve their respective business purposes.

---

## 5. Data Type Standardization

Appropriate data types are applied to financial and descriptive fields.

| Data Category | Power Query Type |
|---|---|
| Invoice identifiers | Text |
| Supplier identifiers | Text |
| Supplier names | Text |
| Invoice dates | Date |
| Payment dates | Date |
| Payment terms | Whole Number |
| Purchase amounts | Fixed Decimal / Currency |
| Payment amounts | Fixed Decimal / Currency |

Using appropriate data types improves calculation reliability and reduces transformation errors.

---

## 6. Identifier Standardization

Invoice and supplier identifiers are standardized to improve matching accuracy.

For example:

```powerquery
Text.Trim()
```

removes leading and trailing spaces.

```powerquery
Text.Clean()
```

removes certain non-printable characters.

These transformations reduce the risk of mismatched records during data merging.

### Accounting Consideration

Invoice numbers may not be globally unique across suppliers.

Therefore, invoice-payment reconciliation should ideally rely on a unique invoice identifier or a composite key combining supplier identification and invoice number.

The published scripts use invoice numbers as matching keys, subject to this uniqueness assumption.

---

## 7. Payment Aggregation

A supplier invoice may be settled through multiple payments.

The `REGLEMENTS GROUPES` query consolidates these transactions.

Power Query implementation:

```powerquery
Table.Group(
    SelectedColumns,
    {"Num_Facture"},
    {
        {
            "Montant Réglé",
            each List.Sum([Montant_Paye]),
            Currency.Type
        }
    }
)
```

### Business Rule

```text
Total Payments per Invoice =
Sum of All Payments Allocated to That Invoice
```

This aggregation is necessary to calculate the outstanding balance of each supplier invoice.

---

## 8. Invoice-Payment Reconciliation

The aggregated payment data is merged with supplier invoices using a left outer join.

Power Query function:

```powerquery
Table.NestedJoin()
```

The left outer join preserves all supplier invoices, including those with no recorded payments.

Following the merge, payment amounts are expanded into the invoice table.

Missing payment values are replaced with zero, representing invoices for which no matching payment was found.

### Accounting Objective

The reconciliation provides a link between:

- Original supplier invoices.
- Payments allocated to invoices.
- Remaining outstanding liabilities.

This supports supplier account monitoring and financial reporting.

---

## 9. Contractual Due Date Calculation

Payment due dates are calculated using invoice dates and contractual payment terms.

### Formula

```text
Due Date = Invoice Date + Payment Terms
```

Power Query implementation:

```powerquery
Date.AddDays(
    [Date_facture],
    [Delai_Reglement]
)
```

This calculation supports payment scheduling and accounts payable aging analysis.

---

## 10. Overdue Days Calculation

Overdue days are determined by comparing the contractual due date with the reporting reference date.

### Formula

```text
Overdue Days =
MAX(0, Reference Date - Due Date)
```

Power Query implementation:

```powerquery
Duration.Days(
    ReferenceDate - [Echeance]
)
```

Negative delays are replaced with zero.

This transformation enables the classification of outstanding invoices into aging categories.

### Reference Date Consideration

The transformation uses the current date at the time of refresh.

Consequently, overdue days may change whenever the dataset is refreshed.

For historical reporting, a fixed or parameterized reference date may be preferable.

---

## 11. Outstanding Balance Calculation

The outstanding balance of each invoice is calculated as:

```text
Outstanding Balance =
Invoice Amount - Payments Made
```

Power Query implementation:

```powerquery
[Achats] - [Montant Réglé]
```

### Example

```text
Invoice Amount:     1,000
Payments Made:        600
Outstanding Balance:  400
```

This calculation distinguishes:

- Fully paid invoices.
- Partially paid invoices.
- Unpaid invoices.

Negative balances are flagged for further investigation.

---

## 12. Data Quality Controls

The project documents an accounting-oriented data quality framework.

The main controls include:

| Control | Objective |
|---|---|
| Missing invoice numbers | Ensure transaction identification |
| Duplicate invoice references | Detect potential duplicate invoices |
| Negative invoice amounts | Identify unusual accounting transactions |
| Negative outstanding balances | Detect advances, overpayments or allocation errors |
| Excess payments | Identify payments exceeding invoice amounts |
| Missing due dates | Ensure payment schedule completeness |
| Negative payment terms | Identify invalid contractual conditions |

These controls are designed to identify exceptions requiring further investigation.

They do not automatically determine whether a transaction is erroneous.

---

## 13. Financial Data Reconciliation

The transformed data supports the following accounting reconciliation:

```text
Total Purchases - Total Payments
= Outstanding Payables
```

For the project dataset:

```text
62,320 - 14,760 = 47,560
```

The outstanding balance is also reconciled with the invoice aging classification:

```text
Overdue Payables + Not-Yet-Due Payables
= Outstanding Payables
```

```text
43,260 + 4,300 = 47,560
```

These controls support the consistency of the financial dashboard.

---

## 14. Loading into Power BI

After transformation, the datasets are loaded into Power BI.

The resulting semantic model connects:

- Supplier invoices.
- Payment transactions.
- Supplier master data.
- Calendar dimension.

The model supports financial analysis by supplier, category, invoice, and reporting period.

DAX measures are subsequently developed to calculate financial KPIs and time-based indicators.

---

## 15. Reusability and Maintenance

The transformation process is designed for maintainability.

Key practices include:

- Parameterized source file paths.
- Descriptive transformation steps.
- Documented accounting rules.
- Separation of source tables and derived queries.
- Explicit data type definitions.
- Data quality exception reporting.

The scripts can be adapted to other financial datasets with compatible structures.

---

## 16. Skills Demonstrated

### Data Engineering & Analytics

- Power Query M.
- ETL Development.
- Data Cleaning.
- Data Transformation.
- Data Aggregation.
- Data Integration.
- Data Quality Validation.
- Analytical Data Preparation.

### Financial & Accounting

- Accounts Payable Reconciliation.
- Supplier Invoice Management.
- Payment Allocation.
- Outstanding Balance Calculation.
- Contractual Payment Monitoring.
- Invoice Aging Analysis.
- Accounting Data Validation.
- Internal Control.

---

## 17. Technical Resources

The complete Power Query scripts are available in:

[Power Query Scripts](../powerquery/)

The financial measures are documented in:

[DAX Measures](../dax/)

The Power BI relational model is available in:

[Data Model](../images/data-model.png)

[Return to Project Methodology](methodology.md)

[Return to Main Project](../README.md)

---

**Author:** Brice Abogo  
**Project:** Accounts Payable Analytics  
**Specialization:** Accounting | Financial Analysis | Business Intelligence
