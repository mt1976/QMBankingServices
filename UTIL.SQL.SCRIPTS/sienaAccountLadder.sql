SELECT        SienaReference, BusinessDate, ContractNumber, Balance
FROM            {{SQL.SOURCE}}.CashBalance
WHERE        (InternalDeleted IS NULL)
