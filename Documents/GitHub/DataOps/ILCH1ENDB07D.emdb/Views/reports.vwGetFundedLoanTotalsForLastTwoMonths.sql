SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [reports].[vwGetFundedLoanTotalsForLastTwoMonths] 

as

	-- get the loan amounts group by mc, lc, and vp
	select	datename( month, _CX_FUNDDATE_1 ) as MonthName, datepart( month, _CX_FUNDDATE_1 ) as MonthNumber, 
		LS03._CX_FINALOCODE_4, LS03._CX_MCNAME_1, LS01._CX_LCNAME_1, sum( LN02._2 ) as LoanAmount, count( * ) as LoanCount
	from	emdbuser.LOANXDB_S_01 LS01
		inner join emdbuser.LoanSummary LS on LS01.XRefID = LS.XRefID 
		inner join emdbuser.LOANXDB_S_03 LS03 on LS01.XRefID = LS03.XRefID
		inner join emdbuser.LOANXDB_D_01 LD01 on LS01.XRefID = LD01.XRefID
		inner join emdbuser.LOANXDB_N_02 LN02 on LS01.XRefID = LN02.XRefID
	where	_CX_FUNDDATE_1 between 
			cast( datepart( month, dateadd( month, -1, getdate())) as varchar( 10 )) + '/01/' + 
				cast( datepart( year, dateadd( month, -1, getdate())) as varchar( 10 )) and getdate() and
		LoanFolder not in ( '(Archive)', '(Trash)', 'Samples' ) 
	group	by datename( month, _CX_FUNDDATE_1 ), datepart( month, _CX_FUNDDATE_1 ), LS03._CX_FINALOCODE_4, LS03._CX_MCNAME_1, LS01._CX_LCNAME_1

GO
