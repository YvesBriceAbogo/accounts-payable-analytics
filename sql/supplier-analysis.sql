/*
=========================================================
ACCOUNTS PAYABLE ANALYTICS
SECTION 02: SUPPLIER FINANCIAL ANALYSIS

PURPOSE:
Analyze supplier liabilities, overdue balances,
payment exposure and supplier concentration.

TABLES:
dbo.DETTES
dbo.LISTEF
dbo.REGLEMENTS

AUTHOR: Brice Abogo

DATABASE: Microsoft SQL Server
=========================================================
*/


/* =====================================================
   ANALYSIS 1: OUTSTANDING BALANCE BY SUPPLIER

   Business Objective:
   Identify the total unpaid liabilities associated
   with each supplier.
   ===================================================== */

WITH PaymentsByInvoice AS
(
    SELECT
        Num_Facture,
        Nom_Fournisseur,
        SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
    FROM dbo.REGLEMENTS
    GROUP BY
        Num_Facture,
        Nom_Fournisseur
),
InvoiceBalances AS
(
    SELECT
        d.Num_Facture,
        d.Nom_Fournisseur,
        CAST(d.Achats AS DECIMAL(18,2)) AS Invoice_Amount,
        COALESCE(p.Total_Payments, 0) AS Payments_Made,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
)
SELECT
    Nom_Fournisseur,
    COUNT(*) AS Total_Invoices,
    SUM(Invoice_Amount) AS Total_Purchases,
    SUM(Payments_Made) AS Total_Payments,
    SUM(Outstanding_Balance) AS Outstanding_Payables
FROM InvoiceBalances
GROUP BY Nom_Fournisseur
ORDER BY Outstanding_Payables DESC;



/* =====================================================
   ANALYSIS 2: TOP FIVE SUPPLIERS BY OUTSTANDING BALANCE

   Business Objective:
   Identify suppliers representing the highest
   outstanding financial exposure.
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
        d.Nom_Fournisseur,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
)
SELECT TOP 5
    Nom_Fournisseur,
    SUM(Outstanding_Balance) AS Outstanding_Payables
FROM InvoiceBalances
GROUP BY Nom_Fournisseur
ORDER BY Outstanding_Payables DESC;



/* =====================================================
   ANALYSIS 3: OUTSTANDING BALANCES BY SUPPLIER CATEGORY

   Business Objective:
   Identify which supplier categories represent
   the largest share of unpaid liabilities.
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
        d.Nom_Fournisseur,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
)
SELECT
    s.Categorie,
    COUNT(*) AS Number_of_Invoices,
    SUM(i.Outstanding_Balance) AS Outstanding_Payables
FROM InvoiceBalances i
INNER JOIN dbo.LISTEF s
    ON i.Nom_Fournisseur = s.Nom_Fournisseur
GROUP BY s.Categorie
ORDER BY Outstanding_Payables DESC;



/* =====================================================
   ANALYSIS 4: OVERDUE AND NOT-YET-DUE PAYABLES BY SUPPLIER

   Business Objective:
   Classify outstanding liabilities according
   to contractual payment due dates.

   Reference Date:
   Current reporting date.
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
        DATEADD(
            DAY,
            d.Delai_Reglement,
            d.Date_facture
        ) AS Due_Date,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
)
SELECT
    Nom_Fournisseur,

    SUM(
        CASE
            WHEN Outstanding_Balance > 0
             AND Due_Date < @ReferenceDate
            THEN Outstanding_Balance
            ELSE 0
        END
    ) AS Overdue_Payables,

    SUM(
        CASE
            WHEN Outstanding_Balance > 0
             AND Due_Date >= @ReferenceDate
            THEN Outstanding_Balance
            ELSE 0
        END
    ) AS Not_Yet_Due_Payables,

    SUM(
        CASE
            WHEN Outstanding_Balance > 0
            THEN Outstanding_Balance
            ELSE 0
        END
    ) AS Total_Outstanding_Payables

FROM InvoiceBalances
GROUP BY Nom_Fournisseur
ORDER BY Total_Outstanding_Payables DESC;



/* =====================================================
   ANALYSIS 5: SUPPLIER DEBT CONCENTRATION

   Business Objective:
   Evaluate the percentage of total outstanding
   liabilities represented by each supplier.
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
        d.Nom_Fournisseur,
        CAST(d.Achats AS DECIMAL(18,2))
            - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
    FROM dbo.DETTES d
    LEFT JOIN PaymentsByInvoice p
        ON d.Num_Facture = p.Num_Facture
       AND d.Nom_Fournisseur = p.Nom_Fournisseur
),
SupplierBalances AS
(
    SELECT
        Nom_Fournisseur,
        SUM(Outstanding_Balance) AS Outstanding_Payables
    FROM InvoiceBalances
    GROUP BY Nom_Fournisseur
)
SELECT
    Nom_Fournisseur,
    Outstanding_Payables,

    CAST(
        Outstanding_Payables * 100.0
        / NULLIF(SUM(Outstanding_Payables) OVER (), 0)
        AS DECIMAL(10,2)
    ) AS Percentage_of_Total_Payables

FROM SupplierBalances
ORDER BY Outstanding_Payables DESC;
