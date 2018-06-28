CREATE TABLE [Inst].[SessionLogSummary]
(
[ServerName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Instance] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatabaseId] [int] NULL,
[DatabaseName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sessionloginname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ntusername] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ntdomainname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hostname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[applicationname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loginname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SessionDate] [datetime] NULL,
[Reads] [bigint] NULL,
[Writes] [bigint] NULL,
[CPU] [int] NULL,
[Duration] [bigint] NULL,
[LoginCount] [int] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IXC_SessionLogSummary] ON [Inst].[SessionLogSummary] ([SessionDate], [DatabaseName]) ON [PRIMARY]
GO
