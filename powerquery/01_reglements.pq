let
    // =====================================================
    // ACCOUNTS PAYABLE ANALYTICS
    // TABLE: REGLEMENTS (Supplier Payments)
    // PURPOSE: Clean and standardize payment transactions
    // =====================================================

    // Step 1: Load the Excel source workbook
    // pFilePath is a Power Query parameter containing
    // the local path to the source workbook.
    Source = Excel.Workbook(
        File.Contents(pFilePath),
        null,
        true
    ),

    // Step 2: Extract supplier payment transactions
    PaymentsTable = Source{
        [Item = "REGLEMENTS", Kind = "Table"]
    }[Data],

    // Step 3: Apply appropriate data types
    ChangedTypes = Table.TransformColumnTypes(
        PaymentsTable,
        {
            {"id_reglement", type text},
            {"Num_Facture", type text},
            {"Nom_Fournisseur", type text},
            {"Date_Reglement", type date},
            {"Montant_Paye", Currency.Type},
            {"Mode_Paiement", type text}
        }
    ),

    // Step 4: Standardize invoice identifiers
    // Removes leading and trailing spaces to improve
    // matching accuracy during invoice reconciliation.
    CleanInvoiceNumbers = Table.TransformColumns(
        ChangedTypes,
        {
            {
                "Num_Facture",
                each if _ = null then null else Text.Trim(_),
                type text
            }
        }
    )

in
    CleanInvoiceNumbers
