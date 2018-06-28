CREATE TABLE [Inst].[MissingIndexes]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemaName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MITable] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[improvement_measure] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[create_index_statement] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[group_handle] [int] NULL,
[unique_compiles] [int] NULL,
[user_seeks] [int] NULL,
[last_user_seek] [smalldatetime] NULL,
[avg_total_user_cost] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[avg_user_impact] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[MIID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_MissingIndexes] ON [Inst].[MissingIndexes] ([ServerName], [InstanceName], [DBName], [DateAdded], [MIID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
