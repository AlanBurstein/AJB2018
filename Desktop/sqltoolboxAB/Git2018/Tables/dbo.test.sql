CREATE TABLE [dbo].[test]
(
[stringId] [bigint] NOT NULL,
[string] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[test] ADD CONSTRAINT [pk_cl__dbo_test] PRIMARY KEY CLUSTERED  ([stringId]) ON [PRIMARY]
GO
