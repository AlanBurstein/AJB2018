SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Inst].[vwLongRunningQuery] WITH SCHEMABINDING AS 
SELECT
  fullQuery   = tr.q,
  objStartPos = SUBSTRING(tr.q, CHARINDEX('FROM ', tr.q),100),
  objType     = CASE 
                  WHEN tr.q LIKE 'EXEC %' THEN 'Proc' 
                  WHEN tr.q LIKE 'insert%exec%' THEN 'INSERT EXEC'
                  WHEN CHARINDEX('[',tr.q) > 0 THEN 'obj' 
                END,
  objPreview  = obj.preview,
  obj1        = SUBSTRING(obj.preview, CHARINDEX('].[', obj.preview)+2, 8000),
  obj2        = SUBSTRING(obj.preview, 1, CHARINDEX('].[',obj.preview)),
  queryTime   = DATEDIFF(MINUTE,lq.StartTime,lq.EndTime) + 
                  DATEDIFF(SECOND,lq.StartTime,lq.EndTime)%60/60.
FROM Inst.LongRunningQuery lq -- long query
CROSS JOIN Inst.today_ajb t   -- today
CROSS APPLY (VALUES (CAST(lq.textData as varchar(8000)))) AS tr(q) -- trimmed query
CROSS APPLY (VALUES (SUBSTRING(tr.q,1,
  CHARINDEX(']', tr.q, CHARINDEX('].[', tr.q, CHARINDEX('[', tr.q)+1)+3)))
    ) AS trq(obj) -- trimmed query object
CROSS APPLY (VALUES (CHARINDEX('[', trq.obj))) b(s) -- block start
CROSS APPLY (VALUES (SUBSTRING(trq.obj, b.s, 8000))) obj(preview)
WHERE lq.loginname = 'grcorp\org_tableau'
AND lq.starttime > DATEADD(DAY,-t.duration,t.dt);
GO
