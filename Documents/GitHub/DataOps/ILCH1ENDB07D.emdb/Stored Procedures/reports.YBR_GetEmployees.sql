SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [reports].[YBR_GetEmployees] as 

/*

-----------------------------------------------------------------------------------------------------
	who	when		what
-----------------------------------------------------------------------------------------------------
	???	????		inital rev of proc
	sethm	20130524	pulling login and display name for mc's and lc's from employee table
	sethm	20140407	fixed logic looking for recently departed employees - also changed it to 180 days from 30 days
	mava	20150511	changed encompasslogin to reflect employeeID for MC and LC UserLogin field
*/

select distinct
	'MC' as DisplayName,
	EMC.employeeId as UserLogin,
	EMC.DisplayName as FindDisplayName,
--	LoanTeamMember_UserID_MortgageConsultant as UserLogin,
--	LoanTeamMember_Name_MortgageConsultant as FindDisplayName,
	c.costCenter as branch,
	eMc.titleid as TitleID
	
from
	[grchilhq-sq-03].emdb.emdbuser.Loansummary ls
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	left outer join chilhqpsql05.admin.corp.Employee eMc on eMc.encompasslogin = LoanTeamMember_UserID_Mortgageconsultant
	left outer join chilhqpsql05.admin.corp.costcenter c on c.costcenterid = emc.costcenterid
where ( emc.active = 1  or emc.endDate > getdate() - 180 ) and 
isnull(LoanTeamMember_UserID_MortgageConsultant,'') <> '' and  isnull(LoanTeamMember_Name_MortgageConsultant,'') <> ''
union -- temporary fix by mava on 6.2.15
select 'MC', 3419, 'Kathleen Russo', 1040, 36 -- temporary fix by mava on 6.2.15
union

select distinct
	'LC' as DisplayName,
	ELC.employeeId as UserLogin,
	ELC.DisplayName as FindDisplayName,
--	LoanTeamMember_UserID_LoanCoordinator as UserLogin,
--	LoanTeamMember_Name_LoanCoordinator as FindDisplayName,
	c.costCenter as branch,
	elc.titleid as TitleID
from
	[grchilhq-sq-03].emdb.emdbuser.Loansummary ls
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	left outer join chilhqpsql05.admin.corp.Employee elc on elc.encompasslogin = LoanTeamMember_UserID_LoanCoordinator
	left outer join chilhqpsql05.admin.corp.costcenter c on c.costcenterid = elc.costcenterid 
where ( elc.active = 1  or elc.endDate > GETDATE() - 180 ) and 
isnull(LoanTeamMember_UserID_LoanCoordinator,'') <> '' and  isnull(LoanTeamMember_Name_LoanCoordinator,'') <> ''
union -- temporary fix by mava on 6.26.15
select 'LC', 11297, 'Jonathan Bryant', 1149, 31 -- temporary fix by mava on 6.26.15
--order by LoanTeamMember_Name_LoanCoordinator

union

select distinct
	'VP' as DisplayName,
	_CX_FINALOCODE_4 as UserLogin,
	evp.displayName as FindDisplayName,
	c.costCenter as branch,
	evp.titleid as TitleID
from
	[grchilhq-sq-03].emdb.emdbuser.Loansummary ls
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	left outer join chilhqpsql05.admin.corp.Employee evp on evp.employeeid = _CX_FINALOCODE_4
	left outer join chilhqpsql05.admin.corp.costcenter c on c.costcenterid = evp.costcenterid

where ( evp.active = 1  or evp.endDate > GETDATE() - 180 ) and 
isnull(_CX_FINALOCODE_4,'') <> '' and  isnull(displayName,'') <> ''
GO
