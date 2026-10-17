let
    // =====================================================
    // ACCOUNTS PAYABLE ANALYTICS
    // TABLE: DETTES (Supplier Invoices)
    //
    // PURPOSE:
    // Prepare supplier invoices for financial analysis,
    // payment reconciliation and accounts payable aging.
    // =====================================================


    // STEP 1: LOAD SOURCE WORKBOOK
    // The pFilePath parameter contains the location
    // of the Excel workbook.

    Source = Excel.Workbook(
        File.Contents(pFilePath),
        null,
        true
    ),


    // STEP 2: EXTRACT SUPPLIER INVOICES

    InvoicesTable = Source{
        [Item = "DETTES", Kind = "Table"]
    }[Data],


    // STEP 3: APPLY APPROPRIATE DATA TYPES

    ChangedTypes = Table.TransformColumnTypes(
        InvoicesTable,
        {
            {"id_Achats", type text},
            {"Num_Facture", type text},
            {"Date_facture", type date},
            {"Nom_Fournisseur", type text},
            {"Categorie", type text},
            {"Delai_Reglement", Int64.Type},
            {"Achats", Currency.Type}
        }
    ),


    // STEP 4: STANDARDIZE INVOICE IDENTIFIERS
    // Remove leading and trailing spaces to improve
    // invoice-payment matching accuracy.

    CleanInvoiceNumbers = Table.TransformColumns(
        ChangedTypes,
        {
            {
                "Num_Facture",
                each
                    if _ = null
                    then null
                    else Text.Trim(_),
                type text
            }
        }
    ),


    // STEP 5: CALCULATE CONTRACTUAL PAYMENT DUE DATES
    //
    // Business rule:
    // Due Date = Invoice Date + Payment Terms (days)

    AddedDueDate = Table.AddColumn(
        CleanInvoiceNumbers,
        "Echeance",
        each
            if [Date_facture] = null
                or [Delai_Reglement] = null
            then null
            else
                Date.AddDays(
                    [Date_facture],
                    [Delai_Reglement]
                ),
        type date
    ),


    // STEP 6: DEFINE REPORTING REFERENCE DATE
    // The reference date is refreshed whenever
    // the Power Query model is refreshed.

    ReferenceDate =
        Date.From(DateTime.LocalNow()),


    // STEP 7: CALCULATE OVERDUE DAYS
    //
    // Business rule:
    // Overdue Days = MAX(0, Reference Date - Due Date)

    AddedOverdueDays = Table.AddColumn(
        AddedDueDate,
        "Jours de retard",
        each
            if [Echeance] = null
            then null
            else
                let
                    Delay =
                        Duration.Days(
                            ReferenceDate - [Echeance]
                        )
                in
                    if Delay < 0
                    then 0
                    else Delay,
        Int64.Type
    ),


    // STEP 8: MERGE INVOICES WITH AGGREGATED PAYMENTS
    //
    // This step links each supplier invoice
    // to its corresponding accumulated payments.

    MergedPayments = Table.NestedJoin(
        AddedOverdueDays,
        {"Num_Facture"},
        #"REGLEMENTS GROUPES",
        {"Num_Facture"},
        "Payments",
        JoinKind.LeftOuter
    ),


    // STEP 9: EXPAND PAYMENT AMOUNTS

    ExpandedPayments = Table.ExpandTableColumn(
        MergedPayments,
        "Payments",
        {"Montant Réglé"},
        {"Montant Réglé"}
    ),


    // STEP 10: HANDLE INVOICES WITHOUT PAYMENTS
    //
    // Null values indicate invoices for which
    // no payment transaction was found.

    ReplacedNullPayments = Table.ReplaceValue(
        ExpandedPayments,
        null,
        0,
        Replacer.ReplaceValue,
        {"Montant Réglé"}
    ),


    // STEP 11: CALCULATE OUTSTANDING INVOICE BALANCES
    //
    // Business rule:
    // Outstanding Balance = Invoice Amount - Payments

    AddedOutstandingBalance = Table.AddColumn(
        ReplacedNullPayments,
        "Solde",
        each
            [Achats] - [Montant Réglé],
        Currency.Type
    )

in
    AddedOutstandingBalance
