SELECT        Description1
FROM            {{SQL.SOURCE}}.Portfolio
WHERE        (InternalDeleted IS NULL)
