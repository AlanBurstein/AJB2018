SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[rs_UWProblemFilesMC]
@StartDate datetime,  
@EndDate datetime,
@MC varchar(max)
as 
select
		--        exec rs_UWProblemFilesMC   @StartDate, @EndDate, @MC
    -----------   exec [dbo].[rs_UWProblemFilesMC] '2012-04-01', '2012-04-28', 'Nikki Mardos'
   
    --ls01._cx_lcname_1 
	LoanTeamMember_Name_LoanCoordinator as 'Lc Name',
	--ls03._cx_mcname_1 
	LoanTeamMember_Name_MortgageConsultant as 'MC Name',
	ls01._317 as 'Loan Officer',
	ls02._2574 as 'Underwriter',
	ls02._364 as 'Loan #',
	ls01._37 as 'Last Name',
	_748 as 'Closed',
	_cx_funddate_1 as Funded,
	_420 as Lien,
	Case when  _19 = 'NoCash-Out Refinance' then 'No C/O Refi'
	     when _19 = 'Cash-Out Refinance' then 'C/O Refi'
	     else _19 end  as 'Loan Purpose',
	_cx_probloan_5 as 'Problem Loan submission',
	_CX_NUMUWCONDITION as '# of UW conditions',
	_CX_UWC_COUNT_MC as 'Count of Role: Mortgage Consultant',
	_CX_PROBLOANDESC_5 as 'Problem Loan Description',
	_CX_PROBDISPUTESUB as 'Problem Loan Dispute',
	_1172 as 'Loan Type',
	 _CX_UWRUSH_1 as 'Rush File to UW',
	_CX_UWRUSHCOND_1  as  'Were there Rush Conditions'
from 
	emdb.emdbuser.Loansummary ls
	inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
	inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
	inner join emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
	inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
	inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId
	inner join emdb.emdbuser.LOANXDB_N_10 ln10 on ls.XrefId = ln10.XrefId
	
where 
	(_2301 between @StartDate and @EndDate --Underwriting Approval Date
	 or _2303  between @StartDate and @EndDate --Underwriting Suspended Date
	 or _2987 between @StartDate and @EndDate)  --Underwriting Denied Date 
	 
	 and	(rtrim(ltrim(LoanTeamMember_Name_MortgageConsultant)) in 
				(select SPLITVALUES 
			from dbo.DelimitedListToVarcharTableVariable(isnull(@MC, LoanTeamMember_Name_MortgageConsultant), ',')))
		
	 
	 
	 --and ls03._cx_mcname_1  = @MC
	--and emdb.dbo.DelimitedListToVarcharTableVariable(isnull,ls03._cx_mcname_1, ',') in (@MC)
--dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, _CX_LCNAME_1), ','))
-- Select distinct
-- ls03._cx_mcname_1 as 'MC Name'
--from 
--	emdb.emdbuser.Loansummary ls
--	inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
-- order by  _cx_mcname_1 
GO
