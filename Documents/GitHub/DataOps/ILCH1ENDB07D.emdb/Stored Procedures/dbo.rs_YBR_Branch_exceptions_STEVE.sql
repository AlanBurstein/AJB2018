SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[rs_YBR_Branch_exceptions_STEVE]

--@Branch int = null,
@UserName varchar(50),
@GroupBy varchar(10),
@Employee varchar(max) = null,
@Options varchar(max) 





as

/*	2012-06-19 03:01PM
	Just the Query Plan took 0:25...

	exec dbo.rs_YBR_Branch_exceptions_STEVE 'dgorman', 'VP', null ,'all'
	
	exec   dbo.rs_YBR_Branch_exceptions_STEVE 'bcarr', 'VP', 3179 ,'all'

Q1 EXEC cost 0 
Q2	Cost relative to the batch 100%
	Cost: 98,757.6
	
*/




--'UWapprvNotSubmit'  --'all'

Select

-------- ==========================================================================================
-------- Author:		Darlene Gorman	
-------- Create Date:	March 20, 2012
-------- Description:	used in SSRS 'YBR 2.1 - Branch' and YBR exception report
-------- ==========================================================================================
   --test = Case when (_CX_APPSENT_1 > '2001-01-01' and _CX_APPRCVD_1 IS null) then 'YES' else 'No' end,

--   distinct
    -- coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ),
    ls.loanofficerid,
    _761,
    _3137,
    case when _761 > _3137 then 'alert' end as checklockdisc,
    
    Case when isnull(rtrim(ltrim(_CX_LCNAME_1)),'') = '' then 'none' else isnull(rtrim(ltrim(_CX_LCNAME_1)),'') end as LCName,
	--empLC.userlogin as LClogon,  --- when using this- rows are duplicated by loan number
	--LoanTeamMember_UserID_LoanCoordinator,
	Case when isnull(rtrim(ltrim(_CX_MCNAME_1)),'') = '' then 'none' else isnull(rtrim(ltrim(_CX_MCNAME_1)),'') end as MCName,
	--empmc.userlogin as MClogon, --- when using this- rows are duplicated by loan number
	--LoanTeamMember_UserID_MortgageConsultant,
	--LoanTeamMember_Name_MortgageConsultant,
	_317 AS LicensedVP,
	--LoanTeamMember_UserID_LoanOfficer,
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

_cx_restltvcomplete,
_cx_restdticomplete,

--need restructure box field id  
--The resolution fields are: 
--The fields are CX.RESTLTVCOMPLETE and CX.RESTDTICOMPLETE. 
--Do not send it back to the assigned milestone when the date is taken out. 
--Please make sure this is the only way it gets assigned back in the pipeline. 
	
	CASE
	    WHEN (_2303 > '2000-01-01' or _CX_RESTRUCTUREDTI > '2001-01-01' or _CX_RESTLTVCOMPLETE > '2001-01-01')
	    and (_cx_restltvcomplete <> 'Y' and _cx_restdticomplete <> 'Y')     then 11  ---UW SUSPENDED
		WHEN Log_MS_Lastcompleted = 'Started' then 1
		WHEN Log_MS_Lastcompleted IN ('Processing', 'App Fee Collected') then  2
		--WHEN Log_MS_Lastcompleted = 'App Fee Collected' then 3
		WHEN Log_MS_Lastcompleted = 'Assigned to UW' then 4
		WHEN Log_MS_Lastcompleted = 'Submittal' then 5
		WHEN Log_MS_Lastcompleted = 'UW Decision Expected' then 6
		WHEN Log_MS_Lastcompleted = 'Conditions Submitted to UW' then 7
		WHEN Log_MS_Lastcompleted = 'Approval' then 8
		WHEN Log_MS_Lastcompleted = 'Assign to Close' then 9
		WHEN Log_MS_Lastcompleted = 'Doc Signing' then 10
	end as MilestoneOrder,

	Case
		 WHEN (_2303 > '2000-01-01' or _CX_RESTRUCTUREDTI > '2001-01-01' or _CX_RESTLTVCOMPLETE > '2001-01-01')
	    and (_cx_restltvcomplete <> 'Y' and _cx_restdticomplete <> 'Y')  then 'RESTRUCTURE – LTV, DTI or UW SUSPENSE' 
	    when Log_MS_Lastcompleted = 'App Fee Collected' then 'Processing'
	    else Log_MS_Lastcompleted
	END  AS PrevMilestoneGroup,
	
	_4000 AS FirstName,
	_4002 as LastName,
	
	CASE
		when _19  = 'Purchase' then 'Purchase' 
		when _19  = 'NoCash-Out Refinance' then 'NO C/O Refi'
		when _19  = 'Cash-Out Refinance' then 'C/O Refi'
	END as LoanPurpose, 
		
	Case 
		when _1041 = 'Condominium' then 'Condo'
		else _1041 
	End as  PropertyType,
	
	Case 
	  when _CX_SECINVESTOR_10 = 'Chase Manhattan Mortgage Corporation' then 'Chase Manhattan MC' 	  
	  when _CX_SECINVESTOR_10 = 'U.S. Bank Home Mortgage' then 'US Bank Home Mtg'
	  else _CX_SECINVESTOR_10   
	END as Investor,
	
	LoanAmount,
	_428 as SecondLoanAmount,
	_745 as OrigDate,
	_761 as LockDate,
