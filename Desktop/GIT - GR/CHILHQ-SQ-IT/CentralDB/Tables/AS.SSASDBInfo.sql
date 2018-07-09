CREATE TABLE [AS].[SSASDBInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBSizeInMB] [decimal] (10, 2) NULL,
[Collation] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompatibilityLevel] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBCreateDate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBLastProcessed] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBLastUpdated] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBStorageLocation] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoOfCubes] [smallint] NULL,
[NoOfDimensions] [smallint] NULL,
[ReadWriteMode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StorgageEngineUsed] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[ASDBID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_SSASDBInfo] ON [AS].[SSASDBInfo] ([ServerName], [InstanceName], [DateAdded], [ASDBID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
