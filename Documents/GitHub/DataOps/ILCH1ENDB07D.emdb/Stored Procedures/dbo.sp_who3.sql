SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_who3]
(
    @SessionID int = NULL
)
AS
BEGIN
SELECT
    SPID                = er.session_id
    ,Status             = ses.status
    ,[Login]            = ses.login_name
    ,Host               = ses.host_name
    ,BlkBy              = er.blocking_session_id
    ,DBName             = DB_Name(er.database_id)
    ,CommandType        = er.command
    ,SQLStatement       =
        SUBSTRING
        (
            qt.text,
            er.statement_start_offset/2,
            (CASE WHEN er.statement_end_offset = -1
                THEN LEN(CONVERT(nvarchar(MAX), qt.text)) * 2
                ELSE er.statement_end_offset
                END - er.statement_start_offset)/2
        )
    ,ObjectName         = OBJECT_SCHEMA_NAME(qt.objectid,dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid)
    ,ElapsedMS          = er.total_elapsed_time
    ,CPUTime            = er.cpu_time
    ,IOReads            = er.logical_reads + er.reads
    ,IOWrites           = er.writes
    ,LastWaitType       = er.last_wait_type
    ,StartTime          = er.start_time
    ,Protocol           = con.net_transport
    ,ConnectionWrites   = con.num_writes
    ,ConnectionReads    = con.num_reads
    ,ClientAddress      = con.client_net_address
    ,Authentication     = con.auth_scheme
FROM sys.dm_exec_requests er
LEFT JOIN sys.dm_exec_sessions ses
ON ses.session_id = er.session_id
LEFT JOIN sys.dm_exec_connections con
ON con.session_id = ses.session_id
OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) as qt
WHERE er.session_id > 50
    AND @SessionID IS NULL OR er.session_id = @SessionID
ORDER BY
    er.blocking_session_id DESC
    ,er.session_id
 
END
GO
