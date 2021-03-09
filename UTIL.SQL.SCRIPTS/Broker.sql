SELECT        Code
FROM            {{SQL.SOURCE}}.Broker
WHERE        (InternalDeleted IS NULL)
