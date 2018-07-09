CREATE TABLE [DB].[DBFileGrowth]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataFileInMB] [int] NULL,
[LogFileInMB] [int] NULL,
[DateAdded] [smalldatetime] NULL,
[DBFGID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_DBFileGrowth] ON [DB].[DBFileGrowth] ([InstanceName], [DBName], [DateAdded], [DBFGID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
