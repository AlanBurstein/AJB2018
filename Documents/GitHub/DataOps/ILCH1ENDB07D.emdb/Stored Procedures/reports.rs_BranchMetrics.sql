SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create Procedure [reports].[rs_BranchMetrics]

@StartDate datetime,
@EndDate datetime
as
Select


-------- ==========================================================================================
-------- Author:		Darlene Gorman	
-------- Create Date:	Feb 15, 2012
-------- Description:	used in SSRS 'Branch Monthly Report' as requested by Adal Bisharat
-------- ==========================================================================================


--------- Groups ---------------------------------------------------------------
  --e.userlogin ,
  --ls.loanofficerid,

  d.division as region,
  cc.costcenterid,
  case when cc.costcenter is null then 9990 else cc.costcenter end as costcenter,

  cc.costcentername,
  pdlo.PaidLocode,
  
  _CX_PAIDLO_3 as PaidLOName,
  e.displayname as PaidLONAmeAdmin,
    _4002 as BorrLastName,

  Case 
	when CAST(cc.costcenter AS int) is null then 0
	else CAST(cc.costcenter AS int)
  end as officeid,
  
  --o.displayname,
---- Section 1 -------------------- General Data --------------------------------
CASE
	WHEN _1172 = 'FHA' or  _1172 = 'VA'  then 'FHA/VA'
	else _1172
END as LoanType,

Case
when _1172 = 'FHA' or  _1172 = 'VA'  then 1
end as FhaVaLoanAmt,

_364 as LoanNumber,
 
--_CX_LOCODE_1 as 'BranchID',

CASE 
	when ls01._19 = 'Purchase' then 'Purchase'
	when   ls01._19 like '%Refi%'then 'Refi'
end as  'Loan Purpose',

CASE 
	when ls01._19 = 'Purchase' then 1
	end as  'PurchaseLoanAmt',

ls.LoanOfficerName,
ln02._2 as LoanAmount,

CASE when _2 < 1 then 0 else 1 end as LoanCount,
Case 
     when lockrate_2965 is null then _2
	 when lockrate_2965 =0 then _2
     else lockrate_2965 end as [LoanAmount_mip_ff],



  
  ---- Section 4  ---------------------- Efficiency Dates ----------------------------
 
  _CX_FUNDDATE_1 as 'Date Funded',
  
Case 
	when DATEDIFF(d,origlockdate, Log_MS_Date_Processing)   < -60 then -60
	when DATEDIFF(d,origlockdate, Log_MS_Date_Processing)   > 60 then 60
	else DATEDIFF(d,origlockdate, Log_MS_Date_Processing)  
end   as   'Lock to Processing',
--DATEDIFF(d,lockdate, Log_MS_Date_Processing ) as    'Lock to Processing',

--DATEDIFF(d,_CX_APPSENT_1, _CX_APPRCVD_1 ) as    'App Out to App In',

Case 
	when DATEDIFF(d,_CX_APPSENT_1, _CX_APPRCVD_1 )  < -60 then -60
	when DATEDIFF(d,_CX_APPSENT_1, _CX_APPRCVD_1 )  > 60 then 60
	else DATEDIFF(d,_CX_APPSENT_1, _CX_APPRCVD_1 ) 
end   as    'App Out to App In',

--DATEDIFF(d, ld02._cX_APPRRECTRANS_10 , Log_MS_Date_AssignedtoUW) as    'Appraisal In to Assigned to UW',

--DATEDIFF(d, _REQUEST_X21 , Log_MS_Date_AssignedtoUW) as    'Appraisal In to Assigned to UW',
Case 
	when DATEDIFF(d, ld02._cX_APPRRECTRANS_10 , Log_MS_Date_AssignedtoUW)  < -60 then -60
	when DATEDIFF(d, ld02._cX_APPRRECTRANS_10 , Log_MS_Date_AssignedtoUW)  > 60 then 60
	else DATEDIFF(d, ld02._cX_APPRRECTRANS_10 , Log_MS_Date_AssignedtoUW) 
end   as    'Appraisal In to Assigned to UW',

 --DATEDIFF(d, _761 , Log_MS_Date_AssignedtoUW)    as    'Lock to Assigned to UW',
