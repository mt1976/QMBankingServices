SELECT        Code, Name
FROM            {{SQL.SOURCE}}.Sector
WHERE        (InternalDeleted IS NULL)
