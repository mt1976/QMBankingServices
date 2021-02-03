USE [ReportingDb_sal_prd_demo_sys-3]
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

CREATE VIEW [SRS].[vwRandomizerReason]
AS

SELECT        Reason
FROM            RG.EditDealReason
WHERE        (InternalDeleted IS NULL)}

GO
