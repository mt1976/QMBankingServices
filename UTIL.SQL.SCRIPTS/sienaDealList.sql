SELECT        dbo.Deals.SienaReference, dbo.Deals.CustomerSienaView, dbo.Deals.Status, dbo.Deals.StartDate AS ValueDate, dbo.Deals.MaturityDate, dbo.Deals.ContractNumber, dbo.Deals.ExternalReference, dbo.Deals.Book,
                         dbo.Deals.MandatedUser, dbo.Deals.Portfolio, dbo.Deals.AgreementId, dbo.Deals.BackOfficeRefNo, dbo.Deals.ISIN, dbo.Deals.UTI, dbo.Book.FullName AS BookName, RIGHT(dbo.Deals.CustomerSienaView, 3) AS Centre,
                         RTRIM(LTRIM(LEFT(dbo.Deals.CustomerSienaView, 10))) AS Firm, dbo.FundamentalDealType.DealTypeShortName, dbo.Deals.FullDealType, dbo.Deals.TradeDate, dbo.Deals.DealtCcy, dbo.Deals.DealtAmount,
                         dbo.Deals.AgainstAmount, dbo.Deals.AgainstCcy, dbo.Deals.AllInRate, dbo.Deals.MktRate, dbo.Deals.SettleCcy, dbo.Deals.Direction, dbo.Deals.NpvRate, dbo.Deals.OriginUser, dbo.Deals.PayInstruction,
                         dbo.Deals.ReceiptInstruction, dbo.Deals.NIName, { fn CONCAT(dbo.Deals.DealtCcy, dbo.Deals.AgainstCcy) } AS CCYPair, ISNULL(NULLIF (dbo.Deals.NIName, NULL), { fn CONCAT(dbo.Deals.DealtCcy, dbo.Deals.AgainstCcy) }) 
                         AS Instrument, dbo.Portfolio.Description1 AS PortfolioName, dbo.DealRevaluation.Date AS RVDate, dbo.DealRevaluation.MarkToMarket AS RVMTM, dbo.Deals.CounterBook, Book_1.FullName AS CounterBookName,
                         ISNULL(NULLIF (dbo.Deals.CounterBook, NULL), dbo.Deals.CustomerSienaView) AS Party, ISNULL(NULLIF (Book_1.FullName, NULL), dbo.Deals.CustomerSienaView) AS PartyName
FROM            dbo.Deals INNER JOIN
                         dbo.DealType ON dbo.Deals.FullDealType = dbo.DealType.DealTypeKey INNER JOIN
                         dbo.FundamentalDealType ON dbo.DealType.FundamentalDealTypeKey = dbo.FundamentalDealType.DealTypeKey INNER JOIN
                         dbo.Currency ON dbo.Deals.DealtCcy = dbo.Currency.Code LEFT OUTER JOIN
                         dbo.Book AS Book_1 ON dbo.Deals.CounterBook = Book_1.BookName LEFT OUTER JOIN
                         dbo.DealRevaluation ON dbo.Deals.SienaReference = dbo.DealRevaluation.DealRefNo LEFT OUTER JOIN
                         dbo.Book ON dbo.Deals.Book = dbo.Book.BookName LEFT OUTER JOIN
                         dbo.Portfolio ON dbo.Deals.Portfolio = dbo.Portfolio.Code
WHERE        (dbo.Deals.InternalDeleted IS NULL) AND (dbo.FundamentalDealType.DealTypeShortName <> 'Acct') AND (dbo.FundamentalDealType.InternalDeleted IS NULL) AND (dbo.DealType.InternalDeleted IS NULL) AND
                         (dbo.Deals.LimitOrderType IS NULL)
