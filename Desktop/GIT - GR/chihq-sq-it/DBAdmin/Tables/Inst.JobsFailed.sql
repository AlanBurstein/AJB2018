CREATE TABLE [Inst].[JobsFailed]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StepID] [int] NULL,
[StepName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrMsg] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobRunDate] [smalldatetime] NULL,
[DateAdded] [smalldatetime] NULL,
[JFID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_JobFailInfo] ON [Inst].[JobsFailed] ([ServerName], [InstanceName], [DateAdded], [JFID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
