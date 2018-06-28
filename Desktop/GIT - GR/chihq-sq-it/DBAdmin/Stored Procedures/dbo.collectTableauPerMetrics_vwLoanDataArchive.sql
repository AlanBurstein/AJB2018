SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[collectTableauPerMetrics_vwLoanDataArchive] 
AS

SET NOCOUNT ON;
BEGIN
  -- 1. Create a constant with the time of the last update
  DECLARE @lastInsert datetime = (SELECT MAX(startTime) FROM dbo.tableauPerfmetrics);

  -- 2. Check dbo.tableauPerfmetrics for new tableau queries that use vwLoanDataArchive
  IF EXISTS
  (
    SELECT 1
    FROM CentralDB.Inst.LongRunningQuery with (nolock)
    WHERE loginname = 'grcorp\org_tableau'
    AND starttime > @lastInsert
    AND TextData NOT LIKE 'declare @p%'
    AND TextData LIKE '%vwLoanDataArchive%'
  )
  BEGIN
    PRINT 'Adding new rows';
  
    -- 3. Add rows created since the last insert
    INSERT dbo.tableauPerfmetrics
    (
      materialized,txtLen,queryId,txt,[minutes],[seconds],
      startTime,EndTime,Reads,Writes,CPU,mObject,rowCounts
    )
    SELECT
      materialized = 1,
      txtLen       = LEN(CAST(textdata as nvarchar(max))),
      queryId      = CHECKSUM(CAST(textdata as nvarchar(max))),
      txt          = CAST(textdata as nvarchar(max)),
    	[minutes]    = DATEDIFF(SECOND,StartTime,EndTime)/60,
      [seconds]    = DATEDIFF(SECOND,StartTime,EndTime)%60,
      startTime, EndTime, Reads, Writes, CPU, 
      'vwLoanDataArchive_persisted', ISNULL(rowCounts,0)
    FROM [CentralDB].[Inst].[LongRunningQuery] with (nolock)
    WHERE loginname = 'grcorp\org_tableau'
    AND starttime > @lastInsert -- since last insert
    AND TextData NOT LIKE 'declare @p%'
    AND TextData LIKE '%vwLoanDataArchive%';
  
    PRINT CAST(@@rowcount AS varchar(10))+' rows added to dbo.tableauPerfmetrics';
  
    -- 4. Add new lookup records
    INSERT dbo.tableauPerfmetricsLookup (materialized, txtLen, queryId, txt)
    SELECT DISTINCT materialized, txtLen, queryId, txt
    FROM dbo.tableauPerfmetrics
    WHERE starttime > @lastInsert
    AND queryId NOT IN (SELECT DISTINCT queryId FROM dbo.tableauPerfmetrics); 
    -- filter for rows new rows only for a lighter sort

    PRINT CAST(@@rowcount AS varchar(10))+' rows added to dbo.tableauPerfmetricsLookup';

   -- 5. De-duplicate lookup records (may not need this in the future)
   WITH dedupe AS
   (
     SELECT 
       rn = ROW_NUMBER() OVER (PARTITION BY queryId, Materialized ORDER BY (SELECT 1)), *
     FROM dbo.tableauPerfmetricsLookup
   )
   DELETE FROM dedupe WHERE rn > 1;
   PRINT CAST(@@rowcount AS varchar(10))+' duplicates removed from dbo.tableauPerfmetricsLookup';

  END
  ELSE PRINT 'Nothing new to add. Have a great day!';
END;
GO
