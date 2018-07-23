SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[LoanStatusLoanData]
AS
SELECT
	[Guid] AS LoanID,
	ls.XRefId,
	LoanOfficerID AS LoanOfficerUserID,
	LoanOfficerName,
	_2298 AS UnderwritingSubmittalDate,
	_2301 AS ApprovedWithConditionsDate,
	_2301 AS UnderwritingApprovalDate,
	_2305 AS ClearToCloseDate,
	_2305 AS UnderwritingClearToCloseDate,
	_2313 AS UnderwritingAUSRunDate,
	_682 AS FirstPaymentDueDate,
	_745 AS StartDate,
	_748 AS ClosedDate,
	_CX_APPRCVD_1 AS ApplicationReceivedDate,
	_CX_APPRDUE_4 AS AppraisalDueDate,
	_CX_APPSENT_1 AS ApplicationSentDate,
	_CX_CLSSCHED_1 AS ScheduledCloseDate,
	_CX_FUNDDATE_1 AS FundedDate,
	_CX_PREAPPROVORDER_1 AS PreApprovedDate,
	_763 AS EstimatedCloseDate,
	Log_MS_Date_Approval AS ApprovalDate,
	_CX_APPRORDERTRANS_10 AS AppraisalOrderedDate,
	_CX_APPRRECTRANS_10 AS AppraisalReceivedDate,
	Log_MS_Date_UWDecisionExpected AS UnderwritingDecisionExpectedDate,
	_CX_CRRPTORDERED AS CreditReportOrderedDate,
	_SERVICE_X32 AS LastPaymentRecdDate,
	_SERVICE_X14 AS NextPaymentDate,
	LOCKRATE_2151 AS LockExpirationDate,
	_2630 AS PurchaseDate,
	_3514 AS InvFirstPayDate,
	_CX_APPPAKCOMPLETE AS ApplicationCompletedDate,
	Log_MS_Date_Processing AS ProcessingDate,
	_3 AS InterestRate,
	_11 AS SubjectPropertyStreet,
	_1240 AS BorrowerEmail,
	_1268 AS CoBorrowerEmail,
	_13 AS SubjectPropertyCounty,
	_14 AS SubjectPropertyState,
	_66 AS PhoneNumber,
	_97 AS CoBorrowerId,
	_CX_CLSTIME_1 AS ScheduledCloseTime,
	_12 AS SubjectPropertyCity,
	_1401 AS LoanProgram,
	_364 AS LoanNumber,
	_15 AS SubjectPropertyZIP,
	_1822 AS RealtyAgentName,
	_65 AS BorrowerId,
	_CX_FINALOCODE_4 AS FixedLoanOfficerId,
	_SERVICE_X8 AS LoanServiceTransferred,
	_VEND_X152 AS SellingRealtorEmail,
	_VEND_X263 AS InvestorName,
	_4000 AS BorrowerFirstName,
	_4002 AS BorrowerLastName,
	_4004 AS CoBorrowerFirstName,
	_4006 AS CoBorrowerLastName,
	_1416 AS BillingAddress,
	_1417 AS BillingCity,
	_1418 AS BillingState,
	_1419 AS BillingZip,
	_CX_SERVLNNUMBER AS ServicerLoanNumber,
	_CX_LOANSERVICER AS LoanServicer,
	_VEND_X178 AS Servicer,
	_VEND_X179 AS ServicerAddress,
	_VEND_X180 AS ServicerCity,
	_VEND_X181 AS ServicerState,
	_VEND_X182 AS ServicerZip,
	_VEND_X185 AS ServicerPhoneNumber,
	_CX_PARTXCHANGE_ID AS PartnerExchangeID,
	LOCKRATE_1401 AS Investor,
	_2 AS TotalLoanAmount,
	_2211 AS PurchasePrinciple,
	_19 AS LoanPurpose,
	_1811 AS ResidenceType


From emdbuser.LoanSummary ls
	INNER JOIN emdbuser.LOANXDB_D_01 ld01 ON ls.XrefId = ld01.XrefId
	INNER JOIN emdbuser.LOANXDB_D_02 ld02 ON ls.XrefId = ld02.XrefId
	INNER JOIN emdbuser.LOANXDB_D_03 ld03 ON ls.XrefId = ld03.XrefId
	INNER JOIN emdbuser.LOANXDB_D_04 ld04 ON ls.XrefId = ld04.XrefId
	INNER JOIN emdbuser.LOANXDB_N_01 ln01 ON ls.XrefId = ln01.XrefId
	INNER JOIN emdbuser.LOANXDB_N_02 ln02 ON ls.XrefId = ln02.XrefId
	INNER JOIN emdbuser.LOANXDB_N_07 ln07 ON ls.XrefId = ln07.XrefId
	INNER JOIN emdbuser.LOANXDB_N_12 ln12 ON ls.XrefId = ln12.XrefId
	INNER JOIN emdbuser.LOANXDB_S_01 ls01 ON ls.XrefId = ls01.XrefId
	INNER JOIN emdbuser.LOANXDB_S_02 ls02 ON ls.XrefId = ls02.XrefId
	INNER JOIN emdbuser.LOANXDB_S_03 ls03 ON ls.XrefId = ls03.XrefId
	INNER JOIN emdbuser.LOANXDB_S_04 ls04 ON ls.XrefId = ls04.XrefId
	INNER JOIN emdbuser.LOANXDB_S_05 ls05 ON ls.XrefId = ls05.XrefId
	INNER JOIN emdbuser.LOANXDB_S_06 ls06 ON ls.XrefId = ls06.XrefId
	INNER JOIN emdbuser.LOANXDB_S_07 ls07 ON ls.XrefId = ls07.XrefId
	INNER JOIN emdbuser.LOANXDB_S_13 ls13 ON ls.XrefId = ls13.XrefId
	INNER JOIN emdbuser.LOANXDB_S_16 ls16 ON ls.XrefId = ls16.XrefId
	
