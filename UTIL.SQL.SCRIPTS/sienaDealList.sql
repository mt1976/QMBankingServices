SELECT        {{SQL.SOURCE}}.Deals.SienaReference, {{SQL.SOURCE}}.Deals.CustomerSienaView, {{SQL.SOURCE}}.Deals.Status, {{SQL.SOURCE}}.Deals.StartDate AS ValueDate, {{SQL.SOURCE}}.Deals.MaturityDate, {{SQL.SOURCE}}.Deals.ContractNumber, {{SQL.SOURCE}}.Deals.ExternalReference, {{SQL.SOURCE}}.Deals.Book,
                         {{SQL.SOURCE}}.Deals.MandatedUser, {{SQL.SOURCE}}.Deals.Portfolio, {{SQL.SOURCE}}.Deals.AgreementId, {{SQL.SOURCE}}.Deals.BackOfficeRefNo, {{SQL.SOURCE}}.Deals.ISIN, {{SQL.SOURCE}}.Deals.UTI, {{SQL.SOURCE}}.Book.FullName AS BookName, RIGHT({{SQL.SOURCE}}.Deals.CustomerSienaView, 3) AS Centre,
                         RTRIM(LTRIM(LEFT({{SQL.SOURCE}}.Deals.CustomerSienaView, 10))) AS Firm, {{SQL.SOURCE}}.FundamentalDealType.DealTypeShortName, {{SQL.SOURCE}}.Deals.FullDealType, {{SQL.SOURCE}}.Deals.TradeDate, {{SQL.SOURCE}}.Deals.DealtCcy, {{SQL.SOURCE}}.Deals.DealtAmount,
                         {{SQL.SOURCE}}.Deals.AgainstAmount, {{SQL.SOURCE}}.Deals.AgainstCcy, {{SQL.SOURCE}}.Deals.AllInRate, {{SQL.SOURCE}}.Deals.MktRate, {{SQL.SOURCE}}.Deals.SettleCcy, {{SQL.SOURCE}}.Deals.Direction, {{SQL.SOURCE}}.Deals.NpvRate, {{SQL.SOURCE}}.Deals.OriginUser, {{SQL.SOURCE}}.Deals.PayInstruction,
                         {{SQL.SOURCE}}.Deals.ReceiptInstruction, {{SQL.SOURCE}}.Deals.NIName, { fn CONCAT({{SQL.SOURCE}}.Deals.DealtCcy, {{SQL.SOURCE}}.Deals.AgainstCcy) } AS CCYPair, ISNULL(NULLIF ({{SQL.SOURCE}}.Deals.NIName, NULL), { fn CONCAT({{SQL.SOURCE}}.Deals.DealtCcy, {{SQL.SOURCE}}.Deals.AgainstCcy) })
                         AS Instrument, {{SQL.SOURCE}}.Portfolio.Description1 AS PortfolioName, {{SQL.SOURCE}}.DealRevaluation.Date AS RVDate, {{SQL.SOURCE}}.DealRevaluation.MarkToMarket AS RVMTM, {{SQL.SOURCE}}.Deals.CounterBook, Book_1.FullName AS CounterBookName,
                         ISNULL(NULLIF ({{SQL.SOURCE}}.Deals.CounterBook, NULL), {{SQL.SOURCE}}.Deals.CustomerSienaView) AS Party, ISNULL(NULLIF (Book_1.FullName, NULL), {{SQL.SOURCE}}.Deals.CustomerSienaView) AS PartyName
FROM            {{SQL.SOURCE}}.Deals INNER JOIN
                         {{SQL.SOURCE}}.DealType ON {{SQL.SOURCE}}.Deals.FullDealType = {{SQL.SOURCE}}.DealType.DealTypeKey INNER JOIN
                         {{SQL.SOURCE}}.FundamentalDealType ON {{SQL.SOURCE}}.DealType.FundamentalDealTypeKey = {{SQL.SOURCE}}.FundamentalDealType.DealTypeKey INNER JOIN
                         {{SQL.SOURCE}}.Currency ON {{SQL.SOURCE}}.Deals.DealtCcy = {{SQL.SOURCE}}.Currency.Code LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Book AS Book_1 ON {{SQL.SOURCE}}.Deals.CounterBook = Book_1.BookName LEFT OUTER JOIN
                         {{SQL.SOURCE}}.DealRevaluation ON {{SQL.SOURCE}}.Deals.SienaReference = {{SQL.SOURCE}}.DealRevaluation.DealRefNo LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Book ON {{SQL.SOURCE}}.Deals.Book = {{SQL.SOURCE}}.Book.BookName LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Portfolio ON {{SQL.SOURCE}}.Deals.Portfolio = {{SQL.SOURCE}}.Portfolio.Code
WHERE        ({{SQL.SOURCE}}.Deals.InternalDeleted IS NULL) AND ({{SQL.SOURCE}}.FundamentalDealType.DealTypeShortName <> 'Acct') AND ({{SQL.SOURCE}}.FundamentalDealType.InternalDeleted IS NULL) AND ({{SQL.SOURCE}}.DealType.InternalDeleted IS NULL) AND
                         ({{SQL.SOURCE}}.Deals.LimitOrderType IS NULL)
