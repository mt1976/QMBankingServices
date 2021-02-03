SELECT        UserName
FROM            RG.Usr
WHERE        (Type = 'CORE') AND (InternalDeleted IS NULL)
