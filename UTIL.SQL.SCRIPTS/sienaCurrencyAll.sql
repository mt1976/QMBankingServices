SELECT        TOP (100) PERCENT {{SQL.SOURCE}}.Currency.Code, {{SQL.SOURCE}}.Currency.Name, {{SQL.SOURCE}}.Currency.Active, {{SQL.SOURCE}}.Currency.AmountDp, {{SQL.SOURCE}}.Currency.Country, {{SQL.SOURCE}}.Country.Name AS CountryName
FROM            {{SQL.SOURCE}}.Currency INNER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.Currency.Country = {{SQL.SOURCE}}.Country.Code
WHERE        ({{SQL.SOURCE}}.Currency.InternalDeleted IS NULL)
ORDER BY {{SQL.SOURCE}}.Currency.Code