--SC rule - when LockDate greater than app date - note by color
	CASE
		when _761 > _CX_APPSENT_1 then 'Red'
	END as LockAfterAppColor,
	CASE
		when _761 > _CX_APPSENT_1 then 1
		else 0
	END as Count_LockkAfterApp,
	CASE
		when _761 > _CX_APPSENT_1 then 0
		else 1
	END as CountOK_LockkAfterApp,
	
--SC/VP rule -  when lockDate > 2 days of Orig 
		--#DB7093 is pale red  -- 745 is app date  --761 is lock date #FFE4E1 lt pink
	CASE 
		when  _761 is null and (_CX_APPRAISALRCVD_1 > '2001-01-01') 
		                   and ( _CX_APPRORDERTRANS_10 > '2001-01-01')
		                    and (_19 <> 'Purchase') then '#FFE4E1'
		when (dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null then '#FFFFCC'
		
	END as LockColor,
	
	
	CASE 
		when  _761 > (dbo.DateAddWeekDay(2,_745)) then 'Red'
	END as LockColor2,
	
	CASE 
		when ((dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null ) Or 
		  (_761 > (dbo.DateAddWeekDay(2,_745))) then 1
		else 0
	END as count_Lock,
	CASE 
		when ((dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null ) Or 
		  (_761 > (dbo.DateAddWeekDay(2,_745))) then 0
		else 1
	END as countOK_Lock,
			
	
	_CX_CLSSCHED_1 as schdldClose,
    _763 as estClose,
     
--SC/VP rule -  when send to Proc > 2 days of orig
	CASE 
		when (dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null then '#FFFFCC'
	END as SendProcColor,
	CASE 
		when  Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745)) then 'Red'
	END as SendProcColor2,
	CASE 
		when ((dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null)  
		OR (Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745)))then 1
		else 0
	END as count_SendProc,
	CASE 
		when ((dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null)  
		OR (Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745)))then 0
		else 1
	END as countOK_SendProc,
	

	Log_MS_Date_Processing as SentToProc,
--changed from same day to 1 day after per mike dye on 5/24/2012	
----SC/VP/MC rule - Application OUT > Same Day of Send to Processing ( 1 day after)		

	CASE	
	--	when 	Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL THEN '#FFFFCC'
	--END AS AppOutColor,
	when (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null then '#FFFFCC'
    END AS AppOutColor, 
    
	
	CASE	
	--	when   _CX_APPSENT_1 > Log_MS_Date_Processing THEN 'Red'
	--END AS AppOutColor2	,
		when _CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) then 'Red'
	END AS AppOutColor2, 
	
	CASE	
	--	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	--	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 1
	--	else 0 
	--END AS count_AppOut,
		when ((dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null) or
	  (_CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing))) then 1 else 0
	 END AS count_AppOut, 
	
	CASE	
	--	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	--	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 0
	--	else 1 
	--END AS countOK_AppOut,
		when ((dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null) or
	  (_CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing))) then 0 else 1
	 END AS countOK_AppOut, 
		
	
	_CX_APPSENT_1 as AppOut,
	_CX_APPRCVD_1 as AppIn,
	
	
	
	

