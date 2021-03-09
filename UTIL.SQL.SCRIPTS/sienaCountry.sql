SELECT        Code, Name, ShortCode, EU_EEA, InternalDeleted
FROM            {{SQL.SOURCE}}.Country
WHERE        (InternalDeleted IS NULL)
