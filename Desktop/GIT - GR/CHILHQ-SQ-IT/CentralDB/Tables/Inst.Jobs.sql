CREATE TABLE [Inst].[Jobs]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobOwner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsEnabled] [bit] NULL,
[category] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobCreatedDate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobLastModified] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastRunDate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextRunDate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastRunOutcome] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentRunRetryAttempt] [smallint] NULL,
[OperatorToEmail] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OperatorToPage] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasSchedule] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[JobID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_Jobs] ON [Inst].[Jobs] ([ServerName], [InstanceName], [DateAdded], [JobID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
