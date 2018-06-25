CREATE TABLE [dbo].[keyword]
(
[kwId] [int] NOT NULL IDENTITY(1, 1),
[kw] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[kwLen] AS (CONVERT([tinyint],len([kw]),(0)))
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [nc_uq_dbo_keyword] ON [dbo].[keyword] ([kw], [kwLen] DESC) ON [PRIMARY]
GO
