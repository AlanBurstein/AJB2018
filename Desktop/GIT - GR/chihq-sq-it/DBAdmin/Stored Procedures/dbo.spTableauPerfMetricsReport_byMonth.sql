SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[spTableauPerfMetricsReport_byMonth] @months int = 3
AS
SET NOCOUNT ON;

SELECT
  f.queryGroup,
  f.materialized,
  f.mObject,
  f.queryId,
  f.queryYear,
  f.queryMonth,
  f.avgRowCounts,
  f.totalRuns,
  f.avgTime,
  f.slowestTime 
FROM dbo.fnTableauPerfmetricsAgg(@months) f
GO
