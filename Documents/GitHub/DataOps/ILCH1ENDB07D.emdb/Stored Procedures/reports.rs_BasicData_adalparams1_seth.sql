SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [reports].[rs_BasicData_adalparams1_seth]
  @AllSales     varchar(20),
  @SelectRange  varchar(20),
  @LoanType     varchar (20),
  --@SelectOption varchar(20),
  @StartDate    datetime,   
  @EndDate      datetime        
  as 
 
Select
		   --   exec reports.rs_BasicData_adalparams1_testnumemp  'Retail', 'closed', 'all', '2012-09-01', '2012-09-30' 

-------- ==========================================================================================
-------- Author:		Darlene Gorman	
-------- Create Date:	May 11, 2012
-------- Description:	used in SSRS 'VP production report' as requested by Adal Bisharat
-------- ==========================================================================================
  
  --case when d.Division = 'Admin/Operations' OR d.Division = 'Retail' then 'Retail'
  --else d.Division end as Region,
	d.Division as region,
	case when d.Division = 'Retail' then 1
	when d.Division = 'Direct' then 2
	when d.Division = 'Online' then 3
	end as RegionOrder,
	cc.costcenterid,
	case when cc.costcenter is null then 9990 else 
	cc.costcenter end as costcenter,
	cc.costcentername,
	convert(nvarchar(6),cc.costcenter) + ' ' + 
	costcentername as costcenternamemerge,
	_CX_FINALOCODE_4 as PaidLocode,
	_CX_FINALLONAME as PaidLOName,
	e.displayname as PaidLONAmeAdmin,
	_4002 as BorrLastName,
	e.ismanager,
	e.userlogin,
	Case when CAST(cc.costcenter AS int) is null then 0	else CAST(cc.costcenter AS int)
	end as officeid,
	CASE WHEN _1172 = 'FHA' or  _1172 = 'VA'  then 'FHA/VA'	else _1172
	END as LoanType,
	_364 as LoanNumber,
	CASE when ls01._19 = 'Purchase' then 'Purchase'
	--when  ls01._19 like '%Refi%'then 'Refi'
	else 'Refi'
	end as  LoanPurpose,
	CASE when ls01._19 = 'Purchase' then 1	else 0 end as  PurchaseLoanCount,
	CASE when ls01._19 = 'Purchase' then _2	end as  PurchaseLoanAmt,
	CASE when ls01._19 <> 'Purchase' then 1	else 0 end as  RefiLoanCount,
	CASE when ls01._19 <> 'Purchase' then _2	end as  RefiLoanAmt,
	ln02._2 as LoanAmount,
	CASE when _2 < 1 then 0 else 1 end as LoanCount,
	_CX_FUNDDATE_1 as DateFunded,
	_761 as Lockdate,
	1 as rcount ,
	0 as  totVP,
	0 as TOTMC,
	0 as TotLC,
	0 as TotSA,
	0 as TOTemp

from
	emdbuser.Loansummary ls
	--inner join reports.PaidLo pdlo on ls.XrefId = pdlo.XrefId
	inner join emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
	inner join emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
	inner join emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
	inner join emdbuser.LOANXDB_s_10 ls10 on ls.XrefId = ls10.XrefId
	inner join emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	--left outer join corp.Employee e on e.employeeid = pdlo.paidlocode
	left outer join corp.employee e on e.locode = ls03._CX_FINALOCODE_4
	left outer join corp.office o on o.officeid = e.officeid
	left outer join corp.costcenter cc on cc.CostCenterID = e.costcenterid
	left outer join corp.Region r ON r.regionID = cc.RegionID 
	left outer join corp.division d on d.DivisionID = r.divisionid

where 
	loanFolder not in ('(Archive)','(Trash)', 'Samples') 
	and
		(case @SelectRange
			when  'closed' then _748 
			when  'funded' then _CX_FUNDDATE_1 
			when  'locked' then _761
			end
			between   
			 @StartDate and @EndDate )
	and 
		 _19 like  (case @LoanType 
			when 'purchase' then '%Purchase%' 
			when 'refinance'then '%Refi%'
			when 'all' then '%r%'
			 end) 
			
	and
		 d.division like (case @AllSales
			when 'Retail' then '%Retail%'
			when 'Direct' then '%Direct%'
			when 'online' then '%Online%'
			when 'all' then '%e%'
			 end)
 
	 UNION

