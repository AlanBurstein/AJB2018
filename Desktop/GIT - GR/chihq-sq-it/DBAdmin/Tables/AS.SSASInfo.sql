CREATE TABLE [AS].[SSASInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASVersion] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASPatchLevel] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSPUpToDateOnAS] [bit] NULL,
[ASEdition] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASVersionNo] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoOfDBs] [smallint] NULL,
[LastSchemaUpdate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsConnected] [bit] NULL,
[IsMajorObjLoaded] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[ASID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_SSASInfo] ON [AS].[SSASInfo] ([ServerName], [InstanceName], [DateAdded], [ASID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
