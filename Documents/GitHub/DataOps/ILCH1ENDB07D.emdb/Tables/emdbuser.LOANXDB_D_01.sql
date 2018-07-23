CREATE TABLE [emdbuser].[LOANXDB_D_01]
(
[XrefId] [int] NOT NULL,
[_CX_ACCTDATECHRG4_3] [datetime] NULL,
[_CX_FLOODORDER_1] [datetime] NULL,
[_CX_RESPAAPP_1] [datetime] NULL,
[_CX_ACCTDATECHRG2_2] [datetime] NULL,
[_CX_UFMIPFEESENT_1] [datetime] NULL,
[_CX_PCSUSPEND_1] [datetime] NULL,
[_762] [datetime] NULL,
[Log_MS_Date_Approval] [datetime] NULL,
[_CX_APPRAISEDUE_1] [datetime] NULL,
[_2987] [datetime] NULL,
[_CX_REDISCLOSE_1] [datetime] NULL,
[_CX_ACCTDEPOSIT_2] [datetime] NULL,
[_CX_INSURERASSIGN_1] [datetime] NULL,
[_CX_CONDITIONSUBMIT_1] [datetime] NULL,
[_CX_CLSSCHED_1] [datetime] NULL,
[Log_MS_Date_AssignedtoUW] [datetime] NULL,
[_CX_ACCTDEPOSIT3_3] [datetime] NULL,
[_CX_CONTINGE_1] [datetime] NULL,
[_CX_ACCTDEPOSIT4_3] [datetime] NULL,
[_CX_SUSPENSEDUE_1] [datetime] NULL,
[_CX_ASSIGNPC_1] [datetime] NULL,
[_CX_LOANCOMMITSENT_1] [datetime] NULL,
[_CX_TITLESHIP_3] [datetime] NULL,
[_2352] [datetime] NULL,
[_682] [datetime] NULL,
[Log_MS_Date_submittal] [datetime] NULL,
[_763] [datetime] NULL,
[_CX_RECORDMTGSHIP_3] [datetime] NULL,
[_LOANLASTMODIFIED] [datetime] NULL,
[_2220] [datetime] NULL,
[_CX_FUNDDATE_1] [datetime] NULL,
[_1994] [datetime] NULL,
[_1997] [datetime] NULL,
[_2297] [datetime] NULL,
[_2299] [datetime] NULL,
[_2298] [datetime] NULL,
[_78] [datetime] NULL,
[_2012] [datetime] NULL,
[_CX_ACCTDEPOST2_2] [datetime] NULL,
[_CX_ACCTDATECHRG_2] [datetime] NULL,
[_CX_PAYOFFORDER_1] [datetime] NULL,
[_CX_APPRCVD_1] [datetime] NULL,
[_CX_DATEINSURED_1] [datetime] NULL,
[_2023] [datetime] NULL,
[_CX_PREAPPROVORDER_1] [datetime] NULL,
[_2013] [datetime] NULL,
[_2014] [datetime] NULL,
[_1402] [datetime] NULL,
[_CX_TITLEORDER_1] [datetime] NULL,
[_CX_BROKERCHKRCVD_2] [datetime] NULL,
[_CX_SENDTOSOLLEN_1] [datetime] NULL,
[_761] [datetime] NULL,
[Log_MS_Date_Completion] [datetime] NULL,
[_2145] [datetime] NULL,
[_CX_DATEPCCLEAR_1] [datetime] NULL,
[_363] [datetime] NULL,
[_2147] [datetime] NULL,
[_CX_INSURORDER_1] [datetime] NULL,
[Log_MS_Date_Funding] [datetime] NULL,
[_CX_INSURSENT_1] [datetime] NULL,
[_CX_CLSRUSHDATE_1] [datetime] NULL,
[_2149] [datetime] NULL,
[_2151] [datetime] NULL,
[_1992] [datetime] NULL,
[_1999] [datetime] NULL,
[_CX_SHPDATEASSIGN_1] [datetime] NULL,
[_2222] [datetime] NULL,
[_CX_NORDATE_1] [datetime] NULL,
[_749] [datetime] NULL,
[_CX_APPRAISALRCVD_1] [datetime] NULL,
[_CX_APPSENT_1] [datetime] NULL,
[Log_MS_Date_DocsSigning] [datetime] NULL,
[_CX_ACCTDATECHRG3_3] [datetime] NULL,
[_2303] [datetime] NULL,
[_2301] [datetime] NULL,
[_2305] [datetime] NULL,
[_2304] [datetime] NULL,
[Log_MS_Date_Resubmittal] [datetime] NULL,
[_2302] [datetime] NULL,
[_CX_PACKAGERECVD_1] [datetime] NULL,
[_1961] [datetime] NULL,
[_CX_TITLERCVD_1] [datetime] NULL,
[_CX_TODAY_2] [datetime] NULL,
[_748] [datetime] NULL,
[_CX_BRKREXPIRE_3] [datetime] NULL,
[_CX_BRKRLOCKDATE_3] [datetime] NULL,
[_2370] [datetime] NULL,
[_2308] [datetime] NULL,
[_2313] [datetime] NULL,
[_745] [datetime] NULL,
[_CX_APPRRECV_4] [datetime] NULL,
[_CX_APPRORDER_4] [datetime] NULL,
[_CX_APPRREQUEST_4] [datetime] NULL,
[_CX_APPRDUE_4] [datetime] NULL,
[_CX_APPRDUEFOLLUDATE2_4] [datetime] NULL,
[_3341] [datetime] NULL,
[_CX_3RDDRAW] [datetime] NULL,
[_3312] [datetime] NULL,
[_CX_COMP_DUE_LTR] [datetime] NULL,
[_CX_1STDRAW] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[ti_LOANXDB_D_01_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_01]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF NOT EXISTS( SELECT 1 FROM emdbuser.LoanSummary ls JOIN inserted i ON i.XRefID = ls.XRefID)
	BEGIN

		INSERT INTO emdbuser.LoanSummary([Guid]
										,[LoanNumber]
										,[LoanFolder] 
										,[LoanName]
										,[Status]
										,[loanStatus]
										,[RateLockStatus]
										,[RateIsLocked]
										,[Investor]
										,[Broker]
										,XRefID
										,LockExpirationDate
										,DateCompleted
										,LastModified
										,ActionTakenDate
										,DateShipped
										,InvestorDeliveryDate
										,UnderWriterApprovalDate
										,UnderWriterSuspendedDate
										,UnderWriterDeniedDate)
		SELECT NEWID()
			  ,''
			  ,''
			  ,NEWID()
			  ,'A'
			  ,''
			  ,''
			  ,CASE WHEN i._2149 IS NULL THEN 'N' ELSE 'Y' END
			  ,''
			  ,''
			  ,XRefID
			  ,_762
			  ,Log_MS_Date_Completion
			  ,GETDATE()
			  ,_749
			  ,_2014
			  ,_2012
			  ,_2301
			  ,_2303
			  ,_2987
		FROM inserted i
	END
	ELSE

		UPDATE ls
		SET  LockExpirationDate = i._762
			,DateCompleted = i.Log_MS_Date_Completion
			,LastModified = GETDATE()
			,ActionTakenDate = i._749
			,DateShipped = i._2014
			,InvestorDeliveryDate = i._2012
			,UnderWriterApprovalDate = i._2301
			,UnderWriterSuspendedDate = i._2303
			,UnderWriterDeniedDate = i._2987
			,RateIsLocked = CASE WHEN i._2149 IS NULL THEN 'N' ELSE 'Y' END
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[tu_LOANXDB_D_01_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_01]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF (UPDATE(_762) OR UPDATE(Log_MS_Date_Completion) OR UPDATE(_LOANLASTMODIFIED) OR UPDATE(_749) OR UPDATE(_2014) 
		OR UPDATE(_2012) OR UPDATE(_2301) OR UPDATE(_2303) OR UPDATE(_2987) OR UPDATE(_2149))

		UPDATE ls
		SET  LockExpirationDate = i._762
			,DateCompleted = i.Log_MS_Date_Completion
			,LastModified = GETDATE()
			,ActionTakenDate = i._749
			,DateShipped = i._2014
			,InvestorDeliveryDate = i._2012
			,UnderWriterApprovalDate = i._2301
			,UnderWriterSuspendedDate = i._2303
			,UnderWriterDeniedDate = i._2987
			,RateIsLocked = CASE WHEN i._2149 IS NULL THEN 'N' ELSE 'Y' END
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
ALTER TABLE [emdbuser].[LOANXDB_D_01] ADD CONSTRAINT [PK_LOANXDB_D_01_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_CHILHQSQLDB_Warehouse_DailyLocks_04] ON [emdbuser].[LOANXDB_D_01] ([_2149]) INCLUDE ([_2151], [_2298], [_2301], [_2303], [_2370], [_745], [_748], [_749], [_CX_APPSENT_1], [_CX_FUNDDATE_1], [XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_CHILHQSQLDB_Warehouse_DailyLocks_01] ON [emdbuser].[LOANXDB_D_01] ([_2149]) INCLUDE ([_2370], [_748], [_CX_APPSENT_1], [_CX_FUNDDATE_1], [XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_01__2987__2303__2301__2298_includes] ON [emdbuser].[LOANXDB_D_01] ([_2987], [_2303], [_2301], [_2298]) INCLUDE ([_2151], [_749], [XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_01__761_Includes] ON [emdbuser].[LOANXDB_D_01] ([_761]) INCLUDE ([_2151], [_2370], [_CX_APPSENT_1], [_CX_FUNDDATE_1], [XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_LOANXDB_D_01_763] ON [emdbuser].[LOANXDB_D_01] ([_763]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_1] ON [emdbuser].[LOANXDB_D_01] ([_CX_FUNDDATE_1]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_01__CX_FUNDDATE_1_Includes] ON [emdbuser].[LOANXDB_D_01] ([_CX_FUNDDATE_1]) INCLUDE ([_2149], [_2370], [XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_01__CX_TITLEORDER_1_includes] ON [emdbuser].[LOANXDB_D_01] ([_CX_TITLEORDER_1]) INCLUDE ([XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_01_FrontDesk_02] ON [emdbuser].[LOANXDB_D_01] ([XrefId]) INCLUDE ([_1997], [_2014], [_CX_FUNDDATE_1]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_VelocifyLeadPull_2149] ON [emdbuser].[LOANXDB_D_01] ([XrefId]) INCLUDE ([_2149]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_01_CHILHQSQLDB_rs_BasicData_adalparams1_01] ON [emdbuser].[LOANXDB_D_01] ([XrefId]) INCLUDE ([_748], [_761], [_CX_FUNDDATE_1]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
