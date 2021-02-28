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

CREATE VIEW [SRS].[MandatedUser]
AS
SELECT        MandatedUserKeyUserName
FROM            RG.MandatedUser
WHERE        (InternalDeleted IS NULL) AND (Active = 1)
GO
