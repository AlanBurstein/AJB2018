SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[rs_YBR_usingEncompassEmpList3] 
	@UserName varchar(max),
	@GroupBy varchar(10),
	@Employee varchar(max) = null,
	@Options varchar(max)
	--@EmployeeInfoKey int
AS

--SELECT * FROM loanwarehouse.dbo.dimEmployeeInfo WHERE EmployeeID = 630

--DECLARE @UserName varchar(max)
--DECLARE @GroupBy varchar(10)
--DECLARE @Employee varchar(max)
--DECLARE @Options varchar(max)
--DECLARE @EmployeeInfoKey varchar(max)

--SET @UserName = 'narobinson'
--SET @GroupBy = 'MC'
--SET @Employee = '3462'
--SET @Options = 'all'
--SET @EmployeeInfoKey = '4829,2680'

----DROP TABLE #LoanInfoKeyTemp
CREATE TABLE #EmpInfoKeyTemp
(Employeeinfokey int
,EmployeeID int null
,UserLogin varchar(255) null
,EmployeeName varchar(1000) null)

IF (@GroupBy = 'VP')
BEGIN
	INSERT INTO #EmpInfoKeyTemp
	SELECT Employeeinfokey, EmployeeID, UserLogin, EmployeeName
	FROM LoanWarehouse.dbo.dimEmployeeInfo
	WHERE RowStatusTypeID = 1 
	AND EmployeeID IN (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(@Employee, ','))
END
ELSE

-- Mava: Made temp fix for one user so that she can see her YBR
IF (@UserName = 'narobinson' or @UserName = 'nrobinson' )
BEGIN
	SET @UserName = 'nrobinson'
	INSERT INTO #EmpInfoKeyTemp
	select 2756, 3462, 'nrobinson', 'Natasha Robinson'
END
ELSE

-- End of temp fix

BEGIN
	INSERT INTO #EmpInfoKeyTemp
	SELECT Employeeinfokey, EmployeeID, UserLogin, EmployeeName
	FROM LoanWarehouse.dbo.dimEmployeeInfo
	WHERE RowStatusTypeID = 1 
	AND UserLogin IN (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(@Employee, ','))
END

--SELECT * FROM #EmpInfoKeyTemp

--DROP TABLE #EmpInfoKeyTemp


SELECT DISTINCT
	lf.LoanInfoKey as LoanInfoKey
