SELECT        Name, ReportDealsOver, ReportDealsOverCCY, AccountTransferCutOffTime, AccountTransferCutOffTimeTimeZone, AccountTransferCutOffTimeCutOffPeriod
FROM            {{SQL.SOURCE}}.SalesTradingEntity
WHERE        (InternalDeleted IS NULL)
