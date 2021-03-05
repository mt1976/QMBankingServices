SELECT        dbo.CounterpartyImportID.KeyImportID, dbo.CounterpartyImportID.CounterpartyFirm AS Firm, dbo.CounterpartyImportID.CounterpartyCentre AS Centre, dbo.Firm.FirmName, dbo.Centre.FullName AS CentreName
FROM            dbo.CounterpartyImportID INNER JOIN
                         dbo.Firm ON dbo.CounterpartyImportID.CounterpartyFirm = dbo.Firm.FirmName INNER JOIN
                         dbo.Centre ON dbo.CounterpartyImportID.CounterpartyCentre = dbo.Centre.ShortName
WHERE        (dbo.CounterpartyImportID.InternalDeleted IS NULL) AND (dbo.CounterpartyImportID.KeyOriginID = 'ExternalDealImporter')
