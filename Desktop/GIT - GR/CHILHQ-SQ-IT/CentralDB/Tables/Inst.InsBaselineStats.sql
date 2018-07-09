CREATE TABLE [Inst].[InsBaselineStats]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FwdRecSec] [decimal] (15, 0) NOT NULL,
[FlScansSec] [decimal] (15, 0) NOT NULL,
[IdxSrchsSec] [decimal] (15, 0) NOT NULL,
[PgSpltSec] [decimal] (15, 0) NOT NULL,
[FreeLstStallsSec] [decimal] (15, 0) NOT NULL,
[LzyWrtsSec] [decimal] (15, 0) NOT NULL,
[PgLifeExp] [decimal] (15, 0) NOT NULL,
[PgRdSec] [decimal] (15, 0) NOT NULL,
[PgWtSec] [decimal] (15, 0) NOT NULL,
[LogGrwths] [decimal] (15, 0) NOT NULL,
[TranSec] [decimal] (15, 0) NOT NULL,
[BlkProcs] [decimal] (15, 0) NOT NULL,
[UsrConns] [decimal] (15, 0) NOT NULL,
[LatchWtsSec] [decimal] (15, 0) NOT NULL,
[LckWtTime] [decimal] (15, 0) NOT NULL,
[LckWtsSec] [decimal] (15, 0) NOT NULL,
[DeadLockSec] [decimal] (15, 0) NOT NULL,
[MemGrnts] [decimal] (15, 0) NOT NULL,
[BatReqSec] [decimal] (15, 0) NOT NULL,
[SQLCompSec] [decimal] (15, 0) NOT NULL,
[SQLReCompSec] [decimal] (15, 0) NOT NULL,
[RunDate] [smalldatetime] NOT NULL CONSTRAINT [DF_InsStats_RunDate] DEFAULT (getdate()),
[InsBLID] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_InsBaselineStats] ON [Inst].[InsBaselineStats] ([ServerName], [InstanceName], [RunDate], [InsBLID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
