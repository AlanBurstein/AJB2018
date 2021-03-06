CREATE TABLE [DB].[DatabaseInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBStatus] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBOwner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBCreateDate] [smalldatetime] NULL,
[DBSizeInMB] [decimal] (10, 2) NULL,
[DBSpaceAvailableInMB] [decimal] (10, 2) NULL,
[DBUsedSpaceInMB] [decimal] (10, 2) NULL,
[DBPctFreeSpace] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBDataSpaceUsageInMB] [decimal] (10, 2) NULL,
[DBIndexSpaceUsageInMB] [decimal] (10, 2) NULL,
[ActiveConnections] [int] NULL,
[Collation] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecoveryModel] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompatibilityLevel] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryFilePath] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastBackupDate] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastDifferentialBackupDate] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastLogBackupDate] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoShrink] [bit] NULL,
[AutoUpdateStatisticsEnabled] [bit] NULL,
[IsReadCommittedSnapshotOn] [bit] NULL,
[IsFullTextEnabled] [bit] NULL,
[BrokerEnabled] [bit] NULL,
[ReadOnly] [bit] NULL,
[EncryptionEnabled] [bit] NULL,
[IsDatabaseSnapshot] [bit] NULL,
[ChangeTrackingEnabled] [bit] NULL,
[IsMirroringEnabled] [bit] NULL,
[MirroringPartnerInstance] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MirroringStatus] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MirroringSafetyLevel] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplicationOptions] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AvailabilityGroupName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoOfTbls] [int] NULL,
[NoOfViews] [smallint] NULL,
[NoOfStoredProcs] [smallint] NULL,
[NoOfUDFs] [smallint] NULL,
[NoOfLogFiles] [tinyint] NULL,
[NoOfFileGroups] [tinyint] NULL,
[NoOfUsers] [smallint] NULL,
[NoOfDBTriggers] [tinyint] NULL,
[LastGoodDBCCCheckDB] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoClose] [bit] NULL,
[HasFileInCloud] [bit] NULL,
[HasMemoryOptimizedObjects] [bit] NULL,
[MemoryAllocatedToMemoryOptimizedObjectsInKB] [decimal] (20, 2) NULL,
[MemoryUsedByMemoryOptimizedObjectsInKB] [decimal] (20, 2) NULL,
[DateAdded] [smalldatetime] NULL,
[DBID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_DatabaseInfo] ON [DB].[DatabaseInfo] ([InstanceName], [DBName], [DateAdded], [DBID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
