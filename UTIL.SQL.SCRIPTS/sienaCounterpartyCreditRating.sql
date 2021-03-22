SELECT        NameFirm, NameCentre, CreditRatingUsage, CreditRatingAgency, CreditRatingName
FROM            {{SQL.SOURCE}}.CounterpartyCreditRatings
WHERE        (InternalDeleted IS NULL)
