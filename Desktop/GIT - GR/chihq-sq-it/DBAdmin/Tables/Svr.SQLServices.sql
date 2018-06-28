CREATE TABLE [Svr].[SQLServices]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServiceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Started] [bit] NULL,
[StartMode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BinaryPath] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogOnAs] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessId] [int] NULL,
[DateAdded] [smalldatetime] NULL,
[SQLID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_SQLServices] ON [Svr].[SQLServices] ([ServerName], [DateAdded], [SQLID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
