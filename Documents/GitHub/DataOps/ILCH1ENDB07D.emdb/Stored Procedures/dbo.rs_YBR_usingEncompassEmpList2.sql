SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[rs_YBR_usingEncompassEmpList2] 
	--@Branch int = null,
	@UserName varchar(max),
	@GroupBy varchar(10),
	@Employee varchar(max) = null,
	@Options varchar(max) 
AS
--exec dbo.[rs_YBR_usingEncompassEmpList_testprequal] 'dgorman', 'MC', 'cathyj' ,'all'
--exec dbo.rs_YBR_usingEncompassEmpList 'dgorman', 'vp',2113 ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'dgorman', MC', 6088 ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'dgorman', 'LC', 'Julissa Eusebio' ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'mortiz', 'LC', 'Julissa Eusebio' ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg_VPPM 'mortiz', 'MC', 'Suzanne Dzolan' ,'all'
--exec dbo.rs_YBR_Branch_exceptions_testdg 'mcohn', 'LC', 'Heidi Selteneck' ,'all'

-------- ==========================================================================================
-------- Author:		Robert Corro	
-------- Create Date:	7/2014
-------- Description:	Rewrote YBR stored procedure using LoanWarehouse
-------- ==========================================================================================
-------- ==========================================================================================
-------- Modifications:
-------- Name				Date				Modification
-------- rcorro				9/3/2014			Sonya request, add Condo/PUD Approval Submitted (CX.UW.CONDOSUB) and Condo/PUD Approval Issued (CX.UWCONDOAPPR)
-------- rcorro				9/15/2014			Added _cx_brkapprove_12 as BrokeredApproval, this is needed, when the loan is brokered, UWApproval displays BrokeredApproval instead of UWApproval
-------- rcorro				12/2/2014			Added ltrout to the all access list
-------- ==========================================================================================
   --test = Case when (_CX_APPSENT_1 > '2001-01-01' and _CX_APPRCVD_1 IS null) then 'YES' else 'No' end,
   
   
--DECLARE @UserName varchar(max)
--DECLARE @GroupBy varchar(10)
--DECLARE @Employee varchar(max)
--DECLARE @Options varchar(max)   

--SET @UserName = 'rcorro'
--SET @GroupBy = 'MC'
--SET @Employee = 'ahunt'
--SET @Options = 'all'   
   
SELECT DISTINCT
	ISNULL(ligi.StreetAddress, 'PREQUALIFIED') AS Address1,
	lf.FundedDate as_CX_FUNDDATE_1,
    -- coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ),
	eilo.EmployeeID as loanofficerid,
    fld.EstimatedClosingDate as _763,
    ls.LoanStatusName AS _1393,
    llp.DisplayLoanLienPositionName AS _420,
    ligi.StreetAddress AS _11,
	-- 761, 3137 and checklockdisk do not seem to be used in the YBR Report
    -- _761,
    -- _3137,
    -- case when _761 > _3137 then 'alert' end as checklockdisc,
    
    --Case when isnull(rtrim(ltrim(LoanTeamMember_Name_LoanCoordinator)),'') = '' then _CX_LCNAME_1 
    --else isnull(rtrim(ltrim(LoanTeamMember_Name_LoanCoordinator)),'') end as LCName,
	eilc.EmployeeName as  LCName,
	--empLC.userlogin as LClogon,  --- when using this- rows are duplicated by loan number
	--_CX_LCNAME_1,
	eilc.UserLogin AS LoanTeamMember_UserID_LoanCoordinator,
	--Case when isnull(rtrim(ltrim(LoanTeamMember_Name_MortgageConsultant)),'') = '' then _CX_MCNAME_1
	--else isnull(rtrim(ltrim(LoanTeamMember_Name_MortgageConsultant)),'') end as MCName,
	eimc.EmployeeName as  MCName,
	-- _CX_MCNAME_1,
	--empmc.userlogin as MClogon, --- when using this- rows are duplicated by loan number
	eimc.UserLogin as LoanTeamMember_UserID_MortgageConsultant,
	--LoanTeamMember_Name_MortgageConsultant,
	eilo.EmployeeName AS LicensedVP,
	--LoanTeamMember_UserID_LoanOfficer,1
	--LoanTeamMember_Email_LoanOfficer,
	--_CX_PAIDLO_3 AS VP,
	eilo.EmployeeName AS VP,
	--e.displayname AS VP, --use this for Paid VP 
	--_CX_FINALOCODE_4 as pdVPcode,
	eilo.employeeId as pdVPCode,
	--e.UserLogin as pdVPlogin,
	eilo.UserLogin as pdVPlogin,

	--dbo.DateDiffWeekDay(getdate(),_762) as daysLocked, changed to days diff per mike
	--DATEDIFF(d,getdate(),_762) as daysLocked,
	DATEDIFF(d,getdate(), fld.LockExpirationDate) as daysLocked,
	getdate() as compareDate,
	r.SalesRegionName AS region,
	cc.costcenter, 
	cc.costcentername,	
	--ls.LoanFolder,
	dli.LoanFolder as LoanFolder,
	--LoanOfficer not used in report -rc
	--_CX_PAIDLO_3 AS LoanOfficer,
	--_364 as LoanNumber,
	dli.LoanNumber as LoanNumber,
	--_CX_CONTINGE_1,
	fld.ContingencyDate as _CX_CONTINGE_1,
	--_CX_RESTRUCTUREDTI not used in report -rc 6/6/2014
	--_CX_RESTRUCTUREDTI ,
	--_CX_RESTRUCTURELTV not used in report -rc 6/6/2014
	--_CX_RESTRUCTURELTV,
	--_cx_restltvcomplete not used in report -rc 6/6/2014
	--_cx_restltvcomplete,
	--_cx_restdticomplete not used in report -rc 6/6/2014
	--_cx_restdticomplete,

	--need restructure box field id  
	--The resolution fields are: 
	--The fields are CX.RESTLTVCOMPLETE and CX.RESTDTICOMPLETE. 
	--Do not send it back to the assigned milestone when the date is taken out. 
	--Please make sure this is the only way it gets assigned back in the pipeline. 
	--_2303 AS UWSuspended,
	--_2301 as UWApproval,	
	--Log_MS_Lastcompleted,
	--_2301,
	fld.UnderwritingApprovalDate as _2301,
	--_2303,
	fld.UnderwritingSuspendedDate as _2303,
    --_2626 ,---<> 'Brokered'
	ct.ChannelTypeName as _2626,
	
	--_Milestone Order is calculated in the loading process of the loan warehouse  -rc 6/6/2014
	-- CASE      --find brokered loans first
		 -- WHEN   _2626 = 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 <> inv.lockrate_2278)
		 -- then 11
		
		 -- WHEN ((_2303 > '2000-01-01' and _2301 is null 
			-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 = inv.lockrate_2278)))  
			-- or 
			-- (_CX_RESTRUCTUREDTI > '2001-01-01'  and _cx_restdticomplete <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			-- or 
			-- (_CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			-- or 
			-- (_CX_CX_RESTRUCTUREASSET > '2001-01-01' and _CX_RESTRUCTUREASSETCOMPLETE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			-- or 
			-- (_CX_RESTRUCTUREPROPERTY > '2001-01-01' and _CX_RESTRUCTUREPROPERTYCOMPLE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))		
			-- )

		 -- then 12  ---UW SUSPENDED
		 
		-- WHEN Log_MS_Lastcompleted = 'Started' 
			-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 = inv.lockrate_2278))
		-- then 1
		
		-- WHEN 
			-- (Log_MS_Lastcompleted  = 'Processing'
			   -- and _CX_RESTRUCTUREDTI < '2001-01-01' 
			   -- and _CX_RESTRUCTURELTV < '2001-01-01'
						   
			   -- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			   -- and ls09.lockrate_2278 = inv.lockrate_2278))) 
			-- or 
			-- (Log_MS_Lastcompleted = 'App Fee Collected' 
			   -- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			   -- and ls09.lockrate_2278 = inv.lockrate_2278))) 
		-- then 2
			
				-- --WHEN Log_MS_Lastcompleted = 'App Fee Collected' then 3
		-- WHEN Log_MS_Lastcompleted = 'Assigned to UW' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278))
		-- then 4
		
		-- WHEN Log_MS_Lastcompleted = 'Submittal' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 5
		
		-- WHEN Log_MS_Lastcompleted = 'UW Decision Expected'  
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 6
		
		-- WHEN Log_MS_Lastcompleted = 'Conditions Submitted to UW' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 7
		
		-- WHEN Log_MS_Lastcompleted = 'Approval' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 8
		
		-- WHEN Log_MS_Lastcompleted = 'Assign to Close'
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278))  
		-- then 9
		
		-- WHEN Log_MS_Lastcompleted in ( 'Doc Signing', 'Docs Signing' )
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 10

		-- when Log_MS_Lastcompleted IN ('Funding', 'Shipping') then 12
		-- else 2
	-- END as MilestoneOrder,
	lm.SortOrder as MilestoneOrder,
	--_PrevMilestoneGroup is calculated in the loading process of the loan warehouse  -rc 6/6/2014
	-- CASE      --find brokered loans first
		 -- WHEN   _2626 = 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 <> inv.lockrate_2278)
		 -- then 'Brokered'
		
		 -- WHEN ((_2303 > '2000-01-01' and _2301 is null 
			-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 = inv.lockrate_2278)))  
			-- or 
			-- (_CX_RESTRUCTUREDTI > '2001-01-01'  and _cx_restdticomplete <> 'Y' 
			-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 = inv.lockrate_2278)))
			-- or 
			-- (_CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y' 
			-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 = inv.lockrate_2278)))
			-- or 
			-- (_CX_CX_RESTRUCTUREASSET > '2001-01-01' and _CX_RESTRUCTUREASSETCOMPLETE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))
			-- or 
			-- (_CX_RESTRUCTUREPROPERTY > '2001-01-01' and _CX_RESTRUCTUREPROPERTYCOMPLE <> 'Y' and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' and ls09.lockrate_2278 = inv.lockrate_2278)))		
			-- )
		 -- then 'RESTRUCTURE – LTV, DTI or UW SUSPENSE'
		 
		-- WHEN Log_MS_Lastcompleted = 'Started' 
			-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			-- and ls09.lockrate_2278 = inv.lockrate_2278))
		-- then 'Started'
		
		-- WHEN 
			-- (Log_MS_Lastcompleted  = 'Processing'
			   -- and _CX_RESTRUCTUREDTI < '2001-01-01' 
			   -- and _CX_RESTRUCTURELTV < '2001-01-01'
						   
			   -- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			   -- and ls09.lockrate_2278 = inv.lockrate_2278))) 
			-- or 
			-- (Log_MS_Lastcompleted = 'App Fee Collected' 
			   -- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
			   -- and ls09.lockrate_2278 = inv.lockrate_2278))) 
		-- then 'Processing'
			
				-- --WHEN Log_MS_Lastcompleted = 'App Fee Collected' then 3
		-- WHEN Log_MS_Lastcompleted = 'Assigned to UW' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278))
		-- then 'Assigned to Underwriting Department'	
		
		-- WHEN Log_MS_Lastcompleted = 'Submittal' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 'Submitted to an Underwriter'
		
		-- WHEN Log_MS_Lastcompleted = 'UW Decision Expected'  
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		 -- then 'Underwriting Decision Issued'
		
		-- WHEN Log_MS_Lastcompleted = 'Conditions Submitted to UW' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 'Conditions Submitted to UW'
		
		-- WHEN Log_MS_Lastcompleted = 'Approval' 
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 'Final Approval/CTC'
		
		-- WHEN Log_MS_Lastcompleted = 'Assign to Close'
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278))  
		-- then 'Assigned to Closing'
		
		-- WHEN Log_MS_Lastcompleted in ( 'Doc Signing', 'Docs Signing' )
				-- and ( _2626 <> 'Brokered' or (isnull(ls09.lockrate_2278,'') <> '' 
				-- and ls09.lockrate_2278 = inv.lockrate_2278)) 
		-- then 'Doc Signing'
						-- --when Log_MS_Lastcompleted IN ('Funding', 'Shipping') then 12
		-- else  Log_MS_Lastcompleted
	-- END  AS PrevMilestoneGroup,
	lmg.LoanMilestoneGroupName AS PrevMilestoneGroup,
 	  
	--_4000 AS FirstName,
	bi.BorrowerFirstName AS FirstName,
	--_4002 as LastName,
	bi.BorrowerLastName AS LastName,
	
	--LoanPurpose is calculated in the loading process of the loan warehouse  -rc 6/6/2014
	-- CASE
		-- when _19  = 'Purchase' then 'Purchase' 
		-- when _19  = 'NoCash-Out Refinance' then 'NO C/O Refi'
		-- when _19  = 'Cash-Out Refinance' then 'C/O Refi'
	-- END as LoanPurpose, 
	lp.DisplayLoanPurposeName as LoanPurpose,
		
	Case 
		when pt.DisplayPropertyTypeName = 'Condominium' then 'Condo'
		else pt.DisplayPropertyTypeName 
	End as  PropertyType,
	
	-- Case 
		-- when _1041 = 'Condominium' then 'Condo'
		-- else _1041 
	-- End as  PropertyType,
	
	--Case 
	--  when _CX_SECINVESTOR_10 = 'Chase Manhattan Mortgage Corporation' then 'Chase Manhattan MC' 	  
	--  when _CX_SECINVESTOR_10 = 'U.S. Bank Home Mortgage' then 'US Bank Home Mtg'
	--  else _CX_SECINVESTOR_10   
	--END as Investor,
	
	i.DisplayInvestorName AS 'Investor', 
	-- CASE when  isnull(ls09.lockrate_2278,'') <> '' and  ls09.lockrate_2278 <> inv.lockrate_2278   
         -- then 'BRKR' + '-' + LEFT(ls09.lockrate_2278,15)
		 -- else LEFT(ls09.lockrate_2278,15)
	-- end AS 'Investor',
	ct.DisplayChannelTypeName as 'broker2626',
	--_2626 as 'broker2626',
	
	lf.LoanAmount AS LoanAmount,
	--LoanAmount,
	--Does not seem to be used in Report -rcorro 6/9/2014
	--_428 as SecondLoanAmount,
	fld.LoanOriginationDate as OrigDate,
	fld.LockedDate as LockDate,
	-- _745 as OrigDate,
	-- _761 as LockDate,
