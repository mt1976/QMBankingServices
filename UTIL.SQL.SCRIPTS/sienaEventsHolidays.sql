SELECT        '{{SQL.SOURCE}}.CountryHolidayDates' AS SourceTable, Code, HDate, Name, SettleOK
FROM            {{SQL.SOURCE}}.CountryHolidaysDates
UNION ALL
SELECT   'SRS.sienaEventHolidaysAnnualDates' AS SourceTable, Code, HDate, Name, SettleOK
FROM SRS.sienaEventsHolidaysAnnualDates
