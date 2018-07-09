SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnTableauPerfmetricsAgg](@monthsBack /* default=3 */ tinyint)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP (1000000000000) -- forces the ORDER BY clause from function
  queryGroup = DENSE_RANK() OVER (ORDER BY queryId),
  x.materialized,
  x.mObject,
  x.queryId,
	x.queryYear,
  x.queryMonth,
  totalRows     = SUM(x.rowCounts),
  avgRowCounts  = AVG(x.rowCounts),
  totalCPU      = SUM(x.CPU),
  avgCPU        = AVG(x.CPU),
  totalReads    = SUM(x.Reads),
  avgReads      = AVG(x.Reads),
  totalRuns     = COUNT(*), 
  totalTime     = SUM(fn.tm), 
  avgTime       = AVG(fn.tm),
  fastestTime   = MIN(fn.tm),
  slowestTime   = MAX(fn.tm),
  avgTimePerRow = LEFT(1.*SUM(fn.tm)/SUM(x.rowCounts),12),
  LastExecution = MAX(x.startTime)
FROM dbo.tableauPerfmetrics x
CROSS APPLY (VALUES (x.[minutes]*60+x.[seconds])) fn(tm)
WHERE 
(
  (x.materialized = 0 AND queryId IN 
    (SELECT queryId FROM dbo.tableauPerfmetrics WHERE materialized = 1)) OR
  (x.materialized = 1 AND queryId IN 
    (SELECT queryId FROM dbo.tableauPerfmetrics WHERE materialized = 0))
)
AND x.startTime >= 
  (
    SELECT CAST(DATEADD(DAY, -DAY(fn.base)+1, fn.base) AS date) 
	  FROM (VALUES (DATEADD(MONTH, -ISNULL(@monthsBack,3), getdate()))) fn(base)
	) -- gets the 1st day of the month beginning @monthsBack months ago
GROUP BY x.queryId, x.mObject, x.materialized, x.queryYear, x.queryMonth
ORDER BY x.queryId, x.materialized, x.queryYear, x.queryMonth;
GO
