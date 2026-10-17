/*
=========================================================
ACCOUNTS PAYABLE ANALYTICS
SECTION 03: FINANCIAL KPI & CASH FLOW ANALYSIS

PURPOSE:
Analyze supplier purchases, payments, outstanding
liabilities, aging, payment performance and cash flow.

TABLES:
dbo.DETTES
dbo.LISTEF
dbo.REGLEMENTS

AUTHOR: Brice Abogo

DATABASE: Microsoft SQL Server
=========================================================
*/


/* =====================================================
   ANALYSIS 1: TOTAL PURCHASES AND INVOICE COUNT
   ===================================================== */

SELECT
    SUM(CAST(Achats AS DECIMAL(18,2))) AS Total_Purchases,
    COUNT(DISTINCT Num_Facture) AS Total_Invoices
FROM dbo.DETTES;



/* =====================================================
   ANALYSIS 2: TOTAL SUPPLIER PAYMENTS
   ===================================================== */

SELECT
    SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
FROM dbo.REGLEMENTS;



/* =====================================================
   ANALYSIS 3: TOTAL OUTSTANDING PAYABLES
   ===================================================== */

WITH Purchases AS
(
    SELECT SUM(CAST(Achats AS DECIMAL(18,2))) AS Total_Purchases
    FROM dbo.DETTES
),
Payments AS
(
    SELECT SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
)
SELECT
    COALESCE(p.Total_Purchases, 0) AS Total_Purchases,
    COALESCE(r.Total_Payments, 0) AS Total_Payments,
    COALESCE(p.Total_Purchases, 0)
        - COALESCE(r.Total_Payments, 0) AS Outstanding_Payables
FROM Purchases p
CROSS JOIN Payments r;



/* =====================================================
   ANALYSIS 4: SUPPLIER PAYMENT RATE
   ===================================================== */

WITH Purchases AS
(
    SELECT SUM(CAST(Achats AS DECIMAL(18,2))) AS Total_Purchases
    FROM dbo.DETTES
),
Payments AS
(
    SELECT SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
)
SELECT
    CAST(
        r.Total_Payments * 100.0
        / NULLIF(p.Total_Purchases, 0)
        AS DECIMAL(10,2)
    ) AS Payment_Rate_Percent
FROM Purchases p
CROSS JOIN Payments r;



/* =====================================================
   ANALYSIS 5: ACCOUNTS PAYABLE AGING
   ===================================================== */

DECLARE @ReferenceDate DATE = CAST(GETDATE() AS DATE);

WITH PaymentsByInvoice AS
(
    SELECT
        Num_Facture,
        Nom_Fournisseur,
        SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
    GROUP BY Num_Facture, Nom_Fournisseur
),
InvoiceBalances AS
(
    SELECT
        d.Num_Facture,
        d.Nom_Fournisseur,
        DATEADD(DAY, d.Delai_Reglement, d.Date_facture) AS Due_Date,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
),
InvoiceAging AS
(
    SELECT
        *,
        CASE
            WHEN Outstanding_Balance <= 0 THEN 'Fully Paid'
            WHEN Due_Date >= @ReferenceDate THEN 'Not Yet Due'
            WHEN DATEDIFF(DAY, Due_Date, @ReferenceDate) <= 30 THEN 'Overdue 0-30'
            WHEN DATEDIFF(DAY, Due_Date, @ReferenceDate) <= 60 THEN 'Overdue 31-60'
            WHEN DATEDIFF(DAY, Due_Date, @ReferenceDate) <= 90 THEN 'Overdue 61-90'
            ELSE 'Overdue >90'
        END AS Aging_Category
    FROM InvoiceBalances
)
SELECT
    Aging_Category,
    COUNT(*) AS Invoice_Count,
    SUM(Outstanding_Balance) AS Outstanding_Amount
FROM InvoiceAging
GROUP BY Aging_Category
ORDER BY Aging_Category;



/* =====================================================
   ANALYSIS 6: MONTHLY PURCHASES VS PAYMENTS
   ===================================================== */

WITH PurchasesMonthly AS
(
    SELECT
        DATEFROMPARTS(YEAR(Date_facture), MONTH(Date_facture), 1) AS Month_Start,
        SUM(CAST(Achats AS DECIMAL(18,2))) AS Total_Purchases
    FROM dbo.DETTES
    GROUP BY YEAR(Date_facture), MONTH(Date_facture)
),
PaymentsMonthly AS
(
    SELECT
        DATEFROMPARTS(YEAR(Date_Reglement), MONTH(Date_Reglement), 1) AS Month_Start,
        SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
    GROUP BY YEAR(Date_Reglement), MONTH(Date_Reglement)
)
SELECT
    COALESCE(p.Month_Start, r.Month_Start) AS Reporting_Month,
    COALESCE(p.Total_Purchases, 0) AS Purchases,
    COALESCE(r.Total_Payments, 0) AS Payments,
    COALESCE(p.Total_Purchases, 0)
        - COALESCE(r.Total_Payments, 0) AS Net_Payable_Movement
FROM PurchasesMonthly p
FULL OUTER JOIN PaymentsMonthly r
    ON p.Month_Start = r.Month_Start
ORDER BY Reporting_Month;



/* =====================================================
   ANALYSIS 7: CUMULATIVE PURCHASES, PAYMENTS & PAYABLES
   ===================================================== */

