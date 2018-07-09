CREATE TABLE [Svr].[ServerInfo]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IPAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturer] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemType] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActiveNodeName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Domain] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DomainRole] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartOfDomain] [bit] NULL,
[NumberOfProcessors] [int] NULL,
[NumberOfLogicalProcessors] [int] NULL,
[NumberOfCores] [int] NULL,
[IsHyperThreaded] [bit] NULL,
[CurrentCPUSpeed] [int] NULL,
[MaxCPUSpeed] [int] NULL,
[IsPowerSavingModeON] [bit] NULL,
[TotalPhysicalMemoryInGB] [decimal] (10, 2) NULL,
[IsPagefileManagedBySystem] [bit] NULL,
[IsVM] [bit] NULL,
[IsClu] [bit] NULL,
[DateAdded] [smalldatetime] NULL,
[SvrID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_ServerInfo] ON [Svr].[ServerInfo] ([ServerName], [DateAdded], [SvrID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
