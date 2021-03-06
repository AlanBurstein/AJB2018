CREATE TABLE [Inst].[InstanceInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IPAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Port] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQLVersion] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQLPatchLevel] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSPUpToDate] [bit] NULL,
[SQLEdition] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQLVersionNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Collation] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RootDirectory] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultDataPath] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultLogPath] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorLogPath] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCaseSensitive] [bit] NULL,
[IsClustered] [bit] NULL,
[IsFullTextInstalled] [bit] NULL,
[IsSingleUser] [bit] NULL,
[IsAlwaysOnEnabled] [bit] NULL,
[TCPEnabled] [bit] NULL,
[NamedPipesEnabled] [bit] NULL,
[ClusterName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClusterQuorumState] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClusterQuorumType] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlwaysOnStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaxMemInMB] [int] NULL,
[MinMemInMB] [int] NULL,
[MaxDOP] [tinyint] NULL,
[NoOfUsrDBs] [smallint] NULL,
[NoOfJobs] [smallint] NULL,
[NoOfLnkSvrs] [smallint] NULL,
[NoOfLogins] [smallint] NULL,
[NoOfRoles] [tinyint] NULL,
[NoOfTriggers] [tinyint] NULL,
[NoOfAvailGrps] [tinyint] NULL,
[AvailGrps] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsXTPSupported] [bit] NULL,
[FilFactor] [tinyint] NULL,
[ProcessorUsage] [int] NULL,
[ActiveNode] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClusterNodeNames] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[InstID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_InstanceInfo] ON [Inst].[InstanceInfo] ([ServerName], [InstanceName], [DateAdded], [InstID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
