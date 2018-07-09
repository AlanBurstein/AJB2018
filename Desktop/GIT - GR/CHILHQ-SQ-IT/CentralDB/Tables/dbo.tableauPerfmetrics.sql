CREATE TABLE [dbo].[tableauPerfmetrics]
(
[materialized] [int] NULL,
[txtLen] [bigint] NULL,
[queryId] [int] NULL,
[txt] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rowCounts] [bigint] NOT NULL,
[minutes] [int] NULL,
[seconds] [int] NULL,
[startTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[Reads] [bigint] NULL,
[Writes] [bigint] NULL,
[CPU] [int] NULL,
[queryMonth] AS (datepart(month,[startTime])) PERSISTED,
[queryYear] AS (datepart(year,[startTime])) PERSISTED,
[mObject] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc__dbo_tableauPerfMetrics__materialized_queryId_txtLen] ON [dbo].[tableauPerfmetrics] ([materialized], [queryId], [txtLen]) INCLUDE ([txt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc__dbo_tableauPerfmetrics__materialized_startTime] ON [dbo].[tableauPerfmetrics] ([materialized], [startTime]) INCLUDE ([CPU], [minutes], [mObject], [queryId], [queryMonth], [queryYear], [Reads], [rowCounts], [seconds]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [cl__dbo_tableauPerfmetrics__queryId] ON [dbo].[tableauPerfmetrics] ([queryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc__dbo_tableauPerfmetrics__startTime] ON [dbo].[tableauPerfmetrics] ([startTime]) INCLUDE ([minutes], [queryId], [queryMonth], [queryYear], [seconds]) ON [PRIMARY]
GO