--MC rule - Application IN < 48 hours of Application Out -- use all days including weekends--		
	CASE
		when (dbo.DateAddWeekDay(2,_CX_APPSENT_1))< GETDATE() and _CX_APPRCVD_1 is null then '#FFFFCC'
    end AS AppInColor,
    CASE
		when _CX_APPRCVD_1 > DateAdd(d,2,_CX_APPSENT_1) then 'Red'
    end AS AppInColor2,
    CASE
		when DateAdd(d,2,_CX_APPSENT_1) < GETDATE() and _CX_APPRCVD_1 is null  or 
		 (_CX_APPRCVD_1 > DateAdd(d,2,_CX_APPSENT_1)) then  1
		 else 0
    end AS count_AppIn,
    CASE
		when DateAdd(d,2,_CX_APPSENT_1) < GETDATE() and _CX_APPRCVD_1 is null or 
		 (_CX_APPRCVD_1 > DateAdd(d, 2,_CX_APPSENT_1)) then  0
		 else 1
    end AS countOK_AppIn,
    

  
    
    
--MC rule -  appraisal ordered > same day of send to processing	
	CASE 
		when _CX_APPRAISALREQ <> 'No' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null then '#FFFFCC'
	END as AprslOrdColor,
	CASE 
		when _CX_APPRAISALREQ <> 'No' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing then 'Red'
	END as AprslOrdColor2,
	CASE 
		when _CX_APPRAISALREQ <> 'No' and (Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) or
		 _CX_APPRAISALREQ <> 'No' and (Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing)
		 then 1 else 0
	END as Count_AprslOrd,
	CASE 
		when (_CX_APPRAISALREQ <> 'No' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) or
		 (_CX_APPRAISALREQ <> 'No' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing)
		 then 0 else 1
	END as CountOK_AprslOrd,
    
--MC rule -  appraisal Received(IN) > 7 Days of Appraisal Order Date
    CASE 
		when _CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(7,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null then '#FFFFCC'
    end AS AprslRecColor,
    CASE 
		when _CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(7,_CX_APPRORDERTRANS_10))then 'Red'
    end AS AprslRecColor2, 
    CASE 
		when (_CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(7,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null) or
		  (_CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(7,_CX_APPRORDERTRANS_10))) then 1 else 0
    end AS Count_AprslRec,
    CASE 
		when (_CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(7,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null) or
		  (_CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(7,_CX_APPRORDERTRANS_10))) then 0 else 1
    end AS CountOK_AprslRec,
	 
	case when _CX_APPRAISALREQ = 'No' then 'N/A'
	else convert(varchar(8),_CX_APPRORDERTRANS_10,1) end as AppraisalOrdered,	 
   	
	 case when _CX_APPRAISALREQ = 'No' then 'N/A'
	else convert(varchar(8),_CX_APPRRECTRANS_10,1) end as   AppraisalRec,
	
--MC rule -  title Ordered > same day of Send to Processing	
	 CASE	
		when 	Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL THEN '#FFFFCC'
	END AS TitleOrdColor,
	CASE	
		when   _CX_TITLEORDER_1 > Log_MS_Date_Processing THEN 'Red'
	END AS TitleOrdColor2,
	 CASE	
		when 	(Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL) or 
		 (  _CX_TITLEORDER_1 > Log_MS_Date_Processing ) then 1 else 0
	END AS count_TitleOrd,
	 CASE	
		when 	(Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL) or 
		 (  _CX_TITLEORDER_1 > Log_MS_Date_Processing ) then 0 else 1
	END AS countOK_TitleOrd,
	
--MC rule -  title IN > 7 days of order date
   CASE 
		when (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null then '#FFFFCC'
    END AS TitleInColor, 
    CASE 
		when _CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) then 'Red'
	END AS TitleInColor2, 
	 CASE 
		when ((dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null) or
	  (_CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1))) then 1 else 0
	 END AS Count_TitleIn, 
	  CASE 
		when ((dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null) or
	  (_CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1))) then 0 else 1
	 END AS CountOK_TitleIn, 
	
	_CX_TITLEORDER_1 as TitleOrdered,
	_CX_TITLERCVD_1 AS TitleReceived,

