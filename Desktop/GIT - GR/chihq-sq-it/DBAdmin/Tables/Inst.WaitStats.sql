CREATE TABLE [Inst].[WaitStats]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WaitType] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wait_S] [decimal] (14, 2) NULL,
[Resource_S] [decimal] (14, 2) NULL,
[Signal_S] [decimal] (14, 2) NULL,
[WaitCount] [bigint] NULL,
[Percentage] [decimal] (4, 2) NULL,
[AvgWait_S] [decimal] (14, 2) NULL,
[AvgRes_S] [decimal] (14, 2) NULL,
[AvgSig_S] [decimal] (14, 2) NULL,
[DateAdded] [smalldatetime] NULL,
[WtID] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_WaitStats] ON [Inst].[WaitStats] ([ServerName], [InstanceName], [DateAdded], [WtID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
