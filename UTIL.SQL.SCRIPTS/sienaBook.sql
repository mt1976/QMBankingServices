SELECT        BookName, FullName
FROM            {{SQL.SOURCE}}.Book
WHERE        (InternalDeleted IS NULL)
