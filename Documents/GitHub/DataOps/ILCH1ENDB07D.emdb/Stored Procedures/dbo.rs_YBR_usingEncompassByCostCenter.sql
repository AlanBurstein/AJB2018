SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[rs_YBR_usingEncompassByCostCenter]

--@Branch int = null,
@UserName varchar(max),
@GroupBy varchar(10),
@CostCenter varchar(max) = null,
@Options varchar(max) 

as
--exec dbo.[rs_YBR_usingEncompassEmpList_testprequal] 'dgorman', 'MC', 'cathyj' ,'all'
--exec dbo.rs_YBR_usingEncompassEmpList 'dgorman', 'vp',2113 ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'dgorman', MC', 6088 ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'dgorman', 'LC', 'Julissa Eusebio' ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'mortiz', 'LC', 'Julissa Eusebio' ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'mortiz', 'MC', 'Suzanne Dzolan' ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg 'mcohn', 'LC', 'Heidi Selteneck' ,'all'

-------- ==========================================================================================
-------- Author:		Darlene Gorman	
-------- Create Date:	March 20, 2012
-------- Description:	used in SSRS 'YBR 2.1 - Branch' and YBR exception report
-------- ==========================================================================================
-------- Modifications:
-------- Name				Date				Modification
-------- rcorro				9/3/2014			Sonya request, add Condo/PUD Approval Submitted (CX.UW.CONDOSUB) and Condo/PUD Approval Issued (CX.UWCONDOAPPR)
-------- rcorro				9/12/2014			Added _cx_brkapprove_12 as BrokeredApproval, this is needed, when the loan is brokered, UWApproval displays BrokeredApproval instead of UWApproval
-------- ==========================================================================================
   --test = Case when (_CX_APPSENT_1 > '2001-01-01' and _CX_APPRCVD_1 IS null) then 'YES' else 'No' end,
	SELECT DISTINCT 
	Address1,
	_CX_FUNDDATE_1,
    -- coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ),
    ls.loanofficerid,
    _763,
    _1393,
    _420,
    _11,
    _761,
    _3137,
    CASE 
		WHEN _761 > _3137 THEN 'alert' 
	END AS checklockdisc,
    CASE 
		WHEN isnull(rtrim(ltrim(LoanTeamMember_Name_LoanCoordinator)),'') = '' THEN _CX_LCNAME_1 
		ELSE isnull(rtrim(ltrim(LoanTeamMember_Name_LoanCoordinator)),'') 
	END AS LCName,
	--empLC.userlogin as LClogon,  --- when using this- rows are duplicated by loan number
	_CX_LCNAME_1,
	LoanTeamMember_UserID_LoanCoordinator,
	CASE 
		WHEN isnull(rtrim(ltrim(LoanTeamMember_Name_MortgageConsultant)),'') = '' THEN _CX_MCNAME_1
		ELSE isnull(rtrim(ltrim(LoanTeamMember_Name_MortgageConsultant)),'') 
	END AS MCName,
	_CX_MCNAME_1,
	--empmc.userlogin as MClogon, --- when using this- rows are duplicated by loan number
	LoanTeamMember_UserID_MortgageConsultant,
	--LoanTeamMember_Name_MortgageConsultant,
	_317 AS LicensedVP,
	--LoanTeamMember_UserID_LoanOfficer,1
	--LoanTeamMember_Email_LoanOfficer,
	--_CX_PAIDLO_3 AS VP,
	e.displayname AS VP, --use this for Paid VP 
	_CX_FINALOCODE_4 as pdVPcode,
	e.UserLogin as pdVPlogin,
	--dbo.DateDiffWeekDay(getdate(),_762) as daysLocked, changed to days diff per mike
	DATEDIFF(d,getdate(),_762) as daysLocked,
	getdate() as compareDate,
	r.region,
	cc.costcenter, 
	cc.costcentername,	
	ls.LoanFolder,
	_CX_PAIDLO_3 AS LoanOfficer,
	_364 as LoanNumber,
	_CX_CONTINGE_1,
	_CX_RESTRUCTUREDTI ,
	_CX_RESTRUCTURELTV,
	_cx_restltvcomplete,
	_cx_restdticomplete,
	--need restructure box field id  
	--The resolution fields are: 
	--The fields are CX.RESTLTVCOMPLETE and CX.RESTDTICOMPLETE. 
	--Do not send it back to the assigned milestone when the date is taken out. 
	--Please make sure this is the only way it gets assigned back in the pipeline. 
	--_2303 AS UWSuspended,
	--_2301 as UWApproval,	
	--Log_MS_Lastcompleted,
	_2301,
	_2303,
    _2626 ,---<> 'Brokered'
	CASE      --find brokered loans first
		WHEN _2626 = 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 <> inv.lockrate_2278) THEN 11
		WHEN ((_2303 > '2000-01-01' and _2301 is null 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)))  
			OR (_CX_RESTRUCTUREDTI > '2001-01-01'  and _cx_restdticomplete <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			OR (_CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			OR (_CX_CX_RESTRUCTUREASSET > '2001-01-01' and _CX_RESTRUCTUREASSETCOMPLETE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			OR (_CX_RESTRUCTUREPROPERTY > '2001-01-01' and _CX_RESTRUCTUREPROPERTYCOMPLE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278))))
			THEN 12  ---UW SUSPENDED
		WHEN Log_MS_Lastcompleted = 'Started' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) THEN 1
		WHEN (Log_MS_Lastcompleted  = 'Processing'
			AND _CX_RESTRUCTUREDTI < '2001-01-01' 
			AND _CX_RESTRUCTURELTV < '2001-01-01'           
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))) 
			OR (Log_MS_Lastcompleted = 'App Fee Collected' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))) 
			THEN 2
			--WHEN Log_MS_Lastcompleted = 'App Fee Collected' then 3
		WHEN Log_MS_Lastcompleted = 'Assigned to UW' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))
			THEN 4
		WHEN Log_MS_Lastcompleted = 'Submittal' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 5
		WHEN Log_MS_Lastcompleted = 'UW Decision Expected'  
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 6
		WHEN Log_MS_Lastcompleted = 'Conditions Submitted to UW' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 7
		WHEN Log_MS_Lastcompleted = 'Approval' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 8	
		WHEN Log_MS_Lastcompleted = 'Assign to Close'
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))  
			THEN 9
		WHEN Log_MS_Lastcompleted in ( 'Doc Signing', 'Docs Signing' )
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 10
		WHEN Log_MS_Lastcompleted IN ('Funding', 'Shipping') THEN 12
		ELSE 2
	END as MilestoneOrder,

	CASE      --find brokered loans first
		WHEN _2626 = 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 <> inv.lockrate_2278)
			THEN 'Brokered'
		WHEN ((_2303 > '2000-01-01' and _2301 is null 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)))  
			OR 
			(_CX_RESTRUCTUREDTI > '2001-01-01'  and _cx_restdticomplete <> 'Y' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)))
			OR 
			(_CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)))
			OR 
			(_CX_CX_RESTRUCTUREASSET > '2001-01-01' and _CX_RESTRUCTUREASSETCOMPLETE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			OR 
			(_CX_RESTRUCTUREPROPERTY > '2001-01-01' and _CX_RESTRUCTUREPROPERTYCOMPLE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))		
			)
			THEN 'RESTRUCTURE – LTV, DTI or UW SUSPENSE'
		WHEN Log_MS_Lastcompleted = 'Started' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))
			THEN 'Started'
		WHEN 
			(Log_MS_Lastcompleted  = 'Processing'
			AND _CX_RESTRUCTUREDTI < '2001-01-01' 
			AND _CX_RESTRUCTURELTV < '2001-01-01'         
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))) 
			OR 
			(Log_MS_Lastcompleted = 'App Fee Collected' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))) 
			THEN 'Processing'
			--WHEN Log_MS_Lastcompleted = 'App Fee Collected' then 3
		WHEN Log_MS_Lastcompleted = 'Assigned to UW' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))
			THEN 'Assigned to Underwriting Department'	
		WHEN Log_MS_Lastcompleted = 'Submittal' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 'Submitted to an Underwriter'
		WHEN Log_MS_Lastcompleted = 'UW Decision Expected'  
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 'Underwriting Decision Issued'
		WHEN Log_MS_Lastcompleted = 'Conditions Submitted to UW' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 'Conditions Submitted to UW'
		WHEN Log_MS_Lastcompleted = 'Approval' 
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 'Final Approval/CTC'
		WHEN Log_MS_Lastcompleted = 'Assign to Close'
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278))  
			THEN 'Assigned to Closing'
		WHEN Log_MS_Lastcompleted in ( 'Doc Signing', 'Docs Signing' )
			AND ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			AND ls09.lockrate_2278 = inv.lockrate_2278)) 
			THEN 'Doc Signing'
		--when Log_MS_Lastcompleted IN ('Funding', 'Shipping') then 12
		ELSE Log_MS_Lastcompleted
	END AS PrevMilestoneGroup,
	_4000 AS FirstName,
	_4002 as LastName,
	CASE
		WHEN _19  = 'Purchase' then 'Purchase' 
		WHEN _19  = 'NoCash-Out Refinance' then 'NO C/O Refi'
		WHEN _19  = 'Cash-Out Refinance' then 'C/O Refi'
	END AS LoanPurpose, 
	CASE 
		WHEN _1041 = 'Condominium' then 'Condo'
		ELSE _1041 
	END AS  PropertyType,
	--Case 
	--  when _CX_SECINVESTOR_10 = 'Chase Manhattan Mortgage Corporation' then 'Chase Manhattan MC' 	  
	--  when _CX_SECINVESTOR_10 = 'U.S. Bank Home Mortgage' then 'US Bank Home Mtg'
	--  else _CX_SECINVESTOR_10   
	--END as Investor,
	CASE WHEN  isnull(ls09.lockrate_2278,'') <> '' and  ls09.lockrate_2278 <> inv.lockrate_2278   
         THEN 'BRKR' + '-' + LEFT(ls09.lockrate_2278,15)
		 ELSE LEFT(ls09.lockrate_2278,15)
	END AS 'Investor',
	_2626 as 'broker2626',
	LoanAmount,
	_428 as SecondLoanAmount,
	_745 as OrigDate,
	_761 as LockDate,
	--SC rule - when LockDate greater than app date - note by color
	CASE
		WHEN _761 > _CX_APPSENT_1 THEN 'Red'
	END AS LockAfterAppColor,
	CASE
		WHEN _761 > _CX_APPSENT_1 THEN 1
		ELSE 0
	END AS Count_LockkAfterApp,
	CASE
		WHEN _761 > _CX_APPSENT_1 THEN 0
		ELSE 1
	END AS CountOK_LockkAfterApp,
