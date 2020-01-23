Using the BCFXSPOT loader - add in a pre-routine that pulls the list from a particular DB using SQL code like this;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [CodeMajorCurrencyIsoCode]
      ,[CodeMinorCurrencyIsoCode]
  FROM [rel_gateway_sal_prd_demo-sys-3].[dbo].[CurrencyPair]
  where Active=1 and InternalDeleted is null

  NOTE USE THE SQL QUERY FUNC

  This should update the SIENA.CONFIG>forwards.list
