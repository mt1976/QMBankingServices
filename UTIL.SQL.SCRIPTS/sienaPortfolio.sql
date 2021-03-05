SELECT        Code, Description1 AS Name
FROM            dbo.Portfolio
WHERE        (InternalDeleted IS NULL)
