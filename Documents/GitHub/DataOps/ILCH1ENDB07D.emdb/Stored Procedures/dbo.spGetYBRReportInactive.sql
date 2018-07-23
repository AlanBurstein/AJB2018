SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spGetYBRReportInactive]
	@UserName varchar(max),
	@GroupBy varchar(10),
	@Employee varchar(max) = null,
	@Options varchar(max)
	
AS

-- -- For Testing Purposes:

--DECLARE @UserName varchar(max)
--DECLARE @GroupBy varchar(10)
--DECLARE @Employee varchar(max)
--DECLARE @Options varchar(max)
----DECLARE @EmployeeInfoKey varchar(max)

--SET @UserName = 'jmavalankar'
--SET @GroupBy = 'VP'
--SET @Employee = '11669'
--SET @Options = 'missingFromYBR'

SELECT rp.AllowViewEmployeeInfoKey
	INTO #EmpInfoKey
	FROM LoanWarehouse.dbo.dimEmployeeInfo ei
	INNER JOIN LoanWarehouse.dbo.ReportPermission rp
	ON rp.EmployeeInfoKey = ei.EmployeeInfoKey
	WHERE ei.RowStatusTypeID = 1
	AND rp.ReportTypeID = 2		
	AND (ei.UserLogin = @UserName OR ei.EncompassLogin = @UserName)
	AND rp.AllowViewEmployeeInfoKey IN 
		(SELECT ei.EmployeeInfoKey 
		FROM LoanWarehouse.dbo.dimEmployeeInfo ei 
		where ei.EmployeeID IN (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(@Employee, ','))
		)
	