--SC rule - when LockDate greater than app date - note by color
	CASE
		when fld.LockedDate > fld.ApplicationOutDate then 'Red'
	END as LockAfterAppColor,
	CASE
		when fld.LockedDate > fld.ApplicationOutDate then 1
		else 0
	END as Count_LockkAfterApp,
	CASE
		when fld.LockedDate > fld.ApplicationOutDate then 0
		else 1
	END as CountOK_LockkAfterApp,

	-- CASE
		-- when _761 > _CX_APPSENT_1 then 'Red'
	-- END as LockAfterAppColor,
	-- CASE
		-- when _761 > _CX_APPSENT_1 then 1
		-- else 0
	-- END as Count_LockkAfterApp,
	-- CASE
		-- when _761 > _CX_APPSENT_1 then 0
		-- else 1
	-- END as CountOK_LockkAfterApp,
	
--SC/VP rule -  when lockDate > 2 days of Orig 
		--#DB7093 is pale red  -- 745 is app date  --761 is lock date #FFE4E1 lt pink
		
	CASE 
		when  fld.LockedDate is null and (fld.AppraisalReceivedDate > '2001-01-01') 
		                   and ( fld.AppraisalOrderedDate > '2001-01-01')
		                    and (lp.DisplayLoanPurposeName <> 'Purchase') then '#FFE4E1'
		when (dbo.DateAddWeekDay(2, fld.LoanOriginationDate)) < getdate() and fld.LockedDate is null then '#FFFFCC'
	END as LockColor,
		
	-- CASE 
		-- when  _761 is null and (_CX_APPRAISALRCVD_1 > '2001-01-01') 
		                   -- and ( _CX_APPRORDERTRANS_10 > '2001-01-01')
		                    -- and (_19 <> 'Purchase') then '#FFE4E1'
		-- when (dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null then '#FFFFCC'
		
	-- END as LockColor,
	
	CASE 
		when  fld.LockedDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) then 'Red'
	END as LockColor2,
	
	-- CASE 
		-- when  _761 > (dbo.DateAddWeekDay(2,_745)) then 'Red'
	-- END as LockColor2,
	
	CASE 
		when ((dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) < getdate() and fld.LockedDate is null ) Or 
		  (fld.LockedDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate))) then 1
		else 0
	END as count_Lock,
	
	-- CASE 
		-- when ((dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null ) Or 
		  -- (_761 > (dbo.DateAddWeekDay(2,_745))) then 1
		-- else 0
	-- END as count_Lock,
	
	CASE 
		when ((dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) < getdate() and fld.LockedDate is null ) Or 
		  (fld.LockedDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate)))  or fld.LockedDate is null then 0
		else 1
	END as countOK_Lock,
	
	-- CASE 
		-- when ((dbo.DateAddWeekDay(2,_745)) < getdate() and _761 is null ) Or 
		  -- (_761 > (dbo.DateAddWeekDay(2,_745)))  or _761 is null then 0
		-- else 1
	-- END as countOK_Lock,
	
	--The following two fields are not used in the Report -rcorro 6/9/2014		
	-- _CX_CLSSCHED_1 as schdldClose,
    -- _763 as estClose,
     
--SC/VP rule -  when send to Proc > 2 days of orig
	CASE 
		when (dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) < getdate() and fld.SentToProcessingDate is null then '#FFFFCC'
	END as SendProcColor,
	CASE 
		when  fld.SentToProcessingDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) then 'Red'
	END as SendProcColor2,
	CASE 
		when ((dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) < getdate() and fld.SentToProcessingDate is null)  
		OR (fld.SentToProcessingDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate)))then 1
		else 0
	END as count_SendProc,
	CASE 
		when ((dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) < getdate() and fld.SentToProcessingDate is null)  
		OR (fld.SentToProcessingDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate))) or fld.SentToProcessingDate is null then 0
		else 1
	END as countOK_SendProc,

	-- CASE 
		-- when (dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null then '#FFFFCC'
	-- END as SendProcColor,
	-- CASE 
		-- when  Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745)) then 'Red'
	-- END as SendProcColor2,
	-- CASE 
		-- when ((dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null)  
		-- OR (Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745)))then 1
		-- else 0
	-- END as count_SendProc,
	-- CASE 
		-- when ((dbo.DateAddWeekDay(2,_745)) < getdate() and Log_MS_Date_Processing is null)  
		-- OR (Log_MS_Date_Processing > (dbo.DateAddWeekDay(2,_745))) or Log_MS_Date_Processing is null then 0
		-- else 1
	-- END as countOK_SendProc,
	
	fld.SentToProcessingDate as SentToProc,
	--Log_MS_Date_Processing as SentToProc,
