SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [secmktg].[EncompassDataTest]
AS
SELECT LEFT(ls02._364, 13) AS [LoanNumber],
	LEFT(ls01._37, 35) AS [BorrowerLastName],
	ls02._1401 AS [LoanProgram],
	ln01._3 AS [NoteRate],
	LEFT(ls01._11, 30) AS [SubjectPropertyStreet],
	LEFT(ls02._12, 15) AS [SubjectPropertyCity],
	ls01._14 AS [SubjectPropertyState],
	LEFT(REPLACE(ls03._15, '-', ''), 9) AS [SubjectPropertyZip],
	ls01._1811 AS [Occupancy],
	ln01._353 AS [LTV],
	ln02._VASUMM_X23 AS [FICO],
	ls01._1041 AS [SubjectPropertyType],
	LEFT(ls03._1051, 20) AS [TransDetailsMERSMINNum],
	ISNULL(CONVERT(varchar(20), NULLIF (ln01._689, 0)), '') AS [ARMMargin], 
	ISNULL(CONVERT(varchar(20), NULLIF (ln03._1699, 0)), '') AS [ARMFloorRate],
	CASE 
		WHEN CONVERT(CHAR(10), ld04._3054, 101) IS NULL THEN '' 
		ELSE CONVERT(CHAR(10), ld04._3054, 101)
	END AS [FirstPymtAdjDate],
	ISNULL(CONVERT(varchar(20), NULLIF (ln02._4, 0)), '') AS [LoanTerm],
	ls03._299 AS [LoanInfoRefiPurpose],
	ls03._675 AS [PrepymtMayWillNotPenalty],
	CASE
		WHEN (_CX_AUSSOURCE_2 = 'DU') AND (LEN(ls01._MORNET_X4) < 11) THEN ls01._MORNET_X4
		ELSE ''
	END AS [FannieMaeMORNETPlusCaseFileID],
	ls04._1039 AS [LoanInfoSectionOfHousingAct],
	ls05._L248 AS [MtgInsCoName],
	LEFT(ls02._CX_MICERTNUM, 12) AS [MICertNumber],
	ISNULL(CONVERT(varchar(20), NULLIF (ln01._1107, 0)), '') AS [InsuranceMtgInsUpfrontFactor],
	LEFT(ls02._CX_SFC1, 3) AS [SpecialFeatureCode1],
	LEFT(ls02._CX_SFC2, 3) AS [SpecialFeatureCode2],
	LEFT(ls02._CX_SFC3, 3) AS [SpecialFeatureCode3],
	LEFT(ls02._CX_SFC4, 3) AS [SpecialFeatureCode4],
	LEFT(ls02._CX_SFC5, 3) AS [SpecialFeatureCode5],
	LEFT(ls02._CX_SFC6, 3) AS [SpecialFeatureCode6],
	ls02._1012 AS [SubjectPropertyProjectClassification],
	ls02._18 AS [SubjectPropertyYrBuilt],
	ISNULL(CONVERT(varchar(20), NULLIF (ROUND(ln02._356, 15, 2), 0)), '') AS [SubjectPropertyAppraisedValue],
	ISNULL(CONVERT(varchar(20), NULLIF (ln01._136, 0)), '') AS [PurchasePrice],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_BEDROOMS_1, 0)), '') AS [Bedrooms1],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_BEDROOMS_2, 0)), '') AS [Bedrooms2],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_BEDROOMS_3, 0)), '') AS [Bedrooms3],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_BEDROOMS_4, 0)), '') AS [Bedrooms4],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_RENT_1, 0)), '') AS [Rent1],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_RENT_2, 0)), '') AS [Rent2],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_RENT_3, 0)), '') AS [Rent3],
	ISNULL(CONVERT(varchar(20), NULLIF (ln09._CX_RENT_4, 0)), '') AS [Rent4],
	LEFT(REPLACE(ls03._65, '-', ''), 10) AS [BorrSSN],
	ls04._1524 AS [BorrRaceAmericanIndian],
	ls04._1525 AS [BorrRaceAsian],
	ls04._1526 AS [BorrRaceBlack],
	ls04._1527 AS [BorrRaceNativeHawaiian],
	ls04._1528 AS [BorrRaceWhite],
	ls04._1529 AS [BorrRaceInfoNotProvided],
	ls04._1530 AS [BorrRaceNotApplicable],
	ls04._1523 AS [BorrEthnicity],
	CEILING(ln01._1389) AS [IncomeTotalMoIncomeBorrCoBorr],
	ls04._1532 AS [CoBorrRaceAmericanIndian],
	ls04._1533 AS [CoBorrRaceAsian],
	ls04._1534 AS [CoBorrRaceBlack],
	ls04._1535 AS [CoBorrRaceNativeHawaiian], 
	ls04._1536 AS [CoBorrRaceWhite],
	ls04._1537 AS [CoBorrRaceInfoNotprovided],
	ls04._1538 AS [CoBorrRaceNotApplicable],
	ls04._1531 AS [CoBorrEthnicity],
	CASE 
		WHEN CONVERT(CHAR(10), ld01._1402, 101) IS NULL THEN ''
		ELSE CONVERT(CHAR(10), ld01._1402, 101) 
	END AS [BorrDOB],
	CASE 
		WHEN CONVERT(CHAR(10), ld02._1403, 101) IS NULL THEN ''
		ELSE CONVERT(CHAR(10), ld02._1403, 101) 
	END AS [CoBorrDOB], 
	ABS(ln02._38) AS [BorrAge],
	ABS(ISNULL(CONVERT(varchar(20), NULLIF (ln01._70, 0)), '')) AS [CoBorrAge],
	ls02._471 AS [BorrSexMaleFemale],
	ls03._478 AS [CoBorrSexMaleFemale],
	LEFT(ls05._4004, 30) AS [CoBorrFirstName],
	LEFT(ls05._4006, 35) AS [CoBorrLastName],
	LEFT(ls02._4001, 30) AS [BorrMiddleName],
	ls02._4003 AS [BorrSuffixName], 
	LEFT(ls02._4005, 30) AS [CoBorrMiddleName],
	ls02._4007 AS [CoBorrSuffixName],
	LEFT(REPLACE(ls01._97, '-', ''), 10) AS [CoBorrSSN],
	LEFT(ls05._4000, 30) AS [BorrFirstName],
	CEILING(ln03._1742) AS [ExpensesTotalPrimaryExpenses],
	ls01._608 AS [TransDetailsAmortType],
	ISNULL(CONVERT(varchar(20), NULLIF (ln02._695, 0)), '') AS [LoanInfoARMRateCap],
	ln07._SERVICE_X57 AS [UPB],
	ln06._SERVICE_X82 AS [OrigPIPmt],
	ISNULL(CONVERT(CHAR(10), ld01._1994, 101), '') AS [NoteDate],
	ls08._1298 AS [ProjectName],
	ls04._CX_UWMIPCT_5 AS [MILossCov], 
	CEILING(ln02._912) AS [MonthlyHousingExp],
	ls03._SERVICE_X4 AS [BorrMailingAdd],
	ls03._SERVICE_X5 AS [BorrMailingCity],
	ls03._SERVICE_X6 AS [BillingState],
	LEFT(REPLACE(ls03._SERVICE_X7, '-', ''), 9) AS [BillingZip],
	ln06._SERVICE_X20 AS [MonthlyEscrow],
	ln01._231 AS [EscrowMonthlyAmountCounty],
	ln03._L268 AS [EscrowMonthlyAmountCity],
	ls01._230 AS [EscrowMonthlyAmountHazard],
	ls01._232 AS [MonthlyAmountMIPPMIInsurance], 
	ln02._235 AS [MonthlyFlood],
	CONVERT(money, ln10._253) AS [MonthlyStateTax],
	CONVERT(money, ln10._1630) AS [MonthlyEQIns],
	ls08._661 AS [OtherInsDesc],
	ln10._254 AS [MonthlyOtherIns],
	ln07._SERVICE_X81 AS [EscrowBal],
	LEFT(REPLACE(ls01._3238, '-', ''), 12) AS [NMLSNumber],
	LEFT(REPLACE(ls04._974, '-', ''), 21) AS [AppraiserLicNum],
	LEFT(REPLACE(ls01._3243, '-', ''), 21) AS [SupervisoryAppraiserLicNum],
	CASE 
		WHEN ld03._Service_X15 < CURRENT_TIMESTAMP THEN CONVERT(CHAR(10), ld03._SERVICE_X15, 101) 
		ELSE CONVERT(CHAR(10), DATEADD(m, -1, CAST(CAST(YEAR(ld01._682) AS VARCHAR(4)) + '/' + CAST(MONTH(ld01._682) AS VARCHAR(2)) + '/01' AS DATETIME)), 101) 
	END AS [InterestPaidtoDate],
	CASE
		WHEN ISNUMERIC(LEFT(ls01._2288, 10)) = 1
		THEN LEFT(_2288, 10)
		ELSE ''
	END AS [InvestorLoanNum],
	ls02._CX_AUSSOURCE_2 AS [AUSTYPE],
	ls02._CX_AUSRECOMMENDATION_2 AS [AUSRecommendation],
	ISNULL(CONVERT(CHAR(10), ld02._3142, 101), '') as [AppDate], 
	ls03._CX_UWREQMI AS [MI],
	ISNULL(CONVERT(CHAR(10), ld04._ULDD_X17, 101), '') AS [PriceLockDatetime],
	ISNULL(CONVERT(CHAR(10), ld04._ULDD_X30, 101), '') AS [PropertyValuationEffectiveDate],
	ISNULL(CONVERT(CHAR(10), ld04._ULDD_X58, 101), '') AS [NextRateAdjustmentEffectiveDate],
	ln10._ULDD_X3 AS [AggregateLoanCurtailmentAmount],
	ln10._ULDD_X56 AS [DelinquentPaymentsOverPastTwelveMonthsCount],
	ln10._ULDD_X59 AS [PerChangeRateAdjustmentFrequencyMonthsCount],
	ln10._ULDD_X169 AS [PerChangeMaximumIncreaseRatePercent],
	ln10._ULDD_X138 AS [ProjectDwellingUnitsSoldCount],
	ln10._ULDD_X176 AS [ProjectDwellingUnitCount],
	ln10._ULDD_X168 AS [PerChangeMaximumDecreaseRatePercent],
	ln10._ULDD_X105 AS [ClosingCostContributionAmount], 
	ln10._ULDD_X110 AS [OtherFundsCollectedAtClosingAmount],
	ls10._ULDD_X7 AS [CapitalizedLoanIndicator],
	ls10._ULDD_X9 AS [SharedEquityIndicator],
	ls10._ULDD_X8 AS [RelocationLoanIndicator],
	ls10._ULDD_X31 AS [AppraisalIdentifier],
	ls12._ULDD_X32 AS [AVMModelNameType],
	ls12._ULDD_X89 AS [DownPaymentSourceType],
	ls12._ULDD_X67 AS [InvestorCollateralProgramIdentifier],
	ls12._ULDD_X24 AS [CounselingFormatType], 
	CASE
		WHEN ls01._2356 LIKE '%1004%' THEN '1004'
		WHEN ls01._2356 LIKE '%1007%' THEN '1007'
		WHEN ls01._2356 LIKE '%1025%' THEN '1025'
		WHEN ls01._2356 LIKE '%1073%' THEN '1073'
		WHEN ls01._2356 LIKE '%1075%' THEN '1075'
		WHEN ls01._2356 LIKE '%2055%' THEN '2055'
		WHEN ls01._2356 LIKE '%2075%' THEN '2075'
		WHEN ls01._2356 LIKE '%2090%' THEN '2090'
		WHEN ls01._2356 LIKE '%2095%' THEN '2095'
		WHEN ls01._2356 LIKE '2-4%' THEN '2-4'
		WHEN ls01._2356 LIKE 'Condo Appraisal%' THEN 'Condo'
		WHEN ls01._2356 LIKE 'FHA%' THEN 'FHA'
		WHEN ls01._2356 LIKE '%piw%' THEN 'PIW'
		WHEN ls01._2356 LIKE '%property inspection waiver%' THEN 'PIW'
		WHEN ls01._2356 LIKE 'No appraisal%' THEN 'NoAppraisal'
		WHEN ls01._2356 LIKE 'Other%' THEN 'Other'
		ELSE ls01._2356
	END AS [PropertyValuationMethodType],
	ls12._ULDD_X172 AS [ConstructionMethodType],
	ls12._ULDD_X143 AS [ProjectAttachmentType],
	ls12._ULDD_X120 AS [LegalEntityType],
	ls12._ULDD_X140 AS [ProjectDesignType],
	ls12._ULDD_X177 AS [AttachmentType],
	ls12._ULDD_X28 AS [CondominiumProjectStatusType],
	ls01._19 AS [ConstructionLoanIndicator],
	ls04._934 AS [BorrowerFirstTimeHomebuyerIndicator],
	ls03._965 AS [CitizenshipResidencyType1],
	ls01._985 AS [CitizenshipResidencyType2], 
	ls04._352 AS [RelatedInvestorLoanIdentifier], 
	'100' AS [InvestorOwnershipPercent], 
	'Lender' AS [LoanOriginatorType], 
	'Mailing' AS [AddressType],
	ls04._1066 AS [PropertyEstateType],
	ls05._541 AS [FloodZone],
	ls05._CX_INSFLDPOLICYNO AS [FloodPolicyNo],
	CASE
		WHEN ls06._1414<=ls06._1450 AND ls01._67>=ls06._1450 THEN ls06._1450
		WHEN ls01._67<=ls06._1450 AND ls06._1414>=ls06._1450 THEN ls06._1450
		WHEN ls06._1450<=ls06._1414 AND ls01._67>=ls06._1414 THEN ls06._1414 
		WHEN ls01._67<=ls06._1414 AND ls06._1450>=ls06._1414 THEN ls06._1414 
		WHEN ls06._1450<=ls01._67 AND ls06._1414>=ls01._67 THEN ls01._67 
		WHEN ls06._1414<=ls01._67 AND ls06._1450>=ls01._67 THEN ls01._67 
		ELSE ''
	END AS [BorrMiddleScore],
	CASE
		WHEN ls06._1414<=ls06._1450 AND ls01._67>=ls06._1450 THEN 'TransUnion' 
		WHEN ls01._67<=ls06._1450 AND ls06._1414>=ls06._1450 THEN 'TransUnion'
		WHEN ls06._1450<=ls06._1414 AND ls01._67>=ls06._1414 THEN 'Equifax' 
		WHEN ls01._67<=ls06._1414 AND ls06._1450>=ls06._1414 THEN 'Equifax'
		WHEN ls06._1450<=ls01._67 AND ls06._1414>=ls01._67 THEN 'Experian' 
		WHEN ls06._1414<=ls01._67 AND ls06._1450>=ls01._67 THEN 'Experian' 
		ELSE ''
	END AS [BorrCreditRepositorySourceType],
	CASE
		WHEN ls06._1415<=ls06._1452 AND ls01._60>=ls06._1452 THEN ls06._1452 
		WHEN ls01._60<=ls06._1452 AND ls06._1415>=ls06._1452 THEN ls06._1452
		WHEN ls06._1452<=ls06._1415 AND ls01._60>=ls06._1415 THEN ls06._1415 
		WHEN ls01._60<=ls06._1415 AND ls06._1452>=ls06._1415 THEN ls06._1415 
		WHEN ls06._1452<=ls01._60 AND ls06._1415>=ls01._60 THEN ls01._60 
		WHEN ls06._1415<=ls01._60 AND ls06._1452>=ls01._60 THEN ls01._60 
		ELSE ''
	END AS [CoBorrMiddleScore],
	CASE
		WHEN ls06._1415<=ls06._1452 AND ls01._60>=ls06._1452 THEN 'TransUnion' 
		WHEN ls01._60<=ls06._1452 AND ls06._1415>=ls06._1452 THEN 'TransUnion'
		WHEN ls06._1452<=ls06._1415 AND ls01._60>=ls06._1415 THEN 'Equifax'
		WHEN ls01._60<=ls06._1415 AND ls06._1452>=ls06._1415 THEN 'Equifax' 
		WHEN ls06._1452<=ls01._60 AND ls06._1415>=ls01._60 THEN 'Experian' 
		WHEN ls06._1415<=ls01._60 AND ls06._1452>=ls01._60 THEN 'Experian' 
		ELSE ''
	END AS [CoBorrCreditRepositorySourceType],
	ls06._HMDA_X15 AS [HMDARateSpreadPercent],
	ls12._2847 AS [CounselingConfirmationType], 
	ls08._1108 AS [CoBorrFirstTimeHomebuyer],
	ls04._CASASRN_X13 AS [FreddieMacLPKeyNum],
	ls07._CX_LOANSERVICER AS [LoanServicer],
	LEFT(ls16._3050, 10) AS [FNMCPMProjectID],
	ls12._466 AS [PermanentResidentAlienB1], 
	ls12._467 AS [PermanentResidentAlienB2],
	ls12._ULDD_X18 AS [RefinanceCashOutType],
	ls12._ULDD_X11 AS [InterestCalculationType], 
	ls12._ULDD_X106 AS [ClosingCostFundsType], 
	ld01._CX_FUNDDATE_1 AS [DateFunded]