CREATE TABLE #EmpInfoKeyTemp
(Employeeinfokey int
,EmployeeID int null
--,UserLogin varchar(255) null
--,EmployeeName varchar(1000) null
)


	INSERT INTO #EmpInfoKeyTemp
	SELECT Employeeinfokey, EmployeeID --, UserLogin, EmployeeName
	FROM LoanWarehouse.dbo.dimEmployeeInfo
	WHERE RowStatusTypeID = 1 
	and EmployeeInfoKey IN (SELECT AllowViewEmployeeInfoKey FROM #EmpInfoKey)

SELECT
	lf.LoanInfoKey as LoanInfoKey
INTO #LoanInfoKeyTemp	
FROM LoanWarehouse.dbo.factLoan lf
	INNER JOIN LoanWarehouse.dbo.dimLoanInfo dli ON dli.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.factLoanDates fld ON fld.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.dimEmployeeInfo eilo ON lf.EmployeeInfoKey_LO = eilo.EmployeeInfoKey
	inner JOIN LoanWarehouse.dbo.dimEmployeeInfo eilc ON lf.EmployeeInfoKey_LC = eilc.EmployeeInfoKey
	inner JOIN LoanWarehouse.dbo.dimEmployeeInfo eimc ON lf.EmployeeInfoKey_MC = eimc.EmployeeInfoKey
	LEFT OUTER JOIN #EmpInfoKeyTemp eiklo ON eiklo.Employeeinfokey = lf.EmployeeInfoKey_LO -- MAVA ADDED
	LEFT OUTER JOIN #EmpInfoKeyTemp eikmc ON eikmc.Employeeinfokey = lf.EmployeeInfoKey_MC -- MAVA ADDED
	LEFT OUTER JOIN #EmpInfoKeyTemp eiklc ON eiklc.Employeeinfokey = lf.EmployeeInfoKey_LC -- MAVA ADDED
WHERE
		(
		(@Options = 'locked'  AND fld.LockedDate >= '2001-01-01' AND fld.LockExpirationDate > GETDATE())
		OR (@Options = 'expire' AND fld.LockExpirationDate < GETDATE()) 
		OR (@Options = 'float' AND  fld.LockedDate is null) 
		OR (@Options = 'all' AND lf.IsFunded = 0) 
		OR (@Options = 'purchase' AND dli.LoanPurposeID = 6) 
		OR (@Options = 'refinance' AND dli.LoanPurposeID <> 6) 
		OR (@Options = 'appNotReturned'   AND fld.ApplicationOutDate > '2001-01-01' AND fld.PartialApplicationReceivedDate IS NULL) 
		OR (@Options = 'aprslNotReceived' AND fld.AppraisalOrderedDate >  '2001-01-01' AND fld.AppraisalReceivedDate  IS Null) 
		OR (@Options = 'expire3' AND (dbo.DateDiffWeekDay(getdate(), fld.LockExpirationDate) < 16)) 
		OR (@Options = 'expire2' AND (dbo.DateDiffWeekDay(getdate(), fld.LockExpirationDate) < 11)) 
		OR (@Options = 'expire1' AND (dbo.DateDiffWeekDay(getdate(), fld.LockExpirationDate) < 6)) 
		OR (@Options = 'missingFromYBR' AND (fld.EstimatedClosingDate IS NULL OR
		( IsPrequalifiedLoan = 1 and dli.LoanMilestoneID in ( 0,16, 21 ))
		))
		OR (@Options = 'notRedisclosed' AND fld.LockedDate > fld.GFELastDisclosedDate)
		--OR (@Options = 'ctc' AND cast(convert(varchar(10), fld.ClearToCloseDate, 112) as int) >= 20010101 AND dli.LoanMilestoneID <> 3) -- is not 'Assign to Close')
		OR (@Options = 'ctc' AND fld.ClearToCloseDate >= '2001-01-01' AND dli.LoanMilestoneID <> 3) -- is not 'Assign to Close')
		OR (@Options = 'UWapprvNotSubmit' AND fld.UnderwritingDecisionExpectedDate >= '2001-01-01' AND fld.ConditionsSubmittedDate is null) 
		OR (@Options = 'DocSignNotfund' AND fld.EstimatedClosingDate >= '2001-01-01' AND fld.FundedDate is null) 
		OR ((@Options = 'p2weeks' AND dli.LoanPurposeID = 6 AND (dbo.DateDiffWeekDay(fld.EstimatedClosingDate, getdate()) < 11)) AND 
			(@Options = 'p2weeks' AND dli.LoanPurposeID = 6 AND (dbo.DateDiffWeekDay(fld.EstimatedClosingDate,getdate()) < 11))) 
		OR ((@Options = 'p1week' AND dli.LoanPurposeID = 6 AND (dbo.DateDiffWeekDay(getdate(), fld.EstimatedClosingDate) < 6)) OR 
			(@Options = 'p1week' AND dli.LoanPurposeID = 6 AND (dbo.DateDiffWeekDay(getdate(),fld.EstimatedClosingDate) < 6))) 
		OR ((@Options = 'notSubmittedUW' AND (dbo.DateAddWeekDay(1, fld.AppraisalReceivedDate)) < GETDATE()
									  AND (dbo.DateAddWeekDay(1, fld.ApplicationReceivedDate)) < GETDATE() 
									  AND fld.LockedDate is not null   --761 is lock date								 
		                              AND dli.LoanPurposeID IN (3, 5) AND fld.UnderwritingSubmissionDate IS NULL)) or  --_2298 is UW submit date 
		 (@Options = 'notSubmittedUW' AND (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)      ) < GETDATE() 
		                              AND dli.LoanPurposeID = 6 AND fld.UnderwritingSubmissionDate is null) 
		--new MC Lane AND LC Lane--
							
		OR (@Options = 'McLane' AND  dli.LoanMilestoneID in (4, 14)) -- 'Sent to processing', 'Assigned to UW','Submittal'
		OR (@Options = 'LcLane' AND  dli.LoanMilestoneID in (3, 8, 18)) --	'UW Decision Expected','Conditions Submitted to UW','Assign to Close'
		OR (@Options = 'MStarted' AND dli.LoanMilestoneID = 16) -- 'Started'
		OR (@Options = 'Mprocessing' AND dli.LoanMilestoneID = 1) -- ('Processing', 'App Fee Collected')) 
		
		OR (@Options = 'MassignedToUW' AND dli.LoanMilestoneID = 4) -- 'Assigned to UW'
		-- OR (@Options = 'Msubmittal' AND lm.DisplayLoanMilestoneName = 'Submittal')  -- Removed because LM name Submittal does not exist
		OR (@Options = 'MUWExp' AND dli.LoanMilestoneID = 18) -- 'UW Decision Expected'
		OR (@Options = 'McondSubUW' AND dli.LoanMilestoneID = 8) -- 'Conditions Submitted to UW') 
		-- OR (@Options = 'Mapproval' AND lm.DisplayLoanMilestoneName = 'Approval') -- Removed because LM name Approval does not exist
		OR (@Options = 'MassignToClose' AND dli.LoanMilestoneID = 3)  -- 'Assign to Close') 
		OR (@Options = 'MdocSigning' AND dli.LoanMilestoneID = 10) -- 'Doc Signing')
		
		OR (@Options = 'ltv' AND dli.LoanMilestoneID = 20) -- 'Restructured - LTV, DTI, UW Suspended')	   	
		
		OR (@Options = 'contingency1' AND (dbo.DateDiffWeekDay(getdate(), fld.ContingencyDate) < 6)) 
		OR (@Options = 'contingency2' AND (dbo.DateDiffWeekDay(getdate(), fld.ContingencyDate) < 13)) 
		OR (@Options = 'LoansToDisclose' AND ((fld.SentToProcessingDate > '2001-01-01') AND fld.ApplicationOutDate is null)) 
		OR (@Options = 'CondoSubmitted' AND dli.PropertyTypeID IN (1,3,5,11) AND fld.UnderwritingSubmissionDate >= '2001-01-01' AND fld.UnderwritingApprovalDate is null) 
		OR (@Options = 'CondoApproved'  AND dli.PropertyTypeID IN (1,3,5,11) AND fld.UnderwritingApprovalDate >= '2001-01-01') 
		
		OR (@Options = '4506TOrdered' AND fld.Date4506TOrder >= '2001-01-01' AND fld.Date4506TReceived is null) 
		OR (@Options = '4506tReceived' AND fld.Date4506TReceived >= '2001-01-01' )
		OR (@Options = 'digitalMortgage' AND lf.IsDigitalMortgageLoan = 1 )  
		
		)
		
	AND lf.IsFunded = 0
	
