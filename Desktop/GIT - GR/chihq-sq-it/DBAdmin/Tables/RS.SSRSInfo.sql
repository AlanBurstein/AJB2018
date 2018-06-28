CREATE TABLE [RS].[SSRSInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSVersion] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSEdition] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSVersionNo] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSharePointIntegrated] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[RSID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_SSRSInfo] ON [RS].[SSRSInfo] ([ServerName], [InstanceName], [DateAdded], [RSID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
