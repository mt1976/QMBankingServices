SELECT        {{SQL.SOURCE}}.DealAuditEvent.Timestamp AS HDate, {{SQL.SOURCE}}.DealAuditEvent.EventType AS Code, CONCAT_WS(' ', SRS.sienaDealList.FullDealType, {{SQL.SOURCE}}.DealAuditEvent.EventType, {{SQL.SOURCE}}.DealAuditEvent.DealRefNo, {{SQL.SOURCE}}.DealAuditEvent.Status,
                         {{SQL.SOURCE}}.DealAuditEvent.Details) AS Name, '0' AS SettleOK
FROM            {{SQL.SOURCE}}.DealAuditEvent INNER JOIN
                         SRS.sienaDealList ON {{SQL.SOURCE}}.DealAuditEvent.DealRefNo = SRS.sienaDealList.SienaReference
WHERE        ({{SQL.SOURCE}}.DealAuditEvent.InternalDeleted IS NULL)