--MC rule -  UWApproval > 5 days after Submission to UW
	CASE	
		when(dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL THEN '#FFFFCC'
	END AS UWApprovalColor,
	CASE	
		when _2301 > (dbo.DateAddWeekDay(5,_2298)) then 'Red'
	END AS UWApprovalColor2,
	CASE	
		when((dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL) or
		( _2301 > (dbo.DateAddWeekDay(5,_2298))) then 1 else 0
	END AS count_UWApproval,
	CASE	
		when((dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL) or
		( _2301 > (dbo.DateAddWeekDay(5,_2298))) then 0 else 1
	END AS countOK_UWApproval,
	
	_2298  as UWSubmitted,
	_2301 as UWApproval,
	---   _CX_APPRRECTRANS_10  appraisal recvd
	---  _CX_APPRCVD_1           application recvd
	
--MC rule -  UWSubmission for REFI  > 1 day of appraisal in
--        -  UWSubmission for PURCH > 1 day of application in	
	CASE	
		when  (_CX_APPRRECTRANS_10 > '2001-01-01' and (dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) < GETDATE() AND _19 like '%Refi%' and _2298 IS NULL) or
		      (_CX_APPRRECTRANS_10 > '2001-01-01' and(dbo.DateAddWeekDay(1,_CX_APPRCVD_1))       < GETDATE() and  _19 = 'Purchase' and _2298 is null) then '#FFFFCC'
	END AS UWSubmissionColor,
	CASE	
		when (_2298 > (dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) AND _19 like '%Refi%') OR
		     (_2298 > (dbo.DateAddWeekDay(1,_CX_APPRCVD_1))       AND _19  = 'Purchase')THEN 'Red'
	END AS UWSubmissionColor2,
	CASE	
		when  (((dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) < GETDATE() AND _19 like '%Refi%' and _2298 IS NULL)) or
		      ((dbo.DateAddWeekDay(1,_CX_APPRCVD_1))       < GETDATE() and  _19 = 'Purchase' and _2298 is null)  or
		      (_2298 > (dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) AND _19 like '%Refi%') OR
		     (_2298 > (dbo.DateAddWeekDay(1,_CX_APPRCVD_1))       AND _19  = 'Purchase') then 1 else 0
	END AS Count_UWSubmission,
	CASE	
		when  (((dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) < GETDATE() AND _19 like '%Refi%' and _2298 IS NULL)) or
		      ((dbo.DateAddWeekDay(1,_CX_APPRCVD_1))       < GETDATE() and  _19 = 'Purchase' and _2298 is null)  or
		      (_2298 > (dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) AND _19 like '%Refi%') OR
		     (_2298 > (dbo.DateAddWeekDay(1,_CX_APPRCVD_1))       AND _19  = 'Purchase') then 0 else 1
	END AS CountOK_UWSubmission,
	
	
	_2305 AS UWCTC,
	Case
		when  _748 > '2001-01-01' then _748
		when 	_CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763
	END as EstClosingDate, 
		
	_762 as LockExpiration,
	Address1,

	
--LC rule -  Condition Submission  > 2 Days after Approval Date From UW
	CASE	
		when  ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
		  ((dbo.DateAddWeekDay(3,_2301) < GETDATE()) AND r.region <> 'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) THEN '#FFFFCC'
	end AS CondSubmitColor,
	CASE	
		when ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))AND r.region =  'Online') or
		 (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(3,_2301))AND r.region <> 'Online') then 'Red'
	end AS CondSubmitColor2,
	CASE	
		when ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
		  ((dbo.DateAddWeekDay(3,_2301) < GETDATE()) AND r.region <> 'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) OR 
		  ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))AND r.region =  'Online') or
		  (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(3,_2301))AND r.region <> 'Online') then 1 else 0
	end AS Count_CondSubmit,
	CASE	
		when ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
		  ((dbo.DateAddWeekDay(3,_2301) < GETDATE()) AND r.region <> 'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) OR 
		  ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))AND r.region =  'Online') or
		  (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(3,_2301))AND r.region <> 'Online') then 0 else 1
	end AS CountOK_CondSubmit,

--LC rule -  CTC  > 2 Days after Conditions submitted to UW
		  -- or	Purch: < 6 days from Contigency Date 
		   --or Refi Primary < 10 days from Lock expiration
		   --or Refi 3nd or inv < 6 days from Lock expiration
		   --or purchase < 6 dayd from extimated/scheduled close date
		   --    _2305 = UWCTC    _CX_CONTINGE_1 = contigency Date
	CASE	
		when  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
		      (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) )
	    THEN '#FFFFCC'
	END AS CTCColor,
	
	CASE	
		when  (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
		      ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase'))OR 
		      ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
			  ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
              ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
        then 'Red'
	END AS CTCColor2,
	
	CASE	
		when  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
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
	END AS Count_CTC,
	CASE	
		when  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
		      (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) ) or
		      (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
		      ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase') )OR 
		      ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
			  ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
              ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
	    THEN 0 else 1
	END AS CountOK_CTC,
	
			
	_2303 AS UWSuspended,
	Log_MS_Date_DocsSigning as DocsSigned,
    coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) as CondSubmit,
    _1811 as proptype,
    e.titleid ,
  Log_MS_Lastcompleted,
    dbo.allmanagers(e.employeeId) as MGRLogin
  
 

	
    
    
