SELECT        Code, Description1 AS Name
FROM            {{SQL.SOURCE}}.Portfolio
WHERE        (InternalDeleted IS NULL)