WITH MonthlyTransactions AS
(
    SELECT
        DATEFROMPARTS(YEAR(Date_facture), MONTH(Date_facture), 1) AS Month_Start,
        CAST(Achats AS DECIMAL(18,2)) AS Purchases,
        CAST(0 AS DECIMAL(18,2)) AS Payments
    FROM dbo.DETTES

    UNION ALL

    SELECT
        DATEFROMPARTS(YEAR(Date_Reglement), MONTH(Date_Reglement), 1),
        CAST(0 AS DECIMAL(18,2)),
        CAST(Montant_Paye AS DECIMAL(18,2))
    FROM dbo.REGLEMENTS
),
MonthlySummary AS
(
    SELECT
        Month_Start,
        SUM(Purchases) AS Purchases,
        SUM(Payments) AS Payments
    FROM MonthlyTransactions
    GROUP BY Month_Start
)
SELECT
    Month_Start,
    Purchases,
    Payments,

    SUM(Purchases) OVER (
        ORDER BY Month_Start
        ROWS UNBOUNDED PRECEDING
    ) AS Cumulative_Purchases,

    SUM(Payments) OVER (
        ORDER BY Month_Start
        ROWS UNBOUNDED PRECEDING
    ) AS Cumulative_Payments,

    SUM(Purchases - Payments) OVER (
        ORDER BY Month_Start
        ROWS UNBOUNDED PRECEDING
    ) AS Cumulative_Net_Payables

FROM MonthlySummary
ORDER BY Month_Start;



/* =====================================================
   ANALYSIS 8: FORECAST SUPPLIER PAYMENTS BY DUE DATE
   ===================================================== */

WITH PaymentsByInvoice AS
(
    SELECT
        Num_Facture,
        Nom_Fournisseur,
        SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
    GROUP BY Num_Facture, Nom_Fournisseur
),
InvoiceBalances AS
(
    SELECT
        d.Num_Facture,
        DATEADD(DAY, d.Delai_Reglement, d.Date_facture) AS Due_Date,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
)
SELECT
    DATEFROMPARTS(YEAR(Due_Date), MONTH(Due_Date), 1) AS Forecast_Month,
    SUM(Outstanding_Balance) AS Expected_Payments
FROM InvoiceBalances
WHERE Outstanding_Balance > 0
GROUP BY YEAR(Due_Date), MONTH(Due_Date)
ORDER BY Forecast_Month;



/* =====================================================
   ANALYSIS 9: ESTIMATED DPO - ROLLING SIX MONTHS

   Methodology:
   ((Purchases - Payments) / Purchases)
   * Number of Days in the Period

   Reference:
   Latest recorded supplier payment date.
   ===================================================== */

DECLARE @LastPaymentDate DATE =
(
    SELECT MAX(Date_Reglement)
    FROM dbo.REGLEMENTS
);

DECLARE @PeriodEnd DATE =
    EOMONTH(@LastPaymentDate);

DECLARE @PeriodStart DATE =
    DATEADD(DAY, 1, EOMONTH(@PeriodEnd, -6));

WITH PurchasesPeriod AS
(
    SELECT
        SUM(CAST(Achats AS DECIMAL(18,2))) AS Total_Purchases
    FROM dbo.DETTES
    WHERE Date_facture >= @PeriodStart
      AND Date_facture <= @PeriodEnd
),
PaymentsPeriod AS
(
    SELECT
        SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
    WHERE Date_Reglement >= @PeriodStart
      AND Date_Reglement <= @PeriodEnd
)
SELECT
    @PeriodStart AS Period_Start,
    @PeriodEnd AS Period_End,

    COALESCE(p.Total_Purchases, 0) AS Purchases,
    COALESCE(r.Total_Payments, 0) AS Payments,

    CAST(
        (
            COALESCE(p.Total_Purchases, 0)
            - COALESCE(r.Total_Payments, 0)
        )
        * DATEDIFF(DAY, @PeriodStart, @PeriodEnd) * 1.0
        / NULLIF(p.Total_Purchases, 0)
        AS DECIMAL(10,2)
    ) AS Estimated_DPO_Days

FROM PurchasesPeriod p
CROSS JOIN PaymentsPeriod r;



/* =====================================================
   ANALYSIS 10: FIVE OLDEST OVERDUE INVOICES
   ===================================================== */

DECLARE @ReferenceDateOldest DATE = CAST(GETDATE() AS DATE);

WITH PaymentsByInvoice AS
(
    SELECT
        Num_Facture,
        Nom_Fournisseur,
        SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
    GROUP BY Num_Facture, Nom_Fournisseur
),
InvoiceBalances AS
(
    SELECT
        d.Num_Facture,
        d.Nom_Fournisseur,
        d.Date_facture,
        DATEADD(DAY, d.Delai_Reglement, d.Date_facture) AS Due_Date,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
)
SELECT TOP 5
    Num_Facture,
    Nom_Fournisseur,
    Date_facture,
    Due_Date,
    DATEDIFF(DAY, Due_Date, @ReferenceDateOldest) AS Days_Overdue,
    Outstanding_Balance
FROM InvoiceBalances
WHERE Outstanding_Balance > 0
  AND Due_Date < @ReferenceDateOldest
ORDER BY
    Due_Date ASC,
    Outstanding_Balance DESC;
