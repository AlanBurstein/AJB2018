CREATE TABLE [DB].[Triggers]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TriggerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModified] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsEnabled] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[DBTrgID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_DBTriggers] ON [DB].[Triggers] ([InstanceName], [DBName], [DateAdded], [DBTrgID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
