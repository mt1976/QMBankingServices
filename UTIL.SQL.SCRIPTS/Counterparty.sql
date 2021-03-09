SELECT        KeyImportID
FROM            {{SQL.SOURCE}}.CounterpartyImportID
WHERE        (InternalDeleted IS NULL) AND (KeyOriginID = 'ExternalDealImporter')