--changed from same day to 1 day after per mike dye on 5/24/2012	
----SC/VP/MC rule - Application OUT > Same Day of Send to Processing ( 1 day after)		

	CASE	
	--	when 	fld.SentToProcessingDate > '2001-01-01' AND fld.ApplicationOutDate IS NULL THEN '#FFFFCC'
	--END AS AppOutColor,
	when (dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) < getdate() and fld.ApplicationOutDate is null then '#FFFFCC'
    END AS AppOutColor,

	-- CASE	
	-- --	when 	Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL THEN '#FFFFCC'
	-- --END AS AppOutColor,
	-- when (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null then '#FFFFCC'
    -- END AS AppOutColor, 
    
	CASE	
	--	when   fld.ApplicationOutDate > fld.SentToProcessingDate THEN 'Red'
	--END AS AppOutColor2	,
		when fld.ApplicationOutDate > (dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) then 'Red'
	END AS AppOutColor2, 
	
	-- CASE	
	-- --	when   _CX_APPSENT_1 > Log_MS_Date_Processing THEN 'Red'
	-- --END AS AppOutColor2	,
		-- when _CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) then 'Red'
	-- END AS AppOutColor2, 
	
	CASE	
	--	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	--	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 1
	--	else 0 
	--END AS count_AppOut,
		when ((dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) < getdate() and fld.ApplicationOutDate is null) or
	  (fld.ApplicationOutDate > (dbo.DateAddWeekDay(1,fld.SentToProcessingDate))) then 1 else 0
	 END AS count_AppOut, 
	
	-- CASE	
	-- --	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	-- --	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 1
	-- --	else 0 
	-- --END AS count_AppOut,
		-- when ((dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null) or
	  -- (_CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing))) then 1 else 0
	 -- END AS count_AppOut, 
	 
	 CASE	
	--	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	--	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 0
	--	else 1 
	--END AS countOK_AppOut,
		when ((dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) < getdate() and fld.ApplicationOutDate is null) or
	  (fld.ApplicationOutDate > (dbo.DateAddWeekDay(1,fld.SentToProcessingDate)))
	  or  fld.ApplicationOutDate is null then 0 else 1
	 END AS countOK_AppOut, 
	
	-- CASE	
	-- --	when 	((Log_MS_Date_Processing > '2001-01-01' AND _CX_APPSENT_1 IS NULL))
	-- --	or ( _CX_APPSENT_1 > Log_MS_Date_Processing) THEN 0
	-- --	else 1 
	-- --END AS countOK_AppOut,
		-- when ((dbo.DateAddWeekDay(1,Log_MS_Date_Processing)) < getdate() and _CX_APPSENT_1 is null) or
	  -- (_CX_APPSENT_1 > (dbo.DateAddWeekDay(1,Log_MS_Date_Processing)))
	  -- or  _CX_APPSENT_1 is null   then 0 else 1
	 -- END AS countOK_AppOut, 
	
	fld.ApplicationOutDate as AppOut,
	fld.PartialApplicationReceivedDate as AppIn,
	-- _CX_APPSENT_1 as AppOut,
	-- _CX_APPRCVD_1 as AppIn,
	
	--MC rule - Application IN < 48 hours of Application Out -- use all days including weekends--		
	CASE
		when (dbo.DateAddWeekDay(2,fld.ApplicationOutDate))< GETDATE() and fld.PartialApplicationReceivedDate is null then '#FFFFCC'
    end AS AppInColor,
    CASE
		when fld.PartialApplicationReceivedDate > DateAdd(d,2,fld.ApplicationOutDate) then 'Red'
    end AS AppInColor2,
    CASE
		when DateAdd(d,2,fld.ApplicationOutDate) < GETDATE() and fld.PartialApplicationReceivedDate is null  or 
		 (fld.PartialApplicationReceivedDate > DateAdd(d,2,fld.ApplicationOutDate)) then  1
		 else 0
    end AS count_AppIn,
    CASE
		when DateAdd(d,2,fld.ApplicationOutDate) < GETDATE() and fld.PartialApplicationReceivedDate is null or 
		 (fld.PartialApplicationReceivedDate > DateAdd(d, 2,fld.ApplicationOutDate)) or fld.PartialApplicationReceivedDate is null  then  0
		 else 1
    end AS countOK_AppIn,
	
	-- --MC rule - Application IN < 48 hours of Application Out -- use all days including weekends--		
	-- CASE
		-- when (dbo.DateAddWeekDay(2,_CX_APPSENT_1))< GETDATE() and _CX_APPRCVD_1 is null then '#FFFFCC'
    -- end AS AppInColor,
    -- CASE
		-- when _CX_APPRCVD_1 > DateAdd(d,2,_CX_APPSENT_1) then 'Red'
    -- end AS AppInColor2,
    -- CASE
		-- when DateAdd(d,2,_CX_APPSENT_1) < GETDATE() and _CX_APPRCVD_1 is null  or 
		 -- (_CX_APPRCVD_1 > DateAdd(d,2,_CX_APPSENT_1)) then  1
		 -- else 0
    -- end AS count_AppIn,
    -- CASE
		-- when DateAdd(d,2,_CX_APPSENT_1) < GETDATE() and _CX_APPRCVD_1 is null or 
		 -- (_CX_APPRCVD_1 > DateAdd(d, 2,_CX_APPSENT_1))   or _CX_APPRCVD_1 is null  then  0
		 -- else 1
    -- end AS countOK_AppIn,

	--MC rule -  appraisal ordered > same day of send to processing	
	CASE 
	when (lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName <> 'FHA' and fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate is null) OR
	( lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName = 'FHA' and fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate is null) then '#FFFFCC'
		END as AprslOrdColor,

		CASE 
	when (lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName <> 'FHA' and fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.SentToProcessingDate ) OR
	( lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName = 'FHA' and fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.PartialApplicationReceivedDate) then 'Red'
	END as AprslOrdColor2,

	CASE 
		when (lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName <> 'FHA' and (fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate is null))
			OR (lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName <> 'FHA' and (fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.SentToProcessingDate))		 
			OR (lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName = 'FHA' and (fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate is null)) 
			OR (lf.IsAppraisalRequired <> 0 and lt.DisplayLoanTypeName = 'FHA' and (fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.PartialApplicationReceivedDate))
		THEN 1 ELSE 0
	END as Count_AprslOrd,
  
	-- --MC rule -  appraisal ordered > same day of send to processing	
	-- CASE 
	-- when (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) OR
	-- ( _CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) then '#FFFFCC'
		-- END as AprslOrdColor,

		-- CASE 
	-- when (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing ) OR
	-- ( _CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 > _CX_APPRCVD_1) then 'Red'
	-- END as AprslOrdColor2,

		-- CASE 
	-- when (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and (Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null))
	 -- or
	-- (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and (Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing))
			 
	-- OR 
	-- ( _CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and (_CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 is null)) or
	-- (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and (_CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 > _CX_APPRCVD_1))
			 -- then 1 else 0
	-- END as Count_AprslOrd,
	
	CASE 
		WHEN (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName <> 'FHA' AND fld.SentToProcessingDate > '2001-01-01' AND fld.AppraisalOrderedDate IS NULL)
			OR (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName <> 'FHA' AND fld.SentToProcessingDate > '2001-01-01' AND fld.AppraisalOrderedDate > fld.SentToProcessingDate)
			OR (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName = 'FHA' AND fld.PartialApplicationReceivedDate > '2001-01-01' AND fld.AppraisalOrderedDate IS NULL) 
			OR (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName = 'FHA' AND fld.PartialApplicationReceivedDate > '2001-01-01' AND fld.AppraisalOrderedDate > fld.PartialApplicationReceivedDate)
		THEN 0 ELSE 1
	END AS CountOK_AprslOrd,
	
	-- CASE 
			-- when (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) or
			 -- (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing)
			-- OR (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 is null) or
			 -- (_CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 > _CX_APPRCVD_1)
			 -- then 0 else 1
		-- END as CountOK_AprslOrd,
		
	--MC rule -  appraisal Received(IN) > 7 Days of Appraisal Order Date
		CASE 
			WHEN lf.IsAppraisalRequired <> 0 
				AND (dbo.DateAddWeekDay(10,fld.AppraisalOrderedDate)) < GETDATE() 
				AND fld.AppraisalReceivedDate IS NULL 
			THEN '#FFFFCC'
		END AS AprslRecColor,
		
		CASE 
			WHEN lf.IsAppraisalRequired <> 0 
				AND fld.AppraisalReceivedDate > (dbo.DateAddWeekDay(10,fld.AppraisalOrderedDate))
			THEN 'Red'
		END AS AprslRecColor2,
		
		CASE 
			WHEN (lf.IsAppraisalRequired <> 0 AND (dbo.DateAddWeekDay(10,fld.AppraisalOrderedDate)) < GETDATE() 
				AND fld.AppraisalReceivedDate IS NULL) 
				OR (lf.IsAppraisalRequired <> 0 AND fld.AppraisalReceivedDate > (dbo.DateAddWeekDay(10,fld.AppraisalOrderedDate))) 
			THEN 1 ELSE 0
		END AS Count_AprslRec,
		
		CASE 
			WHEN (lf.IsAppraisalRequired <> 0 AND (dbo.DateAddWeekDay(10,fld.AppraisalOrderedDate)) < GETDATE() 
				AND fld.AppraisalReceivedDate IS NULL) 
				OR (lf.IsAppraisalRequired <> 0 AND fld.AppraisalReceivedDate > (dbo.DateAddWeekDay(10,fld.AppraisalOrderedDate))) 
				OR fld.AppraisalReceivedDate IS NULL 
			THEN 0 ELSE 1
		END AS CountOK_AprslRec,
		
		 
		CASE 
			WHEN lf.IsAppraisalRequired = 0 THEN 'N/A'
			ELSE CONVERT(VARCHAR(8),fld.AppraisalOrderedDate,1) 
		END AS AppraisalOrdered,	 
		
		CASE 
			WHEN lf.IsAppraisalRequired = 0 THEN 'N/A'
			ELSE CONVERT(VARCHAR(8),fld.AppraisalReceivedDate,1) 
		END AS AppraisalRec,

    
	-- --MC rule -  appraisal Received(IN) > 7 Days of Appraisal Order Date
		-- CASE 
			-- when _CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null then '#FFFFCC'
		-- end AS AprslRecColor,
		-- CASE 
			-- when _CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10))then 'Red'
		-- end AS AprslRecColor2, 
		-- CASE 
			-- when (_CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null) or
			  -- (_CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10))) then 1 else 0
		-- end AS Count_AprslRec,
		-- CASE 
			-- when (_CX_APPRAISALREQ <> 'No' and (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10)) < getdate() and _CX_APPRRECTRANS_10 is null) or
			  -- (_CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > (dbo.DateAddWeekDay(10,_CX_APPRORDERTRANS_10))) or  _CX_APPRRECTRANS_10 is null then 0 else 1
		-- end AS CountOK_AprslRec,
		 
		-- case when _CX_APPRAISALREQ = 'No' then 'N/A'
		-- else convert(varchar(8),_CX_APPRORDERTRANS_10,1) end as AppraisalOrdered,	 
		
		 -- case when _CX_APPRAISALREQ = 'No' then 'N/A'
		-- else convert(varchar(8),_CX_APPRRECTRANS_10,1) end as   AppraisalRec,
		
	--MC rule -  title Ordered > same day of Send to Processing	
		CASE	
			WHEN fld.SentToProcessingDate > '2001-01-01' 
				AND fld.TitleOrderedDate IS NULL 
			THEN '#FFFFCC'
		END AS TitleOrdColor,
		
		CASE	
			WHEN fld.TitleOrderedDate > fld.SentToProcessingDate THEN 'Red'
		END AS TitleOrdColor2,
		
		CASE	
			WHEN (fld.SentToProcessingDate > '2001-01-01' AND fld.TitleOrderedDate IS NULL) 
				OR (fld.TitleOrderedDate > fld.SentToProcessingDate ) 
			THEN 1 ELSE 0
		END AS count_TitleOrd,
		
		CASE	
			WHEN (fld.SentToProcessingDate > '2001-01-01' AND fld.TitleOrderedDate IS NULL) 
				OR (fld.TitleOrderedDate > fld.SentToProcessingDate ) 
				OR fld.TitleOrderedDate IS NULL 
			THEN 0 ELSE 1
		END AS countOK_TitleOrd,
	
	-- --MC rule -  title Ordered > same day of Send to Processing	
	 -- CASE	
		-- when 	Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL THEN '#FFFFCC'
	-- END AS TitleOrdColor,
	-- CASE	
		-- when   _CX_TITLEORDER_1 > Log_MS_Date_Processing THEN 'Red'
	-- END AS TitleOrdColor2,
	 -- CASE	
		-- when 	(Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL) or 
		 -- (  _CX_TITLEORDER_1 > Log_MS_Date_Processing ) then 1 else 0
	-- END AS count_TitleOrd,
	 -- CASE	
		-- when 	(Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL) or 
		 -- (  _CX_TITLEORDER_1 > Log_MS_Date_Processing ) or _CX_TITLEORDER_1 is null  then 0 else 1
	-- END AS countOK_TitleOrd,
	
	--MC rule -  title IN > 7 days of order date
	    CASE 
			WHEN (dbo.DateAddWeekDay(7,fld.TitleOrderedDate)) < GETDATE() 
				AND fld.TitleReceivedDate IS NULL 
			THEN '#FFFFCC'
		END AS TitleInColor,
		
		CASE 
			WHEN fld.TitleReceivedDate > (dbo.DateAddWeekDay(7,fld.TitleOrderedDate)) THEN 'Red'
		END AS TitleInColor2,
		
		CASE 
			WHEN ((dbo.DateAddWeekDay(7,fld.TitleOrderedDate)) < GETDATE() 
				AND fld.TitleReceivedDate IS NULL) 
				OR (fld.TitleReceivedDate > (dbo.DateAddWeekDay(7,fld.TitleOrderedDate))) 
			THEN 1 ELSE 0
		END AS Count_TitleIn,
		
		CASE 
			WHEN ((dbo.DateAddWeekDay(7,fld.TitleOrderedDate)) < GETDATE() 
				AND fld.TitleReceivedDate IS NULL) 
				OR (fld.TitleReceivedDate > (dbo.DateAddWeekDay(7,fld.TitleOrderedDate))) 
			THEN 0 ELSE 1
		END AS CountOK_TitleIn, 
		
		fld.TitleOrderedDate AS TitleOrdered,
		fld.TitleReceivedDate AS TitleReceived,
	
	-- --MC rule -  title IN > 7 days of order date
   -- CASE 
		-- when (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null then '#FFFFCC'
    -- END AS TitleInColor, 
    -- CASE 
		-- when _CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) then 'Red'
	-- END AS TitleInColor2, 
	 -- CASE 
		-- when ((dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null) or
	  -- (_CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1))) then 1 else 0
	 -- END AS Count_TitleIn, 
	  -- CASE 
		-- when ((dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)) < getdate() and _CX_TITLERCVD_1 is null) or
	  -- (_CX_TITLERCVD_1 > (dbo.DateAddWeekDay(7,_CX_TITLEORDER_1)))    then 0 else 1
	 -- END AS CountOK_TitleIn, 
	
	-- _CX_TITLEORDER_1 as TitleOrdered,
	-- _CX_TITLERCVD_1 AS TitleReceived,
	
	--MC rule -  UWApproval > 5 days after Submission to UW
		CASE	
			WHEN(dbo.DateAddWeekDay(5,fld.UnderwritingSubmissionDate)) < GETDATE() 
				AND fld.UnderwritingApprovalDate IS NULL 
			THEN '#FFFFCC'
		END AS UWApprovalColor,
		
		CASE	
			WHEN fld.UnderwritingApprovalDate > (dbo.DateAddWeekDay(5,fld.UnderwritingSubmissionDate)) THEN 'Red'
		END AS UWApprovalColor2,
		
		CASE	
			WHEN((dbo.DateAddWeekDay(5,fld.UnderwritingSubmissionDate)) < GETDATE() 
				AND  fld.UnderwritingApprovalDate IS NULL) 
				OR (fld.UnderwritingApprovalDate > (dbo.DateAddWeekDay(5,fld.UnderwritingSubmissionDate))) 
			THEN 1 ELSE 0
		END AS count_UWApproval,
		
		CASE	
			WHEN((dbo.DateAddWeekDay(5,fld.UnderwritingSubmissionDate)) < GETDATE() 
				AND  fld.UnderwritingApprovalDate IS NULL) 
				OR (fld.UnderwritingApprovalDate > (dbo.DateAddWeekDay(5,fld.UnderwritingSubmissionDate))) 
				OR fld.UnderwritingApprovalDate IS NULL 
			THEN 0 ELSE 1
		END AS countOK_UWApproval,
	
	fld.UnderwritingSubmissionDate  as UWSubmitted,
	fld.UnderwritingApprovalDate as UWApproval,
	fld.BrokerUnderwritingApprovalDate as BrokeredApproval,

