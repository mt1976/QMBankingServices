SELECT        {{SQL.SOURCE}}.SystemCounterparty.SystemKey, {{SQL.SOURCE}}.SystemCounterparty.NameFirm, {{SQL.SOURCE}}.SystemCounterparty.NameCentre, {{SQL.SOURCE}}.SystemCounterpartyExtensions.FeeType, {{SQL.SOURCE}}.SystemCounterpartyExtensions.NonMonetaryBenefits,
                         {{SQL.SOURCE}}.SystemCounterpartyExtensions.Rebate, {{SQL.SOURCE}}.SystemCounterpartyExtensions.TradingMode, {{SQL.SOURCE}}.SystemCounterpartyExtensions.TradingPlatform, {{SQL.SOURCE}}.SystemCounterpartyExtensions.TradingSystem,
                         {{SQL.SOURCE}}.SystemCounterpartyExtensions.WebsiteURL
FROM            {{SQL.SOURCE}}.SystemCounterparty LEFT OUTER JOIN
                         {{SQL.SOURCE}}.SystemCounterpartyExtensions ON {{SQL.SOURCE}}.SystemCounterparty.SystemKey = {{SQL.SOURCE}}.SystemCounterpartyExtensions.SystemKey
WHERE        ({{SQL.SOURCE}}.SystemCounterparty.InternalDeleted IS NULL)