--LC rule -  Closing date < 10 Days from Lock expiration
  
    

from
	[grchilhq-sq-03].emdb.emdbuser.Loansummary ls  
	
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_01 ls01 ON  ls.XrefId = ls01.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_02 ls02  on ls.XrefId = ls02.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_03 ls03  on ls.XrefId = ls03.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_04 ls04   on ls.XrefId = ls04.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_05 ls05  on ls.XrefId = ls05.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_10 ls10  on ls.XrefId = ls10.XrefId

	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_02 ln02  on ls.XrefId = ln02.XrefId 
	Inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_03 ln03  on ls.XrefId = ln03.XrefId 
	
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01  on ls.XrefId = ld01.XrefId 
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_02 ld02  on ls.XrefId = ld02.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_03 ld03  on ls.XrefId = ld03.XrefId
	inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_04 ld04  on ls.XrefId = ld04.XrefId
	
	left outer join chilhqpsql05.admin.corp.Employee e  on e.employeeId = ls03._CX_FINALOCODE_4
	--ls.loanofficerid
	--left outer join chilhqpsql05.admin.corp.employee empcorp on empcorp.employeeId = e.employeeid
	left outer join chilhqpsql05.admin.corp.costcenter cc  on cc.CostCenterID = e.costcenterid
	left outer join chilhqpsql05.admin.corp.Region r  ON r.regionID = cc.RegionID 
	left outer join chilhqpsql05.admin.corp.employeeandmanager dem  on dem.empid =  e.employeeId
	left outer join chilhqpsql05.admin.corp.employee empMC  on empMC.displayname  = rtrim(ltrim(_CX_MCNAME_1))
	left outer join chilhqpsql05.admin.corp.employee empLC   on empLC.displayname  = rtrim(ltrim(_CX_LCNAME_1))
	
	/*
	
	ls03._CX_FINALOCODE_4 as pdVPcode,
	ls03._CX_MCNAME_1
	ls03._CX_LCNAME_1
	ls03._CX_FINALOCODE_4
	
	
	
	where OR  (@GroupBy = 'VP' AND 
		(rtrim(ltrim(_CX_FINALOCODE_4))in 
				(select SPLITVALUES 
			from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,_CX_FINALOCODE_4), ','))))
	
	
	
*/	
	
where 
		(
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
									  and (dbo.DateAddWeekDay(1,_CX_APPRCVD_1)) < GETDATE() 
									  and _761 is null   --761 is lock date								 
		                              AND _19 like '%Refi%' and _2298 IS NULL)) or  --_2298 is UW submit date 
		 (@Options = 'notSubmittedUW' and (dbo.DateAddWeekDay(1,_CX_APPRCVD_1)      ) < GETDATE() 
		                              and _19 =  'Purchase' and _2298 is null) OR
							
							
		(@Options = 'MStarted' and Log_MS_Lastcompleted = 'Started') OR
		(@Options = 'Mprocessing' and Log_MS_Lastcompleted = 'Processing') OR
		(@Options = 'Mprocessing' and Log_MS_Lastcompleted = 'App Fee Collected') OR
		(@Options = 'MassignedToUW' and Log_MS_Lastcompleted = 'Assigned to UW') OR
		(@Options = 'Msubmittal' and Log_MS_Lastcompleted = 'Submittal') OR
		(@Options = 'MUWExp' and Log_MS_Lastcompleted = 'UW Decision Expected') OR
		(@Options = 'McondSubUW' and Log_MS_Lastcompleted = 'Conditions Submitted to UW') OR
		(@Options = 'Mapproval' and Log_MS_Lastcompleted = 'Approval') OR
		(@Options = 'MassignToClose' and Log_MS_Lastcompleted = 'Assign to Close') OR
		(@Options = 'MdocSigning' and Log_MS_Lastcompleted = 'Doc Signing') or
		(@Options = 'ltv' and _2303 > '2000-01-01') or
		(@Options = 'contingency1' and (dbo.DateDiffWeekDay(getdate(),_CX_CONTINGE_1) < 6)) OR
		(@Options = 'contingency2' and (dbo.DateDiffWeekDay(getdate(),_CX_CONTINGE_1) < 13)) OR
		(@Options = 'LoansToDisclose' and ((Log_MS_Date_Processing > '2001-01-01')and _CX_APPSENT_1 is null))
		)