-- Allow Prequal addresses when the milestione is greater than 'started'
	AND (
		(@Options <> 'missingFromYBR' and lf.IsPrequalifiedLoan = 0 OR (lf.IsPrequalifiedLoan = 1 AND dli.LoanMilestoneID not in( 16,21 ) ))
		OR
		(@Options = 'missingFromYBR' and lf.IsPrequalifiedLoan = 0 OR (lf.IsPrequalifiedLoan = 1 AND dli.LoanMilestoneID in( 16,21 ) ))	
	)
		
	AND (fld.EstimatedClosingDate >= '2012-01-01' 
			AND @Options <> 'missingFromYBR' 
			OR (@Options = 'missingFromYBR' AND fld.EstimatedClosingDate IS NULL)
		)     -- est closing date
	
	AND (dli.LoanFolder NOT IN ('(Archive)','(Trash)',  'Closed Loans',
							 'Completed Loans','Samples','Adverse Loans', 'To Archive', 
							 'Adverse 1', 'Adverse 2', 'Adverse 3', 'Adverse 4', 'Adverse 5',
							  'Adverse 6', 'GRIOnline - Testing' ))
    and ( 
			lf.EmployeeInfoKey_LO IN (SELECT Employeeinfokey FROM #EmpInfoKeyTemp) 
			or lf.EmployeeInfoKey_MC IN (SELECT Employeeinfokey FROM #EmpInfoKeyTemp) 
			or lf.EmployeeInfoKey_LC IN (SELECT Employeeinfokey FROM #EmpInfoKeyTemp) 
		)
	and lf.FundedDate = 0
	and (
		(@Options <> 'missingFromYBR' and IsValidLoan = 1)  or ( IsPrequalifiedLoan = 1 and dli.LoanMilestoneID not in ( 0,16, 21 ))
		OR
		(@Options = 'missingFromYBR' and IsValidLoan = 1)  or ( IsPrequalifiedLoan = 1 and dli.LoanMilestoneID in ( 0,16, 21 ))
		) 
	AND dli.LoanStatusID = 1
	
	AND 
		(  ---- get employee(s)
			(@GroupBy = 'MC' AND eimc.EmployeeID IN (SELECT EmployeeID FROM #EmpInfoKeyTemp))
			OR (@GroupBy = 'LC' AND eilc.EmployeeID IN (SELECT EmployeeID FROM #EmpInfoKeyTemp))
			OR (@GroupBy = 'VP' AND eilo.EmployeeID IN (SELECT EmployeeID FROM #EmpInfoKeyTemp)	)		
		)
	
	
SELECT
	lf.FundedDate as_CX_FUNDDATE_1,
   
	eilo.EmployeeID as loanofficerid,
    fld.EstimatedClosingDate as _763,
    llp.DisplayLoanLienPositionName AS _420,

	eilc.EmployeeName as  LCName,
	
	eilc.UserLogin AS LoanTeamMember_UserID_LoanCoordinator,
	
	eimc.EmployeeName as  MCName,
	
	eimc.UserLogin as LoanTeamMember_UserID_MortgageConsultant,
	
	eilo.EmployeeName AS LicensedVP,

	eilo.EmployeeName AS VP,

	eilo.employeeId as pdVPCode,
	
	eilo.UserLogin as pdVPlogin,

	DATEDIFF(d,getdate(), fld.LockExpirationDate) as daysLocked,
	getdate() as compareDate,
	r.SalesRegionName AS region,
	cc.costcenter, 
	cc.costcentername,
	dli.LoanFolder as LoanFolder,

	dli.LoanNumber as LoanNumber,
	fld.ContingencyDate as _CX_CONTINGE_1,

	fld.UnderwritingApprovalDate as _2301,
	fld.UnderwritingSuspendedDate as _2303,
	ct.ChannelTypeName as _2626,
	

	lm.SortOrder as MilestoneOrder,

	lmg.LoanMilestoneGroupName AS PrevMilestoneGroup,
 	  

	bi.BorrowerFirstName AS FirstName,
	bi.BorrowerLastName AS LastName,

	lp.DisplayLoanPurposeName as LoanPurpose,
		
	Case 
		when dli.PropertyTypeID IN (1,3,5,11) then 'Condo'
		else pt.DisplayPropertyTypeName 
	End as  PropertyType,
	
	
	i.DisplayInvestorName AS 'Investor', 

	ct.DisplayChannelTypeName as 'broker2626',

	
	lf.LoanAmount AS LoanAmount,

	fld.LoanOriginationDate as OrigDate,
	fld.LockedDate as LockDate,

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

		
	CASE 
		when  fld.LockedDate is null and (fld.AppraisalReceivedDate > '2001-01-01') 
		                   and ( fld.AppraisalOrderedDate > '2001-01-01')
		                    and (dli.LoanPurposeID <> 6) then '#FFE4E1'
		when (dbo.DateAddWeekDay(2, fld.LoanOriginationDate)) < getdate() and fld.LockedDate is null then '#FFFFCC'
	END as LockColor,
		

	
	CASE 
		when  fld.LockedDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) then 'Red'
	END as LockColor2,

	
	CASE 
		when ((dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) < getdate() and fld.LockedDate is null ) Or 
		  (fld.LockedDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate))) then 1
		else 0
	END as count_Lock,

	
	CASE 
		when ((dbo.DateAddWeekDay(2,fld.LoanOriginationDate)) < getdate() and fld.LockedDate is null ) Or 
		  (fld.LockedDate > (dbo.DateAddWeekDay(2,fld.LoanOriginationDate)))  or fld.LockedDate is null then 0
		else 1
	END as countOK_Lock,
	

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

	
	fld.SentToProcessingDate as SentToProc,
	

	CASE	

	when (dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) < getdate() and fld.ApplicationOutDate is null then '#FFFFCC'
    END AS AppOutColor,


    
	CASE	

		when fld.ApplicationOutDate > (dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) then 'Red'
	END AS AppOutColor2, 
	

	
	CASE	

		when ((dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) < getdate() and fld.ApplicationOutDate is null) or
	  (fld.ApplicationOutDate > (dbo.DateAddWeekDay(1,fld.SentToProcessingDate))) then 1 else 0
	 END AS count_AppOut, 
	
	 
	 CASE	

		when ((dbo.DateAddWeekDay(1,fld.SentToProcessingDate)) < getdate() and fld.ApplicationOutDate is null) or
	  (fld.ApplicationOutDate > (dbo.DateAddWeekDay(1,fld.SentToProcessingDate)))
	  or  fld.ApplicationOutDate is null then 0 else 1
	 END AS countOK_AppOut, 
 
	
	fld.ApplicationOutDate as AppOut,
	fld.PartialApplicationReceivedDate as AppIn,
		
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
	
	CASE 
	when (lf.IsAppraisalRequired <> 0 and dli.LoanTypeID <> 5 and fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate is null) OR
	( lf.IsAppraisalRequired <> 0 and dli.LoanTypeID = 5 and fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate is null) then '#FFFFCC'
		END as AprslOrdColor,

		CASE 
	when (lf.IsAppraisalRequired <> 0 and dli.LoanTypeID <> 5 and fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.SentToProcessingDate ) OR
	( lf.IsAppraisalRequired <> 0 and dli.LoanTypeID = 5 and fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.PartialApplicationReceivedDate) then 'Red'
	END as AprslOrdColor2,

	CASE 
		when (lf.IsAppraisalRequired <> 0 and dli.LoanTypeID <> 5 and (fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate is null))
			OR (lf.IsAppraisalRequired <> 0 and dli.LoanTypeID <> 5 and (fld.SentToProcessingDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.SentToProcessingDate))		 
			OR (lf.IsAppraisalRequired <> 0 and dli.LoanTypeID = 5 and (fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate is null)) 
			OR (lf.IsAppraisalRequired <> 0 and dli.LoanTypeID = 5 and (fld.PartialApplicationReceivedDate > '2001-01-01' and fld.AppraisalOrderedDate > fld.PartialApplicationReceivedDate))
		THEN 1 ELSE 0
	END as Count_AprslOrd,
  
	
	
	CASE 
		WHEN (lf.IsAppraisalRequired <> 0 AND dli.LoanTypeID <> 5 AND fld.SentToProcessingDate > '2001-01-01' AND fld.AppraisalOrderedDate IS NULL)
			OR (lf.IsAppraisalRequired <> 0 AND dli.LoanTypeID <> 5 AND fld.SentToProcessingDate > '2001-01-01' AND fld.AppraisalOrderedDate > fld.SentToProcessingDate)
			OR (lf.IsAppraisalRequired <> 0 AND dli.LoanTypeID = 5 AND fld.PartialApplicationReceivedDate > '2001-01-01' AND fld.AppraisalOrderedDate IS NULL) 
			OR (lf.IsAppraisalRequired <> 0 AND dli.LoanTypeID = 5 AND fld.PartialApplicationReceivedDate > '2001-01-01' AND fld.AppraisalOrderedDate > fld.PartialApplicationReceivedDate)
		THEN 0 ELSE 1
	END AS CountOK_AprslOrd,
	
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

	CASE	--when refi
		WHEN  (fld.AppraisalReceivedDate > '2001-01-01' AND fld.ApplicationReceivedDate  > '2001-01-01' 
		        AND (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate) < GETDATE() AND dbo.DateAddWeekDay(2,fld.ApplicationReceivedDate) < GETDATE()) 
		        AND dli.LoanPurposeID IN (3, 5) AND fld.UnderwritingSubmissionDate IS NULL) 
		      OR  --when purchase
		      (fld.ApplicationReceivedDate  > '2001-01-01'  
		       AND(dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate))  < GETDATE() 
		       AND  dli.LoanPurposeID = 6  AND fld.UnderwritingSubmissionDate IS NULL) 
		THEN '#FFFFCC'
	END AS UWSubmissionColor,
	
	CASE	
		WHEN (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) AND dli.LoanPurposeID IN (3,5)) OR
		     (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) AND dli.LoanPurposeID = 6)
		THEN 'Red'
	END AS UWSubmissionColor2,
	
	CASE	
		WHEN (((dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) < GETDATE()  AND dli.LoanPurposeID IN (3, 5) AND fld.UnderwritingSubmissionDate IS NULL)) 
			OR ((dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) < GETDATE() AND  dli.LoanPurposeID = 6 AND fld.UnderwritingSubmissionDate IS NULL)
			OR (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) AND dli.LoanPurposeID IN (3, 5)) 
			OR (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) AND dli.LoanPurposeID = 6) 
		THEN 1 ELSE 0
	END AS Count_UWSubmission,
	
	CASE	
		WHEN (dli.LoanPurposeID IN (3, 5)
			AND ((((dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)) < GETDATE() AND fld.UnderwritingSubmissionDate IS NULL)) 
			OR (fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(2,fld.AppraisalReceivedDate)))))
			OR (dli.LoanPurposeID = 6
			AND (((dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)) < GETDATE() AND fld.UnderwritingSubmissionDate is null)  
			OR(fld.UnderwritingSubmissionDate > (dbo.DateAddWeekDay(1,fld.ApplicationReceivedDate)))
			OR fld.UnderwritingSubmissionDate IS NULL))
		THEN 0 ELSE 1
	END AS CountOK_UWSubmission,
	
	fld.ClearToCloseDate AS UWCTC,
	fld.EstimatedClosingDate as EstClosingDate, 
	fld.LockExpirationDate as LockExpiration,

	CASE	
		WHEN ((dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate) < GETDATE()) 
			AND lf.DivisionInfoKey = 3 
			AND fld.ConditionsSubmittedDate IS NULL) 
			OR ((dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate) < GETDATE()) 
			AND lf.DivisionInfoKey <> 3 AND fld.ConditionsSubmittedDate IS NULL) 
		THEN '#FFFFCC'
	END AS CondSubmitColor,
	
	CASE	
		WHEN (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate)) AND lf.DivisionInfoKey = 3) 
		OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate))AND lf.DivisionInfoKey <> 3) THEN 'Red'
	END AS CondSubmitColor2,
	
	CASE	
		WHEN ((dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate) < GETDATE()) AND lf.DivisionInfoKey = 3 AND fld.ConditionsSubmittedDate IS NULL) 
			OR ((dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate) < GETDATE()) AND lf.DivisionInfoKey <> 3 AND fld.ConditionsSubmittedDate IS NULL) 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate))AND lf.DivisionInfoKey = 3) 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate))AND lf.DivisionInfoKey <> 3) 
		THEN 1 ELSE 0
	END AS Count_CondSubmit,
		
	CASE
		WHEN ((lf.DivisionInfoKey = 3 AND ((dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate) < GETDATE()) AND (fld.ConditionsSubmittedDate IS NULL) 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(2,fld.UnderwritingApprovalDate)))))
			OR (lf.DivisionInfoKey <> 3 AND ((dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate) < GETDATE()) AND (fld.ConditionsSubmittedDate IS NULL) 
			OR (fld.ConditionsSubmittedDate > (dbo.DateAddWeekDay(4,fld.UnderwritingApprovalDate))))))	 
			OR fld.ConditionsSubmittedDate is null
		THEN 0 ELSE 1
	END AS CountOK_CondSubmit,
	
	CASE	
		WHEN ((dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate) < GETDATE()) AND fld.ClearToCloseDate IS NULL)  OR
		      ((dbo.DateAddWeekDay(-6,fld.ContingencyDate)< GETDATE() AND dli.LoanPurposeID = 6 AND fld.ClearToCloseDate IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > fld.LockExpirationDate AND dli.LoanPurposeID = 6 AND dli.OccupancyStatusTypeID = 2 AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.LockExpirationDate AND dli.LoanPurposeID IN (3, 5) AND dli.OccupancyStatusTypeID IN (1, 3) AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.EstimatedClosingDate AND dli.LoanPurposeID = 6 AND fld.ClearToCloseDate is null) )
	    THEN '#FFFFCC'
	END AS CTCColor,
	
	CASE	
		WHEN  (fld.ClearToCloseDate > (dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate))) OR
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(-6,fld.ContingencyDate))AND dli.LoanPurposeID = 6))OR 
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(10,fld.LockExpirationDate)) AND dli.LoanPurposeID = 6 AND dli.OccupancyStatusTypeID = 2) ) OR
			  ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(6,fld.LockExpirationDate))  AND dli.LoanPurposeID IN (3, 5) AND dli.OccupancyStatusTypeID IN (1, 3) ) OR
              ((fld.ClearToCloseDate < (dbo.DateAddWeekday(6,fld.EstimatedClosingDate)) AND dli.LoanPurposeID = 6) ))
        then 'Red'
	END AS CTCColor2,
	
	CASE	
		WHEN  ((dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate) < GETDATE()) AND fld.ClearToCloseDate IS NULL)  OR
		      (( dbo.DateAddWeekDay(-6,fld.ContingencyDate)< GETDATE() AND dli.LoanPurposeID = 6 AND fld.ClearToCloseDate IS NULL) )  OR
		      ((dbo.DateAddWeekDay(10,getdate()) > fld.LockExpirationDate AND dli.LoanPurposeID = 6 AND dli.OccupancyStatusTypeID = 2 AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.LockExpirationDate AND dli.LoanPurposeID IN (3, 5) AND dli.OccupancyStatusTypeID IN (1, 3) AND fld.ClearToCloseDate is null)) OR
		      ((dbo.DateAddWeekDay(6,getdate()) > fld.EstimatedClosingDate AND dli.LoanPurposeID = 6 AND fld.ClearToCloseDate is null) ) or
		      (fld.ClearToCloseDate > (dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate))) OR
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(-6,fld.ContingencyDate))AND dli.LoanPurposeID = 6) )OR 
		      ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(10,fld.LockExpirationDate)) AND dli.LoanPurposeID = 6 AND dli.OccupancyStatusTypeID = 2) ) OR
			  ((fld.ClearToCloseDate < (dbo.DateAddWeekDay(6,fld.LockExpirationDate))  AND dli.LoanPurposeID IN (3, 5) AND dli.OccupancyStatusTypeID IN (1, 3) ) OR
              ((fld.ClearToCloseDate < (dbo.DateAddWeekday(6,fld.EstimatedClosingDate)) AND dli.LoanPurposeID = 6) ))
	    THEN 1 else 0
	END AS  Count_CTC,
	
	CASE	
		WHEN dli.LoanPurposeID = 6 AND  
			((fld.ClearToCloseDate <= (dbo.DateAddWeekDay(6,fld.ContingencyDate))) OR
			((fld.ClearToCloseDate >= (dbo.DateAddWeekDay(10, fld.LockExpirationDate)) AND dli.OccupancyStatusTypeID = 2)) OR
			(fld.ClearToCloseDate >= (dbo.DateAddWeekDay(6,fld.EstimatedClosingDate)))) OR
			(dli.LoanPurposeID IN (3, 5) AND dli.OccupancyStatusTypeID IN (1, 3) AND 
			(fld.ClearToCloseDate >= (dbo.DateAddWeekDay(6,fld.LockExpirationDate)))) OR
			fld.ClearToCloseDate <= ((dbo.DateAddWeekDay(2,fld.ConditionsSubmittedDate))) 
		THEN 1 else 0
	END AS CountOK_CTC,

	fld.UnderwritingSuspendedDate AS UWSuspended,

    fld.ConditionsSubmittedDate as CondSubmit,
    lp.DisplayLoanPurposeName AS proptype,

	eisa.userlogin AS SALogin,

	fld.ApplicationReceivedDate AS _cx_apppakcomplete,
	fld.ApprovalReviewedDate AS APPROVALreviewed,

		
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
    fld.CondoPUDApprovalIssued,
    lf.IsOnlinePricingLoan, -- added by Mava on 5-29-15
    lf.IsDigitalMortgageLoan, -- added by Mava on 5-29-15
    lf.OptimalBlueCorporateObjective as [CorpObj], -- added by Mava on 5-29-15
    lf.CorporateObjective AS [YSP],  -- added by Mava on 5-29-15
    CASE 
		when  lf.IsDigitalMortgageLoan = 1 
		then 'Lime'
	END as DigitalMortgageColor -- added by Mava on 5-29-15

