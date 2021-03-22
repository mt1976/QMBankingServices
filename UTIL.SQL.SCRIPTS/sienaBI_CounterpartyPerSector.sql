SELECT        COUNT(InternalId) AS Count, SectorCode
FROM            {{SQL.SOURCE}}.Counterparty
GROUP BY InternalDeleted, SectorCode
HAVING        (InternalDeleted IS NULL)
