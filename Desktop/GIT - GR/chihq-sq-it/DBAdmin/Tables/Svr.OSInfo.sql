CREATE TABLE [Svr].[OSInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OSName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSArchitecture] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSVersion] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSServicePack] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSInstallDate] [smalldatetime] NULL,
[OSLastRestart] [smalldatetime] NULL,
[OSUpTime] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSTotalVisibleMemorySizeInGB] [decimal] (10, 2) NULL,
[OSFreePhysicalMemoryInGB] [decimal] (10, 2) NULL,
[OSTotalVirtualMemorySizeInGB] [decimal] (10, 2) NULL,
[OSFreeVirtualMemoryInGB] [decimal] (10, 2) NULL,
[OSFreeSpaceInPagingFilesInGB] [decimal] (10, 2) NULL,
[DateAdded] [smalldatetime] NULL,
[OSID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_OSInfo] ON [Svr].[OSInfo] ([ServerName], [DateAdded], [OSID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
