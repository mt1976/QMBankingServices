SELECT        UserName
FROM            {{SQL.SOURCE}}.Usr
WHERE        (Type = 'CORE') AND (InternalDeleted IS NULL)