Case 
	when DATEDIFF(d, origlockdate , Log_MS_Date_AssignedtoUW) < -60 then -60
	when DATEDIFF(d, origlockdate , Log_MS_Date_AssignedtoUW)  > 60 then 60
	else DATEDIFF(d, origlockdate , Log_MS_Date_AssignedtoUW) 
end  as    'Lock to Assigned to UW',

--DATEDIFF(d, Log_MS_Date_UWDecisionExpected, Log_MS_Date_AssigntoClose) as    'UW Decision Expected to Assigned to Close',
Case 
	when DATEDIFF(d, Log_MS_Date_UWDecisionExpected, Log_MS_Date_AssigntoClose) < -60 then -60
	when DATEDIFF(d, Log_MS_Date_UWDecisionExpected, Log_MS_Date_AssigntoClose)  > 60 then 60
	else DATEDIFF(d, Log_MS_Date_UWDecisionExpected, Log_MS_Date_AssigntoClose) 
end  as    'UW Decision Expected to Assigned to Close',

--  DATEDIFF(d,_761 , Log_MS_Date_Approval ) as 'Lock to Approval',
Case 
	when DATEDIFF(d,origlockdate , Log_MS_Date_Approval ) < -60 then -60
	when DATEDIFF(d,origlockdate , Log_MS_Date_Approval )  > 60 then 60
	else DATEDIFF(d,origlockdate , Log_MS_Date_Approval )
end  as 'Lock to Approval',

--  DATEDIFF(d,_761, Log_MS_Date_DocsSigning ) as 'Lock to Doc Signing',
Case 
	when DATEDIFF(d,origlockdate, Log_MS_Date_DocsSigning ) < -60 then -60
	when DATEDIFF(d,origlockdate, Log_MS_Date_DocsSigning )  > 60 then 60
	else DATEDIFF(d,origlockdate, Log_MS_Date_DocsSigning )
end  as 'Lock to Doc Signing',


--    DATEDIFF(d, _761   , _CX_FUNDDATE_1 ) as 'Lock to Fund',

Case 
	when DATEDIFF(d, origlockdate   , _CX_FUNDDATE_1 ) < -60 then -60
	when DATEDIFF(d, origlockdate   , _CX_FUNDDATE_1 )  > 60 then 60
	else DATEDIFF(d, origlockdate   , _CX_FUNDDATE_1 )
end  as 'Lock to Fund',


 ---- Section 5  ---------------------- Quality  ------------------------------------
 
 _CX_NUMUWCONDITION as '#MC Conditions',				----1

CASE
	when _CX_NUMUWCONDITION < 1 then 0 
	else 1
END as 'NumOfLoansMC_COND',
CASE
	when _CX_PROBLOAN_5  = 'Y' then 1 
	else 0 
END as '% of MC PROB files',						 -----2

_CX_UWNUMCNDOREVD as 'LC: # Avg submission for approval',     -----3

CASE
	when _CX_PROBLOANsub_14  = 'Y' then 1
	else 0
END as '% UW Problem Files',        --------4

CASE 
	WHEN _CX_CLSRUSH_1 = 'Yes' 	then 1 
	else 0 
end as 'LC % Rush Closing', -- do count to get avg        -----5

CASE 
	WHEN _CX_PROBLOANCLS_14 = 'Y' 	then 1 
	else 0 
end as 'LC % Problem Closing', -- do count to get avg    -----6
------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------
 --COUNTS
0 AS  totVP,
0 AS  TOTMC,
0 AS TotLC,
0 AS TotSA,
null as lt3,
null as costperloan,
null as Expense,
null as cpl_units
 
from
emdb.emdbuser.Loansummary ls
inner join emdb.dbo.PaidLo pdlo on ls.XrefId = pdlo.XrefId
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
inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
--inner join emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId

inner join emdbuser.dbo.lockdate ld on ld.xrefid = ls.XRefID


--inner join emdb.emdbuser.LOANXDB_s_09 ls09 on ls.XrefId = ls09.XrefId
inner join emdb.emdbuser.LOANXDB_s_10 ls10 on ls.XrefId = ls10.XrefId
inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
 