--SC/VP rule -  when lockDate > 2 days of Orig 
		--#DB7093 is pale red  -- 745 is app date  --761 is lock date #FFE4E1 lt pink
	CASE 
		WHEN _761 is null AND (_CX_APPRAISALRCVD_1 > '2001-01-01') 
		                  AND ( _CX_APPRORDERTRANS_10 > '2001-01-01')
		                  AND (_19 <> 'Purchase') THEN '#FFE4E1'
		WHEN (dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null THEN '#FFFFCC'
	END as LockColor,
	CASE 
		WHEN  _761 > (dbo.DateAddWeekDay(2,_745)) THEN 'Red'
	END AS LockColor2,
	CASE 
		WHEN ((dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null ) Or 
		  (_761 > (dbo.DateAddWeekDay(2,_745))) THEN 1
		ELSE 0
	END AS count_Lock,
	CASE 
		WHEN ((dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null ) Or 
		  (_761 > (dbo.DateAddWeekDay(2,_745)))  or _761 is null THEN 0
		ELSE 1
	END AS countOK_Lock,
	_CX_CLSSCHED_1 AS schdldClose,
    _763 AS estClose,
     
--SC/VP rule -  when send to Proc > 2 days of orig
	CASE 
		WHEN (dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null THEN '#FFFFCC'
	END AS SendProcColor,
	CASE 
		WHEN  Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745)) THEN 'Red'
	END AS SendProcColor2,
	CASE 
		WHEN ((dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null)  
		OR (Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745)))THEN 1
		ELSE 0
	END AS count_SendProc,
	CASE 
		WHEN ((dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null)  
		OR (Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745))) or Log_MS_Date_Processing is null THEN 0
		ELSE 1
	END AS countOK_SendProc,
	Log_MS_Date_Processing AS SentToProc,
