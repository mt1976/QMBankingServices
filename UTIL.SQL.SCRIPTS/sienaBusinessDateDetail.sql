SELECT        {{SQL.SCHEMA}}.sienaBusinessDate.Today, {{SQL.SOURCE}}.BusinessDate.CurrentDate, {{SQL.SOURCE}}.BusinessDate.PreviousBusinessDate, {{SQL.SOURCE}}.BusinessDate.CurrentBusinessDate, {{SQL.SOURCE}}.BusinessDate.NextBusinessDate, {{SQL.SOURCE}}.BusinessDate.DealingStatus,
                         {{SQL.SOURCE}}.BusinessDate.RolloverType
FROM            {{SQL.SOURCE}}.BusinessDate INNER JOIN
                         {{SQL.SCHEMA}}.sienaBusinessDate ON {{SQL.SOURCE}}.BusinessDate.CurrentDate = {{SQL.SCHEMA}}.sienaBusinessDate.Today
