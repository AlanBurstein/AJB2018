CREATE TABLE [emdbuser].[LOANXDB_D_04]
(
[XrefId] [int] NOT NULL,
[_CX_UWCNDNASGND] [datetime] NULL,
[_CX_UWAPRVLASGN] [datetime] NULL,
[_3054] [datetime] NULL,
[_MS_STATUSDATE] [datetime] NULL,
[_CX_PROPTAXDUEDATE_1] [datetime] NULL,
[_CX_PROPTAXDUEDATE_4] [datetime] NULL,
[_CX_INSFLDDUEDATE] [datetime] NULL,
[_CX_INSFLDZONEDATE] [datetime] NULL,
[_CX_INSEQEXPDATE] [datetime] NULL,
[_CX_INSHUREXPDATE] [datetime] NULL,
[_CX_PROPTAXDUEDATE_2] [datetime] NULL,
[_CX_INSFLDEXPDATE] [datetime] NULL,
[_CX_PROPTAXDUEDATE_5] [datetime] NULL,
[_CX_INSWNDDUEDATE] [datetime] NULL,
[_CX_PROPTAXDUEDATE_3] [datetime] NULL,
[_CX_INSHURDUEDATE] [datetime] NULL,
[_CX_INSEQDUEDATE] [datetime] NULL,
[_CX_INSHAZEXPDATE] [datetime] NULL,
[_CX_INSHAZDUEDATE] [datetime] NULL,
[_CX_INSWNDEXPDATE] [datetime] NULL,
[_CX_UWSUBASGND] [datetime] NULL,
[_CX_UWSENTMILEND] [datetime] NULL,
[_DENIAL_X69] [datetime] NULL,
[_CX_UWAPRVDUEDATE] [datetime] NULL,
[_CX_UWUPDAPRRECD] [datetime] NULL,
[_CX_UWUPDAPRSNTPOD] [datetime] NULL,
[_2630] [datetime] NULL,
[_CX_SHIPDIAUDITCOMPLETE] [datetime] NULL,
[_CX_L360FIRSTCON] [datetime] NULL,
[Log_MS_Date_AppFeeCollected] [datetime] NULL,
[Log_MS_Date_Processing] [datetime] NULL,
[_CX_L360DATEADD] [datetime] NULL,
[_CX_CONDITIONSUBMIT_4] [datetime] NULL,
[_CX_CONDITIONSUBMIT_5] [datetime] NULL,
[_CX_CONDITIONSUBMIT_2] [datetime] NULL,
[_CX_CONDITIONSUBMIT_3] [datetime] NULL,
[_CX_UWCNDOREVIEW_5] [datetime] NULL,
[_CX_UWCNDOREVIEW_4] [datetime] NULL,
[_CX_UWCNDOREVIEW_3] [datetime] NULL,
[_CX_UWCNDOREVIEW_2] [datetime] NULL,
[_CX_UWCNDOREVIEW_1] [datetime] NULL,
[_CX_POVERFDDATE] [datetime] NULL,
[_CX_AGENCYUWAUDITCLEAR] [datetime] NULL,
[_CX_AGENCYCLOSINGAUDITCLEAR] [datetime] NULL,
[_CX_INSMASEXP] [datetime] NULL,
[_CX_INSMASDUE] [datetime] NULL,
[_3261] [datetime] NULL,
[_CX_GFEEXPDATE] [datetime] NULL,
[_CX_RVNDTEREQ] [datetime] NULL,
[_CX_AGENCYPOOLUPLOAD] [datetime] NULL,
[_CX_CONREBREVIEW] [datetime] NULL,
[_CX_SUBREBUTDATE] [datetime] NULL,
[_1402_P2] [datetime] NULL,
[_CX_4506TORDDTE] [datetime] NULL,
[_CX_UCDPDATE] [datetime] NULL,
[_CX_TRKINFO_NOAPP_REQ_ARCH] [datetime] NULL,
[_CX_RESTRUCTUREDTI] [datetime] NULL,
[_CX_APPPAKCOMPLETE] [datetime] NULL,
[_CX_RESTRUCTURELTV] [datetime] NULL,
[_ULDD_X30] [datetime] NULL,
[_ULDD_X58] [datetime] NULL,
[_ULDD_X17] [datetime] NULL,
[_CX_L360SECONDGMACCA] [datetime] NULL,
[_CX_L360GMACPITCHDATE] [datetime] NULL,
[_CX_L360FIRSTGMACCA] [datetime] NULL,
[_CX_LSTDAYMNTH] [datetime] NULL,
[_CX_LSTDAYMNTH_2] [datetime] NULL,
[_CX_DCCRD] [datetime] NULL,
[_CX_APPRREVIEWED] [datetime] NULL,
[_CX_4506TRECDDTE] [datetime] NULL,
[_CX_20094506TRECDDTE] [datetime] NULL,
[_CX_20104506TRECDDTE] [datetime] NULL,
[_3514] [datetime] NULL,
[_CX_APRVLFUP] [datetime] NULL,
[_CX_CTCFUP] [datetime] NULL,
[_CX_TIINPUTDATE] [datetime] NULL,
[_CX_SWCHAPRDATE_2] [datetime] NULL,
[_CX_SWCHAPRDATE_3] [datetime] NULL,
[_CX_SWCHAPRDATE_1] [datetime] NULL,
[_CX_SCOREEXPDATE] [datetime] NULL,
[_CX_UW_REQ_POD_DOCS_CTC] [datetime] NULL,
[_CX_UW_ALLONHILL] [datetime] NULL,
[_CX_COOP_DENIED] [datetime] NULL,
[_CX_BROKER_UW] [datetime] NULL,
[_CX_NY_BOARD_IN] [datetime] NULL,
[_CX_COOP_REVIEW] [datetime] NULL,
[_CX_CX_NY_CONDO_COOP_APPROVED] [datetime] NULL,
[_CX_NY_STOCK_LEASE_RECIEVED] [datetime] NULL,
[_CX_INVAPPROVAL] [datetime] NULL,
[_CX_NY_CEMA_ORDERED] [datetime] NULL,
[_CX_COOP_SUBMITTED] [datetime] NULL,
[_CX_2NDDRAW] [datetime] NULL,
[_3337] [datetime] NULL,
[_CX_ACTUAL_COMPLETION_DATE] [datetime] NULL,
[_CX_4THDRAW] [datetime] NULL,
[_CX_UWAUDCOMPLETE] [datetime] NULL,
[_CX_TRUSTDOCSREQUESTED] [datetime] NULL,
[_DISCLOSURE_X1095] [datetime] NULL,
[_CX_TRUSTSUBMITTEDFORAPPROVAL] [datetime] NULL,
[_CX_TRUSTDOCSRECEIVED] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[ti_LOANXDB_D_04_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_04]
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
										,CurrentMilestoneDate
										,DatePurchased
										,ARMAdjustmentDate
										,DateSentToProcessing
										,NextMilestoneDate)
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
			  ,i.XRefID
			  ,GETDATE()
			  ,_MS_STATUSDATE
			  ,_2630
			  ,_3054
			  ,Log_MS_Date_Processing
			  ,CASE
					WHEN s01._MS_STATUS = 'App Fee Collected' THEN DATEADD(day,1,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Approval' THEN DATEADD(day,1,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Assign to Close' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Assigned to UW' THEN DATEADD(day,7,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Completion' THEN NULL
					WHEN s01._MS_STATUS = 'Conditions Submitted to UW' THEN DATEADD(day,5,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Docs Signing' THEN DATEADD(day,4,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'File started' THEN NULL
					WHEN s01._MS_STATUS = 'Funding' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Processing' THEN DATEADD(day,0,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Shipping' THEN DATEADD(day,0,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Started' THEN DATEADD(day,14,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'Submittal' THEN DATEADD(day,5,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS = 'UW Decision Expected' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
					WHEN s01._MS_STATUS IS NULL THEN GETDATE()
					ELSE NULL
			   END
		FROM inserted i
		LEFT JOIN emdbuser.LOANXDB_S_01 s01 ON s01.XRefID = i.XRefID

	END
	ELSE

		UPDATE ls
		SET  CurrentMilestoneDate = i._MS_STATUSDATE
			,DatePurchased = i._2630
			,ARMAdjustmentDate = i._3054
			,DateSentToProcessing = i.Log_MS_Date_Processing
			,LastModified = GETDATE()
			,NextMilestoneDate = CASE
									WHEN s01._MS_STATUS = 'App Fee Collected' THEN DATEADD(day,1,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Approval' THEN DATEADD(day,1,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Assign to Close' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Assigned to UW' THEN DATEADD(day,7,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Completion' THEN NULL
									WHEN s01._MS_STATUS = 'Conditions Submitted to UW' THEN DATEADD(day,5,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Docs Signing' THEN DATEADD(day,4,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'File started' THEN NULL
									WHEN s01._MS_STATUS = 'Funding' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Processing' THEN DATEADD(day,0,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Shipping' THEN DATEADD(day,0,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Started' THEN DATEADD(day,14,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Submittal' THEN DATEADD(day,5,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'UW Decision Expected' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS IS NULL THEN GETDATE()
									ELSE NULL
								 END
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID
		LEFT JOIN emdbuser.LOANXDB_S_01 s01 ON s01.XRefID = i.XRefID

	



END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[tu_LOANXDB_D_04_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_04]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF (UPDATE(_MS_STATUSDATE) OR UPDATE(_2630) OR UPDATE(_3054))

		
		UPDATE ls
		SET  CurrentMilestoneDate = i._MS_STATUSDATE
			,DatePurchased = i._2630
			,ARMAdjustmentDate = i._3054
			,DateSentToProcessing = i.Log_MS_Date_Processing
			,LastModified = GETDATE()
			,NextMilestoneDate = CASE
									WHEN s01._MS_STATUS = 'App Fee Collected' THEN DATEADD(day,1,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Approval' THEN DATEADD(day,1,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Assign to Close' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Assigned to UW' THEN DATEADD(day,7,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Completion' THEN NULL
									WHEN s01._MS_STATUS = 'Conditions Submitted to UW' THEN DATEADD(day,5,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Docs Signing' THEN DATEADD(day,4,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'File started' THEN NULL
									WHEN s01._MS_STATUS = 'Funding' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Processing' THEN DATEADD(day,0,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Shipping' THEN DATEADD(day,0,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Started' THEN DATEADD(day,14,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'Submittal' THEN DATEADD(day,5,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS = 'UW Decision Expected' THEN DATEADD(day,3,ISNULL(i._MS_STATUSDATE,GETDATE()))
									WHEN s01._MS_STATUS IS NULL THEN GETDATE()
									ELSE NULL
								 END
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID
		LEFT JOIN emdbuser.LOANXDB_S_01 s01 ON s01.XRefID = i.XRefID

	



END
GO
ALTER TABLE [emdbuser].[LOANXDB_D_04] ADD CONSTRAINT [PK_LOANXDB_D_04_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