--changed from same day to 1 day after per mike dye on 5/24/2012	
----SC/VP/MC rule - Application OUT > Same Day of Send to Processing ( 1 day after)		
	CASE	
		--	when 	Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL THEN '#FFFFCC'
		--END AS AppOutColor,
		WHEN (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null THEN '#FFFFCC'
    END AS AppOutColor, 
	CASE	
	--	when   _CX_APPSENT_1 > Log_MS_Date_Processing THEN 'Red'
	--END AS AppOutColor2	,
		WHEN _CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) THEN 'Red'
	END AS AppOutColor2, 
	CASE	
	--	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	--	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 1
	--	else 0 
	--END AS count_AppOut,
		WHEN ((dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null) 
		OR (_CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing))) THEN 1 ELSE 0
	 END AS count_AppOut, 
	CASE	
	--	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	--	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 0
	--	else 1 
	--END AS countOK_AppOut,
		WHEN ((dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null) 
		OR (_CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)))
		OR _CX_APPSENT_1 is null THEN 0 ELSE 1
	END AS countOK_AppOut, 
	_CX_APPSENT_1 as AppOut,
	_CX_APPRCVD_1 as AppIn,
	
--MC rule - Application IN < 48 hours of Application Out -- use all days including weekends--		
	CASE
		WHEN (dbo.DateAddWeekDay(2,_CX_APPSENT_1))< GETDATE() and _CX_APPRCVD_1 is null then '#FFFFCC'
    END AS AppInColor,
    CASE
		WHEN _CX_APPRCVD_1 > DateAdd(d,2,_CX_APPSENT_1) then 'Red'
    END AS AppInColor2,
    CASE
		WHEN DateAdd(d,2,_CX_APPSENT_1) < GETDATE() and _CX_APPRCVD_1 is null  or 
		 (_CX_APPRCVD_1 > DateAdd(d,2,_CX_APPSENT_1)) then  1
		ELSE 0
    END AS count_AppIn,
    CASE
		WHEN DateAdd(d,2,_CX_APPSENT_1) < GETDATE() and _CX_APPRCVD_1 is null or 
		 (_CX_APPRCVD_1 > DateAdd(d, 2,_CX_APPSENT_1))   or _CX_APPRCVD_1 is null  then  0
		ELSE 1
    END AS countOK_AppIn,
--MC rule -  appraisal ordered > same day of send to processing	
	CASE 
		WHEN (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) 
		OR (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) THEN '#FFFFCC'
	END as AprslOrdColor,
	CASE 
		WHEN (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing ) 
		OR (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 > _CX_APPRCVD_1) then 'Red'
	END as AprslOrdColor2,
	CASE 
		WHEN (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and (Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null))
		OR (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and (Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing))	 
		OR ( _CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and (_CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 is null)) 
		OR (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and (_CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 > _CX_APPRCVD_1))
		THEN 1 ELSE 0
	END AS Count_AprslOrd,
	CASE 
		WHEN (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) 
		OR (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing)
		OR (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) 
		OR (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 > _CX_APPRCVD_1)
		THEN 0 ELSE 1
	END AS CountOK_AprslOrd,
--MC rule -  appraisal Received(IN) > 7 Days of Appraisal Order Date
    CASE 
		WHEN _CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null then '#FFFFCC'
    END AS AprslRecColor,
    CASE 
		WHEN _CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10))then 'Red'
    END AS AprslRecColor2, 
    CASE 
		WHEN (_CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null) or
		  (_CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10))) then 1 
		ELSE 0
    END AS Count_AprslRec,
    CASE 
		WHEN (_CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null) or
		  (_CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10))) or  _CX_APPRRECTRANS_10 is null then 0 else 1
    END AS CountOK_AprslRec,
	CASE 
		WHEN _CX_APPRAISALREQ = 'No' THEN 'N/A'
		ELSE convert(varchar(8),_CX_APPRORDERTRANS_10,1) 
	END AS AppraisalOrdered,	 
	CASE 
		WHEN _CX_APPRAISALREQ = 'No' THEN 'N/A'
		ELSE convert(varchar(8),_CX_APPRRECTRANS_10,1) 
	END AS AppraisalRec,
	
