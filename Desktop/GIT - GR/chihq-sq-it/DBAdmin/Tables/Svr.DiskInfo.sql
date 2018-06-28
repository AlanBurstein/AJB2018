CREATE TABLE [Svr].[DiskInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DiskName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Label] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileSystem] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DskClusterSizeInKB] [int] NULL,
[DskTotalSizeInGB] [decimal] (10, 2) NULL,
[DskFreeSpaceInGB] [decimal] (10, 2) NULL,
[DskUsedSpaceInGB] [decimal] (10, 2) NULL,
[DskPctFreeSpace] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[DiskID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_DiskInfo] ON [Svr].[DiskInfo] ([ServerName], [DateAdded], [DiskID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
