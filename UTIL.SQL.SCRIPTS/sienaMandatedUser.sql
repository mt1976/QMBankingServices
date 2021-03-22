SELECT        {{SQL.SOURCE}}.MandatedUser.MandatedUserKeyCounterpartyFirm, {{SQL.SOURCE}}.MandatedUser.MandatedUserKeyCounterpartyCentre, {{SQL.SOURCE}}.MandatedUser.MandatedUserKeyUserName, {{SQL.SOURCE}}.MandatedUser.TelephoneNumber,
                         {{SQL.SOURCE}}.MandatedUser.EmailAddress, {{SQL.SOURCE}}.MandatedUser.Active, {{SQL.SOURCE}}.MandatedUser.FirstName, {{SQL.SOURCE}}.MandatedUser.Surname, ISNULL({{SQL.SOURCE}}.MandatedUser.DateOfBirth, CAST('1900-01-01' AS DATE)) AS DateOfBirth,
                         {{SQL.SOURCE}}.MandatedUser.Postcode, {{SQL.SOURCE}}.MandatedUser.NationalIDNo, {{SQL.SOURCE}}.MandatedUser.PassportNo, {{SQL.SOURCE}}.MandatedUser.Country, {{SQL.SOURCE}}.Country.Name AS CountryName, {{SQL.SOURCE}}.Firm.FullName AS FirmName,
                         {{SQL.SOURCE}}.Centre.FullName AS CentreName, {{SQL.SOURCE}}.MandatedUser.Notify, {{SQL.SOURCE}}.MandatedUser.SystemUser
FROM            {{SQL.SOURCE}}.MandatedUser INNER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.MandatedUser.Country = {{SQL.SOURCE}}.Country.Code INNER JOIN
                         {{SQL.SOURCE}}.Firm ON {{SQL.SOURCE}}.MandatedUser.MandatedUserKeyCounterpartyFirm = {{SQL.SOURCE}}.Firm.FirmName INNER JOIN
                         {{SQL.SOURCE}}.Centre ON {{SQL.SOURCE}}.MandatedUser.MandatedUserKeyCounterpartyCentre = {{SQL.SOURCE}}.Centre.ShortName
WHERE        ({{SQL.SOURCE}}.MandatedUser.InternalDeleted IS NULL)
