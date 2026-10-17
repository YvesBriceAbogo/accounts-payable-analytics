let
    // =====================================================
    // ACCOUNTS PAYABLE ANALYTICS
    // TABLE: LISTEF (Supplier Master Data)
    // PURPOSE: Clean and standardize supplier reference data
    // =====================================================

    // Step 1: Load the Excel source workbook
    // pFilePath is a Power Query parameter containing
    // the location of the source Excel file.
    Source = Excel.Workbook(
        File.Contents(pFilePath),
        null,
        true
    ),

    // Step 2: Extract supplier master data
    SuppliersTable = Source{
        [Item = "LISTEF", Kind = "Table"]
    }[Data],

    // Step 3: Apply appropriate data types
    ChangedTypes = Table.TransformColumnTypes(
        SuppliersTable,
        {
            {"id_Fournisseur", type text},
            {"Nom_Fournisseur", type text},
            {"Categorie", type text},
            {"Telephone", type text},
            {"Adresse", type text},
            {"Email", type text}
        }
    ),

    // Step 4: Standardize supplier identifiers
    CleanSupplierIDs = Table.TransformColumns(
        ChangedTypes,
        {
            {
                "id_Fournisseur",
                each
                    if _ = null
                    then null
                    else Text.Trim(_),
                type text
            }
        }
    ),

    // Step 5: Remove unnecessary spaces from supplier names
    CleanSupplierNames = Table.TransformColumns(
        CleanSupplierIDs,
        {
            {
                "Nom_Fournisseur",
                each
                    if _ = null
                    then null
                    else Text.Trim(Text.Clean(_)),
                type text
            }
        }
    ),

    // Step 6: Standardize supplier categories
    CleanCategories = Table.TransformColumns(
        CleanSupplierNames,
        {
            {
                "Categorie",
                each
                    if _ = null
                    then null
                    else Text.Trim(Text.Clean(_)),
                type text
            }
        }
    )

in
    CleanCategories
