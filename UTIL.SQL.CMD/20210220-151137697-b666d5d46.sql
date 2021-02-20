USE [ReportingDb_sal_prd_demo_sys-3]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'SRS' )
    EXEC('CREATE SCHEMA SRS');
GO

CREATE VIEW [SRS].[CurrencyPair]
AS
SELECT        RG.CurrencyPair.CodeMajorCurrencyIsoCode, RG.CurrencyPair.CodeMinorCurrencyIsoCode, RG.CurrencyPair.Active, RG.CurrencyPair.SpotRerouteDataRerouteCurrency, RG.CurrencyPairRateRICCode.RICCode,
                         RG.CurrencyPairRateRICCode.Period, { fn CONCAT(RG.CurrencyPair.CodeMajorCurrencyIsoCode, { fn CONCAT('\', RG.CurrencyPair.CodeMinorCurrencyIsoCode) }) } AS CODE1,
                         { fn CONCAT(RG.CurrencyPair.CodeMajorCurrencyIsoCode, RG.CurrencyPair.CodeMinorCurrencyIsoCode) } AS CODE2
FROM            RG.CurrencyPair INNER JOIN
                         RG.CurrencyPairRateRICCode ON RG.CurrencyPair.CodeMajorCurrencyIsoCode = RG.CurrencyPairRateRICCode.CodeMajorCurrencyIsoCode AND
                         RG.CurrencyPair.CodeMinorCurrencyIsoCode = RG.CurrencyPairRateRICCode.CodeMinorCurrencyIsoCode
WHERE        (RG.CurrencyPairRateRICCode.RICCode <> '') AND (RG.CurrencyPair.SpotRerouteDataRerouteCurrency = '') AND (RG.CurrencyPairRateRICCode.Period = 'Spot') AND (RG.CurrencyPair.Active = 1)
GO
