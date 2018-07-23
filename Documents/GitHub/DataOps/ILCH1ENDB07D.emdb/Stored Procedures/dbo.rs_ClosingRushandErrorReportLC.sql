SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[rs_ClosingRushandErrorReportLC]
@StartDate datetime,  
@EndDate datetime,
@LC varchar(max)
as 
select
	ls01._cx_lcname_1 as 'LC Name',
	ls01._317 as 'Loan Officer',
	ls02._364 as 'Loan Number',
	ls01._37 as Borrower,
	ls01._CX_CLSLOCK as 'Rush to Closing',
	ls04._CX_PROBLOANCLS_14 as 'Problem Loan Closing',
	ls04._CX_PROBLOANCLSDESC_14 as 'Problem Loan Closing Dispute by LC',
	ld01._CX_FUNDDATE_1 as 'Funded date',
	ld02._CX_BROKERFUND_5 as 'Funded Date for Broker Loans'

from 
	emdb.emdbuser.Loansummary ls
	inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
	inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
	inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId
	
where  ( _CX_FUNDDATE_1 between @StartDate and @EndDate
		or _CX_BROKERFUND_5 between  @StartDate and @EndDate)
		and	(rtrim(ltrim(_CX_LCNAME_1)) in 
				(select SPLITVALUES 
			from dbo.DelimitedListToVarcharTableVariable(isnull(@LC, _CX_LCNAME_1), ',')))
		
		
		
		--    exec rs_ClosingRushandErrorReportLC '2012-06-01', '2012-06-10', ['Alexis Novelli','Amy Wheeler']
		--and ls01._cx_lcname_1 = @LC

 
 
-- Select distinct
-- ls01._cx_lcname_1 as 'LC Name'
--from 
--	emdb.emdbuser.Loansummary ls
--	inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
-- order by  _cx_lcname_1 
GO