and 
		_CX_FUNDDATE_1 is null 
		and Address1 not like 'Prequal%'
		and _763 >= '2012-01-01'    -- est closing date
		and loanFolder not in ('(Archive)','(Trash)', 'Adverse Loans', 'Closed Loans',
								 'Completed Loans','Samples')
	
	--and 
	--		(costcenter in 
	--			(select SPLITVALUES 
	--		from emdb.dbo.DelimitedListToIntTableVariable(isnull(@Branch,costcenter), ',')))
			
	and 
		(  ---- get employee(s)
		(@GroupBy = 'MC' and 
			(rtrim(ltrim(_CX_MCNAME_1)) in 
				(select SPLITVALUES 
			from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,_CX_MCNAME_1), ','))))
			
		OR (@GroupBy = 'LC' AND 
			(rtrim(ltrim(_CX_LCNAME_1)) in 
				(select SPLITVALUES 
			from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, _CX_LCNAME_1), ','))))
			
		OR  (@GroupBy = 'VP' AND 
		(rtrim(ltrim(_CX_FINALOCODE_4))in 
				(select SPLITVALUES 
			from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,_CX_FINALOCODE_4), ','))))
	    )
		
	and     -- get userid (logon)johne
		( 
		@UserName in (e.Userlogin, empLC.userlogin, empmc.userlogin) --VP, LC, MC
		  or
		@UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.allmanagers(dem.empid), ',')) --MGR
		  or
		@UserName in ('dgorman','dkalinofski', 'abisharat', 'amaloney', 'andrewc','dmoran', 'amargin', 'frankc', 'johne', 'mknopf' , 'bconn', 'jweaver','robs',
		'mdye', 'nathanasiou', 'rjones', 'sstephen', 'slevitt', 'tgrimm', 'kswanseen', 'tshultz','mpatterson', 'sives','scors','mpotter', 'ecconley', 'ghafner' ) 
		)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	 --OR   SUBSTRING(system_user, CHARINDEX('\', system_user) + 1,LEN(system_user)) = e.userlogin and 
		--		e.userlogin in 
		--		(select SPLITVALUES 
		--	 from dbo.DelimitedListToVarcharTableVariable(isnull(system_user,e.userlogin), ','))   
		
	
	--system_user = e.UserLogin
	
	 
	
	-- (
	-- SUBSTRING(system_user, CHARINDEX('\', system_user) + 1,LEN(system_user)) = MgrLogin
	--or 
	-- SUBSTRING(system_user, CHARINDEX('\', system_user) + 1,LEN(system_user)) = e.UserLogin
	-- (Case when e.userlogin = 'dbamonte'  then 'dgorman'
	--else e.UserLogin end)   
	
	    
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--select SUBSTRING(system_user, CHARINDEX('\', system_user) + 1,LEN(system_user)) test sys user
	
	
	
	
--	AND  @Options = case when @Options  is not null then  @Options end
	 
	 
	 ----in 	 (select 
	 -- Case  
		--when  @GroupBy in ('MC','LC','VP') and @Options = 'locked'
		--	then  'x _761 is not null  x'
		--when  @GroupBy in ('MC','LC','VP') and @Options = 'float'
		--	then 'x _761 is null x'
		--when  @GroupBy in ('MC','LC','VP') and @Options = 'purchase'
		--	then 'x _19  = 'Purchase' x'
		--when  @GroupBy in ('MC','LC','VP') and @Options = 'refinance'
		--	then 'x _19 <> 'Purchase' x'		
			
		--	END 
		--	from 
		--		emdb.emdbuser.Loansummary ls
		--			inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
		--			inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
		--			inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
		--			inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
		--			inner join emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId

		--			inner join emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
		--			Inner join emdb.emdbuser.LOANXDB_N_03 ln03 on ls.XrefId = ln03.XrefId 
					
		--			inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
		--			inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
		--			inner join emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
		--			inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId
		--			)
					
	
	--order by Log_MS_Lastcompleted
	
	
	
	-- DateDiff(dd, @start, @end) - DateDiff(ww, @start, @end)*2 - 
     -- (select count(*) from holidays where holiday_date between @start and @end)
  --select * from emdbuser.LegalHolidays
	






GO
