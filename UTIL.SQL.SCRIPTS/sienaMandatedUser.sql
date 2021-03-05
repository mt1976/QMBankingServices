SELECT        dbo.MandatedUser.MandatedUserKeyCounterpartyFirm, dbo.MandatedUser.MandatedUserKeyCounterpartyCentre, dbo.MandatedUser.MandatedUserKeyUserName, dbo.MandatedUser.TelephoneNumber,
                         dbo.MandatedUser.EmailAddress, dbo.MandatedUser.Active, dbo.MandatedUser.FirstName, dbo.MandatedUser.Surname, dbo.MandatedUser.DateOfBirth, dbo.MandatedUser.Postcode, dbo.MandatedUser.NationalIDNo,
                         dbo.MandatedUser.PassportNo, dbo.MandatedUser.Country, dbo.Country.Name AS CountryName, dbo.Firm.FullName AS FirmName, dbo.Centre.FullName AS CentreName
FROM            dbo.MandatedUser INNER JOIN
                         dbo.Country ON dbo.MandatedUser.Country = dbo.Country.Code INNER JOIN
                         dbo.Firm ON dbo.MandatedUser.MandatedUserKeyCounterpartyFirm = dbo.Firm.FirmName INNER JOIN
                         dbo.Centre ON dbo.MandatedUser.MandatedUserKeyCounterpartyCentre = dbo.Centre.ShortName
WHERE        (dbo.MandatedUser.InternalDeleted IS NULL)