INTO #LoanInfoKeyTemp	
FROM LoanWarehouse.dbo.factLoan lf
	INNER JOIN LoanWarehouse.dbo.dimLoanInfo dli ON dli.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.factLoanDates fld ON fld.LoanInfoKey = lf.LoanInfoKey
	INNER JOIN LoanWarehouse.dbo.dimEmployeeInfo eilo ON lf.EmployeeInfoKey_LO = eilo.EmployeeInfoKey
	inner JOIN LoanWarehouse.dbo.dimEmployeeInfo eilc ON lf.EmployeeInfoKey_LC = eilc.EmployeeInfoKey
	inner JOIN LoanWarehouse.dbo.dimEmployeeInfo eimc ON lf.EmployeeInfoKey_MC = eimc.EmployeeInfoKey
	--LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eisa ON lf.EmployeeInfoKey_SA = eisa.EmployeeInfoKey
	inner join admin.corp.Employee E1 on eilo.EmployeeID = E1.employeeId
	inner join admin.corp.Employee E2 on eilc.EmployeeID = E2.employeeId
	inner join admin.corp.Employee E3 on eimc.EmployeeID = E3.employeeId
	left outer join admin.corp.Employee S1 on E1.salesAssistiantId = S1.employeeId
	left outer join admin.corp.Employee S2 on E2.salesAssistiantId = S2.employeeId
	left outer join admin.corp.Employee S3 on E3.salesAssistiantId = S3.employeeId
	
	--LEFT OUTER JOIN LoanWarehouse.dbo.dimEmployeeInfo eiuw ON lf.EmployeeInfoKey_UW = eiuw.EmployeeInfoKey
	--LEFT OUTER JOIN LoanWarehouse.dbo.dimCostCenterInfo cc ON lf.CostCenterInfoKey = cc.CostCenterInfoKey
	--LEFT OUTER JOIN LoanWarehouse.dbo.dimSalesRegionInfo r ON lf.SalesRegionInfoKey = r.SalesRegionInfoKey
	--LEFT OUTER JOIN LoanWarehouse.dbo.ChannelType ct ON dli.ChannelTypeID = ct.ChannelTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanMilestone lm ON dli.LoanMilestoneID = lm.LoanMilestoneID
	--LEFT OUTER JOIN LoanWarehouse.dbo.LoanMilestoneGroup lmg ON lmg.LoanMilestoneGroupID = lm.LoanMilestoneGroupID
	--LEFT OUTER JOIN LoanWarehouse.dbo.dimBorrowerInfo bi ON bi.BorrowerInfoKey = lf.BorrowerInfoKey
	--LEFT OUTER JOIN LoanWarehouse.dbo.dimCoBorrowerInfo cbi ON cbi.CoBorrowerInfoKey = lf.CoBorrowerInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanPurpose lp ON dli.LoanPurposeID = lp.LoanPurposeID
	--LEFT OUTER JOIN LoanWarehouse.dbo.LoanPurposeGroup lpg ON lpg.LoanPurposeGroupID = lp.LoanPurposeGroupID
	LEFT OUTER JOIN LoanWarehouse.dbo.PropertyType pt ON dli.PropertyTypeID = pt.PropertyTypeID
	--LEFT OUTER JOIN LoanWarehouse.dbo.PropertyTypeGroup ptg ON pt.PropertyTypeGroupID = ptg.PropertyTypeGroupID
	--LEFT OUTER JOIN LoanWarehouse.dbo.Investor i ON dli.InvestorID = i.InvestorID
	--LEFT OUTER JOIN LoanWarehouse.dbo.LoanType lt ON dli.LoanTypeID = lt.LoanTypeID
	--LEFT OUTER JOIN LoanWarehouse.dbo.dimDivisionInfo di ON lf.DivisionInfoKey = di.DivisionInfoKey
	--LEFT OUTER JOIN LoanWarehouse.dbo.OccupancyStatusType ost ON dli.OccupancyStatusTypeID = ost.OccupancyStatusTypeID
	--LEFT OUTER JOIN LoanWarehouse.dbo.LoanLienPosition llp ON dli.LoanLienPositionID = llp.LoanLienPositionID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanStatus ls ON dli.LoanStatusID = ls.LoanStatusID
	--LEFT OUTER JOIN LoanWarehouse.dbo.LoanInfoGeographyInfo ligi ON lf.LoanInfoKey = ligi.LoanInfoKey
	LEFT OUTER JOIN chilhqpsql05.admin.corp.employeeandallmanagers2 dem  on dem.empid =  eilo.employeeId

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
		
		OR (@Options = 'notRedisclosed' AND fld.LockedDate > fld.GFELastDisclosedDate) 
		
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
							
		OR (@Options = 'McLane' AND  lm.DisplayLoanMilestoneName in (	'Sent to processing', 'Assigned to UW','Submittal')) 
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
		
		OR (@Options = 'contingency1' AND (dbo.DateDiffWeekDay(getdate(), fld.ContingencyDate) < 6)) 
		OR (@Options = 'contingency2' AND (dbo.DateDiffWeekDay(getdate(), fld.ContingencyDate) < 13)) 
		OR (@Options = 'LoansToDisclose' AND ((fld.SentToProcessingDate > '2001-01-01') AND fld.ApplicationOutDate is null)) 
		OR (@Options = 'CondoSubmitted' AND pt.DisplayPropertyTypeName LIKE '%condo%' AND fld.UnderwritingSubmissionDate >= '2001-01-01' AND fld.UnderwritingApprovalDate is null) 
		OR (@Options = 'CondoApproved'  AND pt.DisplayPropertyTypeName LIKE '%condo%' AND fld.UnderwritingApprovalDate >= '2001-01-01') 
		
		OR (@Options = '4506TOrdered' AND fld.Date4506TOrder >= '2001-01-01' AND fld.Date4506TReceived is null) 
		OR (@Options = '4506tReceived' AND fld.Date4506TReceived >= '2001-01-01' )  
		OR (@Options = 'digitalMortgage' AND lf.IsDigitalMortgageLoan = 1 )
		
		)
	AND ISNULL(fld.FundedDate,'') = ''
	
		 
	-- AND   -- Allow Prequal addresses when the milestione is greater than 'started'
		-- address1 NOT LIKE (
		-- CASE WHEN lm.DisplayLoanMilestoneName = 'Started' 
			-- THEN 'Prequal%' ELSE ''
		-- END )
	-- Allow Prequal addresses when the milestione is greater than 'started'
	AND (lf.IsPrequalifiedLoan = 0 OR (lf.IsPrequalifiedLoan = 1 AND lm.LoanMilestoneID not in( 16,21 ) )
--	AND (ligi.StreetAddress IS NOT NULL OR (lf.IsPrequalifiedLoan = 1 AND lm.LoanMilestoneID = 16  AND ( isnull( ligi.StreetAddress, '' ) = '') )
			
	)
	
	
	
	
	AND fld.EstimatedClosingDate >= '2012-01-01'    -- est closing date
	AND (dli.LoanFolder NOT IN ('(Archive)','(Trash)',  'Closed Loans',
							 'Completed Loans','Samples','Adverse Loans', 'To Archive', 
							 'Adverse 1', 'Adverse 2', 'Adverse 3', 'Adverse 4', 'Adverse 5',
							  'Adverse 6', 'GRIOnline - Testing' ))
	--AND ls.LoanStatusName = 'Active Loan' mava removed this line since dli.LoanStatusID = 1 is listed a few lines down
		
	--AND ISNULL(fld.FundedDate,'') = ''
	-- old -- and ( lf.EmployeeInfoKey_LO IN (@EmployeeInfoKey) or lf.EmployeeInfoKey_MC IN (@EmployeeInfoKey) or lf.EmployeeInfoKey_LC IN (@EmployeeInfoKey) )
    and ( 
			lf.EmployeeInfoKey_LO IN (SELECT Employeeinfokey FROM #EmpInfoKeyTemp) 
			or lf.EmployeeInfoKey_MC IN (SELECT Employeeinfokey FROM #EmpInfoKeyTemp) 
			or lf.EmployeeInfoKey_LC IN (SELECT Employeeinfokey FROM #EmpInfoKeyTemp) 
		)
	and lf.FundedDate = 0
	and ( IsValidLoan = 1 or ( IsPrequalifiedLoan = 1 and dli.LoanMilestoneID not in ( 0,16, 21 ))) 
	AND dli.LoanStatusID = 1
	
	

	AND 
		(  ---- get employee(s)
			(@GroupBy = 'MC' AND eimc.EmployeeID IN (SELECT EmployeeID FROM #EmpInfoKeyTemp))
			OR (@GroupBy = 'LC' AND eilc.EmployeeID IN (SELECT EmployeeID FROM #EmpInfoKeyTemp))
			OR (@GroupBy = 'VP' AND eilo.EmployeeID IN (SELECT EmployeeID FROM #EmpInfoKeyTemp)	)		
		)
		
		
		
	AND     -- get userid (logon)johne
		(
		@UserName in (eilo.UserLogin, eilc.UserLogin, eimc.UserLogin, s1.UserLogin, s2.UserLogin, s3.UserLogin) --VP, LC, MC, each SA
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(dem.empid), ',')) --MGR
		
		
		-- MAVA test:
		--OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(dem.empid), ',')  where SPLITVALUES <> '' and @Employee = 'lisaa'
		--union select 'scbrown'
		--)
		
		-- end of test
				
		 
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(eimc.EmployeeID), ',')) --MGR
		OR @UserName in (select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable(dbo.AllManagers2(eilc.EmployeeID), ',')) --MGR
		OR @UserName in ('alexanderm','amaloney','amargin','bconn','BMercer','cstackhouse','cmorgan','dkalinofski', 
			'dmoran','egarner','eyanaki','frankc','jatkocaitis','jpike','jpugh','jmorgan','KShattuck','kwoodruff', 
			'lauge','lbrictson','lmann','ltitiyevsky','mchaput','mdye','mhamer','mharmon','mkaufman','mknopf','mmunoz', 
			'mowen','nathanasiou','nejohnson','proos','pvandivier','rcorro','rjones','robs','romahoney','sbarcomb','slevitt',
			'smueller','sstephen','tgamache','tgrimm','tlangdon','ylopez','bcotta','mhayes', 'pkurka', 'jmavalankar'
			,'ltrout', 'ntaylor','mwalsh', 'lschreiber', 'hclark'
			) 
		) 

--SELECT * FROM #LoanInfoKeyTemp

SELECT DISTINCT
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
	--ls.LoanFolder,
	dli.LoanFolder as LoanFolder,

	dli.LoanNumber as LoanNumber,
	--_CX_CONTINGE_1,
	fld.ContingencyDate as _CX_CONTINGE_1,

	fld.UnderwritingApprovalDate as _2301,
	--_2303,
	fld.UnderwritingSuspendedDate as _2303,
    --_2626 ,---<> 'Brokered'
	ct.ChannelTypeName as _2626,
	

	lm.SortOrder as MilestoneOrder,

	lmg.LoanMilestoneGroupName AS PrevMilestoneGroup,
 	  
	--_4000 AS FirstName,
	bi.BorrowerFirstName AS FirstName,
	--_4002 as LastName,
	bi.BorrowerLastName AS LastName,

	lp.DisplayLoanPurposeName as LoanPurpose,
		
	Case 
		when pt.DisplayPropertyTypeName = 'Condominium' then 'Condo'
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
		                    and (lp.DisplayLoanPurposeName <> 'Purchase') then '#FFE4E1'
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
  
	
	
	CASE 
		WHEN (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName <> 'FHA' AND fld.SentToProcessingDate > '2001-01-01' AND fld.AppraisalOrderedDate IS NULL)
			OR (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName <> 'FHA' AND fld.SentToProcessingDate > '2001-01-01' AND fld.AppraisalOrderedDate > fld.SentToProcessingDate)
			OR (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName = 'FHA' AND fld.PartialApplicationReceivedDate > '2001-01-01' AND fld.AppraisalOrderedDate IS NULL) 
			OR (lf.IsAppraisalRequired <> 0 AND lt.DisplayLoanTypeName = 'FHA' AND fld.PartialApplicationReceivedDate > '2001-01-01' AND fld.AppraisalOrderedDate > fld.PartialApplicationReceivedDate)
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
	
	fld.ClearToCloseDate AS UWCTC,
	fld.EstimatedClosingDate as EstClosingDate, 
	fld.LockExpirationDate as LockExpiration,

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
    ISNULL(lf.CorporateObjective, '') AS [YSP],  -- added by Mava on 5-29-15
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
	LEFT OUTER JOIN LoanWarehouse.dbo.dimCoBorrowerInfo cbi ON cbi.CoBorrowerInfoKey = lf.CoBorrowerInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanPurpose lp ON dli.LoanPurposeID = lp.LoanPurposeID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanPurposeGroup lpg ON lpg.LoanPurposeGroupID = lp.LoanPurposeGroupID
	LEFT OUTER JOIN LoanWarehouse.dbo.PropertyType pt ON dli.PropertyTypeID = pt.PropertyTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.PropertyTypeGroup ptg ON pt.PropertyTypeGroupID = ptg.PropertyTypeGroupID
	LEFT OUTER JOIN LoanWarehouse.dbo.Investor i ON dli.InvestorID = i.InvestorID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanType lt ON dli.LoanTypeID = lt.LoanTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.dimDivisionInfo di ON lf.DivisionInfoKey = di.DivisionInfoKey
	LEFT OUTER JOIN LoanWarehouse.dbo.OccupancyStatusType ost ON dli.OccupancyStatusTypeID = ost.OccupancyStatusTypeID
	LEFT OUTER JOIN LoanWarehouse.dbo.LoanLienPosition llp ON dli.LoanLienPositionID = llp.LoanLienPositionID	
	LEFT OUTER JOIN chilhqpsql05.admin.corp.employeeandallmanagers2 dem  on dem.empid =  eilo.employeeId
WHERE		
		
 lf.LoanInfoKey IN (SELECT LoanInfoKey FROM #LoanInfoKeyTemp)
 
 drop table #LoanInfoKeyTemp
 drop table #EmpInfoKeyTemp
GO
