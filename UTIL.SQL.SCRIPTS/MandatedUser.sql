SELECT        MandatedUserKeyUserName
FROM            {{SQL.SOURCE}}.MandatedUser
WHERE        (InternalDeleted IS NULL) AND (Active = 1)
