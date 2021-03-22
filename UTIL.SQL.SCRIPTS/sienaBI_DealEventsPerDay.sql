SELECT        TOP (100) PERCENT StartInterestDate, COUNT(InternalId) AS Count
FROM            {{SQL.SOURCE}}.DealLegsInfo
WHERE        (InternalDeleted IS NULL)
GROUP BY StartInterestDate
HAVING        (NOT (StartInterestDate IS NULL))
ORDER BY StartInterestDate
