SELECT        {{SQL.SOURCE}}.Counterparty.NameCentre, {{SQL.SOURCE}}.Counterparty.NameFirm, {{SQL.SOURCE}}.Counterparty.FullName, {{SQL.SOURCE}}.Counterparty.TelephoneNumber, {{SQL.SOURCE}}.Counterparty.EmailAddress, {{SQL.SOURCE}}.Counterparty.CustomerType, {{SQL.SOURCE}}.Counterparty.AccountOfficer,
                         {{SQL.SOURCE}}.Counterparty.CountryCode, {{SQL.SOURCE}}.Counterparty.SectorCode, {{SQL.SOURCE}}.Counterparty.CpartyGroupName, {{SQL.SOURCE}}.Counterparty.Notes, {{SQL.SOURCE}}.Counterparty.Owner, {{SQL.SOURCE}}.Counterparty.Authorised, {{SQL.SOURCE}}.Firm.FullName AS NameFirmName,
                         {{SQL.SOURCE}}.Centre.FullName AS NameCentreName, {{SQL.SOURCE}}.Country.Name AS CountryCodeName, {{SQL.SOURCE}}.Sector.Name AS SectorCodeName
FROM            {{SQL.SOURCE}}.Counterparty INNER JOIN
                         {{SQL.SOURCE}}.Firm ON {{SQL.SOURCE}}.Counterparty.NameFirm = {{SQL.SOURCE}}.Firm.FirmName INNER JOIN
                         {{SQL.SOURCE}}.Centre ON {{SQL.SOURCE}}.Counterparty.NameCentre = {{SQL.SOURCE}}.Centre.ShortName INNER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.Counterparty.CountryCode = {{SQL.SOURCE}}.Country.Code INNER JOIN
                         {{SQL.SOURCE}}.Sector ON {{SQL.SOURCE}}.Counterparty.SectorCode = {{SQL.SOURCE}}.Sector.Code
WHERE        ({{SQL.SOURCE}}.Counterparty.InternalDeleted IS NULL)
