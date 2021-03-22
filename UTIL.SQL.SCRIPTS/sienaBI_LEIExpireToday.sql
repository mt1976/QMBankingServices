SELECT        MAX({{SQL.SOURCE}}.BusinessDate.CurrentDate) AS Today, COUNT({{SQL.SOURCE}}.CounterpartyExtensions.InternalId) AS Count
FROM            {{SQL.SOURCE}}.CounterpartyExtensions LEFT OUTER JOIN
                         {{SQL.SOURCE}}.BusinessDate ON {{SQL.SOURCE}}.CounterpartyExtensions.LEIExpiryDate = {{SQL.SOURCE}}.BusinessDate.CurrentDate
WHERE        ({{SQL.SOURCE}}.CounterpartyExtensions.InternalDeleted IS NULL) AND ({{SQL.SOURCE}}.BusinessDate.InternalDeleted IS NULL)
GROUP BY {{SQL.SOURCE}}.BusinessDate.DealingStatus
HAVING        ({{SQL.SOURCE}}.BusinessDate.DealingStatus = 'Permitted')
