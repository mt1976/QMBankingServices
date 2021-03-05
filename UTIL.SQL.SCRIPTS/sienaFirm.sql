SELECT        dbo.Centre.ShortName AS Code, dbo.Centre.FullName AS Name, dbo.Centre.Country, dbo.Country.Name AS CountryName
FROM            dbo.Centre INNER JOIN
                         dbo.Country ON dbo.Centre.Country = dbo.Country.Code
WHERE        (dbo.Centre.InternalDeleted IS NULL)
