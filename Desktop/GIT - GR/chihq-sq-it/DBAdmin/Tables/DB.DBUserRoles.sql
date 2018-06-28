CREATE TABLE [DB].[DBUserRoles]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBRole] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[DBUsrID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_DBUserRoles] ON [DB].[DBUserRoles] ([InstanceName], [DBName], [DateAdded], [DBUsrID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
