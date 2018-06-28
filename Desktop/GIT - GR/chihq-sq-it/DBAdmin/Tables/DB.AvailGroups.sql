CREATE TABLE [DB].[AvailGroups]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryReplica] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SyncHealth] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BackupPreference] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Failoverlevel] [int] NULL,
[HealthChkTimeout] [int] NULL,
[ListenerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListenerIP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListenerPort] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[AGID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_AGInfo] ON [DB].[AvailGroups] ([ServerName], [InstanceName], [DateAdded], [AGID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
