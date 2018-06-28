CREATE TABLE [Tbl].[HekatonTbls]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TblName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsMemoryOptimized] [bit] NULL,
[Durability] [tinyint] NULL,
[DurabilityDesc] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemAllocForIdxInKB] [bigint] NULL,
[MemAllocForTblInKB] [bigint] NULL,
[MemUsdByIdxInKB] [bigint] NULL,
[MemUsdByTblInKB] [bigint] NULL,
[DateAdded] [smalldatetime] NULL,
[HID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_HekatonInfo] ON [Tbl].[HekatonTbls] ([ServerName], [InstanceName], [DateAdded], [HID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
