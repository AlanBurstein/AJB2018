SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnTableauPerfmetricsAgg_timeGains](@monthsBack tinyint)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH base AS
(
  SELECT
    [QueryGroup] = 'Group '+CAST(queryGroup AS varchar(4)),
    [Object]     = mObject,
    [Year]       = queryYear,
    [Month]      = queryMonth,
    Executions   = totalRuns,
    AvgTime,
    AvgTimePerRow
  FROM dbo.fnTableauPerfmetricsAgg(@monthsBack)
),
agg AS
(
  SELECT QueryGroup, [Object], Executions = SUM(Executions), AvgTime = AVG(avgTime)
  FROM base
  GROUP BY QueryGroup, [Object]
),
Lag1 AS
(
  SELECT rn = ROW_NUMBER() OVER (ORDER BY QueryGroup, [Object]), QueryGroup, [Object], 
         Executions, AvgTime
  FROM agg
)
SELECT TOP (1000000000000)
  a.QueryGroup,
  a.[Object],
  a.Executions,
  a.AvgTime,
  [Avg Time Gained/Lost per query (seconds)] = f.gl,
  [Total Time Gained/Lost (minutes)] = f.gl*a.Executions/60.,
  [Total Time Gained/Lost (hours)] = f.gl*a.Executions/60./60
FROM Lag1 a
LEFT JOIN Lag1 b ON a.rn = b.rn-1
LEFT JOIN Lag1 c ON a.rn = c.rn+1
CROSS APPLY (VALUES (CASE a.rn%2 WHEN 1 THEN b.AvgTime ELSE c.AvgTime END - a.AvgTime)) f(gl)
ORDER BY a.QueryGroup, a.[Object]
GO
