SELECT        MAX(CurrentDate) AS Today
FROM            {{SQL.SOURCE}}.BusinessDate
WHERE        (InternalDeleted IS NULL) AND (DealingStatus = 'Permitted')