--MC rule -  title Ordered > same day of Send to Processing	
	CASE	
		WHEN 	Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL THEN '#FFFFCC'
	END AS TitleOrdColor,
	CASE	
		WHEN   _CX_TITLEORDER_1 > Log_MS_Date_Processing THEN 'Red'
	END AS TitleOrdColor2,
	 CASE	
		WHEN 	(Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL) or 
		 (  _CX_TITLEORDER_1 > Log_MS_Date_Processing ) then 1 else 0
	END AS count_TitleOrd,
	CASE	
		WHEN 	(Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL) or 
		 (  _CX_TITLEORDER_1 > Log_MS_Date_Processing ) or _CX_TITLEORDER_1 is null  then 0 else 1
	END AS countOK_TitleOrd,
	
--MC rule -  title IN > 7 days of order date
   CASE 
		WHEN (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null then '#FFFFCC'
    END AS TitleInColor, 
    CASE 
		WHEN _CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) then 'Red'
	END AS TitleInColor2, 
	 CASE 
		WHEN ((dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null) or
	  (_CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1))) then 1 else 0
	 END AS Count_TitleIn, 
	  CASE 
		WHEN ((dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null) or
	  (_CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)))    then 0 else 1
	 END AS CountOK_TitleIn, 
	
	_CX_TITLEORDER_1 as TitleOrdered,
	_CX_TITLERCVD_1 AS TitleReceived,

--MC rule -  UWApproval > 5 days after Submission to UW
	CASE	
		WHEN(dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL THEN '#FFFFCC'
	END AS UWApprovalColor,
	CASE	
		WHEN _2301 > (dbo.DateAddWeekDay(5,_2298)) then 'Red'
	END AS UWApprovalColor2,
	CASE	
		WHEN((dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL) or
		( _2301 > (dbo.DateAddWeekDay(5,_2298))) then 1 else 0
	END AS count_UWApproval,
	CASE	
		WHEN((dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL) or
		( _2301 > (dbo.DateAddWeekDay(5,_2298))) or _2301 IS null then 0 else 1
	END AS countOK_UWApproval,
	
	_2298 AS UWSubmitted,
	_2301 AS UWApproval,
	_cx_brkapprove_12 AS BrokeredApproval,
	---   _CX_APPRRECTRANS_10  appraisal recvd
	---  _CX_APPRCVD_1           application recvd
	--- _cx_apppakcomplete    application package complete
--MC rule -  UWSubmission for REFI  > 1 day of appraisal in
	--     -  UWSubmission for PURCH > 1 day of application in - changed to remove app in and use app package complete date per mike 7/4/2012	
	CASE	--when refi
		WHEN (_CX_APPRRECTRANS_10 > '2001-01-01' and _cx_apppakcomplete  > '2001-01-01' 
		AND (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10) < GETDATE() 
		AND dbo.DateAddWeekDay(2,_cx_apppakcomplete) < GETDATE()) 
		AND _19 like '%Refi%' and _2298 IS NULL) 
		OR  --when purchase
		(_cx_apppakcomplete  > '2001-01-01'  
		AND (dbo.DateAddWeekDay(1,_cx_apppakcomplete))  < GETDATE() 
		AND _19 = 'Purchase'  
		AND _2298 is null) 
		THEN '#FFFFCC'
	END AS UWSubmissionColor,
	CASE	
		WHEN (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) AND _19 like '%Refi%') OR
		     (_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete))       AND _19  = 'Purchase')
		THEN 'Red'
	END AS UWSubmissionColor2,
	CASE	
		WHEN  (((dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) < GETDATE()  AND _19 like '%Refi%' and _2298 IS NULL)) or
		      ((dbo.DateAddWeekDay(1,_cx_apppakcomplete))   < GETDATE() and  _19 = 'Purchase' and _2298 is null)  or
		      (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10))  AND _19 like '%Refi%') OR
		     (_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete))       AND _19  = 'Purchase') 
		THEN 1 ELSE 0
	END AS Count_UWSubmission,
	CASE	
		WHEN _19 like '%Refi%' 
		AND ((((dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) < GETDATE() AND _2298 IS NULL)) 
		OR (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10))))
		OR _19 = 'Purchase' 
		AND (((dbo.DateAddWeekDay(1,_cx_apppakcomplete)) < GETDATE() AND _2298 IS NULL)  
		OR (_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete)))) 
		OR _2298 is null
		THEN 0 ELSE 1
	END AS CountOK_UWSubmission,
	--CASE	
	--	when  (((dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) < GETDATE() AND _19 like '%Refi%' and _2298 IS NULL)) or
	--	      ((dbo.DateAddWeekDay(1,_cx_apppakcomplete))       < GETDATE() and  _19 = 'Purchase' and _2298 is null)  or
	--	      (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) AND _19 like '%Refi%') OR
	--	     (_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete))       AND _19  = 'Purchase') then 0 else 1
	--END AS CountOK_UWSubmission,

	-- for CTC, if brokered, then show brokered CTC date, else show normal CTC date -- sethm 08/01/14		
	CASE 
		WHEN _2626 = 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
		AND ls09.lockrate_2278 <> inv.lockrate_2278) THEN _CX_BRKCTC 
		ELSE _2305 
	END AS UWCTC,
	CASE
		WHEN _748 > '2001-01-01' THEN _748
		WHEN _CX_CLSSCHED_1 > _763 THEN _CX_CLSSCHED_1 
		ELSE _763
	END AS EstClosingDate, 
	_762 as LockExpiration,
