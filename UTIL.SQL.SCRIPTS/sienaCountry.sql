SELECT        Code, Name, ShortCode, EU_EEA, InternalDeleted
FROM            dbo.Country
WHERE        (InternalDeleted IS NULL)
