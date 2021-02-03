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

CREATE VIEW [SRS].[vwRandomizerUsers]
AS

SELECT        UserName
FROM            RG.Usr
WHERE        (Type = 'CORE') AND (InternalDeleted IS NULL)}

GO
