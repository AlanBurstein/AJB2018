CREATE TABLE [DB].[DatabaseInfoExt]
(
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Purpose] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OnServers] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