-- --MC rule -  UWApproval > 5 days after Submission to UW
	-- CASE	
		-- when(dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL THEN '#FFFFCC'
	-- END AS UWApprovalColor,
	-- CASE	
		-- when _2301 > (dbo.DateAddWeekDay(5,_2298)) then 'Red'
	-- END AS UWApprovalColor2,
	-- CASE	
		-- when((dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL) or
		-- ( _2301 > (dbo.DateAddWeekDay(5,_2298))) then 1 else 0
	-- END AS count_UWApproval,
	-- CASE	
		-- when((dbo.DateAddWeekDay(5,_2298)) < GETDATE() and  _2301 IS NULL) or
		-- ( _2301 > (dbo.DateAddWeekDay(5,_2298))) or _2301 IS null then 0 else 1
	-- END AS countOK_UWApproval,
	
	-- _2298  as UWSubmitted,
	-- _2301 as UWApproval,
	---   _CX_APPRRECTRANS_10  appraisal recvd
	---  _CX_APPRCVD_1           application recvd
	--- _cx_apppakcomplete    application package complete
	
	--MC rule -  UWSubmission for REFI  > 1 day of appraisal in
	--     -  UWSubmission for PURCH > 1 day of application in - changed to remove app in and use app package complete date per mike 7/4/2012	
	CASE	--when refi
		WHEN  (fld.AppraisalReceivedDate > '2001-01-01' AND fld.ApplicationReceivedDate  > '2001-01-01' 
		        AND (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate) < GETDATE() AND dbo.DateAddWeekDay(2,fld.ApplicationReceivedDate) < GETDATE()) 
		        AND lp.DisplayLoanPurposeName LIKE '%Refi%' AND fld.UnderwritingSubmissionDate IS NULL) 
		      OR  --when purchase
		      (fld.ApplicationReceivedDate  > '2001-01-01'  
		       AND(dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate))  < GETDATE() 
		       AND  lp.DisplayLoanPurposeName = 'Purchase'  AND fld.UnderwritingSubmissionDate IS NULL) 
		THEN '#FFFFCC'
	END AS UWSubmissionColor,
	
	CASE	
		WHEN (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) AND lp.DisplayLoanPurposeName LIKE '%Refi%') OR
		     (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) AND lp.DisplayLoanPurposeName  = 'Purchase')
		THEN 'Red'
	END AS UWSubmissionColor2,
	
	CASE	
		WHEN (((dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) < GETDATE()  AND lp.DisplayLoanPurposeName LIKE '%Refi%' AND fld.UnderwritingSubmissionDate IS NULL)) 
			OR ((dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) < GETDATE() AND  lp.DisplayLoanPurposeName = 'Purchase' AND fld.UnderwritingSubmissionDate IS NULL)
			OR (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) AND lp.DisplayLoanPurposeName LIKE '%Refi%') 
			OR (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) AND lp.DisplayLoanPurposeName  = 'Purchase') 
		THEN 1 ELSE 0
	END AS Count_UWSubmission,
	
	CASE	
		WHEN (lp.DisplayLoanPurposeName LIKE '%Refi%' 
			AND ((((dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) < GETDATE() AND fld.UnderwritingSubmissionDate IS NULL)) 
			OR (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)))))
			OR (lp.DisplayLoanPurposeName = 'Purchase' 
			AND (((dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) < GETDATE() AND fld.UnderwritingSubmissionDate is null)  
			OR(fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)))
			OR fld.UnderwritingSubmissionDate IS NULL))
		THEN 0 ELSE 1
	END AS CountOK_UWSubmission,
	
-- --MC rule -  UWSubmission for REFI  > 1 day of appraisal in
	-- --     -  UWSubmission for PURCH > 1 day of application in - changed to remove app in and use app package complete date per mike 7/4/2012	
	-- CASE	--when refi
		-- when  (_CX_APPRRECTRANS_10 > '2001-01-01' and _cx_apppakcomplete  > '2001-01-01' 
		        -- and (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10) < GETDATE() and dbo.DateAddWeekDay(2,_cx_apppakcomplete) < GETDATE()) 
		        -- and _19 like '%Refi%' and _2298 IS NULL) 
		      -- or  --when purchase
		      -- (_cx_apppakcomplete  > '2001-01-01'  
		       -- and(dbo.DateAddWeekDay(1,_cx_apppakcomplete))  < GETDATE() 
		       -- and  _19 = 'Purchase'  and _2298 is null) 
		-- then '#FFFFCC'
	-- END AS UWSubmissionColor,
	
	-- CASE	
		-- when (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) AND _19 like '%Refi%') OR
		     -- (_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete))       AND _19  = 'Purchase')
		-- THEN 'Red'
	-- END AS UWSubmissionColor2,
	
	-- CASE	
		-- when  (((dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) < GETDATE()  AND _19 like '%Refi%' and _2298 IS NULL)) or
		      -- ((dbo.DateAddWeekDay(1,_cx_apppakcomplete))   < GETDATE() and  _19 = 'Purchase' and _2298 is null)  or
		      -- (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10))  AND _19 like '%Refi%') OR
		     -- (_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete))       AND _19  = 'Purchase') 
		 -- then 1 else 0
	-- END AS Count_UWSubmission,
		-- CASE	
		-- when  _19 like '%Refi%' and((((dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) < GETDATE()  and _2298 IS NULL)) or
				-- (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) ))
				-- or
		-- _19 = 'Purchase' and(
		      -- ((dbo.DateAddWeekDay(1,_cx_apppakcomplete))       < GETDATE()  and _2298 is null)  
 -- OR(_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete))  )) 
 -- or _2298 is null
  -- then 0 else 1
	-- END AS CountOK_UWSubmission,
	
	--CASE	
	--	when  (((dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) < GETDATE() AND _19 like '%Refi%' and _2298 IS NULL)) or
	--	      ((dbo.DateAddWeekDay(1,_cx_apppakcomplete))       < GETDATE() and  _19 = 'Purchase' and _2298 is null)  or
	--	      (_2298 > (dbo.DateAddWeekDay(2,_CX_APPRRECTRANS_10)) AND _19 like '%Refi%') OR
	--	     (_2298 > (dbo.DateAddWeekDay(1,_cx_apppakcomplete))       AND _19  = 'Purchase') then 0 else 1
	--END AS CountOK_UWSubmission,
		
	fld.ClearToCloseDate AS UWCTC,
	fld.EstimatedClosingDate as EstClosingDate, 
	fld.LockExpirationDate as LockExpiration,
	--Field is not used in Report -rcorro 6/9/2014
	--Address1,
	
	-- _2305 AS UWCTC,
	-- Case
		-- when  _748 > '2001-01-01' then _748
		-- when 	_CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763
	-- END as EstClosingDate, 
		
	-- _762 as LockExpiration,
	-- Address1,

	--LC rule -  Condition Submission  > 2 Days after Approval Date From UW 
	CASE	
		WHEN ((dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate) < GETDATE()) 
			AND di.DivisionName =  'Online' 
			AND fld.ConditionsSubmittedDate IS NULL) 
			OR ((dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate) < GETDATE()) 
			AND di.DivisionName <> 'Online' AND fld.ConditionsSubmittedDate IS NULL) 
		THEN '#FFFFCC'
	END AS CondSubmitColor,
	
	CASE	
		WHEN (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate)) AND di.DivisionName = 'Online') 
		OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate))AND di.DivisionName <> 'Online') THEN 'Red'
	END AS CondSubmitColor2,
	
	CASE	
		WHEN ((dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate) < GETDATE()) AND di.DivisionName = 'Online' AND fld.ConditionsSubmittedDate IS NULL) 
			OR ((dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate) < GETDATE()) AND di.DivisionName <> 'Online' AND fld.ConditionsSubmittedDate IS NULL) 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate))AND di.DivisionName =  'Online') 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate))AND di.DivisionName <> 'Online') 
		THEN 1 ELSE 0
	END AS Count_CondSubmit,
		
	CASE
		WHEN ((di.DivisionName = 'Online' AND ((dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate) < GETDATE()) AND (fld.ConditionsSubmittedDate IS NULL) 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate)))))
			OR (di.DivisionName <> 'Online' AND ((dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate) < GETDATE()) AND (fld.ConditionsSubmittedDate IS NULL) 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate))))))	 
			OR fld.ConditionsSubmittedDate is null
		THEN 0 ELSE 1
	END AS CountOK_CondSubmit,
	
