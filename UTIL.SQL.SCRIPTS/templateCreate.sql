USE [{{SQL.DB}}]
GO

/****** Object:  View [dbo].[vwRateSourceCurrencyPair]    Script Date: 26/08/2020 10:11:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'{{SQL.SCHEMA}}' )
    EXEC('CREATE SCHEMA {{SQL.SCHEMA}}');
GO

CREATE VIEW [{{SQL.SCHEMA}}].[{{SQL.VIEW}}]
AS

{{SQL.BODY}}}

GO
