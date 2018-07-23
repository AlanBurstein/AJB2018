SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [dbo].[rs_BasicData_adalparams1_smc]
  @AllSales     varchar(20),
  @SelectRange  varchar(20),
  @LoanType     varchar (20),
  --@SelectOption varchar(20),
  @StartDate    datetime,   
  @EndDate      datetime        
  as 
 
Select
		   --exec dbo.rs_BasicData_adalparams1 'Retail','closed', 'refinance', '2011-01-01', '2012-03-31' 

-------- ==========================================================================================
-------- Author:		Darlene Gorman	
-------- Create Date:	May 11, 2012
-------- Description:	used in SSRS 'VP production report' as requested by Adal Bisharat
-------- ==========================================================================================

	r.region,
	cc.costcenterid,
	case when cc.costcenter is null then 9990 else cc.costcenter end as costcenter,

	convert(nvarchar(6),cc.costcenter) + ' ' + costcentername as costcenternamemerge,
	pdlo.PaidLocode,

	_CX_PAIDLO_3 as PaidLOName,
	e.displayname as PaidLONAmeAdmin,
	_4002 as BorrLastName,
	e.ismanager,

	Case when CAST(cc.costcenter AS int) is null then 0	else CAST(cc.costcenter AS int)
	end as officeid,


	CASE WHEN _1172 = 'FHA' or  _1172 = 'VA'  then 'FHA/VA'	else _1172
	END as LoanType,


	_364 as LoanNumber,

	--_CX_LOCODE_1 as 'BranchID',
	ls01._19,
	CASE when ls01._19 = 'Purchase' then 'Purchase'when  ls01._19 like '%Refi%'then 'Refi'
	end as  LoanPurpose,
	CASE when ls01._19 = 'Purchase' then 1	else 0 end as  PurchaseLoanCount,
	CASE when ls01._19 = 'Purchase' then _2	end as  PurchaseLoanAmt,
	CASE when ls01._19 like '%refi%' then 1	else 0 end as  RefiLoanCount,
	CASE when ls01._19 like '%refi%' then _2	end as  RefiLoanAmt,

	ln02._2 as LoanAmount,

	CASE when _2 < 1 then 0 else 1 end as LoanCount,


	_CX_FUNDDATE_1 as DateFunded,

	_761 as Lockdate



 
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
		 r.region like (case @AllSales
			when 'Retail' then '%Retail%'
			when 'Direct' then '%Direct%'
			when 'online' then '%Online%'
			when 'all' then '%e%'
			 end)
	 	
UNION

SELECT

	r.region,
	cc.costcenterid,
	case when cc.costcenter is null then 9990 else cc.costcenter end as costcenter,

	convert(nvarchar(6),cc.costcenter) + ' ' + cc.costcentername as costcenternamemerge,
	_CX_PAIDLOCODE_3 as PaidLocode,

	_CX_PAIDLO_3 as PaidLOName,
	e.displayname as PaidLONAmeAdmin,
	_4002 as BorrLastName,
	e.ismanager,

	Case when CAST(cc.costcenter AS int) is null then 0	else CAST(cc.costcenter AS int)
	end as officeid,


	CASE WHEN _1172 = 'FHA' or  _1172 = 'VA'  then 'FHA/VA'	else _1172
	END as LoanType,


	_364 as LoanNumber,

	--_CX_LOCODE_1 as 'BranchID',
	_19,
	CASE when _19 = 'Purchase' then 'Purchase'when  _19 like '%Refi%'then 'Refi'
	end as  LoanPurpose,
	CASE when _19 = 'Purchase' then 1	else 0 end as  PurchaseLoanCount,
	CASE when _19 = 'Purchase' then _2	end as  PurchaseLoanAmt,
	CASE when _19 like '%refi%' then 1	else 0 end as  RefiLoanCount,
	CASE when _19 like '%refi%' then _2	end as  RefiLoanAmt,

	_2 as LoanAmount,

	CASE when _2 < 1 then 0 else 1 end as LoanCount,


	_748 as DateFunded,

	'2012-01-01' as Lockdate



 
from
	chilhqsqldb.warehouse.reports.SMC_ClosedLoans smc
	 
	left outer join chilhqpsql05.Admin.corp.Employee e on e.employeeid = smc._CX_PAIDLOCODE_3
	left outer join chilhqpsql05.Admin.corp.office o on o.officeid = e.officeid
	left outer join chilhqpsql05.admin.corp.costcenter cc on cc.CostCenterID = e.costcenterid
	left outer join chilhqpsql05.admin.corp.Region r ON r.regionID = cc.RegionID 

where 
	_2 > 1 
	
	--and loanFolder not in ('(Archive)','(Trash)', 'Samples') 
	
	and
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
			
	and
		 r.region like (case @AllSales
			when 'Retail' then '%Retail%'
			when 'Direct' then '%Direct%'
			when 'online' then '%Online%'
			when 'all' then '%e%'
			 end)
	 	




GO
