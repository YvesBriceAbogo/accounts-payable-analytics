/*
=========================================================
ACCOUNTS PAYABLE ANALYTICS
SECTION 01: FINANCIAL DATA VALIDATION

PURPOSE:
Validate supplier invoices, payments, and supplier
master data before financial analysis.

TABLES:
dbo.DETTES
dbo.LISTEF
dbo.REGLEMENTS

AUTHOR: Brice Abogo

DATABASE: Microsoft SQL Server
=========================================================
*/


/* =====================================================
   CHECK 1: MISSING INVOICE IDENTIFIERS
   ===================================================== */

SELECT
    id_Achats,
    Num_Facture,
    Nom_Fournisseur,
    Date_facture,
    Achats
FROM dbo.DETTES
WHERE Num_Facture IS NULL
   OR LTRIM(RTRIM(Num_Facture)) = '';



/* =====================================================
   CHECK 2: POTENTIAL DUPLICATE INVOICES

   BUSINESS RULE:
   Supplier + Invoice Number should identify
   a unique supplier invoice.
   ===================================================== */

SELECT
    Nom_Fournisseur,
    Num_Facture,
    COUNT(*) AS Duplicate_Count
FROM dbo.DETTES
GROUP BY
    Nom_Fournisseur,
    Num_Facture
HAVING COUNT(*) > 1;



/* =====================================================
   CHECK 3: INVOICES WITH UNKNOWN SUPPLIERS
   ===================================================== */

SELECT
    d.id_Achats,
    d.Num_Facture,
    d.Nom_Fournisseur
FROM dbo.DETTES d
LEFT JOIN dbo.LISTEF s
    ON d.Nom_Fournisseur = s.Nom_Fournisseur
WHERE s.Nom_Fournisseur IS NULL;



/* =====================================================
   CHECK 4: PAYMENTS WITHOUT MATCHING INVOICES
   ===================================================== */

SELECT
    r.id_reglement,
    r.Num_Facture,
    r.Nom_Fournisseur,
    r.Date_Reglement,
    r.Montant_Paye
FROM dbo.REGLEMENTS r
LEFT JOIN dbo.DETTES d
    ON r.Num_Facture = d.Num_Facture
   AND r.Nom_Fournisseur = d.Nom_Fournisseur
WHERE d.Num_Facture IS NULL;



/* =====================================================
   CHECK 5: PAYMENTS EXCEEDING INVOICE AMOUNTS
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
)
SELECT
    d.Num_Facture,
    d.Nom_Fournisseur,
    CAST(d.Achats AS DECIMAL(18,2)) AS Invoice_Amount,
    COALESCE(p.Total_Payments, 0) AS Total_Payments
FROM dbo.DETTES d
LEFT JOIN PaymentsByInvoice p
    ON d.Num_Facture = p.Num_Facture
   AND d.Nom_Fournisseur = p.Nom_Fournisseur
WHERE COALESCE(p.Total_Payments, 0)
      > CAST(d.Achats AS DECIMAL(18,2));



/* =====================================================
   CHECK 6: NEGATIVE OUTSTANDING BALANCES
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
)
SELECT
    d.Num_Facture,
    d.Nom_Fournisseur,
    CAST(d.Achats AS DECIMAL(18,2)) AS Invoice_Amount,
    COALESCE(p.Total_Payments, 0) AS Total_Payments,
    CAST(d.Achats AS DECIMAL(18,2))
        - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance
FROM dbo.DETTES d
LEFT JOIN PaymentsByInvoice p
    ON d.Num_Facture = p.Num_Facture
   AND d.Nom_Fournisseur = p.Nom_Fournisseur
WHERE CAST(d.Achats AS DECIMAL(18,2))
      - COALESCE(p.Total_Payments, 0) < 0;



/* =====================================================
   CHECK 7: INVALID PAYMENT TERMS
   ===================================================== */

SELECT
    Num_Facture,
    Nom_Fournisseur,
    Date_facture,
    Delai_Reglement
FROM dbo.DETTES
WHERE Delai_Reglement IS NULL
   OR Delai_Reglement < 0;



/* =====================================================
   CHECK 8: PAYMENTS RECORDED BEFORE INVOICE DATE
   ===================================================== */

SELECT
    r.id_reglement,
    r.Num_Facture,
    r.Nom_Fournisseur,
    d.Date_facture,
    r.Date_Reglement,
    r.Montant_Paye
FROM dbo.REGLEMENTS r
INNER JOIN dbo.DETTES d
    ON r.Num_Facture = d.Num_Facture
   AND r.Nom_Fournisseur = d.Nom_Fournisseur
WHERE r.Date_Reglement < d.Date_facture;



/* =====================================================
   CHECK 9: GLOBAL FINANCIAL RECONCILIATION

   BUSINESS RULE:
   Outstanding Payables = Purchases - Payments
   ===================================================== */

WITH Purchases AS
(
    SELECT
        SUM(CAST(Achats AS DECIMAL(18,2))) AS Total_Purchases
    FROM dbo.DETTES
),
Payments AS
(
    SELECT
        SUM(CAST(Montant_Paye AS DECIMAL(18,2))) AS Total_Payments
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
   CHECK 10: INVOICE-LEVEL PAYMENT RECONCILIATION
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
)
SELECT
    d.Num_Facture,
    d.Nom_Fournisseur,
    d.Date_facture,
    CAST(d.Achats AS DECIMAL(18,2)) AS Invoice_Amount,
    COALESCE(p.Total_Payments, 0) AS Payments_Made,
    CAST(d.Achats AS DECIMAL(18,2))
        - COALESCE(p.Total_Payments, 0) AS Outstanding_Balance,
    DATEADD(
        DAY,
        d.Delai_Reglement,
        d.Date_facture
    ) AS Due_Date
FROM dbo.DETTES d
LEFT JOIN PaymentsByInvoice p
    ON d.Num_Facture = p.Num_Facture
   AND d.Nom_Fournisseur = p.Nom_Fournisseur
ORDER BY
    d.Date_facture,
    d.Num_Facture;
