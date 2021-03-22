SELECT        COUNT(*) AS [View Count], s.name AS [Schema]
FROM            sys.views AS t INNER JOIN
                         sys.schemas AS s ON s.schema_id = t.schema_id
GROUP BY s.name
