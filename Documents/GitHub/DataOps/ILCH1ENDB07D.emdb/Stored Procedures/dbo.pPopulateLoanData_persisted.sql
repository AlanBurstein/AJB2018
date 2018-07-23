SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[pPopulateLoanData_persisted] (@batchSize int = 50000)
AS

SET NOCOUNT ON;

-- 1. Get Valid Loan Numbers into #loanNumbers_prep
;-----------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#loanNumbers_prep') IS NOT NULL DROP TABLE #loanNumbers_prep;
SELECT l.LoanNumber
INTO #loanNumbers_prep
FROM loanwarehouse.dbo.dimloaninfo l --( nolock) on l.loanid = ls.xrefid
JOIN emdb.emdbuser.vwLoanSummary vls ON l.LoanInfoKey = vls.LoanInfoKey
LEFT JOIN loanwarehouse.dbo.factloan fl ( nolock ) on l.loaninfokey = fl.loaninfokey
LEFT JOIN LoanWarehouse.dbo.factLoanDates fld ( nolock ) on fld.LoanInfoKey = l.LoanInfoKey
LEFT JOIN loanwarehouse.dbo.dimLoanMetrics as dlm ( nolock )  on dlm.LoanInfoKey = l.LoanInfoKey
LEFT JOIN LoanWarehouse.dbo.LoanType lt ( nolock ) on lt.LoanTypeID = l.LoanTypeID
LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo elo ( nolock ) on elo.EmployeeInfoKey = fl.EmployeeInfoKey_LO
LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo edlo ( nolock ) on edlo.EmployeeInfoKey = fl.EmployeeInfoKey_DLO
LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo emc ( nolock ) on emc.EmployeeInfoKey = fl.EmployeeInfoKey_MC
LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo elc ( nolock ) on elc.EmployeeInfoKey = fl.EmployeeInfoKey_LC
LEFT JOIN LoanWarehouse.dbo.DimSurveyInfo s ( nolock ) on s.SurveyInfoKey = fl.CSSSurveyInfoKey
LEFT JOIN LoanWarehouse.dbo.LoanCompensationType ct ( nolock ) on ct.LoanCompensationTypeID = l.LoanCompensationTypeID
LEFT JOIN LoanWarehouse.dbo.PropertyType pt ( nolock ) on pt.PropertyTypeID = l.PropertyTypeID
LEFT JOIN LoanWarehouse.dbo.LoanPurpose lp ( nolock ) on lp.LoanPurposeID = l.LoanPurposeID
LEFT JOIN LoanWarehouse.dbo.dimBorrowerInfo b ( nolock ) on b.BorrowerInfoKey = fl.BorrowerInfoKey
LEFT JOIN LoanWarehouse.dbo.dimCoBorrowerInfo cb ( nolock ) on cb.CoBorrowerInfoKey = fl.CoBorrowerInfoKey
LEFT JOIN LoanWarehouse.dbo.MaritalStatusType mst ( nolock ) on mst.MaritalStatusTypeID = b.MaritalStatusTypeID
LEFT JOIN LoanWarehouse.dbo.GenderType gt ( nolock ) on gt.GenderTypeID = b.GenderTypeID
LEFT JOIN LoanWarehouse.dbo.dimGeographyInfo g ( nolock ) on g.GeographyInfoKey = fl.GeographyInfoKey
LEFT JOIN LoanWarehouse.dbo.LoanInfoGeographyInfo lg ( nolock ) on lg.LoanInfoKey = l.LoanInfoKey
LEFT JOIN LoanWarehouse.dbo.LoanMilestone m ( nolock ) on m.LoanMilestoneID = l.LoanMilestoneID
LEFT JOIN LoanWarehouse.dbo.OccupancyStatusType o ( nolock ) on o.OccupancyStatusTypeID = l.OccupancyStatusTypeID
LEFT JOIN LoanWarehouse.dbo.EducationLevel e ( nolock ) on e.EducationLevelID = b.EducationLevelID
LEFT JOIN LoanWarehouse.dbo.EthnicityType et ( nolock ) on et.EthnicityTypeID = b.EthnicityTypeID
LEFT JOIN LoanWarehouse.dbo.RaceType r ( nolock ) on r.RaceTypeID = b.RaceTypeID
LEFT JOIN LoanWarehouse.dbo.ChannelType ch ( nolock ) on ch.ChannelTypeID = l.ChannelTypeID
LEFT JOIN LoanWarehouse.dbo.LoanInfoContactInfo lc ( nolock ) on lc.LoanInfoKey = l.LoanInfoKey
LEFT JOIN LoanWarehouse.dbo.LoanReferrer lr ( nolock ) on lr.LoanReferrerID = l.LoanReferrerID
LEFT JOIN LoanWarehouse.dbo.dimClosingRegionInfo cri ( nolock ) on cri.ClosingRegionInfoKey = fl.ClosingRegionInfoKey
LEFT JOIN LoanWarehouse.dbo.LoanProgram lpr ( nolock ) on lpr.LoanProgramID = l.ConfirmedLoanProgramID
LEFT JOIN LoanWarehouse.dbo.Investor i ( nolock ) on i.InvestorID = l.InvestorID
LEFT JOIN LoanWarehouse.dbo.MasterServiceAgreement msa ( nolock ) on msa.MasterServiceAgreementID=l.MasterServiceAgreementID
LEFT JOIN emdb.emdbuser.LoanSummary ls ( nolock ) on ls.xrefid = l.loanid
LEFT JOIN emdb.emdbuser.LOANXDB_S_02 s02 ( nolock ) on s02.XrefId = l.LoanID
LEFT JOIN emdb.emdbuser.LOANXDB_S_01 s01 ( nolock ) on s01.XrefId = s02.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_03 s03 ( nolock ) on s03.XrefId = s02.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_04 s04 ( nolock ) on s04.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_07 s07 ( nolock ) on s07.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_08 s08 ( nolock ) on s08.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_10 s10 ( nolock ) on s10.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_12 s12 ( nolock ) on s12.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_16 s16 ( nolock ) on s16.XRefID = s03.XRefId 
LEFT JOIN emdb.emdbuser.LOANXDB_S_17 s17 ( nolock ) on s17.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_S_20 s20 ( nolock ) on s20.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_D_01 d01 ( nolock ) on d01.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_D_02 d02 ( nolock ) on d02.XrefId = s03.XrefId
LEFT JOIN emdb.emdbuser.LOANXDB_n_01 n01 ( nolock ) on n01.XrefId = s03.XrefId
OPTION (RECOMPILE);

