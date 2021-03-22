SELECT        {{SQL.SOURCE}}.CpartyGroup.Name, {{SQL.SOURCE}}.CpartyGroup.CountryCode, {{SQL.SOURCE}}.CpartyGroup.SuperGroup, {{SQL.SOURCE}}.Country.Name AS CountryName
FROM            {{SQL.SOURCE}}.CpartyGroup LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.CpartyGroup.CountryCode = {{SQL.SOURCE}}.Country.Code
WHERE        ({{SQL.SOURCE}}.CpartyGroup.InternalDeleted IS NULL)
