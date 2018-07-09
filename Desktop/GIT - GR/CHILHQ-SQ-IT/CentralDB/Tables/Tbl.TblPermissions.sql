CREATE TABLE [Tbl].[TblPermissions]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClassDesc] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PermName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PermState] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[TBLID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_TblPermsInfo] ON [Tbl].[TblPermissions] ([ServerName], [InstanceName], [DateAdded], [TBLID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
