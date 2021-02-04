SELECT        Code
FROM            RG.Currency
WHERE        (InternalDeleted IS NULL) AND (Active = 1)
