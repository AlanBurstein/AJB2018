CREATE TABLE [dbo].[sysdiagrams]
(
[name] [sys].[sysname] NOT NULL,
[principal_id] [int] NOT NULL,
[diagram_id] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[version] [int] NULL,
[definition] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagrams__65A1E6AD] PRIMARY KEY CLUSTERED  ([diagram_id]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED  ([principal_id], [name]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
