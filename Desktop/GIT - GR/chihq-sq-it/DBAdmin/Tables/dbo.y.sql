CREATE TABLE [dbo].[y]
(
[loginname] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[CPU] [int] NULL
) ON [PRIMARY]
GO
