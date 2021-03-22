SELECT        Name
FROM            {{SQL.SOURCE}}.TraderTradingEntity
WHERE        (InternalDeleted IS NULL)
