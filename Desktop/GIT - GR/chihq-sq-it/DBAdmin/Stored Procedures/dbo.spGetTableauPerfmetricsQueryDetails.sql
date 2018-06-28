SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[spGetTableauPerfmetricsQueryDetails] @queryId bigint
AS
SET NOCOUNT ON;
-- get a specific query
DECLARE @queryText varchar(max) = 
ISNULL((
  SELECT txt
  FROM dbo.tableauPerfmetricsLookup
  WHERE queryId = @queryId
  AND materialized = 1), 'Query not found. Sorry.');

EXEC dbadmin.dbo.longprint @queryText;
GO
