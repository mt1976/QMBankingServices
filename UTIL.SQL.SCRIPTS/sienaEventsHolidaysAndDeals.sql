SELECT        SourceTable, Code, HDate, Name, SettleOK
FROM            SRS.sienaEventsHolidays
UNION ALL
SELECT        'SRS.sienaEventsDeals' AS SourceTable, Code, HDate, Name, SettleOK
FROM            SRS.sienaEventsDeals
