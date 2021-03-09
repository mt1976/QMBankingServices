SELECT        {{SQL.SOURCE}}.Centre.ShortName AS Code, {{SQL.SOURCE}}.Centre.FullName AS Name, {{SQL.SOURCE}}.Centre.Country, {{SQL.SOURCE}}.Country.Name AS CountryName
FROM            {{SQL.SOURCE}}.Centre INNER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.Centre.Country = {{SQL.SOURCE}}.Country.Code
WHERE        ({{SQL.SOURCE}}.Centre.InternalDeleted IS NULL)
