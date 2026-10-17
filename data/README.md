# Dataset Documentation
## Accounts Payable Analytics Project

### 1. Data Overview

This project uses structured financial datasets representing supplier invoices, supplier master data, and payment transactions.

The datasets provide the foundation for accounts payable monitoring, invoice aging analysis, payment performance evaluation, and cash flow forecasting.

The data is processed using Power Query and analyzed through a relational Power BI model.

### 2. Data Sources

The analytical model is based on three main tables:

- `DETTES` — Supplier Invoices
- `REGLEMENTS` — Supplier Payments
- `LISTEF` — Supplier Master Data

A fourth table, `Calendar`, is generated using DAX to support time-based financial analysis.

An additional Power Query table, `REGLEMENTS GROUPES`, aggregates supplier payments by invoice.

### 3. Dataset Structure

#### 3.1. DETTES — Supplier Invoices

This table contains supplier invoice transactions.

| Field | Description |
|---|---|
| id_Achats | Unique transaction identifier |
| Num_Facture | Supplier invoice number |
| Date_facture | Invoice issuance date |
| Nom_Fournisseur | Supplier name |
| Categorie | Supplier category |
| Delai_Reglement | Contractual payment term expressed in days |
| Achats | Original invoice amount |
| Echeance | Contractual payment due date |
| Montant Réglé | Total payments allocated to the invoice |
| Solde | Outstanding invoice balance |
| Jours de retard | Number of days overdue |

The `Echeance`, `Montant Réglé`, `Solde`, and `Jours de retard` fields are derived or enriched during the Power Query transformation process.

#### 3.2. REGLEMENTS — Supplier Payments

This table records individual supplier payment transactions.

| Field | Description |
|---|---|
| id_reglement | Unique payment identifier |
| Num_Facture | Related invoice number |
| Nom_Fournisseur | Supplier name |
| Date_Reglement | Actual payment date |
| Montant_Paye | Payment amount |
| Mode_Paiement | Payment method |

An invoice may be settled through one or several payments.

#### 3.3. LISTEF — Supplier Master Data

This table contains supplier reference information.

| Field | Description |
|---|---|
| id_Fournisseur | Unique supplier identifier |
| Nom_Fournisseur | Supplier name |
| Categorie | Supplier business category |
| Telephone | Supplier contact number |
| Adresse | Supplier address |
| Email | Supplier email address |

This table supports supplier-level reporting and analysis by business category.

#### 3.4. REGLEMENTS GROUPES — Aggregated Payments

This Power Query table summarizes payments by invoice.

Its main fields are:

| Field | Description |
|---|---|
| Num_Facture | Supplier invoice number |
| Montant Réglé | Total payments allocated to the invoice |

Business rule:

**Total Payments per Invoice = Sum of All Payments Associated with the Invoice**

The aggregated amount is merged into the `DETTES` table to calculate outstanding balances.

#### 3.5. Calendar — Date Dimension

The Calendar table is generated using DAX.

It contains:

- Date
- Year
- Month
- Month Number

This dimension supports monthly, annual, year-to-date, and rolling-period analyses.

### 4. Data Relationships

The main business relationships are:

**Supplier → Invoices**

One supplier may be associated with multiple invoices.

**Supplier → Payments**

One supplier may receive multiple payments.

**Invoice → Payments**

One invoice may be settled through multiple payment transactions.

**Calendar → Financial Transactions**

The Calendar table supports financial analysis based on invoice dates, payment dates, and contractual due dates.

Active and inactive relationships are managed within the Power BI semantic model.

### 5. Accounting Business Rules

The project applies the following accounting rules.

#### Invoice Due Date

```text
Due Date = Invoice Date + Contractual Payment Term
```

#### Total Payments per Invoice

```text
Total Payments = Sum of Payments Allocated to the Invoice
```

#### Outstanding Balance

```text
Outstanding Balance = Invoice Amount - Total Payments
```

#### Overdue Days

```text
Overdue Days = Maximum(0, Reference Date - Due Date)
```

#### Payment Status

Invoices are classified as:

- Fully Paid
- Not Yet Due
- Overdue: 0–30 days
- Overdue: 31–60 days
- Overdue: 61–90 days
- Overdue: More than 90 days

These classifications support the accounts payable aging analysis.

### 6. Data Quality Controls

The following checks are relevant to the project:

- Verification of invoice identifiers.
- Verification of supplier identifiers.
- Identification of missing or inconsistent values.
- Validation of invoice and payment dates.
- Reconciliation between invoice amounts and recorded payments.
- Identification of negative outstanding balances.
- Verification of duplicate invoice records.
- Validation of contractual due dates.
- Verification of payment status consistency.

These controls contribute to the reliability of the financial reports.

### 7. Data Privacy and Confidentiality

The original source files are not included in this repository.

This approach helps prevent the unintended disclosure of personal information, supplier contact details, or confidential financial records.

Only technical documentation, transformation scripts, analytical measures, and dashboard screenshots are published.

A synthetic dataset may be added in a future version to facilitate project reproducibility.

### 8. Data Processing Workflow

```text
Excel Source Workbook
         |
         v
DETTES | REGLEMENTS | LISTEF
         |
         v
Power Query Data Cleaning
         |
         v
Payment Aggregation
         |
         v
Invoice-Payment Reconciliation
         |
         v
Due Date & Overdue Calculation
         |
         v
Outstanding Balance Calculation
         |
         v
Power BI Data Model
         |
         v
DAX Financial Measures
         |
         v
Interactive Financial Dashboard
```

### 9. Related Project Resources

The complete transformation scripts are available in:

[Power Query Scripts](../powerquery/)

The financial measures are documented in:

[DAX Measures](../dax/)

The dashboard screenshots are available in:

[Dashboard Images](../images/)

---

**Project Author:** Brice Abogo  
**Specialization:** Financial Analysis | Accounting | Business Intelligence
