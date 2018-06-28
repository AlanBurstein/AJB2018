CREATE TABLE [DB].[AvailReplicas]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplicaName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Role] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AvailabilityMode] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FailoverMode] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SessionTimeout] [int] NULL,
[ConnectionsInPrimaryRole] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReadableSecondary] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndpointUrl] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BackupPriority] [int] NULL,
[AGCreateDate] [smalldatetime] NULL,
[AGModifyDate] [smalldatetime] NULL,
[DateAdded] [smalldatetime] NULL,
[AGRPID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_AGReplInfo] ON [DB].[AvailReplicas] ([ServerName], [InstanceName], [DateAdded], [AGRPID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