FROM LoanWarehouse.dbo.factLoan lf
	INNER JOIN LoanWarehouse.dbo.dimLoanInfo dli ON dli.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.factLoanDates fld ON fld.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.dimEmployeeInfo eilo ON lf.EmployeeInfoKey_LO = eilo.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eilc ON lf.EmployeeInfoKey_LC = eilc.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eimc ON lf.EmployeeInfoKey_MC = eimc.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eisa ON lf.EmployeeInfoKey_SA = eisa.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eiuw ON lf.EmployeeInfoKey_UW = eiuw.EmployeeInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimCostCenterInfo cc ON lf.CostCenterInfoKey = cc.CostCenterInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.dimSalesRegionInfo r ON lf.SalesRegionInfoKey = r.SalesRegionInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.ChannelType ct ON dli.ChannelTypeID = ct.ChannelTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanMilestone lm ON dli.LoanMilestoneID = lm.LoanMilestoneID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanMilestoneGroup lmg ON lmg.LoanMilestoneGroupID = lm.LoanMilestoneGroupID
	LEFT OUTER JOIN LoanWarehouse.dbo.dimBorrowerInfo bi ON bi.BorrowerInfoKey = lf.BorrowerInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanPurpose lp ON dli.LoanPurposeID = lp.LoanPurposeID
	LEFT OUTER JOIN LoanWarehouse.dbo.PropertyType pt ON dli.PropertyTypeID = pt.PropertyTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.Investor i ON dli.InvestorID = i.InvestorID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanLienPosition llp ON dli.LoanLienPositionID = llp.LoanLienPositionID	

WHERE		
		
 lf.LoanInfoKey IN (SELECT LoanInfoKey FROM #LoanInfoKeyTemp)


 drop table #LoanInfoKeyTemp
 drop table #EmpInfoKeyTemp
 drop table #EmpInfoKey
GO
