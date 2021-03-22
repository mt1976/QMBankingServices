SELECT        {{SQL.SOURCE}}.Deals.SienaReference, {{SQL.SOURCE}}.Deals.CustomerSienaView, {{SQL.SOURCE}}.Deals.SienaCommonRef, {{SQL.SOURCE}}.Deals.Status, {{SQL.SOURCE}}.Deals.StartDate, {{SQL.SOURCE}}.Deals.MaturityDate, {{SQL.SOURCE}}.Deals.ContractNumber, {{SQL.SOURCE}}.Deals.ExternalReference,
                         {{SQL.SOURCE}}.Deals.DealtCcy AS CCY, {{SQL.SOURCE}}.Deals.Book, {{SQL.SOURCE}}.Deals.MandatedUser, {{SQL.SOURCE}}.Deals.BackOfficeNotes, {{SQL.SOURCE}}.Deals.CashBalance, {{SQL.SOURCE}}.Deals.AccountNumber, {{SQL.SOURCE}}.Deals.AccountName, {{SQL.SOURCE}}.Deals.LedgerBalance, {{SQL.SOURCE}}.Deals.Portfolio,
                         {{SQL.SOURCE}}.Deals.AgreementId, {{SQL.SOURCE}}.Deals.BackOfficeRefNo, {{SQL.SOURCE}}.Deals.PaymentSystemSienaView, {{SQL.SOURCE}}.Deals.ISIN, {{SQL.SOURCE}}.Deals.UTI, {{SQL.SOURCE}}.Currency.Name AS CCYName, {{SQL.SOURCE}}.Book.FullName AS BookName,
                         {{SQL.SOURCE}}.Portfolio.Description1 AS PortfolioName, RIGHT({{SQL.SOURCE}}.Deals.CustomerSienaView, 3) AS Centre, LEFT({{SQL.SOURCE}}.Deals.CustomerSienaView, LEN({{SQL.SOURCE}}.Deals.CustomerSienaView) - 3) AS Firm, {{SQL.SOURCE}}.Currency.AmountDp AS CCYDp
FROM            {{SQL.SOURCE}}.FundamentalDealType LEFT OUTER JOIN
                         {{SQL.SOURCE}}.DealType ON {{SQL.SOURCE}}.FundamentalDealType.DealTypeKey = {{SQL.SOURCE}}.DealType.FundamentalDealTypeKey RIGHT OUTER JOIN
                         {{SQL.SOURCE}}.Deals ON {{SQL.SOURCE}}.DealType.DealTypeKey = {{SQL.SOURCE}}.Deals.FullDealType LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Currency ON {{SQL.SOURCE}}.Deals.DealtCcy = {{SQL.SOURCE}}.Currency.Code LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Book ON {{SQL.SOURCE}}.Deals.Book = {{SQL.SOURCE}}.Book.BookName LEFT OUTER JOIN
                         {{SQL.SOURCE}}.Portfolio ON {{SQL.SOURCE}}.Deals.Portfolio = {{SQL.SOURCE}}.Portfolio.Code
WHERE        ({{SQL.SOURCE}}.FundamentalDealType.DealTypeShortName = 'Acct') AND ({{SQL.SOURCE}}.FundamentalDealType.InternalDeleted IS NULL) AND ({{SQL.SOURCE}}.DealType.InternalDeleted IS NULL) AND ({{SQL.SOURCE}}.Deals.InternalDeleted IS NULL)
