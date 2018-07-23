SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [dbo].[rs_BasicData_DateRange]
  @SelectRange  varchar(20),
  @SelectOption varchar(20),
  @StartDate    datetime,    ----varchar(20),
  @EndDate      datetime         ---varchar(20)
  as 
  Begin
  set @StartDate = @SelectOption
  set @EndDate  = @SelectOption
  End
		
	

Select

---  exec dbo.rs_basicdata  'locked','YTD'
-------- ==========================================================================================
-------- Author:		Darlene Gorman	
-------- Create Date:	May 7, 2012
-------- Description:	used in SSRS 'Totals report' as requested by Adal Bisharat
-------- ==========================================================================================
  
  r.region,
  cc.costcenterid,
  case when cc.costcenter is null then 9990 else cc.costcenter end as costcenter,

  convert(nvarchar(6),cc.costcenter) + ' ' + costcentername as costcenternamemerge,
  pdlo.PaidLocode,
  
  _CX_PAIDLO_3 as PaidLOName,
  e.displayname as PaidLONAmeAdmin,
    _4002 as BorrLastName,

	Case when CAST(cc.costcenter AS int) is null then 0	else CAST(cc.costcenter AS int)
	end as officeid,


	CASE WHEN _1172 = 'FHA' or  _1172 = 'VA'  then 'FHA/VA'	else _1172
	END as LoanType,


	_364 as LoanNumber,
	 
	--_CX_LOCODE_1 as 'BranchID',

	CASE when ls01._19 = 'Purchase' then 'Purchase'when  ls01._19 like '%Refi%'then 'Refi'
	end as  LoanPurpose,
	CASE when ls01._19 = 'Purchase' then 1	else 0 end as  PurchaseLoanCount,
	CASE when ls01._19 = 'Purchase' then _2	end as  PurchaseLoanAmt,
	CASE when ls01._19 <> 'Purchase' then 1	else 0 end as  RefiLoanCount,
	CASE when ls01._19 <> 'Purchase' then _2	end as  RefiLoanAmt,

	ln02._2 as LoanAmount,

	CASE when _2 < 1 then 0 else 1 end as LoanCount,


	 _CX_FUNDDATE_1 as DateFunded,
	 
	 _761 as Lockdate,
  
Case @StartDate
 		when  'Previous Month' then DATEADD(mm, DATEDIFF(mm,0,getdate())-1, 0)
		when 'YTD' then DATEADD(YY, DATEDIFF(YY,0,getdate())-0, 0)
		when 'MTD' then DATEADD(dd,-(DAY(GETDATE())-1),GETDATE())
		when 'Daily'  then getdate()
 End,
	
Case @EndDate
 		when  'Previous Month' then   DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
		when 'YTD' then GETDATE()
		when 'MTD' then getdate()
		when 'Daily'  then getdate()
 End

 
from
	emdb.emdbuser.Loansummary ls
	inner join emdb.dbo.PaidLo pdlo on ls.XrefId = pdlo.XrefId
	inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
	inner join emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
	inner join emdb.emdbuser.LOANXDB_s_10 ls10 on ls.XrefId = ls10.XrefId
	inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	 
	left outer join chilhqpsql05.Admin.corp.Employee e on e.employeeid = pdlo.paidlocode
	left outer join chilhqpsql05.Admin.corp.office o on o.officeid = e.officeid
	left outer join chilhqpsql05.admin.corp.costcenter cc on cc.CostCenterID = e.costcenterid
	left outer join chilhqpsql05.admin.corp.Region r ON r.regionID = cc.RegionID 

where 
	_2 > 1 
	and loanFolder not in ('(Archive)','(Trash)', 'Samples') 
	and
		(case @SelectRange
			when  'closed' then _748 
			when  'funded' then _CX_FUNDDATE_1 
			when  'locked' then _761
			end)
			between  @StartDate and @EndDate

	
	
	


				--and LoanOfficerName = 'li li'
				--and _CX_FUNDDATE_1 between  @StartDate and @EndDate		
				--and	_CX_FUNDDATE_1 between '2012-02-01' and '2012-02-29'
				----test
				  -- exec rs_BranchMetrics '2012-01-01', '2012-01-31' 
				--order by org.costcenter, loanofficername


-----------------------------------------------------------------------------
--inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
--inner join emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
--inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId
--inner join emdb.emdbuser.LOANXDB_S_06 ls06 on ls.XrefId = ls06.XrefId
--inner join emdb.emdbuser.LOANXDB_S_07 ls07 on ls.XrefId = ls07.XrefId
--inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
--inner join emdb.emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId
--inner join emdb.emdbuser.LOANXDB_N_08 ln08 on ls.XrefId = ln08.XrefId
--inner join emdb.emdbuser.LOANXDB_N_04 ln04 on ls.XrefId = ln04.XrefId
--inner join emdb.emdbuser.LOANXDB_N_07 ln07 on ls.XrefId = ln07.XrefId
--inner join emdb.emdbuser.LOANXDB_N_09 ln09 on ls.XrefId = ln09.XrefId 

--inner join emdb.emdbuser.LOANXDB_s_09 ls09 on ls.XrefId = ls09.XrefId
--inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
GO
