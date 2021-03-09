SELECT        TOP (100) PERCENT {{SQL.SOURCE}}.Currency.Code, {{SQL.SOURCE}}.Currency.Name, {{SQL.SOURCE}}.Currency.AmountDp, {{SQL.SOURCE}}.Currency.Country, {{SQL.SOURCE}}.Country.Name AS CountryName
FROM            {{SQL.SOURCE}}.Currency INNER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.Currency.Country = {{SQL.SOURCE}}.Country.Code
WHERE        ({{SQL.SOURCE}}.Currency.InternalDeleted IS NULL) AND ({{SQL.SOURCE}}.Currency.Active = 1)
ORDER BY {{SQL.SOURCE}}.Currency.Code
