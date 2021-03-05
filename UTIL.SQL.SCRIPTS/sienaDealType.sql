SELECT        DealTypeKey, DealTypeShortName, FundamentalDealTypeKey, RFQ, RelatedDealType
FROM            dbo.DealType
WHERE        (InternalDeleted IS NULL) AND (IsActive = 1) AND (Interbook = 0)
