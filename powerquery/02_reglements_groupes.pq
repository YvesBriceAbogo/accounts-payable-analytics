let
    // =====================================================
    // ACCOUNTS PAYABLE ANALYTICS
    // TABLE: REGLEMENTS GROUPES (Aggregated Payments)
    // PURPOSE: Aggregate supplier payments by invoice
    // =====================================================

    // Step 1: Reference the cleaned payment transactions
    Source = REGLEMENTS,

    // Step 2: Retain only the fields needed
    // for invoice-payment reconciliation
    SelectedColumns = Table.SelectColumns(
        Source,
        {
            "Num_Facture",
            "Montant_Paye"
        }
    ),

    // Step 3: Group payment transactions by invoice
    // Multiple payments related to the same invoice
    // are consolidated into a single amount.
    GroupedPayments = Table.Group(
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

in
    GroupedPayments