-- --LC rule -  Condition Submission  > 2 Days after Approval Date From UW
	-- CASE	
		-- when  ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
		  -- ((dbo.DateAddWeekDay(4,_2301) < GETDATE()) AND r.region <> 'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) THEN '#FFFFCC'
	-- end AS CondSubmitColor,
	-- CASE	
		-- when ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))AND r.region =  'Online') or
		 -- (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(4,_2301))AND r.region <> 'Online') then 'Red'
	-- end AS CondSubmitColor2,
	-- CASE	
		-- when ((dbo.DateAddWeekDay(2,_2301) < GETDATE()) AND r.region =  'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) or
		  -- ((dbo.DateAddWeekDay(4,_2301) < GETDATE()) AND r.region <> 'Online' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) OR 
		  -- ( coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))AND r.region =  'Online') or
		  -- (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(4,_2301))AND r.region <> 'Online') then 1 else 0
	-- end AS Count_CondSubmit,
		-- CASE

-- when ( ( r.region =  'Online' and((dbo.DateAddWeekDay(2,_2301) < GETDATE()) and (  coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,	 ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) 

-- OR 
	  
	  -- (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,  ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(2,_2301))	 )))

-- or

	 -- ( r.region <> 'Online' and ((dbo.DateAddWeekDay(4,_2301) < GETDATE())   and  (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) IS NULL) 
	  
 
	  
-- or
	  
	  -- (coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,   ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) > (dbo.DateAddWeekDay(4,_2301))  ) ))
-- )	 
-- or   coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) is null
-- then 0 else 1
	
	-- end AS CountOK_CondSubmit,
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
		WHEN ((dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate) < GETDATE()) AND fld.ClearToCloseDate IS NULL)  OR
		      ((dbo.DateAddWeekDay(-6,fld.ContingencyDate)< GETDATE() AND lp.DisplayLoanPurposeName = 'Purchase' AND fld.ClearToCloseDate IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > fld.LockExpirationDate AND lp.DisplayLoanPurposeName  = 'Purchase' AND ost.DisplayOccupancyStatusTypeName = 'PrimaryResidence' AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.LockExpirationDate AND lp.DisplayLoanPurposeName like '%Refi%' AND ost.DisplayOccupancyStatusTypeName IN ('SecondHome', 'Investor') AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.EstimatedClosingDate AND lp.DisplayLoanPurposeName  = 'Purchase' AND fld.ClearToCloseDate is null) )
	    THEN '#FFFFCC'
	END AS CTCColor,
	
	CASE	
		WHEN  (fld.ClearToCloseDate > (dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate))) OR
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(-6,fld.ContingencyDate))AND lp.DisplayLoanPurposeName = 'Purchase'))OR 
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(10,fld.LockExpirationDate)) AND lp.DisplayLoanPurposeName  = 'Purchase' AND ost.DisplayOccupancyStatusTypeName = 'PrimaryResidence') ) OR
			  ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(6,fld.LockExpirationDate))  AND lp.DisplayLoanPurposeName like '%Refi%' AND ost.DisplayOccupancyStatusTypeName IN ('SecondHome', 'Investor') ) OR
              ((fld.ClearToCloseDate < (dbo.DateAddWeekday(6,fld.EstimatedClosingDate)) AND lp.DisplayLoanPurposeName  = 'Purchase') ))
        then 'Red'
	END AS CTCColor2,
	
	CASE	
		WHEN  ((dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate) < GETDATE()) AND fld.ClearToCloseDate IS NULL)  OR
		      (( dbo.DateAddWeekDay(-6,fld.ContingencyDate)< GETDATE() AND lp.DisplayLoanPurposeName = 'Purchase' AND fld.ClearToCloseDate IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > fld.LockExpirationDate AND lp.DisplayLoanPurposeName  = 'Purchase' AND ost.DisplayOccupancyStatusTypeName = 'PrimaryResidence' AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.LockExpirationDate AND lp.DisplayLoanPurposeName like '%Refi%' AND ost.DisplayOccupancyStatusTypeName IN ('SecondHome', 'Investor') AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.EstimatedClosingDate AND lp.DisplayLoanPurposeName  = 'Purchase' AND fld.ClearToCloseDate is null) ) or
		      (fld.ClearToCloseDate > (dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate))) OR
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(-6,fld.ContingencyDate))AND lp.DisplayLoanPurposeName = 'Purchase') )OR 
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(10,fld.LockExpirationDate)) AND lp.DisplayLoanPurposeName  = 'Purchase' AND ost.DisplayOccupancyStatusTypeName = 'PrimaryResidence') ) OR
			  ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(6,fld.LockExpirationDate))  AND lp.DisplayLoanPurposeName like '%Refi%' AND ost.DisplayOccupancyStatusTypeName IN ('SecondHome', 'Investor') ) OR
              ((fld.ClearToCloseDate < (dbo.DateAddWeekday(6,fld.EstimatedClosingDate)) AND lp.DisplayLoanPurposeName  = 'Purchase') ))
	    THEN 1 else 0
	END AS  Count_CTC,
	
	CASE	
		WHEN lp.DisplayLoanPurposeName = 'Purchase' AND  
			((fld.ClearToCloseDate <= (dbo.DateAddWeekDay(6,fld.ContingencyDate))) OR
			((fld.ClearToCloseDate >= (dbo.DateAddWeekDay(10, fld.LockExpirationDate)) AND ost.DisplayOccupancyStatusTypeName = 'PrimaryResidence')) OR
			(fld.ClearToCloseDate >= (dbo.DateAddWeekDay(6,fld.EstimatedClosingDate)))) OR
			(lp.DisplayLoanPurposeName like '%Refi%' AND ost.DisplayOccupancyStatusTypeName IN ('SecondHome', 'Investor') AND 
			(fld.ClearToCloseDate >= (dbo.DateAddWeekDay(6,fld.LockExpirationDate)))) OR
			fld.ClearToCloseDate <= ((dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate))) 
		THEN 1 else 0
	END AS CountOK_CTC,

	-- --LC rule -  CTC  > 2 Days after Conditions submitted to UW
		  -- -- or	Purch: < 6 days from Contigency Date 
		   -- --or Refi Primary < 10 days from Lock expiration
		   -- --or Refi 3nd or inv < 6 days from Lock expiration
		   -- --or purchase < 6 dayd from extimated/scheduled close date
		   -- --    _2305 = UWCTC    _CX_CONTINGE_1 = contigency Date
	-- CASE	
		-- when  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
		      -- (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
		      -- ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
		      -- ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
		      -- ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) )
	    -- THEN '#FFFFCC'
	-- END AS CTCColor,
	
	-- CASE	
		-- when  (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
		      -- ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase'))OR 
		      -- ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
			  -- ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
              -- ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
        -- then 'Red'
	-- END AS CTCColor2,
	-- CASE	
		-- when  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )) < GETDATE()) AND _2305 IS NULL)  OR
		      -- (( dbo.DateAddWeekDay(-6,_CX_CONTINGE_1)< GETDATE() AND _19 = 'Purchase' AND _2305 IS NULL) )  OR
		      -- ((dbo.DateAddWeekDay(10,getdate()) > _762 AND _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null)) OR
		      -- ((dbo.DateAddWeekDay(6,getdate()) > _762 AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and _2305 is null)) OR
		      -- ((dbo.DateAddWeekDay(6,getdate()) > ( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End) AND _19  = 'Purchase' and _2305 is null) ) or
		      -- (_2305 > (dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) OR
		      -- ((_2305 < (dbo.DateAddWeekDay(-6,_CX_CONTINGE_1))AND _19 = 'Purchase') )OR 
		      -- ((_2305 < (dbo.DateAddWeekDay(10,_762)) AND _19  = 'Purchase' and _1811 = 'PrimaryResidence') ) OR
			  -- ((-2305 < (dbo.DateAddWeekDay(6,_762))  AND _19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') ) OR
              -- ((_2305 < (dbo.DateAddWeekday(6,( Case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 End))) AND _19  = 'Purchase') ))
	    -- THEN 1 else 0
	-- END AS  Count_CTC,
	
	-- CASE	
		-- when   _19 = 'Purchase' and  
		-- (
		-- (_2305  <= (dbo.DateAddWeekDay(6,_CX_CONTINGE_1))) OR
		
		-- ((_2305 >=  (dbo.DateAddWeekDay(10, _762)) and _1811 = 'PrimaryResidence')) or
		 
		 -- (_2305 >=   (dbo.DateAddWeekDay(6,_763)) )
		 -- )
		-- OR
		 -- (_19 like '%Refi%' and _1811 IN ('SecondHome', 'Investor') and (_2305 >=  (dbo.DateAddWeekDay(6,_762))))
		 
		 -- or
		-- _2305 <=  ((dbo.DateAddWeekDay(2,coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,
		-- ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 )))) 
		 
		   
		   
	    -- THEN 1 else 0
	-- END AS CountOK_CTC,
	
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
	
	fld.UnderwritingSuspendedDate AS UWSuspended,
	--This field is now used -rcorro 6/10/2014
	--Log_MS_Date_DocsSigning as DocsSigned,
    fld.ConditionsSubmittedDate as CondSubmit,
    lp.DisplayLoanPurposeName AS proptype,
	--This field is now used -rcorro 6/10/2014
    --e.titleid ,
	--This field is now used -rcorro 6/10/2014
	--Log_MS_Lastcompleted,
	eisa.userlogin AS SALogin,
	--This field is now used -rcorro 6/10/2014
	--dbo.AllManagers2(dem.empid) AS MGRLogin,
	  --was this:    dbo.allmanagers(e.employeeId) as MGRLogin
	fld.ApplicationReceivedDate AS _cx_apppakcomplete,
	fld.ApprovalReviewedDate AS APPROVALreviewed,

		
	-- _2303 AS UWSuspended,
	-- Log_MS_Date_DocsSigning as DocsSigned,
    -- coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) as CondSubmit,
    -- _1811 as proptype,
    -- e.titleid ,
	-- Log_MS_Lastcompleted,
	-- sa.userlogin as SALogin,
	-- dbo.AllManagers2(dem.empid) as MGRLogin,
	  -- --was this:    dbo.allmanagers(e.employeeId) as MGRLogin
	-- _cx_apppakcomplete,
	-- _cx_apprreviewed AS   APPROVALreviewed,
  
  ------------------------------------------NEW
						--     _2301 as UWApproval
						--      _cx_apprreviewed AS   APPROVALreviewed,
 
 
	--RULE - APPROVAL REVIEWED is greater than 1 day of UW approval
	CASE
		WHEN (dbo.DateAddWeekDay(1, fld.UnderwritingApprovalDate)) < GETDATE() AND fld.ApprovalReviewedDate IS NULL THEN '#FFFFCC'
	END AS aprvlREVIEWEDColor,
	
	CASE	
		WHEN fld.ApprovalReviewedDate > (dbo.DateAddWeekDay(1, fld.UnderwritingApprovalDate)) THEN 'Red'
	END AS aprvlREVIEWEDColor2,
	
	CASE	
		WHEN ((dbo.DateAddWeekDay(1, fld.UnderwritingApprovalDate)) < GETDATE() AND fld.ApprovalReviewedDate IS NULL) 
			OR (fld.ApprovalReviewedDate > (dbo.DateAddWeekDay(1, fld.UnderwritingApprovalDate))) 
		THEN 1 ELSE 0
	END AS count_aprvlREVIEWED,
	
	CASE	
		WHEN ((dbo.DateAddWeekDay(1, fld.UnderwritingApprovalDate)) < GETDATE() 
			AND fld.ApprovalReviewedDate IS NULL) 
			OR (fld.ApprovalReviewedDate > (dbo.DateAddWeekDay(1, fld.UnderwritingApprovalDate))) 
			OR fld.ApprovalReviewedDate IS NULL 
		THEN 0 ELSE 1
	END AS countOK_aprvlREVIEWED,
	
  -- --RULE - APPROVAL REVIEWED is greater than 1 day of UW approval
  -- Case
	-- when(dbo.DateAddWeekDay(1,_2301)) < GETDATE() and  _cx_apprreviewed IS NULL THEN '#FFFFCC'
	-- END AS aprvlREVIEWEDColor,
	-- CASE	
		-- when _cx_apprreviewed > (dbo.DateAddWeekDay(1,_2301)) then 'Red'
	-- END AS aprvlREVIEWEDColor2,
	-- CASE	
		-- when((dbo.DateAddWeekDay(1,_2301)) < GETDATE() and  _cx_apprreviewed IS NULL) or
		-- ( _cx_apprreviewed > (dbo.DateAddWeekDay(1,_2301))) then 1 else 0
	-- END AS count_aprvlREVIEWED,
	-- CASE	
		-- when((dbo.DateAddWeekDay(1,_2301)) < GETDATE() and  _cx_apprreviewed IS NULL) or
		-- ( _cx_apprreviewed > (dbo.DateAddWeekDay(1,_2301))) 
		-- or _cx_apprreviewed is null then 0 else 1
	-- END AS countOK_aprvlREVIEWED,
	
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
		WHEN (dbo.DateAddWeekDay(3, fld.ApplicationOutDate)) < GETDATE() 
			AND fld.ApplicationReceivedDate IS NULL THEN '#FFFFCC'
    END AS AppcmpltColor,
	
    CASE
		WHEN fld.ApplicationReceivedDate > DATEADD(d, 3, fld.ApplicationOutDate) THEN 'Red'
    END AS AppcmpltColor2,
	
    CASE
		WHEN DATEADD(d, 3, fld.ApplicationOutDate) < GETDATE() 
			AND fld.ApplicationReceivedDate IS NULL 
			OR (fld.ApplicationReceivedDate > DATEADD(d, 3, fld.ApplicationOutDate)) 
		THEN 1 ELSE 0
    END AS count_Appcmplt,
	
    CASE
		WHEN DATEADD(d, 3, fld.ApplicationOutDate) < GETDATE() 
			AND fld.ApplicationReceivedDate IS NULL 
			OR (fld.ApplicationReceivedDate > DATEADD(d, 3, fld.ApplicationOutDate)) 
			OR fld.ApplicationReceivedDate IS NULL 
		THEN  0 ELSE 1
    END AS countOK_Appcmplt,
    
    fld.CondoPUDApprovalSubmitted, 
    fld.CondoPUDApprovalIssued
	
	-- The next 4 fields are not used in the report -rcorro 6/10/2014
    -- _CX_UWCONDOSUB,
    -- _CX_UWCONDOAPPR,
    -- _CX_4506TORDDTE,
    -- _CX_4506TRECDDTE
  
	-- CASE
		-- when (dbo.DateAddWeekDay(3,_CX_APPSENT_1))< GETDATE() and _cx_apppakcomplete is null then '#FFFFCC'
    -- end AS AppcmpltColor,
    -- CASE
		-- when _cx_apppakcomplete > DateAdd(d,3,_CX_APPSENT_1) then 'Red'
    -- end AS AppcmpltColor2,
    -- CASE
		-- when DateAdd(d,3,_CX_APPSENT_1) < GETDATE() and _cx_apppakcomplete is null  or 
		 -- (_cx_apppakcomplete > DateAdd(d,3,_CX_APPSENT_1)) then  1
		 -- else 0
    -- end AS count_Appcmplt,
    -- CASE
		-- when DateAdd(d,3,_CX_APPSENT_1) < GETDATE() and _cx_apppakcomplete is null or 
		 -- (_cx_apppakcomplete > DateAdd(d,3,_CX_APPSENT_1)) or _cx_apppakcomplete is null then  0
		 -- else 1
    -- end AS countOK_Appcmplt,
    -- _CX_UWCONDOSUB,
    -- _CX_UWCONDOAPPR,
    -- _CX_4506TORDDTE,
    -- _CX_4506TRECDDTE
    
    
