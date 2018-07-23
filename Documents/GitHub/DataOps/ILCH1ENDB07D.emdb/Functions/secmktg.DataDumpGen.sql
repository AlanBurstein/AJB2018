SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Hawley
-- Create date: 2012-08-07
-- Description:	Gather data fur use in Data Dump queries
-- =============================================
CREATE FUNCTION [secmktg].[DataDumpGen] 
(	
	@StartDate datetime
)
RETURNS TABLE 
AS
RETURN (
select
	_364, -- Loan Number
	_CX_FINALOCODE_4, -- VPCode
	_CX_LOCODE_1,
	_CX_PAIDLO_3,
	_CX_PAIDLOCODE_3,
	
	_11, -- Property Address
	_12, -- Property City
	_14, -- Property State
	_15, -- Property Zip
	
	_36,     -- Borrower First/Middle name
	_37,     -- Borrower Last/Suffix name
	_FR0104, -- Borrower Current Address
	_FR0106, -- Borrower Current City
	_FR0107, -- Borrower Current State
	_FR0108, -- Borrower Current Zip
	
	_2149, -- Lock Date
	LOCKRATE_2151, -- Expires
	LOCKRATE_2222, -- CommitExpires
	LOCKRATE_1172, -- LoanType
	LOCKRATE_MORNET_X67, -- DocType as locked
	_MORNET_X67,         -- DocType
	LOCKRATE_1130, -- ProdCode as locked
	_1130,         -- ProdCode
	LOCKRATE_1401, -- ProdDescript as locked
	_1401,         -- ProdDescript as locked
	LOCKRATE_1811, -- Occupancy as locked
	LOCKRATE_19,   -- Loan Purpose as locked
	LOCKRATE_2160, -- Rate as locked
	_1041,         -- Property Type
	LOCKRATE_136,  -- PurchPX
	LOCKRATE_356,  -- Appraised
	LOCKRATE_353,  -- LTV
	_976,          -- CLTV
	_4,            -- Term
	_697,          -- Arm1stAdj
	_CX_SECONDUNITS_16, -- Units
	_VEND_X200,    -- WHBank
	LOCKRATE_2853,
	LOCKRATE_VASUMM_X23,
	_740, -- Top Ratio
	_742, -- Bot Ratio
	LOCKRATE_2965, -- Loan Amount as locked
	_2, -- Loan Amount
	LOCKRATE_3043, -- LnAmtNoMIP
	LOCKRATE_2961,
	_2293, -- EscrowWaiv
	LOCKRATE_2962,
	_2294, -- EscrowType
	_2150, -- LockDays
	LOCKRATE_2221, -- CommitDays
	LOCKRATE_2231, -- CommitRate
	LOCKRATE_2218, -- BuyPx
	_2295, -- CommitPx
	_CX_ACCTTOTCHRG_2, -- AmtPaidccard
	_2286, -- InvCommit
	_2288, -- InvLoan#
	_CX_AUSSOURCE_2, -- AUS
	_2316, -- AUS#
	_CX_AUSRECOMMENDATION_2, -- AUSDecision
	_1393, -- UWAction
	_1107, -- UFMIP
	LOCKRATE_2278, -- Investor
	
	_CX_PREAPPROVORDER_1, -- Date PreApproval Sent
	_2313, -- AUS Date
	_2298, -- SubmitUW Date
	_2301, -- Approve Date
	_2303, -- Suspend Date
	_2987, -- Denied Date
	_2305, -- CTC Date
	_748,  -- Closed Date
	_CX_FUNDDATE_1, -- Funded Date
	_2297, -- Delivery Date
	_2370, -- Purchase Date
	
	_CX_PROBLOANSUB_14, -- CondtionsProb
	_CX_PROBLOANSUBDT_14, -- ConditionsProbDate
	_CX_UWRUSH_1, -- UWRush
	_CX_UWRUSHCOND_1, -- UWRushCond
	_CX_PROBCONDO, -- CondoProb
	_CX_PROBCONDODESC, -- CondoProbDesc

	_CX_PROBLOAN_5,       -- InitialProb
	_CX_PROBLOANDT_5,     -- InitialProbDate
	_CX_PROBLOANCLS_14,   -- CLSProb
	_CX_PROBLOANCLSDT_14, -- CLSProbDate
	--_CX_PROBLOANCLSDESC_14, -- CLSProbDesc

	_CX_TITLEORDER_1, -- Date Title Ordered
	_CX_FLOODORDER_1, -- FloodOrd
	_CX_INSURORDER_1, -- InsurOrd

	_CX_CONDODOCS_10, -- CondoOrd
	_CX_SUBORD_10, -- SubOrd

	_CX_LOCKCANCEL_16, -- Cancel-1
	_CX_PREVINVEST_16, -- CancelInv-1
	_CX_SECEXP, -- CanceloOrigExp
	_CX_SECNEGOTIATE_10, -- CancelRenegotiate
	_CX_SECCANCEL, -- Cancelled
	_CX_SECRELOCK, -- ReLock

	_CX_LOCKCANCEL2_16, -- Cancel-2
	_CX_PREVINVEST2_16, -- CancelInv-2
	_CX_SECEXP2, -- CanceloOrigExp2
	_CX_SECNEGOTIATE2_10, -- CancelRenegotiate-2
	_CX_SECCANCEL2, -- Cancelled2
	_CX_SECRELOCK2, -- ReLock2

	_CX_LOCKCANCEL3_16, -- Cancel-3
	_CX_PREVINVEST3_16, -- CancelInv-3
	_CX_SECEXP3, -- CanceloOrigExp3
	_CX_SECNEGOTIATE3_10, -- CancelRenegotiate-3
	_CX_SECCANCEL3, -- Cancelled3
	_CX_SECRELOCK3, -- ReLock3

	_CX_LOCKCANCEL4_10, -- Cancel-4
	_CX_PREVINVEST4_10, -- CancelInv-4
	_CX_SECEXP4, -- CanceloOrigExp4
	_CX_SECNEGOTIATE4_10, -- CancelRenegotiate-4
	_CX_SECCANCEL4, -- Cancelled4
	_CX_SECRELOCK4, -- ReLock4

	_CX_LOCKCANCEL5_10, -- Cancel-5
	_CX_PREVINVEST5_10, -- CancelInv-5
	_CX_SECEXP5, -- CanceloOrigExp5
	_CX_SECNEGOTIATE5_10, -- CancelRenegotiate-5
	_CX_SECCANCEL5, -- Cancelled5
	_CX_SECRELOCK5, -- ReLock5

	_CX_SECEXTEND, -- 1stExtension
	_CX_SECEXTEND2, -- 2ndtExtension
	_CX_SECEXTEND3, -- 3rdExtension
	_CX_SECEXTEND4, -- 4thExtension
	_CX_SECEXTEND5, -- 5thExtension
	_CX_SECRUSH, -- SecondayRush
	_CX_CLSRUSH_1, -- ClosingRush
	_CX_CLSRUSHDATE_1, -- ClsRushDate
	_CX_REDRAW_1, -- ReDraws

	LOCKRATE_CURRENTSTATUS, -- LockStatus

	_MS_STATUS, -- CurrMileStone

	Log_MS_DateTime_AssignedtoUW, -- AssigntoUW
	Log_MS_Date_ConditionsSubmittedtoUW, -- CondSubUW
	Log_MS_Date_AssigntoClose, -- AssigntoCls
	Log_MS_Date_DocsSigning, -- DocsSigned
	LOCKRATE_REQUESTCOUNT, -- #ofLockRequest
	_LOANFOLDER, -- loanfolder,
	_CX_PCDISCLOSE, -- Disclosesusp
	_CX_PCOOKCNTY, -- CookCntysusp
	_CX_PCINSUR, -- Insursusp
	_CX_PCVOE, -- VOESusp
	_CX_PCAUS, -- AUSSusp
	_CX_PCAPPRAISE, -- Appraisalsusp
	_CX_PCMISDOCS, -- Docssusp
	_2013, -- TargetDelv
	_2014, -- Shipped
	_CX_PACKAGERECVD_1, -- PkgRec
	_1998, -- CollateralSent
	_CX_UWINVALAUS, -- UWProbAUS
	_CX_UWINVALPRGPRD, -- UWProbProg
	_CX_UWMISCINTSUB, -- UWProbMisc
	_CX_UWINCOMCREDITDOC, -- UWProbCRDocs
	_CX_UWMULTIRESTR, -- UWProbMultirestr
	_CX_UWMISCRESUB, -- UWProbMiscresub
	_CX_UWPIECEMAILCOND, -- PieceMailCond
	_CX_UWDOCNOTSUPPAUS, -- DocNotSupportedAUS
	_736, -- MonIncome
	_700, -- Census
	_CX_SECORIGLOCK_16, -- Secoringlock1
	_CX_SECORIGLOCK2_16, -- Secoringlock2
	_CX_SECORIGLOCK3_16, -- Secoringlock3
	_CX_SECORIGLOCK4_10, -- Secoringlock4
	_CX_SECORIGLOCK5_10, -- Secoringlock5
	_CX_APPRORDER_4, -- AppslOrdDt
	_REQUEST_X21, -- AppslRecDt
	_411, -- TitleCo
	_CX_PCSUSPEND_1, -- PCSuspDt
	_CX_CLSSCHED_1, -- SchedClsDt
	_1997, -- WireDate
	_420, -- LienPosition
	_CX_RESPAAPP_1, -- RespaAppDt
	_3142, -- GFEAppDt
	_CX_COPYLOBPS, -- CorpObj
	_CX_SECMI_16, -- MI Sec 
	_CX_UWREQMI, -- MI UW 
	_2626, -- Channel 
	_CX_BROKERFUND_5, -- BroFundDT 
	_CX_BROKERCLOSE_5, -- BroCloseDT 
	_984, -- UWField 
	_CX_CORPOBJ, -- TotYSP
	_CX_BPSDIFFER, -- BPSDif 
	_CX_BPNETGAINLOSS, -- NetGL
	_CX_NUMUWCONDITION, -- NumUWCond
	_CX_UWNUMCNDOREVD, -- UWNumCndRev 
	Log_MS_Date_Processing, -- AssigntoProc 
	_CX_LOANSERVICER -- Servicer
 
from [grchilhq-sq-03].emdb.emdbuser.LoanSummary ls
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_06 ls06 on ls.XrefId = ls06.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_07 ls07 on ls.XrefId = ls07.XrefId
--join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_08 ls08 on ls.XrefId = ls08.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_09 ls09 on ls.XrefId = ls09.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_03 ln03 on ls.XrefId = ln03.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_04 ln04 on ls.XrefId = ln04.XrefId
--join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_05 ln05 on ls.XrefId = ln05.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_06 ln06 on ls.XrefId = ln06.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_07 ln07 on ls.XrefId = ln07.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_08 ln08 on ls.XrefId = ln08.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_09 ln09 on ls.XrefId = ln09.XrefId 
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId

where 
	LoanFolder not in ('samples','(trash)') and (
		_2149              >= @StartDate or
		_CX_FUNDDATE_1     >= @StartDate or
		_CX_LOCKCANCEL_16  >= @StartDate or
		_CX_LOCKCANCEL2_16 >= @StartDate or
		_CX_LOCKCANCEL3_16 >= @StartDate or
		_CX_LOCKCANCEL4_10 >= @StartDate or
		_CX_LOCKCANCEL5_10 >= @StartDate
	)
)
GO
