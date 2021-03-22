SELECT        NameFirm, NameCentre, Address1, Address2, CityTown, County, Postcode
FROM            {{SQL.SOURCE}}.CounterpartyAddress
WHERE        (InternalDeleted IS NULL)