--LC rule -  Closing date < 10 Days from Lock expiration 

FROM LoanWarehouse.dbo.factLoan lf
	INNER JOIN LoanWarehouse.dbo.dimLoanInfo dli ON dli.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.factLoanDates fld ON fld.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.dimGeographyInfo gi ON lf.GeographyInfoKey = gi.GeographyInfoKey
	INNER JOIN LoanWarehouse.dbo.dimEmployeeInfo eilo ON lf.EmployeeInfoKey_LO = eilo.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eilc ON lf.EmployeeInfoKey_LC = eilc.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eimc ON lf.EmployeeInfoKey_MC = eimc.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eisa ON lf.EmployeeInfoKey_SA = eisa.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eiuw ON lf.EmployeeInfoKey_UW = eiuw.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimCostCenterInfo cc ON lf.CostCenterInfoKey = cc.CostCenterInfoKey
	--LEFT OUTER JOIN LoanWarehouse.dbo.SalesRegionInfoCostCenterInfo srcc srcc.CostCenterInfoKey = lf.CostCenterInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimSalesRegionInfo r ON lf.SalesRegionInfoKey = r.SalesRegionInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.ChannelType ct ON dli.ChannelTypeID = ct.ChannelTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanMilestone lm ON dli.LoanMilestoneID = lm.LoanMilestoneID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanMilestoneGroup lmg ON lmg.LoanMilestoneGroupID = lm.LoanMilestoneGroupID
	LEFT OUTER JOIN LoanWarehouse.dbo.dimBorrowerInfo bi ON bi.BorrowerInfoKey = lf.BorrowerInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimCoBorrowerInfo cbi ON cbi.CoBorrowerInfoKey = lf.CoBorrowerInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanPurpose lp ON dli.LoanPurposeID = lp.LoanPurposeID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanPurposeGroup lpg ON lpg.LoanPurposeGroupID = lp.LoanPurposeGroupID
	LEFT OUTER JOIN LoanWarehouse.dbo.PropertyType pt ON dli.PropertyTypeID = pt.PropertyTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.PropertyTypeGroup ptg ON pt.PropertyTypeGroupID = ptg.PropertyTypeGroupID
	LEFT OUTER JOIN LoanWarehouse.dbo.Investor i ON dli.InvestorID = i.InvestorID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanType lt ON dli.LoanTypeID = lt.LoanTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.dimDivisionInfo di ON lf.DivisionInfoKey = di.DivisionInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.OccupancyStatusType ost ON dli.OccupancyStatusTypeID = ost.OccupancyStatusTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanStatus ls ON dli.LoanStatusID = ls.LoanStatusID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanLienPosition llp ON dli.LoanLienPositionID = llp.LoanLienPositionID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanInfoGeographyInfo ligi ON lf.LoanInfoKey = ligi.LoanInfoKey
	
	LEFT OUTER JOIN chilhqpsql05.admin.corp.employeeandallmanagers2 dem  on dem.empid =  eilo.employeeId

	-- [grchilhq-sq-03].emdb.emdbuser.Loansummary ls  
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_01 ls01  ON ls.XrefId = ls01.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_02 ls02  on ls.XrefId = ls02.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_03 ls03  on ls.XrefId = ls03.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_04 ls04  on ls.XrefId = ls04.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_05 ls05  on ls.XrefId = ls05.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_10 ls10  on ls.XrefId = ls10.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_09 ls09  on ls.XrefId = ls09.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_S_17 ls17  on ls.XrefId = ls17.XrefId

	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_02 ln02  on ls.XrefId = ln02.XrefId 
	-- Inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_N_03 ln03  on ls.XrefId = ln03.XrefId 
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_01 ld01  on ls.XrefId = ld01.XrefId 
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_02 ld02  on ls.XrefId = ld02.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_03 ld03  on ls.XrefId = ld03.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_04 ld04  on ls.XrefId = ld04.XrefId
	-- inner join [grchilhq-sq-03].emdb.emdbuser.LOANXDB_D_05 ld05  on ls.XrefId = ld05.XrefId
	-- left outer join chilhqpsql05.admin.corp.Employee e  on e.employeeId = ls03._CX_FINALOCODE_4
	-- --ls.loanofficerid
	-- --left outer join chilhqpsql05.admin.corp.employee empcorp on empcorp.employeeId = e.employeeid
	-- left outer join chilhqpsql05.admin.corp.costcenter cc  on cc.CostCenterID = e.costcenterid
	-- left outer join chilhqpsql05.admin.corp.Region r  ON r.regionID = cc.RegionID 
	-- left outer join chilhqpsql05.admin.corp.employeeandallmanagers2 dem  on dem.empid =  e.employeeId
	-- left outer join chilhqpsql05.admin.corp.employee empMC  on  empMC.encompasslogin  = rtrim(ltrim(LoanTeamMember_UserID_MortgageConsultant))
	-- left outer join chilhqpsql05.admin.corp.employee empLC   on empLC.encompasslogin  = rtrim(ltrim(LoanTeamMember_UserID_LoanCoordinator))
	-- left outer join chilhqpsql05.admin.corp.employee sa  on sa.employeeid = empmc.salesassistiantid
	-- left outer join chilhqpsql05.admin.corp.employee sb  on sb.employeeid = emplc.salesassistiantid
	-- left outer join chilhqpsql05.admin.corp.employee sc  on sc.employeeid = e.salesassistiantid
	-- left outer join [grchilhq-sq-03].emdb.reports.investor inv on inv.lockrate_2278 = ls09.lockrate_2278  
	--or 
	--sa.employeeid = empmc.salesassistiantid or
	--sa.employeeid = emplc.salesassistiantid)
