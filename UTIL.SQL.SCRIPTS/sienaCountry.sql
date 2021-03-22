SELECT        Code, Name, ShortCode, EU_EEA
FROM            {{SQL.SOURCE}}.Country
WHERE        (InternalDeleted IS NULL)
