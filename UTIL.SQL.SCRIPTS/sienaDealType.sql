SELECT        DealTypeKey, DealTypeShortName, FundamentalDealTypeKey, RFQ, RelatedDealType
FROM            {{SQL.SOURCE}}.DealType
WHERE        (InternalDeleted IS NULL) AND (IsActive = 1) AND (Interbook = 0)
