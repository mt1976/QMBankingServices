SELECT        Code, Name
FROM            {{SQL.SOURCE}}.Product
WHERE        (InternalDeleted IS NULL)
