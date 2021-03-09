SELECT        Code, Style, AllCurrencies, CurrencyIsoCode, RateCategory
FROM            {{SQL.SOURCE}}.IRType
WHERE        (InternalDeleted IS NULL)
