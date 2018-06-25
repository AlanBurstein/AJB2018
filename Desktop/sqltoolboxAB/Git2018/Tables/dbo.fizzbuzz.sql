CREATE TABLE [dbo].[fizzbuzz]
(
[N] [bigint] NULL,
[FB] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [uq_cl_dbo_fizzbuzz__N] ON [dbo].[fizzbuzz] ([N]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [nc_uq_dbo_fizzbuzz] ON [dbo].[fizzbuzz] ([N], [FB]) ON [PRIMARY]
GO
