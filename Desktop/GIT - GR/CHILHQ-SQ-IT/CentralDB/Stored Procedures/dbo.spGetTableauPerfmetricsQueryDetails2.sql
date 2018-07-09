SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[spGetTableauPerfmetricsQueryDetails2] @queryId bigint
AS
SET NOCOUNT ON;
-- get a specific query
DECLARE @queryText varchar(max) = 
ISNULL((
  SELECT txt
  FROM dbo.tableauPerfmetricsLookup
  WHERE queryId = @queryId
  AND materialized = 1), 'Query not found. Sorry.');

SELECT query = @queryText
GO