CREATE CLUSTERED INDEX cl_loanData_prep ON #loanNumbers_prep(LoanNumber);

-- 2. Create #loanNumbers, populate and index #loanNumbers
;-----------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#loanNumbers') IS NOT NULL DROP TABLE #loanNumbers;

SELECT RN = ROW_NUMBER() OVER (ORDER BY loanNumber) ,loanNumber
INTO #loanNumbers
FROM (SELECT DISTINCT loanNumber FROM #loanNumbers_prep WHERE LoanNumber > '') x;

CREATE UNIQUE NONCLUSTERED INDEX cl_validLoans_RN ON #loanNumbers(RN)
INCLUDE (loanNumber);

-- 3. Create or Truncate loanData_persisted
;------------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.loanData_persisted') IS NULL
  SELECT TOP (0)
     l.LoanNumber
  	,l.UseNewLeCdGfeHud AS RESPATILA2015LEandCD 
  	,fl.LoanAmount AS LoanAmount 
  	,fl.LoanRate AS InterestRate 
  	,fl.YSPBuySide AS YSP 
  	,fl.BorrowerAge as BorrowerAge
  	,fl.BorrowerCreditScore AS FICO 
  	,fl.DebtToIncomeRatio AS DTI 
  	,fl.IsValidLoan
  	,l.VelocifyLeadID as VelocifyLeadID 
  	,case
  		when fl.CoBorrowerCreditScore=0 OR fl.CoBorrowerCreditScore is null then fl.BorrowerCreditScore
  		when fl.CoBorrowerCreditScore<fl.BorrowerCreditScore then fl.CoBorrowerCreditScore
  		else fl.BorrowerCreditScore
  		end  AS CreditScoreForDec
  	,fl.CorporateObjective AS GrossLOYield
  
  	,fl.RushClosing AS RushToClosing
  	,fl.ActualSellPriceInvestor AS PurchaseAdviceActualSellPrice
  	,fl.ActualSRPInvestor AS PurchaseAdviceActualSellSideSRP
  	,fl.LockSellPriceInvestor AS RateLockSellSideNetBuyPrice 
  	,fl.LockSRPInvestor AS RateLockSellSideSRPPaidOut 
  	,fl.LoanAmountLessPMI AS RateLockLockRequestLoanAmountExcludingMIPPMI
  	,fl.TotalLoanConditions AS NumberofUWConditions
  	,case
  		when fl.IsDigitalMortgageLoan=1 then 'Y'
  		else 'N'
  		end as  DigitalMortgage
  	,case
  		when fl.IsOnlinePricingLoan=1 then 'Y'
  		else 'N'
  		end as DigitalMortgageShortForm
  	,fl.LoanToValue as LTV
  	,fl.BorrowerMonthlyIncome AS IncomeBorrowerBaseIncome
  	,fl.TotalLockPriceInvestor as TotalLockYieldBPs
  	,fl.OptimalBlueCorporateObjective as LoanCO
  	,fl.CorporateObjective as LONetYSP
  	,fl.npspromoter
  	,fl.npsdetractor
  	,fl.npspassive
  	,fl.LoanTerm
  INTO dbo.loanData_persisted
  FROM loanwarehouse.dbo.dimloaninfo l
  JOIN #loanNumbers vl ON l.loanNumber= vl.loanNumber
  LEFT JOIN loanwarehouse.dbo.factloan fl ( nolock ) on l.loaninfokey = fl.loaninfokey
  LEFT JOIN LoanWarehouse.dbo.factLoanDates fld ( nolock ) on fld.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN loanwarehouse.dbo.dimLoanMetrics as dlm ( nolock )  on dlm.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanType lt ( nolock ) on lt.LoanTypeID = l.LoanTypeID
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo elo ( nolock ) on elo.EmployeeInfoKey = fl.EmployeeInfoKey_LO
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo edlo ( nolock ) on edlo.EmployeeInfoKey = fl.EmployeeInfoKey_DLO
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo emc ( nolock ) on emc.EmployeeInfoKey = fl.EmployeeInfoKey_MC
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo elc ( nolock ) on elc.EmployeeInfoKey = fl.EmployeeInfoKey_LC
  LEFT JOIN LoanWarehouse.dbo.DimSurveyInfo s ( nolock ) on s.SurveyInfoKey = fl.CSSSurveyInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanCompensationType ct ( nolock ) on ct.LoanCompensationTypeID = l.LoanCompensationTypeID
  LEFT JOIN LoanWarehouse.dbo.PropertyType pt ( nolock ) on pt.PropertyTypeID = l.PropertyTypeID
  LEFT JOIN LoanWarehouse.dbo.LoanPurpose lp ( nolock ) on lp.LoanPurposeID = l.LoanPurposeID
  LEFT JOIN LoanWarehouse.dbo.dimBorrowerInfo b ( nolock ) on b.BorrowerInfoKey = fl.BorrowerInfoKey
  LEFT JOIN LoanWarehouse.dbo.dimCoBorrowerInfo cb ( nolock ) on cb.CoBorrowerInfoKey = fl.CoBorrowerInfoKey
  LEFT JOIN LoanWarehouse.dbo.MaritalStatusType mst ( nolock ) on mst.MaritalStatusTypeID = b.MaritalStatusTypeID
  LEFT JOIN LoanWarehouse.dbo.GenderType gt ( nolock ) on gt.GenderTypeID = b.GenderTypeID
  LEFT JOIN LoanWarehouse.dbo.dimGeographyInfo g ( nolock ) on g.GeographyInfoKey = fl.GeographyInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanInfoGeographyInfo lg ( nolock ) on lg.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanMilestone m ( nolock ) on m.LoanMilestoneID = l.LoanMilestoneID
  LEFT JOIN LoanWarehouse.dbo.OccupancyStatusType o ( nolock ) on o.OccupancyStatusTypeID = l.OccupancyStatusTypeID
  LEFT JOIN LoanWarehouse.dbo.EducationLevel e ( nolock ) on e.EducationLevelID = b.EducationLevelID
  LEFT JOIN LoanWarehouse.dbo.EthnicityType et ( nolock ) on et.EthnicityTypeID = b.EthnicityTypeID
  LEFT JOIN LoanWarehouse.dbo.RaceType r ( nolock ) on r.RaceTypeID = b.RaceTypeID
  LEFT JOIN LoanWarehouse.dbo.ChannelType ch ( nolock ) on ch.ChannelTypeID = l.ChannelTypeID
  LEFT JOIN LoanWarehouse.dbo.LoanInfoContactInfo lc ( nolock ) on lc.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanReferrer lr ( nolock ) on lr.LoanReferrerID = l.LoanReferrerID
  LEFT JOIN LoanWarehouse.dbo.dimClosingRegionInfo cri ( nolock ) on cri.ClosingRegionInfoKey = fl.ClosingRegionInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanProgram lpr ( nolock ) on lpr.LoanProgramID = l.ConfirmedLoanProgramID
  LEFT JOIN LoanWarehouse.dbo.Investor i ( nolock ) on i.InvestorID = l.InvestorID
  LEFT JOIN LoanWarehouse.dbo.MasterServiceAgreement msa ( nolock ) on msa.MasterServiceAgreementID=l.MasterServiceAgreementID
  LEFT JOIN emdb.emdbuser.LoanSummary ls ( nolock ) on ls.xrefid = l.loanid
  LEFT JOIN emdb.emdbuser.LOANXDB_S_02 s02 ( nolock ) on s02.XrefId = l.LoanID
  LEFT JOIN emdb.emdbuser.LOANXDB_S_01 s01 ( nolock ) on s01.XrefId = s02.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_03 s03 ( nolock ) on s03.XrefId = s02.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_04 s04 ( nolock ) on s04.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_07 s07 ( nolock ) on s07.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_08 s08 ( nolock ) on s08.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_10 s10 ( nolock ) on s10.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_12 s12 ( nolock ) on s12.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_16 s16 ( nolock ) on s16.XRefID = s03.XRefId 
  LEFT JOIN emdb.emdbuser.LOANXDB_S_17 s17 ( nolock ) on s17.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_20 s20 ( nolock ) on s20.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_D_01 d01 ( nolock ) on d01.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_D_02 d02 ( nolock ) on d02.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_n_01 n01 ( nolock ) on n01.XrefId = s03.XrefId
ELSE TRUNCATE TABLE dbo.loanData_persisted;

-- 4. Populate loanData_persisted in @batch-sized batches
;------------------------------------------------------------------------------------------
DECLARE 
  @rows      int = (SELECT COUNT(*) FROM #loanNumbers),
  @i         int = 1;

DECLARE @ii  int = @batchsize;

WHILE @i <= @rows
BEGIN
  INSERT dbo.loanData_persisted
  SELECT 
     l.LoanNumber
  	,l.UseNewLeCdGfeHud AS RESPATILA2015LEandCD 
  	,fl.LoanAmount AS LoanAmount 
  	,fl.LoanRate AS InterestRate 
  	,fl.YSPBuySide AS YSP 
  	,fl.BorrowerAge as BorrowerAge
  	,fl.BorrowerCreditScore AS FICO 
  	,fl.DebtToIncomeRatio AS DTI 
  	,fl.IsValidLoan
  	,l.VelocifyLeadID as VelocifyLeadID 
  	,case
  		when fl.CoBorrowerCreditScore=0 OR fl.CoBorrowerCreditScore is null then fl.BorrowerCreditScore
  		when fl.CoBorrowerCreditScore<fl.BorrowerCreditScore then fl.CoBorrowerCreditScore
  		else fl.BorrowerCreditScore
  		end  AS CreditScoreForDec
  	,fl.CorporateObjective AS GrossLOYield
  
  	,fl.RushClosing AS RushToClosing
  	,fl.ActualSellPriceInvestor AS PurchaseAdviceActualSellPrice
  	,fl.ActualSRPInvestor AS PurchaseAdviceActualSellSideSRP
  	,fl.LockSellPriceInvestor AS RateLockSellSideNetBuyPrice 
  	,fl.LockSRPInvestor AS RateLockSellSideSRPPaidOut 
  	,fl.LoanAmountLessPMI AS RateLockLockRequestLoanAmountExcludingMIPPMI
  	,fl.TotalLoanConditions AS NumberofUWConditions
  	,case
  		when fl.IsDigitalMortgageLoan=1 then 'Y'
  		else 'N'
  		end as  DigitalMortgage
  	,case
  		when fl.IsOnlinePricingLoan=1 then 'Y'
  		else 'N'
  		end as DigitalMortgageShortForm
  	,fl.LoanToValue as LTV
  
  	,fl.BorrowerMonthlyIncome AS IncomeBorrowerBaseIncome
  	,fl.TotalLockPriceInvestor as TotalLockYieldBPs
  	,fl.OptimalBlueCorporateObjective as LoanCO
  	,fl.CorporateObjective as LONetYSP
  	,fl.npspromoter
  	,fl.npsdetractor
  	,fl.npspassive
  	,fl.LoanTerm
  FROM loanwarehouse.dbo.dimloaninfo l
  JOIN #loanNumbers vl ON l.loanNumber= vl.loanNumber
  LEFT JOIN loanwarehouse.dbo.factloan fl ( nolock ) on l.loaninfokey = fl.loaninfokey
  LEFT JOIN LoanWarehouse.dbo.factLoanDates fld ( nolock ) on fld.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN loanwarehouse.dbo.dimLoanMetrics as dlm ( nolock )  on dlm.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanType lt ( nolock ) on lt.LoanTypeID = l.LoanTypeID
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo elo ( nolock ) on elo.EmployeeInfoKey = fl.EmployeeInfoKey_LO
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo edlo ( nolock ) on edlo.EmployeeInfoKey = fl.EmployeeInfoKey_DLO
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo emc ( nolock ) on emc.EmployeeInfoKey = fl.EmployeeInfoKey_MC
  LEFT JOIN LoanWarehouse.dbo.dimEmployeeInfo elc ( nolock ) on elc.EmployeeInfoKey = fl.EmployeeInfoKey_LC
  LEFT JOIN LoanWarehouse.dbo.DimSurveyInfo s ( nolock ) on s.SurveyInfoKey = fl.CSSSurveyInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanCompensationType ct ( nolock ) on ct.LoanCompensationTypeID = l.LoanCompensationTypeID
  LEFT JOIN LoanWarehouse.dbo.PropertyType pt ( nolock ) on pt.PropertyTypeID = l.PropertyTypeID
  LEFT JOIN LoanWarehouse.dbo.LoanPurpose lp ( nolock ) on lp.LoanPurposeID = l.LoanPurposeID
  LEFT JOIN LoanWarehouse.dbo.dimBorrowerInfo b ( nolock ) on b.BorrowerInfoKey = fl.BorrowerInfoKey
  LEFT JOIN LoanWarehouse.dbo.dimCoBorrowerInfo cb ( nolock ) on cb.CoBorrowerInfoKey = fl.CoBorrowerInfoKey
  LEFT JOIN LoanWarehouse.dbo.MaritalStatusType mst ( nolock ) on mst.MaritalStatusTypeID = b.MaritalStatusTypeID
  LEFT JOIN LoanWarehouse.dbo.GenderType gt ( nolock ) on gt.GenderTypeID = b.GenderTypeID
  LEFT JOIN LoanWarehouse.dbo.dimGeographyInfo g ( nolock ) on g.GeographyInfoKey = fl.GeographyInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanInfoGeographyInfo lg ( nolock ) on lg.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanMilestone m ( nolock ) on m.LoanMilestoneID = l.LoanMilestoneID
  LEFT JOIN LoanWarehouse.dbo.OccupancyStatusType o ( nolock ) on o.OccupancyStatusTypeID = l.OccupancyStatusTypeID
  LEFT JOIN LoanWarehouse.dbo.EducationLevel e ( nolock ) on e.EducationLevelID = b.EducationLevelID
  LEFT JOIN LoanWarehouse.dbo.EthnicityType et ( nolock ) on et.EthnicityTypeID = b.EthnicityTypeID
  LEFT JOIN LoanWarehouse.dbo.RaceType r ( nolock ) on r.RaceTypeID = b.RaceTypeID
  LEFT JOIN LoanWarehouse.dbo.ChannelType ch ( nolock ) on ch.ChannelTypeID = l.ChannelTypeID
  LEFT JOIN LoanWarehouse.dbo.LoanInfoContactInfo lc ( nolock ) on lc.LoanInfoKey = l.LoanInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanReferrer lr ( nolock ) on lr.LoanReferrerID = l.LoanReferrerID
  LEFT JOIN LoanWarehouse.dbo.dimClosingRegionInfo cri ( nolock ) on cri.ClosingRegionInfoKey = fl.ClosingRegionInfoKey
  LEFT JOIN LoanWarehouse.dbo.LoanProgram lpr ( nolock ) on lpr.LoanProgramID = l.ConfirmedLoanProgramID
  LEFT JOIN LoanWarehouse.dbo.Investor i ( nolock ) on i.InvestorID = l.InvestorID
  LEFT JOIN LoanWarehouse.dbo.MasterServiceAgreement msa ( nolock ) on msa.MasterServiceAgreementID=l.MasterServiceAgreementID
  LEFT JOIN emdb.emdbuser.LoanSummary ls ( nolock ) on ls.xrefid = l.loanid
  LEFT JOIN emdb.emdbuser.LOANXDB_S_02 s02 ( nolock ) on s02.XrefId = l.LoanID
  LEFT JOIN emdb.emdbuser.LOANXDB_S_01 s01 ( nolock ) on s01.XrefId = s02.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_03 s03 ( nolock ) on s03.XrefId = s02.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_04 s04 ( nolock ) on s04.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_07 s07 ( nolock ) on s07.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_08 s08 ( nolock ) on s08.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_10 s10 ( nolock ) on s10.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_12 s12 ( nolock ) on s12.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_16 s16 ( nolock ) on s16.XRefID = s03.XRefId 
  LEFT JOIN emdb.emdbuser.LOANXDB_S_17 s17 ( nolock ) on s17.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_S_20 s20 ( nolock ) on s20.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_D_01 d01 ( nolock ) on d01.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_D_02 d02 ( nolock ) on d02.XrefId = s03.XrefId
  LEFT JOIN emdb.emdbuser.LOANXDB_n_01 n01 ( nolock ) on n01.XrefId = s03.XrefId
  WHERE vl.RN BETWEEN @i AND @ii --WHERE d02._MS_START >= '2011-01-01'
  OPTION (RECOMPILE);

  SELECT @i += @batchSize, @ii += @batchSize;
END

-- 5. Cleanup
;------------------------------------------------------------------------------------------
DROP TABLE #loanNumbers_prep;
DROP TABLE #loanNumbers;

--1287079 rows affected
-- Same through 5 joins
--1287100 -- next group
--1287115 -- for the rest
-- 1199603 when adding date filter

-- UNIQUE: 1286913

GO
