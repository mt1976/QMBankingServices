Select '{{SQL.SOURCE}}.Payee' AS SourceTable
        ,KeyCounterpartyFirm
        ,KeyCounterpartyCentre
        ,KeyCurrency
,KeyName
,KeyNumber
,KeyDirection
,KeyType
,FullName
,Address
,PhoneNo
,Country
,Bic
,Iban
,AccountNo
,FedWireNo
,SortCode
,BankName
,BankPinCode
,BankAddress
,Reason
,BankSettlementAcct
,UpdatedUserId

From {{SQL.SOURCE}}.Payee

UNION ALL

Select '{{SQL.SOURCE}}.UnauthorisedPayee' AS SourceTable
        ,KeyCounterpartyFirm
        ,KeyCounterpartyCentre
              ,Currency
        ,KeyName
,'1'
,''
,''
,FullName
,Address
,PhoneNo
,Country
,Bic
,Iban
,AccountNo
,FedWireNo
,SortCode
,BankName
,BankPinCode
,BankAddress
,Reason
,BankSettlementAcct
,Usr

From {{SQL.SOURCE}}.UnauthorisedPayee