WHERE
		(
		(@Options = 'locked'  AND fld.LockedDate >= '2001-01-01' AND fld.LockExpirationDate > GETDATE())
		OR (@Options = 'expire' AND fld.LockExpirationDate < GETDATE()) 
		OR (@Options = 'float' AND  fld.LockedDate is null) 
		OR (@Options = 'all' AND fld.FundedDate is null) 
		OR (@Options = 'purchase' AND lp.DisplayLoanPurposeName = 'Purchase') 
		OR (@Options = 'refinance' AND lp.DisplayLoanPurposeName <> 'Purchase') 
		OR (@Options = 'appNotReturned'   AND fld.ApplicationOutDate > '2001-01-01' AND fld.PartialApplicationReceivedDate IS NULL) 
		OR (@Options = 'aprslNotReceived' AND fld.AppraisalOrderedDate >  '2001-01-01' AND fld.AppraisalReceivedDate  IS Null) 
		OR (@Options = 'expire3' AND (dbo.DateDiffWeekDay(getdate(), fld.LockExpirationDate) < 16)) 
		OR (@Options = 'expire2' AND (dbo.DateDiffWeekDay(getdate(), fld.LockExpirationDate) < 11)) 
		OR (@Options = 'expire1' AND (dbo.DateDiffWeekDay(getdate(), fld.LockExpirationDate) < 6)) 
		
		OR (@options = 'notRedisclosed' AND fld.LockedDate > fld.GFELastDisclosedDate) 
		
		OR (@Options = 'ctc' AND fld.ClearToCloseDate >= '2001-01-01' AND lm.DisplayLoanMilestoneName <> 'Assign to Close')
		OR (@Options = 'UWapprvNotSubmit' AND fld.UnderwritingDecisionExpectedDate >= '2001-01-01' AND fld.ConditionsSubmittedDate is null) 
		OR (@Options = 'DocSignNotfund' AND fld.EstimatedClosingDate >= '2001-01-01' AND fld.FundedDate is null) 
		OR ((@Options = 'p2weeks' AND lp.DisplayLoanPurposeName = 'Purchase' AND (dbo.DateDiffWeekDay(fld.EstimatedClosingDate, getdate()) < 11)) AND 
			(@Options = 'p2weeks' AND lp.DisplayLoanPurposeName = 'Purchase' AND (dbo.DateDiffWeekDay(fld.EstimatedClosingDate,getdate()) < 11))) 
		OR ((@Options = 'p1week' AND lp.DisplayLoanPurposeName = 'Purchase' AND (dbo.DateDiffWeekDay(getdate(), fld.EstimatedClosingDate) < 6)) OR 
			(@Options = 'p1week' AND lp.DisplayLoanPurposeName = 'Purchase' AND (dbo.DateDiffWeekDay(getdate(),fld.EstimatedClosingDate) < 6))) 
		OR ((@Options = 'notSubmittedUW' AND (dbo.DateAddWeekDay(1, fld.AppraisalReceivedDate)) < GETDATE()
									  AND (dbo.DateAddWeekDay(1, fld.ApplicationReceivedDate)) < GETDATE() 
									  AND fld.LockedDate is not null   --761 is lock date								 
		                              AND lp.DisplayLoanPurposeName like '%Refi%' AND fld.UnderwritingSubmissionDate IS NULL)) or  --_2298 is UW submit date 
		 (@Options = 'notSubmittedUW' AND (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)      ) < GETDATE() 
		                              AND lp.DisplayLoanPurposeName =  'Purchase' AND fld.UnderwritingSubmissionDate is null) 
		--new MC Lane AND LC Lane--
							
		OR (@Options = 'McLane' AND  lm.DisplayLoanMilestoneName in (	'Processing', 'Assigned to UW','Submittal')) 
		OR (@Options = 'LcLane' AND  lm.DisplayLoanMilestoneName in (	'UW Decision Expected','Conditions Submitted to UW','Assign to Close')) 
		OR (@Options = 'MStarted' AND lm.DisplayLoanMilestoneName = 'Started') 
		OR (@Options = 'Mprocessing' AND lm.DisplayLoanMilestoneName IN ('Processing', 'App Fee Collected')) 
		
		OR (@Options = 'MassignedToUW' AND lm.DisplayLoanMilestoneName = 'Assigned to UW') 
		OR (@Options = 'Msubmittal' AND lm.DisplayLoanMilestoneName = 'Submittal') 
		OR (@Options = 'MUWExp' AND lm.DisplayLoanMilestoneName = 'UW Decision Expected') 
		OR (@Options = 'McondSubUW' AND lm.DisplayLoanMilestoneName = 'Conditions Submitted to UW') 
		OR (@Options = 'Mapproval' AND lm.DisplayLoanMilestoneName = 'Approval') 
		OR (@Options = 'MassignToClose' AND lm.DisplayLoanMilestoneName = 'Assign to Close') 
		OR (@Options = 'MdocSigning' AND lm.DisplayLoanMilestoneName = 'Doc Signing')
		
		OR (@Options = 'ltv' AND lm.DisplayLoanMilestoneName = 'Restructured - LTV, DTI, UW Suspended')
		      --  AND _2301 IS null) OR  -- Milestone-restructure
		--(@Options = 'ltv' AND _2303 > '2000-01-01') 
		--2301 is und approval date
		--2303 is und suspended date
		
		
		OR (@Options = 'contingency1' AND (dbo.DateDiffWeekDay(getdate(), fld.ContingencyDate) < 6)) 
		OR (@Options = 'contingency2' AND (dbo.DateDiffWeekDay(getdate(), fld.ContingencyDate) < 13)) 
		OR (@Options = 'LoansToDisclose' AND ((fld.SentToProcessingDate > '2001-01-01') AND fld.ApplicationOutDate is null)) 
		
		--I constructed this one myself need to test to see if it does not work. -rcorro 6/10/2014
		OR (@Options = 'CondoSubmitted' AND pt.DisplayPropertyTypeName LIKE '%condo%' AND fld.UnderwritingSubmissionDate >= '2001-01-01' AND fld.UnderwritingApprovalDate is null) 
		OR (@Options = 'CondoApproved'  AND pt.DisplayPropertyTypeName LIKE '%condo%' AND fld.UnderwritingApprovalDate >= '2001-01-01') 
		
		OR (@Options = '4506TOrdered' AND fld.Date4506TOrder >= '2001-01-01' AND fld.Date4506TReceived is null) 
		OR (@Options = '4506tReceived' AND fld.Date4506TReceived >= '2001-01-01' )  
		
		--(@Options = 'Brokered' AND isnull(ls09.lockrate_2278,'') <> '' AND ls09.LOCKRATE_2278 <> inv.lockrate_2278) OR
		--(@Options = 'Brokered' AND _2626 = 'Brokered')
		
		--OLD CODE
		-- (@Options = 'CondoSubmitted'  and _CX_UWCONDOSUB >= '2001-01-01' and   _CX_UWCONDOAPPR is null) OR
		-- (@Options = 'CondoApproved'  and _CX_UWCONDOAPPR >= '2001-01-01') OR
		
		-- (@Options = '4506TOrdered'  and _CX_4506TORDDTE >= '2001-01-01'	and   _CX_4506TRECDDTE is null) OR
		-- (@Options = '4506tReceived'  and _CX_4506TRECDDTE >= '2001-01-01' )  
		)
	
	AND ISNULL(fld.FundedDate,'') = ''
		 
	-- AND   -- Allow Prequal addresses when the milestione is greater than 'started'
		-- address1 NOT LIKE (
		-- CASE WHEN lm.DisplayLoanMilestoneName = 'Started' 
			-- THEN 'Prequal%' ELSE ''
		-- END )
	-- Allow Prequal addresses when the milestione is greater than 'started'
	AND (ligi.StreetAddress IS NOT NULL OR (lf.IsPrequalifiedLoan = 1 AND lm.DisplayLoanMilestoneName = 'Started' AND ligi.StreetAddress IS NULL))
	
	AND fld.EstimatedClosingDate >= '2012-01-01'    -- est closing date
	AND (dli.LoanFolder NOT IN ('(Archive)','(Trash)',  'Closed Loans',
							 'Completed Loans','Samples','Adverse Loans', 'To Archive', 
							 'Adverse 1', 'Adverse 2', 'Adverse 3', 'Adverse 4', 'Adverse 5',
							  'Adverse 6', 'GRIOnline - Testing' ))
	AND ls.LoanStatusName = 'Active Loan'
	-- AND _420 <> 'Second Lien'	-- removed per matt harmon on 06/27/13
								 
								 --removed adverse loan folder as an exclusion - per mike d on 6/19/12.
								 --added _749 - change date to exclude adversed loans.
	AND 
		(  ---- get employee(s)
			(@GroupBy = 'MC' AND eimc.EmployeeID IN (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, eimc.EmployeeID), ',')))
			OR (@GroupBy = 'LC' AND eilc.EmployeeID IN (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, eilc.EmployeeID), ',')))
			OR (@GroupBy = 'VP' AND eilo.EmployeeID IN (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, eilo.EmployeeID), ',')))
			OR (@GroupBy = 'PM' AND eilo.EmployeeID IN (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, eilo.EmployeeID), ',')))
		)
		
	AND     -- get userid (logon)johne
		(
		@UserName in (eilo.UserLogin, eilc.UserLogin, eimc.UserLogin, eisa.UserLogin) --VP, LC, MC, each SA
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(dem.empid), ',')) --MGR
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(eimc.EmployeeID), ',')) --MGR
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(eilc.EmployeeID), ',')) --MGR
    OR
