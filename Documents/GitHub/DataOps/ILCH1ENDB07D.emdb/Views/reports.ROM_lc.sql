SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






--select * from  reports.rom_lc

CREATE view [reports].[ROM_lc]  
--@StartDate date,
--@EndDate date
as
		--  	 exec reports.ROM_lc '2012-08-01', '2012-08-30'
select
	1 as corp,
	o.regionID as LCregionID,
	o.Region as LCregion,
	o.supportregionid as LCsregionID,
	o.supportRegion as LCsregion,
	o.costcentername,
	empLC.displayname as LCname,
	empLC.startDate,
	titleid as LCtitleid ,
	--case when COUNT(loannumber) >= 30 then 1 else 0 end as LCover30,
	--case when COUNT(loannumber) >= 30 then 0 else 1 end as LCunder30,
	1 as LCTotLoans,
	ls01._984 as 'ls984',
	uw._984 as 'uw984',
	ls09.lockrate_2278 as ls2278, 
	--inv.lockrate_2278 as inv2278,
	Case when  ls01._984 = uw._984 and  
	 (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
	
		 then 1	else 0 
	end  as LClessUWandINVLoans,
	ls.loannumber,
	_2 as loanAmt,
	_cx_funddate_1,
	convert(int,_CX_UWNUMCNDOREVD)  as numtimesLoanssubmitUW,
	
	Case when  ls01._984 = uw._984 and   
	(isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
	
		 and  _CX_PROBLOANCLS_14  = 'Y' then 1  else 0
	 end as problemFileClosing,
	 
	 
	Case when  ls01._984 = uw._984 and   
	(isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		then UWDecsionToAssnToClose else 0 
		end as UWDecsionToAssnToClose,
	  	
	--Case when  ls01._984 = uw._984 and  
	--	(isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
	--	then (Case when ( _cx_UWRush_1  = 'Yes' or _cx_UWRush_1 = '1') then 1 
	--			--when ( _cx_UWRush_1  = 'No' or _cx_UWRush_1 = '0')  then 0 
	--			else 0 
	--			--else _cx_UWRush_1 
	--			end ) 
	--	else 0
	--end as UWrush,
	case when rf.UWrush1  = 'Yes' then 1 else 0 end as  UWrush,
	--Case when ls01._984 = uw._984
	--		 and  (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)  
	--		and (_CX_UWRUSHCOND_1 = '1'  OR _CX_UWRUSHCOND_1 = 'Yes' ) then 1 
	--		when ls01._984 = uw._984
	--		 and  (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)  
	--		and (_CX_UWRUSHCOND_1 = '0'  OR _CX_UWRUSHCOND_1 = 'No' ) then 0  
	--		else _CX_UWRUSHCOND_1
	--end as UWrushCond,  
	case when rf.UWrushCond1 = 'Yes' then 1 else 0 end as UWrushCond, 
	Case when  ls01._984 = uw._984 and   
	(isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		then (Case when  _CX_CLSRUSH_1  = 'Yes' then 1 else 0 end)
	end as ClosingRush   
	
	   
from 
	emdbuser.loansummary ls
	inner join emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId 
	inner join emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId
	inner join emdbuser.LOANXDB_S_08 ls08 on ls.XrefId = ls08.XrefId
	inner join emdbuser.LOANXDB_S_09 ls09 on ls.XrefId = ls09.XrefId
	inner join emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId	
	inner join emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
	inner join emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join emdbuser.LOANXDB_n_02 ln02 on ls.XrefId = ln02.XrefId

	inner join emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
	left outer join CHILHQSQLDB.warehouse.reports.rom_fields rf on rf.xrefid = ls.xrefid
	left join reports.Investor inv on inv.lockrate_2278 = ls09.lockrate_2278
	left outer join  admin.corp.employee empLC  on emplc.EncompassLogin = rtrim(ltrim(LoanTeamMember_UserID_LoanCoordinator))
	left outer join CHILHQSQLDB.admin.dbo.Org o on o.employeeId = empLC.employeeid
	left join CHILHQSQLDB.warehouse.reports.Underwriter uw on uw._984 = ls01._984
	--left join warehouse.reports.investor inv on inv.lockrate_2278 = ls09.lockrate_2278
	left outer join CHILHQSQLDB.admin.corp.employeeandallmanagers2 dem  on dem.empid =  emplc.employeeId
	
where 
	_cx_funddate_1 > '2012-01-01'  --between @StartDate and @EndDate
	and empLc.active = 1  
	and emplc.titleId = 31
	--and DATEDIFF(dd,startdate,getdate()) >= 90 
	--and  ls01._984 = uw._984
	--and  lockrate_2278 not in  (
	--		'Astoria Br', 'Astoria Broker', 'Bank of Internet', 'Bank of Internet - Broker', 'Flagstar B', 
	--		'Flagstar Bank', 'Flagstar Bank - Broker', 'Flagstar Bank BROKER', 'Flagstar Broker', 
	--		'FLAGSTAR C', 'FLAGSTAR CORRESPONDENT', 'Hudson City', 'Hudson City - Broker', 
	--		'Hudson City- Broker', 'ING BROKER', 'Kinecta', 'Kinecta Federal Credit Union', 
	--		'Penfed', 'PenFed - Broker', 'U.S. Bank Home Mortgage BROKER', 'Union Bank', 
	--		'Union Bank - Broker', 'UnionBank','UnionBank ', 'UnionBank - Broker', 'US BANk Broker', 
	--		'US Bank Consumer Finance - Broker', 'WELLS BROKER', 'Wells Fargo Broker')
	
--GROUP BY
	 --RegionID, Region, empLc.displayName, titleid
	 
--having COUNT(loannumber) >= 30

--order by RegionID, region,	empLC.displayname, titleid
	






















GO
