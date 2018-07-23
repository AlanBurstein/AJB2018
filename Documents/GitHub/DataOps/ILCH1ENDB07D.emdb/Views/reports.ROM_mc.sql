SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE view [reports].[ROM_mc]
--@StartDate datetime,
--@EndDate datetime
as
		---  select * from  reports.ROM_mc '2012-08-01', '2012-08-30'
select
	1 as corp,
	o.regionID as MCregionid,
	o.Region as MCregion,
	o.supportregionid as MCsregionID,
	o.supportRegion as MCsregion,
	o.costcentername,
	'MC' as emp,
	empMC.displayname as MCname,
	empMC.startDate,
	titleid as MCtitleid,
	ls.loannumber as loannumber,
	_2 as LoanAmt,
	_cx_funddate_1,
	Case when  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		 then(
		case when AppOrderToRecvd > appSentToAssgnToUW
			 then appSentToAssgnToUW
			 else appSentToAssgnToUW - AppOrderToRecvd	end ) 
		 end as    'AppOuttoUWsubmit',
	
	 case when  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		and _19 = 'Purchase' then 
		(case when isnull(AppOrderToRecvd,0) > isnull(appSentToAssgnToUW,0)
			 then isnull(appSentToAssgnToUW,0)
			 else isnull(appSentToAssgnToUW,0) - isnull(AppOrderToRecvd,0)	end )else 0 
	end  as    'Purch_AppOuttoUWsubmit',
	
	case when  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		and  _19 <> 'Purchase' then 
		(case when isnull(AppOrderToRecvd,0) > isnull(appSentToAssgnToUW,0)
			 then isnull(appSentToAssgnToUW,0)
			 else isnull(appSentToAssgnToUW,0) - isnull(AppOrderToRecvd,0)	end ) else 0
	end  as    'Refi_AppOuttoUWsubmit',
	
	case when  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		and  _19 <> 'Purchase' then 
		(case 
		  when DATEDIFF(d,_Request_x21, Log_MS_Date_AssignedtoUW )  < 0 then 0
		  when DATEDIFF(d,_Request_x21, Log_MS_Date_AssignedtoUW )  > 60 then 60
		  else DATEDIFF(d,_Request_x21, Log_MS_Date_AssignedtoUW ) end) else 0
		end as 'Refi_ApprslRecvdToAssgnToUW',

	1 as MCTotLoans,
	
	Case when  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		 then 1	else 0 
	end  as uwInHouse,
	
	 
	 
	 Case when _19 = 'Purchase' and  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		 then 1	else 0 
	end  as uwInHousePurch,
	 
	 Case when _19 <> 'Purchase' and  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		 then 1	else 0 
	end  as uwInHouseRefi,
	
   Case when  ls01._984 = uw._984 and   (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)
		then CAST(_CX_UWC_COUNT_MC AS Int) 
		end as 'CountofRoleMC'	

From 
	 emdbuser.LOANsummary ls 
	inner join emdbuser.LOANXDB_S_01 ls01 on ls01.XrefId = ls.XrefId
	inner join emdbuser.LOANXDB_S_03 ls03 on ls03.XrefId = ls.XrefId
	inner join emdbuser.LOANXDB_S_09 ls09 on ls09.XrefId = ls.XrefId
	inner join emdbuser.LOANXDB_D_01 ld01 on ld01.XrefId = ls.XrefId 
	inner join emdbuser.LOANXDB_D_02 ld02 on ld02.XrefId = ls.XrefId
	inner join emdbuser.LOANXDB_N_10 ln10 on ln10.XrefId = ls.XrefId
	inner join emdbuser.LOANXDB_n_02 ln02 on ls.XrefId = ln02.XrefId
	inner join emdbuser.LOANXDB_S_10 ls10 on ls10.XrefId = ls.XrefId
	left outer join CHILHQSQLDB.warehouse.reports.rom_fields rf on rf.xrefid = ls.xrefid
	left join reports.Investor inv on inv.lockrate_2278 = ls09.lockrate_2278
	left join CHILHQSQLDB.warehouse.reports.Underwriter uw on uw._984 = ls01._984
	left outer join admin.corp.employee empmC  on empmc.EncompassLogin = rtrim(ltrim(LoanTeamMember_UserID_MortgageConsultant))
	left outer join CHILHQSQLDB.admin.corp.employeeandallmanagers2 dem  on dem.empid =  empmc.employeeId
	left outer join CHILHQSQLDB.admin.dbo.Org o
	 on o.employeeId = empMC.employeeid
where 
	_cx_funddate_1 > '2012-01-01' --between @StartDate and @EndDate
	and empmc.active = 1  
	--and DATEDIFF(dd,startdate,getdate()) >= 90 
	and empmc.titleId in (36,112,62)
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
	-- RegionID, Region, empmc.displayName, titleid
	 




















GO
