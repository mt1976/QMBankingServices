SELECT        {{SQL.SOURCE}}.UnauthorisedPayee.KeyCounterpartyFirm, {{SQL.SOURCE}}.UnauthorisedPayee.KeyCounterpartyCentre, {{SQL.SOURCE}}.UnauthorisedPayee.KeyName, {{SQL.SOURCE}}.UnauthorisedPayee.Currency, {{SQL.SOURCE}}.UnauthorisedPayee.FullName,
                         {{SQL.SOURCE}}.UnauthorisedPayee.Address, {{SQL.SOURCE}}.UnauthorisedPayee.PhoneNo, {{SQL.SOURCE}}.UnauthorisedPayee.Country, {{SQL.SOURCE}}.UnauthorisedPayee.Bic, {{SQL.SOURCE}}.UnauthorisedPayee.Iban, {{SQL.SOURCE}}.UnauthorisedPayee.AccountNo,
                         {{SQL.SOURCE}}.UnauthorisedPayee.FedWireNo, {{SQL.SOURCE}}.UnauthorisedPayee.SortCode, {{SQL.SOURCE}}.UnauthorisedPayee.BankName, {{SQL.SOURCE}}.UnauthorisedPayee.BankPinCode, {{SQL.SOURCE}}.UnauthorisedPayee.BankAddress, {{SQL.SOURCE}}.UnauthorisedPayee.Reason,
                         {{SQL.SOURCE}}.UnauthorisedPayee.BankSettlementAcct, {{SQL.SOURCE}}.UnauthorisedPayee.IntermediaryBankName, {{SQL.SOURCE}}.UnauthorisedPayee.IntermediaryBankAddress, {{SQL.SOURCE}}.UnauthorisedPayee.IntermediaryBankSwiftBic,
                         {{SQL.SOURCE}}.UnauthorisedPayee.IntermediaryAcctNo, {{SQL.SOURCE}}.UnauthorisedPayee.IntermediaryIban, {{SQL.SOURCE}}.UnauthorisedPayee.NostroInternalAccountNumber, {{SQL.SOURCE}}.UnauthorisedPayee.NostroBIC, {{SQL.SOURCE}}.UnauthorisedPayee.Usr,
                         {{SQL.SOURCE}}.UnauthorisedPayee.Status, {{SQL.SOURCE}}.UnauthorisedPayee.CreationDate, {{SQL.SOURCE}}.UnauthorisedPayee.AmendedDate, {{SQL.SOURCE}}.Country.Name AS CountryName, {{SQL.SOURCE}}.Currency.Name AS CurrencyName
FROM            {{SQL.SOURCE}}.UnauthorisedPayee INNER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.UnauthorisedPayee.Country = {{SQL.SOURCE}}.Country.Code INNER JOIN
                         {{SQL.SOURCE}}.Currency ON {{SQL.SOURCE}}.UnauthorisedPayee.Currency = {{SQL.SOURCE}}.Currency.Code
WHERE        ({{SQL.SOURCE}}.UnauthorisedPayee.InternalDeleted IS NULL)
