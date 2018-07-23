SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[rs_UWProblemFilesLC]
@StartDate datetime,  
@EndDate datetime,
@LC varchar(max)
as 
select
		--        exec rs_UWProblemFilesLC   @StartDate, @EndDate, @LC
    -----------   exec [dbo].[rs_UWProblemFilesLC] '2012-04-01', '2012-04-28', 'Alexis Novelli'
   
    
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
	_cx_probloansub_14 as 'Problem Loan submission',
	_cx_Uwnumcndorevd as '# of Conds Reviews',
	_CX_UWC_COUNT_LC as 'Count of Role Loan Coordinator',
	_cx_probloansubdesc_14 as 'Problem Loan submission Desription',
	_cx_probdisputecond as 'Problem Loan Dispute',
	_1172 as 'Loan Type',

	  _CX_UWRUSH_1 as  'Rush File to UW',
	
		 _CX_UWRUSHCOND_1 as  'Were there Rush Conditions',
	_2305,
	_cX_CONDITIONSUBMIT_1
	
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
	  ( _2305  between @StartDate and @EndDate  ---Underwriting Clear to Close Date
	OR _cX_CONDITIONSUBMIT_1 between @StartDate and @EndDate )  --CONDITIONS SENT TO UW
	
	and	(rtrim(ltrim(LoanTeamMember_Name_LoanCoordinator)) in 
				(select SPLITVALUES 
			from dbo.DelimitedListToVarcharTableVariable(isnull(@LC, LoanTeamMember_Name_LoanCoordinator), ',')))
		
	--and ls01._cx_lcname_1 in (@LC)
--and emdb.dbo.DelimitedListToVarcharTableVariable(isnull,ls03._cx_mcname_1, ',') in (@LC)
-- Select distinct
-- ls01._cx_lcname_1 as 'LC Name'
--from 
--	emdb.emdbuser.Loansummary ls
--	inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
-- order by  _cx_lcname_1 
GO
