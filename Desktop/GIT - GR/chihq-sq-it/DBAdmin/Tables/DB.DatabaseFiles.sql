CREATE TABLE [DB].[DatabaseFiles]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileID] [int] NULL,
[TypeDesc] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogicalName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhysicalName] [nvarchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SizeInMB] [int] NULL,
[GrowthPct] [int] NULL,
[GrowthInMB] [int] NULL,
[DateAdded] [smalldatetime] NULL,
[DBFlID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_DatabaseFiles] ON [DB].[DatabaseFiles] ([ServerName], [InstanceName], [DBName], [DateAdded], [DBFlID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