WHERE (NOT (ls04._LOANFOLDER IN ('(Trash)', 'Samples', 'Adverse Loans')))

--UNION ALL

--SELECT
--	ls.[Guid] AS LoanID,
--	ls.XRefId,
--	ls.LoanOfficerID AS LoanOfficerUserID,
--	ls.LoanOfficerName,
--	_2298 AS UnderwritingSubmittalDate,
--	_2301 AS ApprovedWithConditionsDate,
--	_2301 AS UnderwritingApprovalDate,
--	_2305 AS ClearToCloseDate,
--	_2305 AS UnderwritingClearToCloseDate,
--	_2313 AS UnderwritingAUSRunDate,
--	_682 AS FirstPaymentDueDate,
--	_745 AS StartDate,
--	_748 AS ClosedDate,
--	_CX_APPRCVD_1 AS ApplicationReceivedDate,
--	_CX_APPRDUE_4 AS AppraisalDueDate,
--	_CX_APPSENT_1 AS ApplicationSentDate,
--	_CX_CLSSCHED_1 AS ScheduledCloseDate,
--	_CX_FUNDDATE_1 AS FundedDate,
--	_CX_PREAPPROVORDER_1 AS PreApprovedDate,
--	_763 AS EstimatedCloseDate,
--	Log_MS_Date_Approval AS ApprovalDate,
--	_CX_APPRORDERTRANS_10 AS AppraisalOrderedDate,
--	_CX_APPRRECTRANS_10 AS AppraisalReceivedDate,
--	Log_MS_Date_UWDecisionExpected AS UnderwritingDecisionExpectedDate,
--	_CX_CRRPTORDERED AS CreditReportOrderedDate,
--	_SERVICE_X32 AS LastPaymentRecdDate,
--	_SERVICE_X14 AS NextPaymentDate,
--	LOCKRATE_2151 AS LockExpirationDate,
--	_2630 AS PurchaseDate,
--	'' AS InvFirstPayDate,
--	_CX_APPPAKCOMPLETE AS ApplicationCompletedDate,
--	Log_MS_Date_Processing AS ProcessingDate,
--	_3 AS InterestRate,
--	_11 AS SubjectPropertyStreet,
--	_1240 AS BorrowerEmail,
--	_1268 AS CoBorrowerEmail,
--	_13 AS SubjectPropertyCounty,
--	_14 AS SubjectPropertyState,
--	_66 AS PhoneNumber,
--	_97 AS CoBorrowerId,
--	_CX_CLSTIME_1 AS ScheduledCloseTime,
--	_12 AS SubjectPropertyCity,
--	_1401 AS LoanProgram,
--	_364 AS LoanNumber,
--	_15 AS SubjectPropertyZIP,
--	_1822 AS RealtyAgentName,
--	_65 AS BorrowerId,
--	_CX_FINALOCODE_4 AS FixedLoanOfficerId,
--	_SERVICE_X8 AS LoanServiceTransferred,
--	_VEND_X152 AS SellingRealtorEmail,
--	_VEND_X263 AS InvestorName,
--	_4000 AS BorrowerFirstName,
--	_4002 AS BorrowerLastName,
--	_4004 AS CoBorrowerFirstName,
--	_4006 AS CoBorrowerLastName,
--	_1416 AS BillingAddress,
--	_1417 AS BillingCity,
--	_1418 AS BillingState,
--	_1419 AS BillingZip,
--	'' AS ServicerLoanNumber,
--	_CX_LOANSERVICER AS LoanServicer,
--	'' AS Servicer,
--	'' AS ServicerAddress,
--	'' AS ServicerCity,
--	'' AS ServicerState,
--	'' AS ServicerZip,
--	'' AS ServicerPhoneNumber,
--	NULL AS PartnerExchangeID,
--	LOCKRATE_1401 AS Investor,
--	_2 AS TotalLoanAmount,
--	_2211 AS PurchasePrinciple,
--	_19 AS LoanPurpose,
--	_1811 AS ResidenceType

--From CHILHQSQ02DEV.emdb.emdbuser.LoanSummary ls
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_D_01 ld01 ON ls.XrefId = ld01.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_D_02 ld02 ON ls.XrefId = ld02.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_D_03 ld03 ON ls.XrefId = ld03.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_D_04 ld04 ON ls.XrefId = ld04.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_N_01 ln01 ON ls.XrefId = ln01.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_N_02 ln02 ON ls.XrefId = ln02.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_N_07 ln07 ON ls.XrefId = ln07.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_01 ls01 ON ls.XrefId = ls01.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_02 ls02 ON ls.XrefId = ls02.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_03 ls03 ON ls.XrefId = ls03.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_04 ls04 ON ls.XrefId = ls04.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_05 ls05 ON ls.XrefId = ls05.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_06 ls06 ON ls.XrefId = ls06.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_07 ls07 ON ls.XrefId = ls07.XrefId
--	INNER JOIN CHILHQSQ02DEV.emdb.emdbuser.LOANXDB_S_13 ls13 ON ls.XrefId = ls13.XrefId
--	LEFT OUTER JOIN CHILHQSQ02DEV.[Admin].emdbuser.LoanSummary ls2 ON ls.[Guid] = ls2.[Guid]
	
--WHERE (ls2.[Guid] IS NULL) AND (NOT (ls04._LOANFOLDER IN ('(Trash)', 'Samples', 'Adverse Loans')))

GO
