CREATE TABLE [Svr].[PgFileUsage]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PgFileLocation] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PgAllocBaseSzInGB] [decimal] (10, 2) NULL,
[PgCurrUsageInGB] [decimal] (10, 2) NULL,
[PgPeakUsageInGB] [decimal] (10, 2) NULL,
[DateAdded] [smalldatetime] NULL,
[PFID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_PgFileUsage] ON [Svr].[PgFileUsage] ([ServerName], [DateAdded], [PFID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
