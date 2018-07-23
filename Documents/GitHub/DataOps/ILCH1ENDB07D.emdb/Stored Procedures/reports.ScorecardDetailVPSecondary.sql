SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [reports].[ScorecardDetailVPSecondary]
@UserName varchar(50),
 @StartDate datetime,
 @EndDate datetime
 --@VPID varchar(50)
as 
select 
	_364 as [Loan],
	_CX_PaidLO_3 as [ProcessMgr],
	_cx_finalocode_4 as [Branch_code],
	convert(date,_2149) as [Locked],
	isnull(nullif(lockrate_2965, 0), _2) as [LoanAmount],
	LockRate_2278 as [Investor],
	--convert(date,_2301) as [ApproveDate],
	--convert(date,_2303) as [Suspendate],
	--convert(date,_2987) as [DeniedDate],
	convert(date,_cx_funddate_1) as [Funded],
	_CX_UWRUSH_1 AS [UWRush],
	_CX_UWRUSHCOND_1 AS [UWRushCond],
	_CX_PROBCONDO AS [CondoProb],
	convert(date,_CX_LOCKCANCEL_16) as [Cancel-1],
	_CX_PREVINVEST_16 as [CancelInv-1],
	convert(date,_CX_SECEXP) as [CanceloOrigExp],
	_CX_SECNEGOTIATE_10 as [CancelRenegotiate],
	_CX_SECCANCEL as [Cancelled],
	_CX_SECRELOCK as [ReLock],
	convert(date,_CX_LOCKCANCEL2_16) as [Cancel-2],
	_CX_PREVINVEST2_16 as [CancelInv-2],
	convert(date,_CX_SECEXP2) as [CanceloOrigExp2],
	_CX_SECNEGOTIATE2_10 as [CancelRenegotiate-2],
	_CX_SECCANCEL2 as [Cancelled2],
	_CX_SECRELOCK2 as [ReLock2],
	convert(date,_CX_LOCKCANCEL3_16) as [Cancel-3],
	_CX_PREVINVEST3_16 as [CancelInv-3],
	convert(date,_CX_SECEXP3) as [CanceloOrigExp3],
	_CX_SECNEGOTIATE3_10 as [CancelRenegotiate-3],
	_CX_SECCANCEL3 as [Cancelled3],
	_CX_SECRELOCK3 as [ReLock3],
	convert(date,_CX_LOCKCANCEL4_10) as [Cancel-4],
	_CX_PREVINVEST4_10 as [CancelInv-4],
	convert(date,_CX_SECEXP4) as [CanceloOrigExp4],
	_CX_SECNEGOTIATE4_10 as [CancelRenegotiate-4],
	_CX_SECCANCEL4 as [Cancelled4],
	_CX_SECRELOCK4 as [ReLock4],
	convert(date,_CX_LOCKCANCEL5_10) as [Cancel-5],
	_CX_PREVINVEST5_10 as [CancelInv-5],
	convert(date,_CX_SECEXP5) as [CanceloOrigExp5],
	_CX_SECNEGOTIATE5_10 as [CancelRenegotiate-5],
	_CX_SECCANCEL5 as [Cancelled5],
	_CX_SECRELOCK5 as [ReLock5],
	_CX_SECEXTEND as [1stExtension],
	_CX_SECEXTEND2 AS [2ndtExtension],
	_CX_SECEXTEND3 AS [3rdExtension],
	_CX_SECEXTEND4 AS [4thExtension],
	_CX_SECEXTEND5 AS [5thExtension],
	_CX_SECRUSH AS [SecondayRush],
	_CX_CLSRUSH_1 AS [ClosingRush]
	--convert(date,_CX_CLSRUSHdate_1) AS [ClsRushDate]
	--_cx_redraw_1 as [ReDraws],
	--LOCKRATE_CURRENTSTATUS as [LockStatus],
	--_MS_status as [CurrMileStone]
 
from [grchilhq-sq-03].emdb.secmktg.DataDumpFields

where
	_2149               between  @StartDate and @EndDate  or   --LOANXDB_D_01	Rate Lock Buy Side Lock Date
	_CX_FUNDDATE_1      between  @StartDate and @EndDate  or
	_CX_LOCKCANCEL_16   between  @StartDate and @EndDate  or
	_CX_LOCKCANCEL2_16  between  @StartDate and @EndDate  or
	_CX_LOCKCANCEL3_16  between  @StartDate and @EndDate  or
	_CX_LOCKCANCEL4_10  between  @StartDate and @EndDate  or
	_CX_LOCKCANCEL5_10  between  @StartDate and @EndDate 
	
	
	--CX.UWRUSH.1	LOANXDB_S_02
	--CX.UWRUSHCOND.1	LOANXDB_S_01
GO
