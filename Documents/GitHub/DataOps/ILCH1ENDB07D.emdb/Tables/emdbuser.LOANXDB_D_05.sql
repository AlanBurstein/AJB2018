CREATE TABLE [emdbuser].[LOANXDB_D_05]
(
[XrefId] [int] NOT NULL,
[_CX_NY_CEMA_IN] [datetime] NULL,
[_CX_NY_STOCK_LEASE_ORDERED] [datetime] NULL,
[_CX_COOP_SUSPENDED] [datetime] NULL,
[_CX_CX_NY_BOARD_APPROVED] [datetime] NULL,
[_BE0211] [datetime] NULL,
[_BE0114] [datetime] NULL,
[_CX_CDDR_DENIED_DATE] [datetime] NULL,
[_BE0311] [datetime] NULL,
[_BE0111] [datetime] NULL,
[_BE0214] [datetime] NULL,
[_CX_NETTANGDATE] [datetime] NULL,
[_BE0414] [datetime] NULL,
[_BE0411] [datetime] NULL,
[_CX_CDDR_APPROVAL_DATE] [datetime] NULL,
[_BE0314] [datetime] NULL,
[Log_MS_DateTime_UWDecisionExpected] [datetime] NULL,
[Log_MS_DateTime_ConditionsSubmittedtoUW] [datetime] NULL,
[_CX_GAAR_DATE] [datetime] NULL,
[_CX_PMTDATE] [datetime] NULL,
[_CX_POSTASSIGNED] [datetime] NULL,
[_CX_POSTFUNDCLEARED] [datetime] NULL,
[_CX_POSTFUNDSENT] [datetime] NULL,
[_CX_FHA_CASE_EXP] [datetime] NULL,
[_CX_CND_SENT_BROKER] [datetime] NULL,
[_CX_UW_DENIAL_REVIEW_DATE] [datetime] NULL,
[_CX_UW_MGR_DATE] [datetime] NULL,
[_IRS4506_X29] [datetime] NULL,
[_CX_DATE_NOV_ISSUED] [datetime] NULL,
[_CX_NY_CEMA_APPROVED] [datetime] NULL,
[_IRS4506_X26] [datetime] NULL,
[_IRS4506_X30] [datetime] NULL,
[_CX_DATE_NOV_ASSIGNED] [datetime] NULL,
[_CX_GR_REVIEW_COMPLETED] [datetime] NULL,
[_L244] [datetime] NULL,
[_CX_LOCK_AUTOLOCKDATE] [datetime] NULL,
[_CX_GRSVCD_LOANPAYOFF_REQUEST] [datetime] NULL,
[_3042] [datetime] NULL,
[_3432] [datetime] NULL,
[_CX_CREDIT_EFFECTIVE] [datetime] NULL,
[_CX_ESTIMATED_COMPLETION_DATE] [datetime] NULL,
[_CX_FUNDS_APPROVED_DATE] [datetime] NULL,
[_CX_CLOSING_DOCS_CLEAR_DATE] [datetime] NULL,
[_CX_RESTRUCTUREPROPERTY] [datetime] NULL,
[_CX_WELCOMELTR] [datetime] NULL,
[_CX_CX_RESTRUCTUREASSET] [datetime] NULL,
[_CX_TITLE_UPDATE] [datetime] NULL,
[_CX_FINAL_INSPECTION] [datetime] NULL,
[_CX_STATUS_LETTER_DATE] [datetime] NULL,
[_CX_CLOSEOUTDATE] [datetime] NULL,
[_CX_LM_DATE_CLEARED] [datetime] NULL,
[_CX_UCC1REC] [datetime] NULL,
[_CX_UCC3REC] [datetime] NULL,
[_CX_LM_DATE_ASSIGNED] [datetime] NULL,
[_CX_LM_POD_NOTIFY] [datetime] NULL,
[_CX_LM_RDD] [datetime] NULL,
[_CX_LM_DATE_RESPONSE_SENT] [datetime] NULL,
[Log_MS_DateTime_Started] [datetime] NULL,
[_CX_PA_DENIED] [datetime] NULL,
[_CX_PA_APPROVED] [datetime] NULL,
[_CX_PA_SUSPENDED] [datetime] NULL,
[_CX_PA_SUBMITTED] [datetime] NULL,
[_CX_MTGCNTGDATE] [datetime] NULL,
[_3253] [datetime] NULL,
[_COMPLIANCEREVIEW_X3] [datetime] NULL,
[_CX_RUSH_UW_DECISION_DATE_4] [datetime] NULL,
[_CX_RUSH_UW_DECISION_DATE_5] [datetime] NULL,
[_CX_RUSH_UW_DECISION_DATE_1] [datetime] NULL,
[_CX_RUSH_UW_DECISION_DATE_2] [datetime] NULL,
[_CX_RUSH_UW_DECISION_DATE_3] [datetime] NULL,
[_CX_RUSH_UW_SUBMIT_DATE_5] [datetime] NULL,
[_CX_RUSH_UW_SUBMIT_DATE_4] [datetime] NULL,
[_CX_RUSH_UW_SUBMIT_DATE_3] [datetime] NULL,
[_CX_RUSH_UW_SUBMIT_DATE_2] [datetime] NULL,
[_CX_RUSH_UW_SUBMIT_DATE_1] [datetime] NULL,
[_CX_UW_EXCP_APRV_DECN_DATE] [datetime] NULL,
[_CX_UW_EXCP_APRV_REQ_DATE] [datetime] NULL,
[_SERVICE_X109] [datetime] NULL,
[_CX_UREMAILSENTDATE_1] [datetime] NULL,
[_CX_UREMAILSENTDATE_3] [datetime] NULL,
[_CX_UREMAILSENTDATE_2] [datetime] NULL,
[_CX_NYCOMMIT_1] [datetime] NULL,
[_CX_CONTRACTCLOSEDATE] [datetime] NULL,
[_CX_CTCCOMMIT_1] [datetime] NULL,
[_CX_CONTRACTSIGNED] [datetime] NULL,
[_CX_CLSPACKAGEDELIVERY] [datetime] NULL,
[_CX_XPCTAFTRCLSNG_EMAILSENT] [datetime] NULL,
[_CX_SHIPSERVDUE] [datetime] NULL,
[_CX_APPRACPTDATE4_4] [datetime] NULL,
[_CX_APPRRECDDATE3_4] [datetime] NULL,
[_CX_CONDO_REQ_DATE_2] [datetime] NULL,
[_3171] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[ti_LOANXDB_D_05_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_05]
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
										,DateFileOpened)
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
			  ,Log_MS_DateTime_Started
		FROM inserted i

	END
	ELSE

		UPDATE ls
		SET  DateFileOpened = i.Log_MS_DateTime_Started
			,LastModified = GETDATE()
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[tu_LOANXDB_D_05_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_D_05]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF (UPDATE(Log_MS_DateTime_Started))

		UPDATE ls
		SET  DateFileOpened = i.Log_MS_DateTime_Started
			,LastModified = GETDATE()
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
ALTER TABLE [emdbuser].[LOANXDB_D_05] ADD CONSTRAINT [PK_LOANXDB_D_05_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
