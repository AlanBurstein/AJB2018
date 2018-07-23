SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----to upload in AMB system-------------------

CREATE procedure [dbo].[AMB] 
	@UserName varchar(50),
	@StartDate date,
	@EndDate date
as 

select
	_364 as 'Loan',
	_317 as 'Loan OfficerName', 
	_CX_LOCODE_1 as 'Loan Officer Code', 
	displayname as 'Process Manager', 
	_CX_FINALOCODE_4 as 'Code for the Paid LO', 
	costcenter  as 'Cost Center',
	_37 as 'Borrower Last Name', 
	_4000 as 'Borrower First Name', 
	_2 as 'Total Loan Amount', 
	_CX_CORPOBJ as 'Total YSP', 
	_CX_COPYLOBPS as 'Corporate Objective', 
	convert(varchar,_CX_FUNDDATE_1,101) as 'FundedDate', 
	convert(varchar,_1994,101) as 'CloseDate', 
	_19 as 'Loan Purpose', 
	_14 as 'Property State', 
	_420 as 'Lien Position', 
	convert(varchar,LOCKRATE_2149,101)   as 'Lock Date',
	_VEND_X200 as 'Warehouse Bank', 
	_CX_BROKERFUND_5 as 'Funded Date for Broker Loans',
	_CX_BROKERCHKRCVD_2 as 'Broker Check Received Date', 
	_CX_BRKLOANCHKAMT_2 as 'Broker Check Amount', 
	_2278 as 'Investor Name', 
	_1401 as 'Loan Program', 
	convert(varchar,_CX_UWBRKAUDREWCMPDATE,101) as 'Broker Audit Review Completed', 
	_1172 as 'Loan Type', 
	_CX_CLOSER_1 as 'Closer', 
	_cx_mcname_1 as 'MC name',
	_CX_LCName_1 as 'LC Name',
	_CX_CLSRUSH_1 as 'Rush to Closing', 
	_CX_PCSUPENDREASON_2 as 'Closer Error', 
	
	_CX_TRUST as 'Trust',
	_3268 as '1st Payment Amount',
	_682  as '1st Payment Date', 
	_11 as 'Property Address', 
	_12 as 'City', 
	_352 as  'Investor Loan Number', 
	_1040 as 'FHA Case Number'

	
from 
	[grchilhq-sq-03].emdb.emdbuser.Loansummary ls
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
	
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_17 ls17 on ls.XrefId = ls17.XrefId

	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
	
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_03 ln03 on ls.XrefId = ln03.XrefId 
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_07 ln07 on ls.XrefId = ln07.XrefId 

	left join Admin.corp.LOCode lo on  lo.LOCode = ls03._CX_FINALOCODE_4
	left join Admin.corp.CostCenter cc on lo.CostCenterID = cc.CostCenterID
where
	_MS_START 
	between @StartDate and @EndDate
	and loanFolder not in ('(Archive)','(Trash)', 'Samples', 'GriOnline - Testing' ) 
	and @UserName in ('jwillis', 'mmehdi', 'pgeary', 'dbassman', 'dgorman', 'MMcLain','JMahone' , 'rmartinez' )
	
--give access - Jeff Willis, Mazen Mehdi, and Patrick Geary.  Thanks, Doug
	
	
GO