--LC rule -  Condition Submission  > 2 Days after Approval Date From UW
	CASE	
		WHEN ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
		  ((dbo.DateAddWeekDay(4,_2301) < GETDATE()) AND r.region <> 'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) THEN '#FFFFCC'
	END AS CondSubmitColor,
	CASE	
		WHEN ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))AND r.region =  'Online') or
		 (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(4,_2301))AND r.region <> 'Online') then 'Red'
	END AS CondSubmitColor2,
	CASE	
		WHEN ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
		  ((dbo.DateAddWeekDay(4,_2301) < GETDATE()) AND r.region <> 'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) OR 
		  ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))AND r.region =  'Online') or
		  (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(4,_2301))AND r.region <> 'Online') then 1 else 0
	END AS Count_CondSubmit,
	CASE
		WHEN ((r.region =  'Online' and((dbo.DateAddWeekDay(2,_2301) < GETDATE()) and (  coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,	 ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) 
		OR (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,  ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301)))))
		OR ( r.region <> 'Online' and ((dbo.DateAddWeekDay(4,_2301) < GETDATE()) and (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) 
		OR (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,   ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(4,_2301))))))	 
		OR   coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) is null
		THEN 0 ELSE 1
	END AS CountOK_CondSubmit,
	--CASE	
	--when ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and 
	--	 coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,
	--	 ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
	--	  ((dbo.DateAddWeekDay(4,_2301) < GETDATE()) AND r.region <> 'Online' and 
	--	  coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,
	--	  ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) OR 
	--	  ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,
	--	  ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))
	--	  AND r.region =  'Online') or
	--	  (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,
	--	  ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(4,_2301))
	--	  AND r.region <> 'Online') 
	--then 0 else 1
	--end AS CountOK_CondSubmit,

