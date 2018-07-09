CREATE TABLE [Svr].[ServerList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Inventory] [bit] NOT NULL,
[Baseline] [bit] NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessOwner] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL CONSTRAINT [DF_ServerList_DateAdded] DEFAULT (getdate()),
[SQLPing] [bit] NULL,
[PingSnooze] [datetime2] NULL,
[MaintStart] [datetime2] NULL,
[MaintEnd] [datetime2] NULL,
[RunningTraces] [bit] NULL,
[SLO] [bit] NULL,
[SLODate] [datetime2] NULL,
[LRQ] [bit] NULL,
[LRQDate] [datetime2] NULL,
[RS] [bit] NULL,
[RSDate] [datetime2] NULL,
[ConfluencePageID] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Svr].[ServerList] ADD CONSTRAINT [IX_ServerList_InsName] UNIQUE NONCLUSTERED  ([InstanceName]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_ServerList] ON [Svr].[ServerList] ([ServerName], [InstanceName], [DateAdded], [ID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
