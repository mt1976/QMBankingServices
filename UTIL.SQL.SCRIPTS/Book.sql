SELECT        BookName
FROM            {{SQL.SOURCE}}.Book
WHERE        (InternalDeleted IS NULL)
