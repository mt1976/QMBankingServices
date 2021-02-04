SELECT        MandatedUserKeyUserName
FROM            RG.MandatedUser
WHERE        (InternalDeleted IS NULL) AND (Active = 1)
