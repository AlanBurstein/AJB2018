CREATE TABLE [Inst].[SessionLog]
(
[servername] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Instance] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[databaseid] [int] NULL,
[databasename] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sessionloginname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ntusername] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ntdomainname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hostname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[applicationname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loginname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eventsubclass] [int] NULL,
[success] [int] NULL,
[eventclass] [int] NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[Reads] [bigint] NULL,
[Writes] [bigint] NULL,
[CPU] [int] NULL,
[Duration] [bigint] NULL,
[LoginCount] [int] NULL,
[Rundate] [datetime] NULL
) ON [PRIMARY]
GO