--Was this: @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.allmanagers(dem.empid), ',')) --MGR 
		@UserName in ('alexanderm','amaloney','amargin','bconn','BMercer','cstackhouse','cmorgan','dkalinofski', 
			'dmoran','egarner','eyanaki','frankc','jatkocaitis','jpike','jpugh','jmorgan','KShattuck','kwoodruff', 
			'lauge','lbrictson','lmann','ltitiyevsky','mchaput','mdye','mhamer','mharmon','mkaufman','mknopf','mmunoz', 
			'mowen','nathanasiou','nejohnson','proos','pvandivier','rcorro','rjones','robs','romahoney','sbarcomb','slevitt',
			'smueller','sstephen','tgamache','tgrimm','tlangdon','ylopez','bcotta','mhayes', 'pkurka', 'jmavalankar'
			,'ltrout', 'ntaylor','mwalsh'
		) 
	)
		
-- where 
		-- (
		-- (@Options = 'locked'  and _761 >= '2001-01-01' and _762 > GETDATE()) OR
		-- (@Options = 'expire' and _762 < getdate()) OR
		
		-- (@Options = 'float' and  _761 is null) OR
		
		-- (@Options = 'all' and  _CX_FUNDDATE_1 is null) OR
		-- (@Options = 'purchase' and _19 = 'Purchase') OR
		-- (@Options = 'refinance' and _19 <> 'Purchase') Or
		
		-- (@Options = 'appNotReturned'   and _CX_APPSENT_1          > '2001-01-01' and _CX_APPRCVD_1 IS null) OR
		-- (@Options = 'aprslNotReceived' and _CX_APPRORDERTRANS_10 >  '2001-01-01' and _CX_APPRRECTRANS_10  IS Null) OR
		-- (@Options = 'expire3' and (dbo.DateDiffWeekDay(getdate(),_762)< 16)) OR
		-- (@Options = 'expire2' and (dbo.DateDiffWeekDay(getdate(),_762)< 11)) OR
		-- (@Options = 'expire1' and (dbo.DateDiffWeekDay(getdate(),_762)< 6)) OR
		-- (@options = 'notRedisclosed' and _761 > _3137) OR 
		-- (@Options = 'ctc' and _2305 >= '2001-01-01' and Log_MS_Lastcompleted <> 'Assign to Close')OR
		-- (@Options = 'UWapprvNotSubmit' and Log_MS_Date_UWDecisionExpected >= '2001-01-01' and coalesce(ld04._CX_CONDITIONSUBMIT_5,ld04._CX_CONDITIONSUBMIT_4,ld04._CX_CONDITIONSUBMIT_3,ld04._CX_CONDITIONSUBMIT_2,ld01._CX_CONDITIONSUBMIT_1 ) is null) OR
	    -- (@Options = 'DocSignNotfund' and _748 >= '2001-01-01' and _CX_FUNDDATE_1 is null) OR
	   
	   -- ((@Options = 'p2weeks' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(_CX_CLSSCHED_1,getdate()) < 11)) and 
		-- (@Options = 'p2weeks' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(_763,getdate()) < 11))) OR
						
	   -- ((@Options = 'p1week' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(getdate(),_CX_CLSSCHED_1) < 6)) OR 
		-- (@Options = 'p1week' and _19 = 'Purchase' and (dbo.DateDiffWeekDay(getdate(),_763) < 6))) OR


		-- ((@Options = 'notSubmittedUW' and (dbo.DateAddWeekDay(1,_CX_APPRRECTRANS_10)) < GETDATE()
									  -- and (dbo.DateAddWeekDay(1,_cx_apppakcomplete)) < GETDATE() 
									  -- and _761 is not null   --761 is lock date								 
		                              -- AND _19 like '%Refi%' and _2298 IS NULL)) or  --_2298 is UW submit date 
		 -- (@Options = 'notSubmittedUW' and (dbo.DateAddWeekDay(1,_cx_apppakcomplete)      ) < GETDATE() 
		                              -- and _19 =  'Purchase' and _2298 is null) OR
		-- --new MC Lane and LC Lane--
							
		-- (@Options = 'McLane' and  Log_MS_Lastcompleted in (	'Processing', 'Assigned to UW','Submittal')) OR
		-- (@Options = 'LcLane' and  Log_MS_Lastcompleted in (	'UW Decision Expected','Conditions Submitted to UW','Assign to Close')) OR				
		-- (@Options = 'MStarted' and Log_MS_Lastcompleted = 'Started') OR
		-- (@Options = 'Mprocessing' and Log_MS_Lastcompleted IN ('Processing', 'App Fee Collected')) OR
		
		-- (@Options = 'MassignedToUW' and Log_MS_Lastcompleted = 'Assigned to UW') OR
		-- (@Options = 'Msubmittal' and Log_MS_Lastcompleted = 'Submittal') OR
		-- (@Options = 'MUWExp' and Log_MS_Lastcompleted = 'UW Decision Expected') OR
		-- (@Options = 'McondSubUW' and Log_MS_Lastcompleted = 'Conditions Submitted to UW') OR
		-- (@Options = 'Mapproval' and Log_MS_Lastcompleted = 'Approval') OR
		-- (@Options = 'MassignToClose' and Log_MS_Lastcompleted = 'Assign to Close') OR
		-- (@Options = 'MdocSigning' and Log_MS_Lastcompleted = 'Doc Signing')
		 -- or
		
		-- (@Options = 'ltv' and ((_2303 > '2000-01-01' and 2301 is null)  or 
		-- (_CX_RESTRUCTUREDTI > '2001-01-01'  and _cx_restdticomplete <> 'Y')or 
		   -- (_CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y')))
		      -- --  and _2301 IS null) OR  -- Milestone-restructure
		-- --(@Options = 'ltv' and _2303 > '2000-01-01') 
		-- --2301 is und approval date
		-- --2303 is und suspended date
		
		
		-- or
		-- (@Options = 'contingency1' and (dbo.DateDiffWeekDay(getdate(),_CX_CONTINGE_1) < 6)) OR
		-- (@Options = 'contingency2' and (dbo.DateDiffWeekDay(getdate(),_CX_CONTINGE_1) < 13)) OR
		-- (@Options = 'LoansToDisclose' and ((Log_MS_Date_Processing > '2001-01-01')and _CX_APPSENT_1 is null)) OR
		
		-- (@Options = 'CondoSubmitted'  and _CX_UWCONDOSUB >= '2001-01-01' and   _CX_UWCONDOAPPR is null) OR
		-- (@Options = 'CondoApproved'  and _CX_UWCONDOAPPR >= '2001-01-01') OR
		
		-- (@Options = '4506TOrdered'  and _CX_4506TORDDTE >= '2001-01-01'	and   _CX_4506TRECDDTE is null) OR
		-- (@Options = '4506tReceived'  and _CX_4506TRECDDTE >= '2001-01-01' )  
		-- --(@Options = 'Brokered' and isnull(ls09.lockrate_2278,'') <> '' and ls09.LOCKRATE_2278 <> inv.lockrate_2278) OR
		-- --(@Options = 'Brokered' and _2626 = 'Brokered')
		-- )
	
	-- and 
		-- isnull(_CX_FUNDDATE_1,'') = ''
		 
	-- and   -- Allow Prequal addresses when the milestione is greater than 'started'
		-- address1 not like(
		-- case when Log_MS_Lastcompleted = 'Started' 
			-- then   'Prequal%' else ''
		-- end )
		
		
	 
	-- and _763 >= '2012-01-01'    -- est closing date
	-- and (loanFolder not in ('(Archive)','(Trash)',  'Closed Loans',
							 -- 'Completed Loans','Samples','Adverse Loans', 'To Archive', 
							 -- 'Adverse 1', 'Adverse 2', 'Adverse 3', 'Adverse 4', 'Adverse 5',
							  -- 'Adverse 6', 'GRIOnline - Testing' ))
	-- and _1393 = 'Active Loan'
	-- -- and _420 <> 'Second Lien'	-- removed per matt harmon on 06/27/13
								 
								 -- --removed adverse loan folder as an exclusion - per mike d on 6/19/12.
								 -- --added _749 - change date to exclude adversed loans.
	-- and 
		-- (  ---- get employee(s)
		-- (@GroupBy = 'MC' and 
			-- (rtrim(ltrim(LoanTeamMember_UserID_MortgageConsultant)) in 
				-- (select SPLITVALUES 
			-- from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,LoanTeamMember_UserID_MortgageConsultant), ','))))
			
		-- OR (@GroupBy = 'LC' AND 
			-- (rtrim(ltrim(LoanTeamMember_UserID_LoanCoordinator)) in 
				-- (select SPLITVALUES 
			-- from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee, LoanTeamMember_UserID_LoanCoordinator), ','))))
			
		-- OR  (@GroupBy = 'VP' AND 
		-- (rtrim(ltrim(_CX_FINALOCODE_4))in 
				-- (select SPLITVALUES 
			-- from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,_CX_FINALOCODE_4), ','))))
			
					
		-- OR  (@GroupBy = 'PM' AND 
		-- (rtrim(ltrim(_cx_locode_1))in 
				-- (select SPLITVALUES 
			-- from dbo.DelimitedListToVarcharTableVariable(isnull(@Employee,_cx_locode_1), ','))))	
			    -- )
		
	-- and     -- get userid (logon)johne
		-- ( 
			-- @UserName in (e.Userlogin, empLC.userlogin, empmc.userlogin, sa.userlogin, sb.userlogin, sc.userlogin) --VP, LC, MC, each SA
		  -- or
		-- @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(dem.empid), ',')) --MGR
		  -- or

				-- @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(empMC.employeeid), ',')) --MGR
		  -- or
		  		-- @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(empLC.employeeid), ',')) --MGR
         -- OR
-- --Was this: @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.allmanagers(dem.empid), ',')) --MGR
		  
		-- @UserName in ('smueller', 'dgorman','dkalinofski', 'abisharat', 'amaloney', 'andrewc','dmoran', 'amargin', 
		-- 'frankc', 'johne', 'mknopf' , 'bconn', 'jweaver','robs','mdye', 'nathanasiou', 'rjones', 
		-- 'sstephen', 'slevitt', 'tgrimm', 'kswanseen', 'ghafner', 'proos', 'mchaput', 'dkalinofski',
		-- 'tbrown', 'klach', 'mmargosein', 'mhamer' , 'tlangdon', 'cong', 'sboers', 'tlangdon', 'egarner', 
		-- 'cstackhouse', 'ahardas', 'cmorgan', 'jpike', 'lauge', 'lmann', 'vhenderson', 'ltitiyevsky' , 'sstephen',			 
		-- 'ghafner', 'mward', 'KShattuck', 'ylopez', 'pgillenwater', 'jpugh', 'nejohnson', 'tgamache', 'jdowney', 'mharmon',
		-- 'alexanderm', 'egarner', 'mmunoz', 'kwoodruff', 'cstackhouse', 'dnates', 'jatkocaitis', 'eyanaki', 'jmorgan', 'sbarcomb', 'lbrictson',
		-- 'rcorro', 'romahoney', 'mkaufman'
		
		-- ) 
		-- )
GO
