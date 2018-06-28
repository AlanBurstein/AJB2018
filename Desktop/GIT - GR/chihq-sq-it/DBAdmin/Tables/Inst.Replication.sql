CREATE TABLE [Inst].[Replication]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsPublisher] [bit] NULL,
[IsDistributor] [bit] NULL,
[DistributorAvailable] [bit] NULL,
[Publisher] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Distributor] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subscribers] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplPubDBs] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DistDB] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[RID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_ReplInfo] ON [Inst].[Replication] ([ServerName], [InstanceName], [DateAdded], [RID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
