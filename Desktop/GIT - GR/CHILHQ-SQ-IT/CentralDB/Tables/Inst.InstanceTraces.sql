CREATE TABLE [Inst].[InstanceTraces]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id] [int] NOT NULL,
[status] [int] NOT NULL,
[path] [nvarchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[max_size] [bigint] NULL,
[stop_time] [datetime] NULL,
[max_files] [int] NULL,
[is_rowset] [bit] NULL,
[is_rollover] [bit] NULL,
[is_shutdown] [bit] NULL,
[is_default] [bit] NULL,
[buffer_count] [int] NULL,
[buffer_size] [int] NULL,
[file_position] [bigint] NULL,
[reader_spid] [int] NULL,
[start_time] [datetime] NULL,
[last_event_time] [datetime] NULL,
[event_count] [bigint] NULL,
[dropped_event_count] [int] NULL,
[RunDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