--LC rule -  CTC  > 2 Days after Conditions submitted to UW
		  -- or	Purch: < 6 days from Contigency Date 
		   --or Refi Primary < 10 days from Lock expiration
		   --or Refi 3nd or inv < 6 days from Lock expiration
		   --or purchase < 6 dayd from extimated/scheduled close date
		   --    _2305 = UWCTC    _CX_CONTINGE_1 = contigency Date
	CASE	
		WHEN  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
		      (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) )
	    THEN '#FFFFCC'
	END AS CTCColor,
	
	CASE	
		WHEN  (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
		      ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase'))OR 
		      ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
			  ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
              ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
        then 'Red'
	END AS CTCColor2,
	CASE	
		WHEN  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
		      (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) ) or
		      (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
		      ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase') )OR 
		      ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
			  ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
              ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
	    THEN 1 else 0
	END AS  Count_CTC,
	
	CASE	
		WHEN _19 = 'Purchase' 
		AND ((_2305  <= (dbo.DateAddWeekDay(6,_CX_CONTINGE_1))) 
		OR ((_2305 >=  (dbo.DateAddWeekDay(10, _762)) and _1811 = 'PrimaryResidence')) 
		OR (_2305 >=   (dbo.DateAddWeekDay(6,_763))))
		OR (_19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') 
		AND (_2305 >=  (dbo.DateAddWeekDay(6,_762))))
		OR _2305 <=  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,
			ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ))))
	    THEN 1 ELSE 0
	END AS CountOK_CTC,
	
	----CTC COUNTS - original ones replaced with 2 pieces of code above
	--CASE	
	--	when  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
	--	      (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
	--	      ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
	--	      ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
	--	      ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) ) or
	--	      (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
	--	      ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase') )OR 
	--	      ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
	--		  ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
 --             ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
	--    THEN 1 else 0
	--END AS Count_CTC,
	--CASE	
	--	when  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
	--	      (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
	--	      ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
	--	      ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
	--	      ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) ) or
	--	      (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
	--	      ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase') )OR 
	--	      ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
	--		  ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
 --             ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
	--    THEN 0 else 1
	--END AS CountOK_CTC,
	
			
	_2303 AS UWSuspended,
	Log_MS_Date_DocsSigning as DocsSigned,
	
	-- for conditions submitted, if brokered, show brokered conditions submitted date, else pick the most recent conditions submitted date -- sethm 08/01/14

	CASE WHEN _2626 = 'Brokered' 
		OR (ISNULL(ls09.lockrate_2278,'') <> '' 
		AND ls09.lockrate_2278 <> inv.lockrate_2278) 
		THEN _CX_CND_SENT_BROKER 
		ELSE COALESCE(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) 
	END AS CondSubmit,

    _1811 as proptype,
    e.titleid ,
	Log_MS_Lastcompleted,
	sa.userlogin as SALogin,
	dbo.AllManagers2(dem.empid) as MGRLogin,
	  --was this:    dbo.allmanagers(e.employeeId) as MGRLogin
	_cx_apppakcomplete,
	_cx_apprreviewed AS APPROVALreviewed,
  
	------------------------------------------NEW
						--     _2301 as UWApproval
						--      _cx_apprreviewed AS   APPROVALreviewed,
 
	--RULE - APPROVAL REVIEWED is greater than 1 day of UW approval
	CASE
		WHEN(dbo.DateAddWeekDay(1,_2301)) < GETDATE() and  _cx_apprreviewed IS NULL THEN '#FFFFCC'
	END AS aprvlREVIEWEDColor,
	CASE	
		WHEN _cx_apprreviewed > (dbo.DateAddWeekDay(1,_2301)) then 'Red'
	END AS aprvlREVIEWEDColor2,
	CASE	
		WHEN((dbo.DateAddWeekDay(1,_2301)) < GETDATE() and  _cx_apprreviewed IS NULL) or
		( _cx_apprreviewed > (dbo.DateAddWeekDay(1,_2301))) then 1 else 0
	END AS count_aprvlREVIEWED,
	CASE	
		WHEN((dbo.DateAddWeekDay(1,_2301)) < GETDATE() 
		AND  _cx_apprreviewed IS NULL) 
		OR (_cx_apprreviewed > (dbo.DateAddWeekDay(1,_2301))) 
		OR _cx_apprreviewed is null then 0 else 1
	END AS countOK_aprvlREVIEWED,
	
	--CASE	
	--	when((dbo.DateAddWeekDay(1,_2301)) < GETDATE() and  _cx_apprreviewed IS NULL) or
	--	( _cx_apprreviewed > (dbo.DateAddWeekDay(1,_2301))) then 0 else 1
	--END AS countOK_aprvlREVIEWED,
	
		
		--	--_CX_APPSENT_1 as AppOut,
		--	-- _CX_APPRCVD_1 as AppIn,
	--CASE
		--when (dbo.DateAddWeekDay(2,_CX_APPSENT_1))< GETDATE()   
		--or   (dbo.DateAddWeekDay(3,_CX_APPRCVD_1))< GETDATE() 
		-- and _cx_apppakcomplete is null then '#FFFFCC'
	--  end AS AppcmpltColor,
	----  CASE
		----when _cx_apppakcomplete > DateAdd(d,2,_CX_APPSENT_1) or _cx_apppakcomplete > DateAdd(d,1,_CX_APPRCVD_1) then 'Red'
	----  end AS AppcmpltColor2,
	--    CASE
		--when (_CX_APPRCVD_1 > _CX_APPSENT_1 and _cx_apppakcomplete > DateAdd(d,3,_CX_APPSENT_1)) or 
		--     (_CX_APPRCVD_1 IS        null  and _cx_apppakcomplete > DateAdd(d,2,_CX_APPSENT_1))  then 'Red'
	--  end AS AppcmpltColor2,
  
	--  CASE
		--when DateAdd(d,2,_CX_APPRCVD_1) < GETDATE() and _cx_apppakcomplete is null  or 
		-- (_cx_apppakcomplete > DateAdd(d,2,_CX_APPSENT_1)) or _cx_apppakcomplete > DateAdd(d,1,_CX_APPRCVD_1) then  1
		-- else 0
	--  end AS count_Appcmplt,
	--  CASE
		--when DateAdd(d,2,_CX_APPSENT_1) < GETDATE() and _cx_apppakcomplete is null or 
		-- (_cx_apppakcomplete > DateAdd(d, 1,_CX_APPRCVD_1)) or _cx_apppakcomplete > DateAdd(d,1,_CX_APPRCVD_1) then  0
		-- else 1
	--  end AS countOK_Appcmplt
	--MC rule - Application IN < 3 weekdays  of Application Out -- 		
	CASE
		WHEN (dbo.DateAddWeekDay(3,_CX_APPSENT_1))< GETDATE() and _cx_apppakcomplete is null THEN '#FFFFCC'
    END AS AppcmpltColor,
    CASE
		WHEN _cx_apppakcomplete > DateAdd(d,3,_CX_APPSENT_1) THEN 'Red'
    END AS AppcmpltColor2,
    CASE
		WHEN DateAdd(d,3,_CX_APPSENT_1) < GETDATE() and _cx_apppakcomplete is null  
		OR (_cx_apppakcomplete > DateAdd(d,3,_CX_APPSENT_1)) THEN  1
		ELSE 0
    END AS count_Appcmplt,
    CASE
		WHEN DateAdd(d,3,_CX_APPSENT_1) < GETDATE() 
		AND _cx_apppakcomplete is null 
		OR (_cx_apppakcomplete > DateAdd(d,3,_CX_APPSENT_1)) 
		OR _cx_apppakcomplete is null THEN 0
		ELSE 1
    END AS countOK_Appcmplt,
    ld03._CX_UWCONDOSUB,
    ld03._CX_UWCONDOAPPR,
    _CX_4506TORDDTE,
    _CX_4506TRECDDTE

--LC rule -  Closing date < 10 Days from Lock expiration
FROM
	[grchilhq-sq-03].emdb.emdbuser.Loansummary ls  
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_01 ls01  ON ls.XrefId = ls01.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_02 ls02  on ls.XrefId = ls02.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_03 ls03  on ls.XrefId = ls03.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_04 ls04  on ls.XrefId = ls04.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_05 ls05  on ls.XrefId = ls05.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_10 ls10  on ls.XrefId = ls10.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_09 ls09  on ls.XrefId = ls09.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_17 ls17  on ls.XrefId = ls17.XrefId

	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_02 ln02  on ls.XrefId = ln02.XrefId 
	Inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_03 ln03  on ls.XrefId = ln03.XrefId 
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01  on ls.XrefId = ld01.XrefId 
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_02 ld02  on ls.XrefId = ld02.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_03 ld03  on ls.XrefId = ld03.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_04 ld04  on ls.XrefId = ld04.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_05 ld05  on ls.XrefId = ld05.XrefId
	left outer join chilhqpsql05.admin.corp.Employee e  on e.employeeId = ls03._CX_FINALOCODE_4
	--ls.loanofficerid
	--left outer join chilhqpsql05.admin.corp.employee empcorp on empcorp.employeeId = e.employeeid
	left outer join chilhqpsql05.admin.corp.costcenter cc  on cc.CostCenterID = e.costcenterid
	left outer join chilhqpsql05.admin.corp.Region r  ON r.regionID = cc.RegionID 
	left outer join chilhqpsql05.admin.corp.employeeandallmanagers2 dem  on dem.empid =  e.employeeId
	left outer join chilhqpsql05.admin.corp.employee empMC  on  empMC.encompasslogin  = rtrim(ltrim(LoanTeamMember_UserID_MortgageConsultant))
	left outer join chilhqpsql05.admin.corp.employee empLC   on empLC.encompasslogin  = rtrim(ltrim(LoanTeamMember_UserID_LoanCoordinator))
	left outer join chilhqpsql05.admin.corp.employee sa  on sa.employeeid = empmc.salesassistiantid
	left outer join chilhqpsql05.admin.corp.employee sb  on sb.employeeid = emplc.salesassistiantid
	left outer join chilhqpsql05.admin.corp.employee sc  on sc.employeeid = e.salesassistiantid
	left outer join [grchilhq-sq-03].emdb.reports.investor inv on inv.lockrate_2278 = ls09.lockrate_2278  
	--or 
	--sa.employeeid = empmc.salesassistiantid or
	--sa.employeeid = emplc.salesassistiantid)
