CREATE TABLE [dbo].[tableauPerfmetricsLookup]
(
[materialized] [int] NULL,
[queryId] [int] NULL,
[txtLen] [bigint] NULL,
[txt] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [cl_uq__dbo_tableauPerfmetricsLookup__queryId_materialized] ON [dbo].[tableauPerfmetricsLookup] ([queryId], [materialized]) ON [PRIMARY]
GO
