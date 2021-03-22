SELECT        {{SQL.SOURCE}}.NegotiableInstrument.NIName, {{SQL.SOURCE}}.NegotiableInstrument.Status, {{SQL.SOURCE}}.NegotiableInstrument.Type, {{SQL.SOURCE}}.NegotiableInstrument.CurrencyCode, {{SQL.SOURCE}}.NegotiableInstrument.IssuerFirm, {{SQL.SOURCE}}.NegotiableInstrument.IssuerCentre,
                         {{SQL.SOURCE}}.NegotiableInstrument.AcceptorFirm, {{SQL.SOURCE}}.NegotiableInstrument.AcceptorCentre, {{SQL.SOURCE}}.NegotiableInstrument.IssueDate, {{SQL.SOURCE}}.NegotiableInstrument.MaturityDate, {{SQL.SOURCE}}.NegotiableInstrument.RateType,
                         {{SQL.SOURCE}}.NegotiableInstrument.CouponRate, {{SQL.SOURCE}}.NegotiableInstrument.InterestBasis, {{SQL.SOURCE}}.NegotiableInstrument.InterestFrequency, {{SQL.SOURCE}}.NegotiableInstrument.ClearingSystem, {{SQL.SOURCE}}.NegotiableInstrument.ParentDealType,
                         {{SQL.SOURCE}}.NegotiableInstrument.SecurityID, {{SQL.SOURCE}}.NegotiableInstrument.Encumbered, {{SQL.SOURCE}}.NegotiableInstrument.Marketable, {{SQL.SOURCE}}.NegotiableInstrument.Hypothecated, {{SQL.SOURCE}}.NegotiableInstrument.RepoFactor,
                         {{SQL.SOURCE}}.NegotiableInstrument.LotSize, {{SQL.SOURCE}}.Currency.Name AS CurrencyName, {{SQL.SOURCE}}.Firm.FullName AS IssuerFirmName, {{SQL.SOURCE}}.Centre.FullName AS IssuerCentreName
FROM            {{SQL.SOURCE}}.NegotiableInstrument LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Firm ON {{SQL.SOURCE}}.NegotiableInstrument.IssuerFirm = {{SQL.SOURCE}}.Firm.FirmName LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Centre ON {{SQL.SOURCE}}.NegotiableInstrument.IssuerCentre = {{SQL.SOURCE}}.Centre.ShortName LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Currency ON {{SQL.SOURCE}}.NegotiableInstrument.CurrencyCode = {{SQL.SOURCE}}.Currency.Code
WHERE        ({{SQL.SOURCE}}.NegotiableInstrument.InternalDeleted IS NULL)
