SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[getDeadlockDistinctQueries]() RETURNS TABLE AS RETURN
/*
Requires dbo.getDeadlockGraph
*/
WITH getQuery AS (
 SELECT DISTINCT queryInfo = CAST(processList.process.query('inputbuf/text()') AS VARCHAR(MAX))
 FROM dbo.getDeadlockGraph() dl
 CROSS APPLY dl.deadLockGraph.nodes('/deadlock/process-list/process') processList(process))
SELECT distinctQuery = CAST(q.queryInfo AS XML)
FROM getQuery q
GO
