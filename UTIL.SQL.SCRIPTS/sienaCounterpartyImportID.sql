SELECT        {{SQL.SOURCE}}.CounterpartyImportID.KeyImportID, {{SQL.SOURCE}}.CounterpartyImportID.CounterpartyFirm AS Firm, {{SQL.SOURCE}}.CounterpartyImportID.CounterpartyCentre AS Centre, {{SQL.SOURCE}}.Firm.FirmName, {{SQL.SOURCE}}.Centre.FullName AS CentreName
FROM            {{SQL.SOURCE}}.CounterpartyImportID INNER JOIN
                         {{SQL.SOURCE}}.Firm ON {{SQL.SOURCE}}.CounterpartyImportID.CounterpartyFirm = {{SQL.SOURCE}}.Firm.FirmName INNER JOIN
                         {{SQL.SOURCE}}.Centre ON {{SQL.SOURCE}}.CounterpartyImportID.CounterpartyCentre = {{SQL.SOURCE}}.Centre.ShortName
WHERE        ({{SQL.SOURCE}}.CounterpartyImportID.InternalDeleted IS NULL) AND ({{SQL.SOURCE}}.CounterpartyImportID.KeyOriginID = 'ExternalDealImporter')
