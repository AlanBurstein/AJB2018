SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[getDeadlockGraph]() RETURNS TABLE AS RETURN
/*
-- using:	https://www.red-gate.com/simple-talk/sql/database-administration/handling-deadlocks-in-sql-server/

Assumes that traceflag 1222 (for tracing deadlocks) is turned on; 

to turn traceflag 1222 on:
  DBCC TRACEON(1222, -1) 
To turn it off:
  DBCC TRACEOFF (1222)
To see if it's running:
  DBCC TRACESTATUS(1222)
*/
SELECT DeadlockGraph = CAST(event_data.value('.','varchar(max)') AS XML)
FROM    
(
  SELECT event_data = XEvent.query('.')
  FROM
  (
    SELECT TargetData = CAST(st.target_data AS XML) -- Cast the target_data to XML
    FROM sys.dm_xe_session_targets st
    JOIN sys.dm_xe_sessions s ON s.address = st.event_session_address
    WHERE s.[name]     = 'system_health'
    AND st.target_name = 'ring_buffer'
  ) AS Data -- Split out the Event Nodes 
  CROSS APPLY TargetData.nodes
    ('RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData(XEvent)
) AS tab(event_data);
GO
