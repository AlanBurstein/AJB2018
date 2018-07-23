CREATE TABLE [emdbuser].[LOANXDB_D_03]
(
[XrefId] [int] NOT NULL,
[_3156] [datetime] NULL,
[_CX_BRKCTC] [datetime] NULL,
[Log_MS_Date_Shipping] [datetime] NULL,
[_CX_CRRPTORDERED] [datetime] NULL,
[_2089] [datetime] NULL,
[_CX_PENDDOCSSENT] [datetime] NULL,
[_2091] [datetime] NULL,
[_L76] [datetime] NULL,
[_L770] [datetime] NULL,
[_CX_GFEDAPROVED] [datetime] NULL,
[_CX_CHANGECIRDT] [datetime] NULL,
[_CX_HUDTOPOD] [datetime] NULL,
[_L724] [datetime] NULL,
[_CX_GFEDDATE] [datetime] NULL,
[_CX_ALLIANTGFE] [datetime] NULL,
[LOCKRATE_2151] [datetime] NULL,
[LOCKRATE_2222] [datetime] NULL,
[LOCKRATE_2220] [datetime] NULL,
[LOCKRATE_2966] [datetime] NULL,
[_CX_CLSPKGTITLE] [datetime] NULL,
[_CX_APPRSCHED2] [datetime] NULL,
[_CX_APPRSCHED3] [datetime] NULL,
[_CX_APPRSCHED1] [datetime] NULL,
[_CX_UWCONDOMGRREV] [datetime] NULL,
[_CX_UWCONDOSUB] [datetime] NULL,
[_CX_UWCONDOAPPR] [datetime] NULL,
[_CX_UWCONDOSUS] [datetime] NULL,
[_CX_APPRORDER2_4] [datetime] NULL,
[_CX_APPRREQUEST2_4] [datetime] NULL,
[_CX_APPRDUE2_4] [datetime] NULL,
[_CX_APPRORDERFOLLUDATE_4] [datetime] NULL,
[LOCKRATE_2149] [datetime] NULL,
[_CX_APPRACPTDATE2_4] [datetime] NULL,
[_CX_APPRACPTDATE_4] [datetime] NULL,
[_CX_APPRDUEFOLLUDATE_4] [datetime] NULL,
[_CX_APPRRECDDATE_4] [datetime] NULL,
[_CX_APPRORDERFOLLUDATE2_4] [datetime] NULL,
[_CX_APPRINSPDATE2_4] [datetime] NULL,
[_CX_APPRINSPDATE1_4] [datetime] NULL,
[_CX_EXITPIPE] [datetime] NULL,
[LOCKRATE3_2091] [datetime] NULL,
[LOCKRATE3_2089] [datetime] NULL,
[_IRS4506_X25] [datetime] NULL,
[_CX_TITREQUEST] [datetime] NULL,
[_CX_TITRECEIVED] [datetime] NULL,
[_CX_TITORDER] [datetime] NULL,
[_CX_UWAUDSUB] [datetime] NULL,
[_CX_CLSVOEDATE] [datetime] NULL,
[_2206] [datetime] NULL,
[LOCKRATE_2206] [datetime] NULL,
[_CX_UWLIASCOMPLETE] [datetime] NULL,
[_CX_UWLIASSUB] [datetime] NULL,
[_CX_30DAYNOTICE] [datetime] NULL,
[_CX_CTCSNTTOPOD] [datetime] NULL,
[_CX_APRVLSNTPOD] [datetime] NULL,
[_CX_CTCRCVDFRMMILEND] [datetime] NULL,
[_CX_CONDOEXPDATE] [datetime] NULL,
[_CX_CNDRCDFRMPOD] [datetime] NULL,
[_CX_APRVLRCDDATE] [datetime] NULL,
[_CX_CNDSNTTOMI] [datetime] NULL,
[_CX_PREAPRVLDATE] [datetime] NULL,
[_CX_SELFEMPLOYED] [datetime] NULL,
[_CX_MIPAIDDATE] [datetime] NULL,
[_SERVICE_X32] [datetime] NULL,
[_3122] [datetime] NULL,
[_SERVICE_X67] [datetime] NULL,
[_SERVICE_X31] [datetime] NULL,
[_SERVICE_X63] [datetime] NULL,
[_SERVICE_X9] [datetime] NULL,
[_SERVICE_X13] [datetime] NULL,
[_SERVICE_X10] [datetime] NULL,
[_SERVICE_X14] [datetime] NULL,
[_SERVICE_X15] [datetime] NULL,
[_SERVICE_X59] [datetime] NULL,
[_SERVICE_X61] [datetime] NULL,
[_SERVICE_X65] [datetime] NULL,
[_2553] [datetime] NULL,
[_CX_UWBRKAUDREWCMPDATE] [datetime] NULL,
[_2981] [datetime] NULL,
[_CX_GFEDSKAPRVD] [datetime] NULL,
[_CX_INSPRESDED] [datetime] NULL,
[_CX_CNTRCTAPRSLDLNE] [datetime] NULL,
[_CX_APPRACPTDATE3_4] [datetime] NULL,
[_CX_LOCKREQDATE] [datetime] NULL,
[_CX_CHKREQDATE_3] [datetime] NULL,
[_CX_CHKREQDATE_1] [datetime] NULL,
[_CX_CHKREQDATE_2] [datetime] NULL,
[_3292] [datetime] NULL,
[_3978] [datetime] NULL,
[_3980] [datetime] NULL,
[_LE1_X1] [datetime] NULL,
[_3981] [datetime] NULL,
[_3145] [datetime] NULL,
[_3982] [datetime] NULL,
[_CD1_X1] [datetime] NULL,
[_CX_BRKR_APPROVED_PAYOUT] [datetime] NULL,
[_4014] [datetime] NULL,
[_CX_CONDO_REQ_DATE_3] [datetime] NULL,
[_CX_CONDO_REQ_DATE_1] [datetime] NULL,
[_CX_ESTCLOSELASTVALID] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[ti_LOANXDB_D_03_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_03]
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
										,LastModified
										,ISStatementDue
										,ISPaymentDue
										,ISEscrowDue
										,ISLatePaymentDate
										,LockRequestDate
										,LockRequested)
		SELECT NEWID()
			  ,''
			  ,''
			  ,NEWID()
			  ,'A'
			  ,''
			  ,''
			  ,''
			  ,''
			  ,''
			  ,XRefID
			  ,GETDATE()
			  ,_SERVICE_X13
			  ,_SERVICE_X14
			  ,_SERVICE_X61
			  ,_SERVICE_X15
			  ,_CX_LOCKREQDATE
			  ,CASE WHEN _CX_LOCKREQDATE IS NOT NULL THEN 'Y' ELSE 'N' END
		FROM inserted i

	END
	ELSE

		UPDATE ls
		SET  ISStatementDue = i._SERVICE_X13
			,ISPaymentDue = i._SERVICE_X14
			,ISEscrowDue = i._SERVICE_X61
			,ISLatePaymentDate = i._SERVICE_X15
			,LockRequestDate = i._CX_LOCKREQDATE
			,LastModified = GETDATE()
			,LockRequested = CASE WHEN _CX_LOCKREQDATE IS NOT NULL THEN 'Y' ELSE 'N' END
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[tu_LOANXDB_D_03_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_03]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF (UPDATE(_SERVICE_X13) OR  UPDATE(_SERVICE_X14) OR UPDATE(_SERVICE_X61) OR UPDATE(_SERVICE_X15) OR UPDATE(_CX_LOCKREQDATE))

		UPDATE ls
		SET  ISStatementDue = i._SERVICE_X13
			,ISPaymentDue = i._SERVICE_X14
			,ISEscrowDue = i._SERVICE_X61
			,ISLatePaymentDate = i._SERVICE_X15
			,LockRequestDate = i._CX_LOCKREQDATE
			,LastModified = GETDATE()
			,LockRequested = CASE WHEN _CX_LOCKREQDATE IS NOT NULL THEN 'Y' ELSE 'N' END
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
ALTER TABLE [emdbuser].[LOANXDB_D_03] ADD CONSTRAINT [PK_LOANXDB_D_03_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_03_LoanService_06] ON [emdbuser].[LOANXDB_D_03] ([XrefId]) INCLUDE ([_CX_CRRPTORDERED], [_SERVICE_X14], [_SERVICE_X32], [LOCKRATE_2149], [LOCKRATE_2151]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_03_LicensingLoanDetails_06] ON [emdbuser].[LOANXDB_D_03] ([XrefId]) INCLUDE ([_CX_PREAPRVLDATE]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
