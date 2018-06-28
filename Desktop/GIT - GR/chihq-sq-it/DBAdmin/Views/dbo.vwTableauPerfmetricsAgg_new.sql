SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwTableauPerfmetricsAgg_new]
WITH SCHEMABINDING AS
SELECT TOP (1000000000)
  t.mObject,
  t.queryId,
	t.queryYear,
  t.queryMonth,
  totalRows     = SUM(t.rowCounts),
  avgRowCounts  = AVG(t.rowCounts),
  totalCPU      = SUM(t.CPU),
  avgCPU        = AVG(t.CPU),
  totalReads    = SUM(t.Reads),
  avgReads      = AVG(t.Reads),
  totalRuns     = COUNT(*), 
  totalTime     = SUM(fn.tm), 
  avgTime       = AVG(fn.tm),
  fastestTime   = MIN(fn.tm),
  slowestTime   = MAX(fn.tm),
  avgTimePerRow = LEFT(1.*SUM(fn.tm)/SUM(t.rowCounts),12),
  firstExecution = MIN(t.startTime),
  lastExecution = MAX(t.startTime),
  daysRunning   = DATEDIFF(hour, MIN(t.startTime), MAX(t.startTime))/24
FROM dbo.tableauPerfmetrics t
CROSS APPLY (VALUES (t.[minutes]*60+t.[seconds])) fn(tm)
WHERE t.materialized = 1
AND queryId NOT IN 
(
  SELECT queryId 
  FROM dbo.tableauPerfmetrics t2
  WHERE t2.materialized = 0
)
GROUP BY t.mObject, t.queryId, t.queryMonth, t.queryYear
ORDER BY totalRuns DESC;
GO
