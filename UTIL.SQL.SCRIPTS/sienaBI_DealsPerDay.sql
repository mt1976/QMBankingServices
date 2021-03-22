SELECT        TOP (100) PERCENT TradeDate, COUNT(SienaReference) AS Count
FROM            {{SQL.SOURCE}}.Deals
GROUP BY TradeDate, InternalDeleted
HAVING        (InternalDeleted IS NULL)
ORDER BY TradeDate
