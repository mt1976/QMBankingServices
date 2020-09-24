USE [ReportingDb-demo-sys-1]
GO

/****** Object:  View [dbo].[vwRateSourceCurrencyPair]    Script Date: 26/08/2020 10:11:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'SRS' )
    EXEC('CREATE SCHEMA SRS');
GO

CREATE VIEW [SRS].[vwRateSourceCurrencyPair]
AS
SELECT        RG.CurrencyPair.CodeMajorCurrencyIsoCode, RG.CurrencyPair.CodeMinorCurrencyIsoCode,
                         RG.CurrencyPair.Active, RG.CurrencyPair.SpotRerouteDataRerouteCurrency, RG.CurrencyPairRateRICCode.RICCode,
                         RG.CurrencyPairRateRICCode.Period
FROM            RG.CurrencyPair INNER JOIN
                         RG.CurrencyPairRateRICCode ON RG.CurrencyPair.CodeMajorCurrencyIsoCode = RG.CurrencyPairRateRICCode.CodeMajorCurrencyIsoCode AND
                         RG.CurrencyPair.CodeMinorCurrencyIsoCode = RG.CurrencyPairRateRICCode.CodeMinorCurrencyIsoCode
WHERE        (RG.CurrencyPairRateRICCode.RICCode <> '') AND (RG.CurrencyPair.SpotRerouteDataRerouteCurrency = '') AND (RG.CurrencyPairRateRICCode.Period = 'Spot')
GO