WHERE 
	cc.costcenter IN (SELECT DATA FROM dbo.Split(@CostCenter, ','))
	AND (
		(@Options = 'locked'  and _761 >= '2001-01-01' and _762 > GETDATE()) OR
		(@Options = 'expire' and _762 < getdate()) OR
		
		(@Options = 'float' and  _761 is null) OR
		
		(@Options = 'all' and  _CX_FUNDDATE_1 is null) OR
		(@Options = 'purchase' and _19 = 'Purchase') OR
		(@Options = 'refinance' and _19 <> 'Purchase') Or
		
		(@Options = 'appNotReturned'   and _CX_APPSENT_1          > '2001-01-01' and _CX_APPRCVD_1 IS null) OR
		(@Options = 'aprslNotReceived' and _CX_APPRORDERTRANS_10 >  '2001-01-01' and _CX_APPRRECTRANS_10  IS Null) OR
		(@Options = 'expire3' and (dbo.DateDiffWeekDay(getdate(),_762)< 16)) OR
		(@Options = 'expire2' and (dbo.DateDiffWeekDay(getdate(),_762)< 11)) OR
		(@Options = 'expire1' and (dbo.DateDiffWeekDay(getdate(),_762)< 6)) OR
		(@options = 'notRedisclosed' and _761 > _3137) OR 
		(@Options = 'ctc' and _2305 >= '2001-01-01' and Log_MS_Lastcompleted <> 'Assign to Close')OR
		(@Options = 'UWapprvNotSubmit' and Log_MS_Date_UWDecisionExpected >= '2001-01-01' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) is null) OR
	    (@Options = 'DocSignNotfund' and _748 >= '2001-01-01' and _CX_FUNDDATE_1 is null) OR
	   
	   ((@Options = 'p2weeks' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(_CX_CLSSCHED_1,getdate()) < 11)) and 
		(@Options = 'p2weeks' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(_763,getdate()) < 11))) OR
						
	   ((@Options = 'p1week' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(getdate(),_CX_CLSSCHED_1) < 6)) OR 
		(@Options = 'p1week' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(getdate(),_763) < 6))) OR


		((@Options = 'notSubmittedUW' and (dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) < GETDATE()
									  and (dbo.DateAddWeekDay(1,_cx_apppakcomplete)) < GETDATE() 
									  and _761 is not null   --761 is lock date								 
		                              AND _19 like '%Refi%' and _2298 IS NULL)) or  --_2298 is UW submit date 
		 (@Options = 'notSubmittedUW' and (dbo.DateAddWeekDay(1,_cx_apppakcomplete)      ) < GETDATE() 
		                              and _19 =  'Purchase' and _2298 is null) OR
		--new MC Lane and LC Lane--
							
		(@Options = 'McLane' and  Log_MS_Lastcompleted in (	'Processing', 'Assigned to UW','Submittal')) OR
		(@Options = 'LcLane' and  Log_MS_Lastcompleted in (	'UW Decision Expected','Conditions Submitted to UW','Assign to Close')) OR				
		(@Options = 'MStarted' and Log_MS_Lastcompleted = 'Started') OR
		(@Options = 'Mprocessing' and Log_MS_Lastcompleted IN ('Processing', 'App Fee Collected')) OR
		
		(@Options = 'MassignedToUW' and Log_MS_Lastcompleted = 'Assigned to UW') OR
		(@Options = 'Msubmittal' and Log_MS_Lastcompleted = 'Submittal') OR
		(@Options = 'MUWExp' and Log_MS_Lastcompleted = 'UW Decision Expected') OR
		(@Options = 'McondSubUW' and Log_MS_Lastcompleted = 'Conditions Submitted to UW') OR
		(@Options = 'Mapproval' and Log_MS_Lastcompleted = 'Approval') OR
		(@Options = 'MassignToClose' and Log_MS_Lastcompleted = 'Assign to Close') OR
		(@Options = 'MdocSigning' and Log_MS_Lastcompleted = 'Doc Signing')
		 or
		
		(@Options = 'ltv' and ((_2303 > '2000-01-01' and 2301 is null)  or 
		(_CX_RESTRUCTUREDTI > '2001-01-01'  and _cx_restdticomplete <> 'Y')or 
		   (_CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y')))
		      --  and _2301 IS null) OR  -- Milestone-restructure
		--(@Options = 'ltv' and _2303 > '2000-01-01') 
		--2301 is und approval date
		--2303 is und suspended date
		
		
		or
		(@Options = 'contingency1' and (dbo.DateDiffWeekDay(getdate(),_CX_CONTINGE_1) < 6)) OR
		(@Options = 'contingency2' and (dbo.DateDiffWeekDay(getdate(),_CX_CONTINGE_1) < 13)) OR
		(@Options = 'LoansToDisclose' and ((Log_MS_Date_Processing > '2001-01-01')and _CX_APPSENT_1 is null)) OR
		
		(@Options = 'CondoSubmitted'  and _CX_UWCONDOSUB >= '2001-01-01' and   _CX_UWCONDOAPPR is null) OR
		(@Options = 'CondoApproved'  and _CX_UWCONDOAPPR >= '2001-01-01') OR
		
		(@Options = '4506TOrdered'  and _CX_4506TORDDTE >= '2001-01-01'	and   _CX_4506TRECDDTE is null) OR
		(@Options = '4506tReceived'  and _CX_4506TRECDDTE >= '2001-01-01' )  
		--(@Options = 'Brokered' and isnull(ls09.lockrate_2278,'') <> '' and ls09.LOCKRATE_2278 <> inv.lockrate_2278) OR
		--(@Options = 'Brokered' and _2626 = 'Brokered')
		)
	
	and 
		isnull(_CX_FUNDDATE_1,'') = ''
		 
	and   -- Allow Prequal addresses when the milestione is greater than 'started'
		address1 not like(
		case when Log_MS_Lastcompleted = 'Started' 
			then   'Prequal%' else ''
		end )
		
		
	 
	and _763 >= '2012-01-01'    -- est closing date
	and (loanFolder not in ('(Archive)','(Trash)',  'Closed Loans',
							 'Completed Loans','Samples','Adverse Loans', 'To Archive', 
							 'Adverse 1', 'Adverse 2', 'Adverse 3', 'Adverse 4', 'Adverse 5',
							  'Adverse 6', 'GRIOnline - Testing' ))
	and _1393 = 'Active Loan'
	-- and _420 <> 'Second Lien'	-- removed per matt harmon on 06/27/13
								 
								 --removed adverse loan folder as an exclusion - per mike d on 6/19/12.
								 --added _749 - change date to exclude adversed loans.
	-- *******************************************************************************
	-- Commented OUT @employee 
	-- *******************************************************************************
	--and 
	--	(  ---- get employee(s)
	--	(@GroupBy = 'MC' and 
	--		(rtrim(ltrim(LoanTeamMember_UserID_MortgageConsultant)) in 
	--			(select SPLITVALUES 
	--		from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,LoanTeamMember_UserID_MortgageConsultant), ','))))
			
	--	OR (@GroupBy = 'LC' AND 
	--		(rtrim(ltrim(LoanTeamMember_UserID_LoanCoordinator)) in 
	--			(select SPLITVALUES 
	--		from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, LoanTeamMember_UserID_LoanCoordinator), ','))))
			
	--	OR  (@GroupBy = 'VP' AND 
	--	(rtrim(ltrim(_CX_FINALOCODE_4))in 
	--			(select SPLITVALUES 
	--		from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,_CX_FINALOCODE_4), ','))))
			
					
	--	OR  (@GroupBy = 'PM' AND 
	--	(rtrim(ltrim(_cx_locode_1))in 
	--			(select SPLITVALUES 
	--		from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,_cx_locode_1), ','))))	
	--		    )
	-- *******************************************************************************
	-- *******************************************************************************	
	AND     -- get userid (logon)johne
		(@UserName in (e.Userlogin, empLC.userlogin, empmc.userlogin, sa.userlogin, sb.userlogin, sc.userlogin) --VP, LC, MC, each SA
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(dem.empid), ',')) --MGR
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(empMC.employeeid), ',')) --MGR
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(empLC.employeeid), ',')) --MGR
        OR
--Was this: @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.allmanagers(dem.empid), ',')) --MGR
		@UserName in ('alexanderm','amaloney','amargin','bconn','BMercer','cstackhouse','cmorgan','dkalinofski', 
		'dmoran','egarner','eyanaki','frankc','jatkocaitis','jpike','jpugh','jmorgan','KShattuck','kwoodruff', 
		'lauge','lbrictson','lmann','ltitiyevsky','mchaput','mdye','mhamer','mharmon','mkaufman','mknopf','mmunoz', 
		'mowen','nathanasiou','nejohnson','proos','pvandivier','rcorro','rjones','robs','romahoney','sbarcomb','slevitt',
		'smueller','sstephen','tgamache','tgrimm','tlangdon','ylopez','bcotta','mhayes'
		
		) 
		)

GO