left outer join chilhqpsql05.Admin.corp.Employee e on e.employeeid = pdlo.paidlocode
left outer join chilhqpsql05.Admin.corp.office o on o.officeid = e.officeid
left outer join chilhqpsql05.admin.corp.costcenter cc on cc.CostCenterID = e.costcenterid
left outer join chilhqpsql05.admin.corp.Region r ON r.regionID = cc.RegionID 
left outer join  chilhqpsql05.admin.corp.Division d ON d.divisionid = r.divisionid
--left outer join chilhqpsql05.Admin.dbo.org org on org.employeeId = empcorp.employeeid
---
left outer join chilhqpsql05.Admin.corp.Titlecount title on title.costcenter = cc.costcenter
left outer join [grchilhq-sq-03].emdb.dbo.LOLessThanThree vlt on vlt.costcenter = cc.costcenter and 
                vlt.mo = MONTH(@StartDate)
-----

where 
_2 > 1  

and _748 between  @StartDate and @EndDate
and loanFolder not in ('(Archive)','(Trash)', 'Samples')
--and r.region not in ('Admin/Operations') and r.region is not null
				--and LoanOfficerName = 'li li'
				--and _CX_FUNDDATE_1 between  @StartDate and @EndDate		
				--and	_CX_FUNDDATE_1 between '2012-02-01' and '2012-02-29'
				----test
				  -- exec rs_BranchMetrics '2012-01-01', '2012-01-31' 
				--order by org.costcenter, loanofficername


-----------------------------------------------------------------------------
UNION

Select


-------- ==========================================================================================
-------- Author:		Darlene Gorman	
-------- Create Date:	Feb 15, 2012
-------- Description:	used in SSRS 'Branch Monthly Report' as requested by Adal Bisharat
-------- ==========================================================================================


--------- Groups ---------------------------------------------------------------
 

 d.division as region,
   cc.costcenterid,
  cc.costcenter as costcenter, 
 cc.costcentername,
 
 
 
 
  null as PaidLocode,
  
  null as PaidLOName,
    null as PaidLONAmeAdmin,
   null as BorrLastName,

  null as  officeid,
  
 -- o.displayname,
---- Section 1 -------------------- General Data --------------------------------

 null as LoanType,
0 as FhaVaLoanAmt,

 null as LoanNumber,
 --null as 'BranchID',

 null as  'Loan Purpose',

0 as  'PurchaseLoanAmt',

 null as LoanOfficerName,
0 as LoanAmount,
0 as loanCount,
0 as [LoanAmount_mip_ff],



  
 ---- Section 4  ---------------------- Efficiency Dates ----------------------------
 
 null as 'Date Funded',
 null as 'Lock to Processing',
 null as 'App Out to App In',
 null as 'Appraisal In to Assigned to UW',
 null as 'Lock to Assigned to UW',
 null as 'UW Decision Expected to Assigned to Close',
 null as 'Lock to Approval',
 null as 'Lock to Doc Signing',
 null as 'Lock to Fund',

 ---- Section 5  ---------------------- Quality  ------------------------------------
 0 as '#MC Conditions',				----1
0 as 'NumOfLoansMC_COND',
0 as '% of MC PROB files',						 -----2
0 as 'LC: # Avg submission for approval',     -----3

0 as '% UW Problem Files',        --------4
0 as 'LC % Rush Closing', -- do count to get avg        -----5

0 as 'LC % Problem Closing', -- do count to get avg    -----6
------------------------------------------------------------------------------------
 --COUNTS

 totVP,
 TOTMC,
 TotLC,
 TotSA,
vlt.lt3,
cpl.costperloan,
cpl.Expense,
cpl.units as cpl_units
 
from

 chilhqpsql05.Admin.corp.titlecount title
 left outer join chilhqpsql05.Admin.corp.costcenter cc on cc.costcenter = title.costcenter
 left outer join chilhqpsql05.Admin.corp.region r on r.regionid = cc.regionid
 left outer join chilhqpsql05.Admin.corp.Division d on d.divisionid = r.divisionid
 left outer join emdb.dbo.LOLessThanThree vlt on vlt.costcenter = cc.costcenter and 
                vlt.mo = MONTH(@StartDate)
 left outer join  chilhqsqldb.Warehouse.operations.CostPerLoan cpl on cpl.costcenter = cc.costcenter and
               Date = (@StartDate)
                
		
--   exec rs_BranchMetrics  '2012-05-01', '2012-05-30'





GO
