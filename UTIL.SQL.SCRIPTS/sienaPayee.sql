SELECT        {{SQL.SOURCE}}.Payee.KeyCounterpartyFirm, {{SQL.SOURCE}}.Payee.KeyCounterpartyCentre, {{SQL.SOURCE}}.Payee.KeyCurrency, {{SQL.SOURCE}}.Payee.KeyName, {{SQL.SOURCE}}.Payee.KeyNumber, {{SQL.SOURCE}}.Payee.KeyDirection, {{SQL.SOURCE}}.Payee.KeyType, {{SQL.SOURCE}}.Payee.FullName,
                         {{SQL.SOURCE}}.Payee.Address, {{SQL.SOURCE}}.Payee.PhoneNo, {{SQL.SOURCE}}.Payee.Country, {{SQL.SOURCE}}.Payee.Bic, {{SQL.SOURCE}}.Payee.Iban, {{SQL.SOURCE}}.Payee.AccountNo, {{SQL.SOURCE}}.Payee.FedWireNo, {{SQL.SOURCE}}.Payee.SortCode, {{SQL.SOURCE}}.Payee.BankName, {{SQL.SOURCE}}.Payee.BankPinCode,
                         {{SQL.SOURCE}}.Payee.BankAddress, {{SQL.SOURCE}}.Payee.Reason, {{SQL.SOURCE}}.Payee.BankSettlementAcct, {{SQL.SOURCE}}.Payee.IntermediaryBankName, {{SQL.SOURCE}}.Payee.IntermediaryBankAddress, {{SQL.SOURCE}}.Payee.IntermediaryBankSwiftBic, {{SQL.SOURCE}}.Payee.IntermediaryAcctNo,
                         {{SQL.SOURCE}}.Payee.IntermediaryIban, {{SQL.SOURCE}}.Payee.NostroInternalAccountNumber, {{SQL.SOURCE}}.Payee.NostroBIC, {{SQL.SOURCE}}.Country.Name AS CountryName, {{SQL.SOURCE}}.Currency.Name AS CurrencyName
FROM            {{SQL.SOURCE}}.Payee INNER JOIN
                         {{SQL.SOURCE}}.Country ON {{SQL.SOURCE}}.Payee.Country = {{SQL.SOURCE}}.Country.Code INNER JOIN
                         {{SQL.SOURCE}}.Currency ON {{SQL.SOURCE}}.Payee.KeyCurrency = {{SQL.SOURCE}}.Currency.Code
WHERE        ({{SQL.SOURCE}}.Payee.InternalDeleted IS NULL)
