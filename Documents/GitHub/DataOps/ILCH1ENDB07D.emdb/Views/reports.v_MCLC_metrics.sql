SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [reports].[v_MCLC_metrics]
as

select
ls.XRefID,
loannumber,
_2301,

_CX_UWC_COUNT_MC as 'CountRole',

 _CX_NUMUWCONDITION as 'MCConditions',				----1

CASE
	when _CX_NUMUWCONDITION < 1 then 0 
	else 1
END as 'NumOfLoansMC_COND',
CASE
	when _CX_PROBLOAN_5  = 'Y' then 1 
	else 0 
END as 'percentMCPROBfiles',						 -----2

_CX_UWNUMCNDOREVD as 'LCAvgsubmissionforapproval',     -----3

CASE
	when _CX_PROBLOANsub_14  = 'Y' then 1
	else 0
END as 'percentUWProblemFiles',        --------4

CASE 
	WHEN _CX_CLSRUSH_1 = 'Yes' 	then 1 
	else 0 
end as 'LCRushClosing', -- do count to get avg        -----5

CASE 
	WHEN _CX_PROBLOANCLS_14 = 'Y' 	then 1 
	else 0 
end as 'LCProblemClosing'  -- do count to get avg    -----6
------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------

 
from
emdb.emdbuser.Loansummary ls
--inner join emdb.dbo.PaidLo pdlo on ls.XrefId = pdlo.XrefId
inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
inner join emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
--inner join emdb.emdbuser.LOANXDB_S_06 ls06 on ls.XrefId = ls06.XrefId
--inner join emdb.emdbuser.LOANXDB_S_07 ls07 on ls.XrefId = ls07.XrefId

inner join emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
--inner join emdb.emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId
--inner join emdb.emdbuser.LOANXDB_N_08 ln08 on ls.XrefId = ln08.XrefId
--inner join emdb.emdbuser.LOANXDB_N_04 ln04 on ls.XrefId = ln04.XrefId
--inner join emdb.emdbuser.LOANXDB_N_07 ln07 on ls.XrefId = ln07.XrefId
inner join emdb.emdbuser.LOANXDB_N_09 ln09 on ls.XrefId = ln09.XrefId 
inner join emdb.emdbuser.LOANXDB_N_10 ln10 on ls.XrefId = ln10.XrefId 
inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
--inner join emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId


--inner join emdbuser.dbo.lockdate ld on ld.xrefid = ls.XRefID


--inner join emdb.emdbuser.LOANXDB_s_09 ls09 on ls.XrefId = ls09.XrefId
inner join emdb.emdbuser.LOANXDB_s_10 ls10 on ls.XrefId = ls10.XrefId
inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
 


where 
_2 > 1  

--and _2301 between      @StartDate and @EndDate
and loanFolder not in ('(Archive)','(Trash)', 'Samples')
--and r.region not in ('Admin/Operations') and r.region is not null
				--and LoanOfficerName = 'li li'
				--and _CX_FUNDDATE_1 between  @StartDate and @EndDate		
				--and	_CX_FUNDDATE_1 between '2012-02-01' and '2012-02-29'
				----test
				  -- exec rs_BranchMetrics '2012-01-01', '2012-01-31' 
				--order by org.costcenter, loanofficername

GO
