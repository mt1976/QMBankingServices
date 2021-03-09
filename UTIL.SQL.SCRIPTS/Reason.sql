SELECT        Reason
FROM            {{SQL.SOURCE}}.EditDealReason
WHERE        (InternalDeleted IS NULL)
