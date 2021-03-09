SELECT        Code
FROM            {{SQL.SOURCE}}.Currency
WHERE        (InternalDeleted IS NULL) AND (Active = 1)