SELECT
	----case when d.Division = 'Admin/Operations' OR d.Division = 'Retail' then 'Retail'
	-- --else d.Division end as Region,
	d.Division as region,
	case when d.Division = 'Retail' then 1
	when d.Division = 'Direct' then 2
	when d.Division = 'Online' then 3
	end as RegionOrder,
	cc.costcenterid,
	case when cc.costcenter is null then 9990 else cc.costcenter end as costcenter,
	cc.costcentername,
	convert(nvarchar(6),cc.costcenter) + ' ' + 
	cc.costcentername as costcenternamemerge,
	_CX_PAIDLOCODE_3 as PaidLocode,
	_CX_PAIDLO_3 as PaidLOName,
	e.displayname as PaidLONAmeAdmin,
	_4002 as BorrLastName,
	e.ismanager,
	e.userlogin,
	Case when CAST(cc.costcenter AS int) is null then 0	else CAST(cc.costcenter AS int)
	end as officeid,
	CASE WHEN _1172 = 'FHA' or  _1172 = 'VA'  then 'FHA/VA'	else _1172
	END as LoanType,
	_364 as LoanNumber,
	CASE when _19 = 'Purchase' then 'Purchase'when  _19 like '%Refi%'then 'Refi'
	end as  LoanPurpose,
	CASE when _19 = 'Purchase' then 1	else 0 end as  PurchaseLoanCount,
	CASE when _19 = 'Purchase' then _2	end as  PurchaseLoanAmt,
	CASE when _19 like '%refi%' then 1	else 0 end as  RefiLoanCount,
	CASE when _19 like '%refi%' then _2	end as  RefiLoanAmt,
	_2 as LoanAmount,
	CASE when _2 < 1 then 0 else 1 end as LoanCount,
	_748 as DateFunded,
	'2012-01-01' as Lockdate,
	1 as rcount,
	0 as  totVP,
	0 as TOTMC,
	0 as TotLC,
	0 as TotSA,
	0 as TOTemp
from
	warehouse.reports.SMC_ClosedLoans smc
	left outer join corp.Employee e on e.employeeid = smc._CX_paidlocode_3
	left outer join corp.office o on o.officeid = e.officeid
	left outer join corp.costcenter cc on cc.CostCenterID = e.costcenterid
	left outer join corp.Region r ON r.regionID = cc.RegionID 
	left outer join corp.division d on d.DivisionID = r.divisionid

where 
		(case @SelectRange
			when  'closed' then _748 
			when  'funded' then _748 
			when  'locked' then '2012-01-01'
						end
			between   
			 @StartDate and @EndDate )
	and 
		 _19 like  (case @LoanType 
			when 'purchase' then '%Purchase%' 
			when 'refinance'then '%Refi%'
			when 'all' then '%r%'
			 end) 
	 	
UNION

Select
	d.Division as region,
	case when d.Division = 'Retail' then 1
	when d.Division = 'Direct' then 2
	when d.Division = 'Online' then 3
	end as RegionOrder,
	cc.costcenterid,
	case when cc.costcenter is null then 9990 else 
	cc.costcenter end as costcenter,
	cc.costcentername,
	convert(nvarchar(6),cc.costcenter) + ' ' + 
	costcentername as costcenternamemerge,
	0 as PaidLocode,
	null as PaidLOName,
	null as PaidLONAmeAdmin,
	null as BorrLastName,
	null as ismanager,
	null as userlogin,
	Case when CAST(cc.costcenter AS int) is null then 0	else CAST(cc.costcenter AS int)
	end as officeid,
	null as LoanType,
	null as LoanNumber,
	null as  LoanPurpose,
	null as  PurchaseLoanCount,
	null as  PurchaseLoanAmt,
	null as  RefiLoanCount,
	null as  RefiLoanAmt,
	0 as LoanAmount,
	0 as LoanCount,
	null as DateFunded,
	null as Lockdate,
	0 as rcount ,
	totVP,
	TOTMC,
	TotLC,
	TotSA,
	TOTemp
from
	admin.corp.titlecount title
	left outer join admin.corp.costcenter cc on cc.costcenter = title.costcenter
	left outer join admin.corp.region r on r.regionid = cc.regionid
left outer join admin.corp.division d on d.divisionid = r.divisionid
GO
