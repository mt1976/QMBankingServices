SELECT        KeyImportID
FROM            RG.CounterpartyImportID
WHERE        (InternalDeleted IS NULL) AND (KeyOriginID = 'ExternalDealImporter')
