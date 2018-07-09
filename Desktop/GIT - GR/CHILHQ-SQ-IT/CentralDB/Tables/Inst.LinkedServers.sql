CREATE TABLE [Inst].[LinkedServers]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkedServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProviderName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProviderString] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateLastModified] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataAccess] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[LnkID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_LinkedServers] ON [Inst].[LinkedServers] ([ServerName], [InstanceName], [DateAdded], [LnkID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
