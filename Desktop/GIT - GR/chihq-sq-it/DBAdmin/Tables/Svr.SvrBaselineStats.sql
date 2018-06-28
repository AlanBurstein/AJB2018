CREATE TABLE [Svr].[SvrBaselineStats]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RunDate] [smalldatetime] NOT NULL,
[PctProcTm] [decimal] (10, 5) NOT NULL,
[ProcQLen] [int] NOT NULL,
[AvDskRd] [decimal] (10, 5) NOT NULL,
[AvDskWt] [decimal] (10, 5) NOT NULL,
[AvDskQLen] [decimal] (10, 5) NOT NULL,
[AvailMB] [bigint] NOT NULL,
[PgFlUsg] [decimal] (10, 5) NOT NULL,
[SvrBLID] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_SvrBaselineStats] ON [Svr].[SvrBaselineStats] ([ServerName], [InstanceName], [RunDate], [SvrBLID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
