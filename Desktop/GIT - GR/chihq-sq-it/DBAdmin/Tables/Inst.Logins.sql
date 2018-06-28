CREATE TABLE [Inst].[Logins]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginCreateDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginLastModified] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDisabled] [bit] NULL,
[IsLocked] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[LoginID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_Logins] ON [Inst].[Logins] ([ServerName], [InstanceName], [DateAdded], [LoginID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