FROM emdbuser.LOANXDB_D_02 AS ld02 INNER JOIN
	emdbuser.LOANXDB_D_01 AS ld01 ON ld02.XrefId = ld01.XrefId INNER JOIN
	emdbuser.LOANXDB_D_03 AS ld03 ON ld02.XrefId = ld03.XrefId INNER JOIN
	emdbuser.LOANXDB_D_04 AS ld04 ON ld02.XrefId = ld04.XrefId INNER JOIN
	emdbuser.LOANXDB_N_01 AS ln01 ON ld02.XrefId = ln01.XrefId INNER JOIN
	emdbuser.LOANXDB_N_02 AS ln02 ON ld02.XrefId = ln02.XrefId INNER JOIN
	emdbuser.LOANXDB_N_03 AS ln03 ON ld02.XrefId = ln03.XrefId INNER JOIN
	emdbuser.LOANXDB_N_04 AS ln04 ON ld02.XrefId = ln04.XrefId INNER JOIN
	emdbuser.LOANXDB_N_06 AS ln06 ON ld02.XrefId = ln06.XrefId INNER JOIN
	emdbuser.LOANXDB_N_07 AS ln07 ON ld02.XrefId = ln07.XrefId INNER JOIN
	emdbuser.LOANXDB_N_08 AS ln08 ON ld02.XrefId = ln08.XrefId INNER JOIN
	emdbuser.LOANXDB_N_09 AS ln09 ON ld02.XrefId = ln09.XrefId INNER JOIN
	emdbuser.LOANXDB_N_10 AS ln10 ON ld02.XrefId = ln10.XrefId INNER JOIN
	emdbuser.LOANXDB_S_01 AS ls01 ON ld02.XrefId = ls01.XrefId INNER JOIN
	emdbuser.LOANXDB_S_02 AS ls02 ON ld02.XrefId = ls02.XrefId INNER JOIN
	emdbuser.LOANXDB_S_03 AS ls03 ON ld02.XrefId = ls03.XrefId INNER JOIN
	emdbuser.LOANXDB_S_04 AS ls04 ON ld02.XrefId = ls04.XrefId INNER JOIN
	emdbuser.LOANXDB_S_05 AS ls05 ON ld02.XrefId = ls05.XrefId INNER JOIN
	emdbuser.LOANXDB_S_06 AS ls06 ON ld02.XrefId = ls06.XrefId INNER JOIN
	emdbuser.LOANXDB_S_07 AS ls07 ON ld02.XrefId = ls07.XrefId INNER JOIN
	emdbuser.LOANXDB_S_08 AS ls08 ON ld02.XrefId = ls08.XrefId INNER JOIN
	emdbuser.LOANXDB_S_09 AS ls09 ON ld02.XrefId = ls09.XrefId INNER JOIN
	emdbuser.LOANXDB_S_10 AS ls10 ON ld02.XrefId = ls10.XrefId INNER JOIN
	emdbuser.LOANXDB_S_12 AS ls12 ON ld02.XrefId = ls12.XrefId INNER JOIN
	emdbuser.LOANXDB_S_16 AS ls16 ON ld02.XrefId = ls16.XrefId

GO
