SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [Inst].[spLongRunningQuery] @sortBy varchar(10) AS
BEGIN
  -- 1. Prep
  ----------------------------------------------------------------------------------------
  SET NOCOUNT ON;
  SET ANSI_WARNINGS OFF;

  IF OBJECT_ID('tempdb..#preAgg') IS NOT NULL DROP TABLE #preagg;
  IF OBJECT_ID('tempdb..#agg') IS NOT NULL DROP TABLE #agg;

  -- 2. Populate and Index #preAgg
  ----------------------------------------------------------------------------------------
  PRINT char(10)+'Populate #preAgg'+char(10)+REPLICATE('-',60);
  DECLARE @st datetime = getdate();  

  SELECT 
    obj = CASE WHEN lq.obj2 IN ('[dbo]','[reports]') THEN lq.obj1 ELSE lq.obj2 END,
    lq.queryTime
  INTO #preAgg
  FROM Inst.vwLongRunningQuery lq
  WHERE lq.objType = 'obj' 
  AND lq.obj2 <> ('')
  AND LEN(lq.obj2) < 900
  OPTION (QUERYTRACEON 8649);

  PRINT DATEDIFF(ms,@st,getdate());

  PRINT char(10)+'Index #preAgg'+char(10)+REPLICATE('-',60);
  SET @st = getdate();
  CREATE CLUSTERED INDEX cl_preagg ON #preAgg(obj);
  PRINT DATEDIFF(ms,@st,getdate());

  -- 3. Populate #agg
  ----------------------------------------------------------------------------------------
  PRINT char(10)+'Populate #Agg'+char(10)+REPLICATE('-',60);
  SET @st = getdate();

  SELECT 
    p.obj,
    minQT = MIN(p.queryTime),
    maxQT = MAX(p.queryTime),
    avgQT = AVG(p.queryTime),
    sumQT = SUM(p.queryTime),
    total = COUNT(*)
  INTO #agg
  FROM #preagg p
  GROUP BY p.obj;
  
  PRINT DATEDIFF(ms,@st,getdate());

  -- 4. Output
  ----------------------------------------------------------------------------------------
  SELECT TOP (20) * 
  FROM #agg a
  ORDER BY CASE @sortBy
             WHEN 'max' THEN a.maxQT
             WHEN 'avg' THEN a.avgQT
             WHEN 'sum' THEN a.sumQT
             ELSE a.total
           END DESC
  OPTION (RECOMPILE);
END
GO
