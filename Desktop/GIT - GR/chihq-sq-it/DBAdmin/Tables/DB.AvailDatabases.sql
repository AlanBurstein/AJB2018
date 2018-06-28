CREATE TABLE [DB].[AvailDatabases]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGDBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryReplica] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SyncState] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SyncHealth] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBState] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSuspended] [bit] NULL,
[SuspendReason] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGDBCreateDate] [smalldatetime] NULL,
[DateAdded] [smalldatetime] NULL,
[AGDBID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_AGDBInfo] ON [DB].[AvailDatabases] ([ServerName], [InstanceName], [DateAdded], [AGDBID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
