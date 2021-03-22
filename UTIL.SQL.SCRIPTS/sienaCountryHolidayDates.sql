SELECT        Code, InternalDeleted, DATEFROMPARTS(YEAR(GETDATE()), HMonth, HDay) AS HDate, Name, SettleOK
FROM            {{SQL.SOURCE}}.CountryHolidaysAnnualDates
WHERE        (InternalDeleted IS NULL)
