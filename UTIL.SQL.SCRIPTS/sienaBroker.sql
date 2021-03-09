SELECT        Code, Name, FullName, Contact, Address, LEI
FROM            {{SQL.SOURCE}}.Broker
WHERE        (InternalDeleted IS NULL)
