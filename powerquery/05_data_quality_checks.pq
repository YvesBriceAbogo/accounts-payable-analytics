let
    // =====================================================
    // ACCOUNTS PAYABLE ANALYTICS
    // DATA QUALITY & ACCOUNTING CONTROL FRAMEWORK
    //
    // PURPOSE:
    // Identify accounting inconsistencies and data
    // quality exceptions affecting supplier invoices.
    // =====================================================

    // STEP 1: LOAD PREPARED INVOICE DATA

    Source = DETTES,


    // STEP 2: IDENTIFY MISSING INVOICE NUMBERS

    MissingInvoiceNumbers = Table.SelectRows(
        Source,
        each
            [Num_Facture] = null
            or Text.Trim([Num_Facture]) = ""
    ),

    MissingInvoiceNumbersTagged = Table.AddColumn(
        MissingInvoiceNumbers,
        "Anomaly_Type",
        each "Missing Invoice Number",
        type text
    ),


    // STEP 3: IDENTIFY DUPLICATE INVOICE NUMBERS

    InvoiceCounts = Table.Group(
        Source,
        {"Num_Facture"},
        {
            {
                "Invoice_Count",
                each Table.RowCount(_),
                Int64.Type
            }
        }
    ),

    DuplicateInvoiceNumbers = Table.SelectRows(
        InvoiceCounts,
        each [Invoice_Count] > 1
    ),

    DuplicateInvoices = Table.NestedJoin(
        Source,
        {"Num_Facture"},
        DuplicateInvoiceNumbers,
        {"Num_Facture"},
        "Duplicates",
        JoinKind.Inner
    ),

    DuplicateInvoicesTagged = Table.AddColumn(
        Table.RemoveColumns(
            DuplicateInvoices,
            {"Duplicates"}
        ),
        "Anomaly_Type",
        each "Duplicate Invoice Number",
        type text
    ),


    // STEP 4: IDENTIFY NEGATIVE INVOICE AMOUNTS

    NegativeInvoiceAmounts = Table.SelectRows(
        Source,
        each [Achats] < 0
    ),

    NegativeInvoiceAmountsTagged = Table.AddColumn(
        NegativeInvoiceAmounts,
        "Anomaly_Type",
        each "Negative Invoice Amount",
        type text
    ),


    // STEP 5: IDENTIFY NEGATIVE OUTSTANDING BALANCES

    NegativeBalances = Table.SelectRows(
        Source,
        each [Solde] < 0
    ),

    NegativeBalancesTagged = Table.AddColumn(
        NegativeBalances,
        "Anomaly_Type",
        each "Negative Outstanding Balance",
        type text
    ),


    // STEP 6: IDENTIFY PAYMENTS EXCEEDING INVOICE AMOUNTS

    ExcessPayments = Table.SelectRows(
        Source,
        each [Montant Réglé] > [Achats]
    ),

    ExcessPaymentsTagged = Table.AddColumn(
        ExcessPayments,
        "Anomaly_Type",
        each "Payments Exceed Invoice Amount",
        type text
    ),


    // STEP 7: IDENTIFY MISSING DUE DATES

    MissingDueDates = Table.SelectRows(
        Source,
        each [Echeance] = null
    ),

    MissingDueDatesTagged = Table.AddColumn(
        MissingDueDates,
        "Anomaly_Type",
        each "Missing Due Date",
        type text
    ),


    // STEP 8: IDENTIFY NEGATIVE PAYMENT TERMS

    NegativePaymentTerms = Table.SelectRows(
        Source,
        each [Delai_Reglement] < 0
    ),

    NegativePaymentTermsTagged = Table.AddColumn(
        NegativePaymentTerms,
        "Anomaly_Type",
        each "Negative Payment Terms",
        type text
    ),


    // STEP 9: COMBINE ALL IDENTIFIED EXCEPTIONS

    CombinedExceptions = Table.Combine(
        {
            MissingInvoiceNumbersTagged,
            DuplicateInvoicesTagged,
            NegativeInvoiceAmountsTagged,
            NegativeBalancesTagged,
            ExcessPaymentsTagged,
            MissingDueDatesTagged,
            NegativePaymentTermsTagged
        }
    ),


    // STEP 10: SELECT FIELDS FOR THE CONTROL REPORT

    ControlReport = Table.SelectColumns(
        CombinedExceptions,
        {
            "id_Achats",
            "Num_Facture",
            "Nom_Fournisseur",
            "Achats",
            "Montant Réglé",
            "Solde",
            "Echeance",
            "Anomaly_Type"
        },
        MissingField.UseNull
    )

in
    ControlReport
