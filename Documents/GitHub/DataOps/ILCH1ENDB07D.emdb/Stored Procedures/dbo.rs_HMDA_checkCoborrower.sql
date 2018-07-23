SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[rs_HMDA_checkCoborrower]
@StartDate datetime,
@EndDate datetime


as
Select
		-------------------------------
		-----HMDA Required Fields------
		-------------------------------

		--Case when cancelled > isnull(note_date,'2010-01-01')  then cancelled
		--	 when denied > isnull(note_date,'2010-01-01') then denied
		--     when note_date > isnull(funded,'2010-01-01') then note_date
		--	 else funded end as 'Action Date',

	ls.LoanNumber as loan_num,
	ls04.Log_MS_LastCompleted as LastMilestoneCompleted,
	ld01._CX_FUNDDATE_1 as fundDate,

	Case 
	when ls04.Log_MS_LastCompleted = 'Completed' and ld01._CX_FUNDDATE_1 is null
	then 'CHECK_FUNDING_DATE' else ''
	end as checkFD,
	ls02._2626 as channel,

	ld01._2298 As submitToUWDATE,
	ls04.Log_MS_LastCompleted,
	
	case
			---ls01._1393 as ACTION -Curent Loan Status: 
		when _CX_FUNDDATE_1 is not null then 1 -- _1393 should be 'Loan Originated'
		-- Otherwise, the loan has not funded; the rest of the choices explain why not...
		when _1393 = 'Active Loan' then null -- Should not happen for closed loans
		when _1393 = 'Loan Originated' then 1 -- Should not happen when there is no funding date
		when _1393 = 'Application approved but not accepted' then 2
		when _1393 = 'Application denied' then 3
		when _1393 = 'Application withdrawn' then 4
		when _1393 = 'File Closed for incompleteness' then 5
		when _1393 = 'Loan purchased by financial institution' then 6  -- Should not happen ("financial institution" means us, and we don't)
		when _1393 = 'Preapproval request denied by financial institution' then 7  -- Should not happen
		when _1393 = 'Preapproval request approved but not accepted' then 8  -- Should not happen
		else null -- Not filled in properly
	end as ACTION,
	ls06._HMDA_X24 as hmdaExclude,
	              --ld01._749 AS   action_date,   ---CurrentStatusDate
	convert(char(10), isnull(_CX_FUNDDATE_1, _749), 101) as  action_date,   
	ls.Address1 as 'Address (Street)',
	
	case
		when _188 = 'Y' and isnull(_479, '') <> 'FaceToFace' then 3
		when _1523 = 'Hispanic or Latino' then 1
		when _1523 = 'Not Hispanic or Latino' then 2
		when _1523 = 'Information not provided' then 3
		--when _1523 = 'Not applicable' then 4  -- Should not happen
		else 3
	end as 'Applicant Ethnicity',
			_479 App_taken_by,
				_4004 as cbfirstname,
				_97 cb_ssn,
				_65_P2 cm_ssn,
				_189 cb_dnwtf ,
				_188_P2   CM_dnwtf,
				
				_1531 cb_ethnicity,
				_1523_P2 cm_ethnicity,
				_478 cb_sex,
				_471_P2 Cm_sex,
				
				
				
				  
	
	CASE	
		WHEN   isnull(_97, '') = '' and isnull(_65_p2, '') = '' --when no co-bor or co-mtgr 
			THEN 5
	    
		WHEN _97 > ''   --when Co-borrower is present use CB ethnicity
			THEN 
				CASE  
					WHEN _1531 = 'Not Hispanic or Latino' 
						THEN 2
					WHEN  (_189 = 'Y' and _479 <> 'FaceToFace') or (_1531 = 'Information not provided')
						THEN 3
					WHEN _1531 = 'Hispanic or Latino' 
						THEN 1
					WHEN _1531 = 'Not applicable' 
						THEN 4
				END 
		 WHEN  _65_P2 > ''  --if coborrower above was null and Co-Mortgager is present use CM ethnicity
			THEN
				CASE 
					WHEN _1523_P2 = 'Not Hispanic or Latino' 
						THEN 2
					WHEN  (_188_P2 = 'Y' and _479 <> 'FaceToFace') or (_1523_P2 = 'Information not provided')
						THEN 3 
					WHEN _1523_P2 = 'Hispanic or Latino' 
						THEN 1
					WHEN _1523_P2 = 'Not applicable' 
						THEN 4
				END 
	END AS 'Co-Applicant Ethnicity',
		
	case
		when _188 = 'Y' and isnull(_479, '') <> 'FaceToFace' then '6'
		when _1524 = 'Y' then '1' 
		when _1525 = 'Y' then '2' 
		when _1526 = 'Y' then '3'
		when _1527 = 'Y' then '4' 
		when _1528 = 'Y' then '5' 
		when _1529 = 'Y' then '6'
		when _1530 = 'Y' then '7' 
	end as 'Applicant Race 1',

	  
'' as 'Applicant Race 2',
'' as 'Applicant Race 3',
'' as 'Applicant Race 4',
'' as 'Applicant Race 5',
	

	ld01._745 as 'Application Date',
	
	ls.LoanNumber as 'Application Number',
	
	case
		when _188 = 'Y' and isnull(_479, '') <> 'FaceToFace' then '3'
		when _471 = 'Male' then '1'
		when _471 = 'Female' then '2'
		when _471 = 'Not Provided/Unknown' then '3'
		--when _471 = 'Not Applicable' then '4'  -- Should not happen
		else '3'
	end as 'Applicant_Sex',
	
	CASE	
		WHEN   isnull(_97, '') = '' and isnull(_65_p2, '') = ''   --when no co-bor or co-mtgr
			THEN 5 
		WHEN _97 > ''   --when Co-borrower is present use CB ethnicity
			THEN 
				CASE  
					WHEN _478 = 'Male' then 1
					WHEN _478 = 'Female' then 2
					WHEN (_189 = 'Y' and _479 <> 'FaceToFace') or _478 = 'Information not provided' THEN 3
				END 
		 WHEN  _65_P2 > ''  --if coborrower above was null and Co-Mortgager is present use CM ethnicity
			THEN
				CASE  
					WHEN _471_P2 = 'Male' then 1
					WHEN _471_P2 = 'Female' then 2
					WHEN (_189 = 'Y' and _479 <> 'FaceToFace') or _471_P2 = 'Information not provided' THEN 3
				END 
	END AS 'Co-Applicant Sex',
	
	CASE	
		when (isnull(_97, '') = '' or _3174 = 'Y') and (isnull(_65_P2, '') = '' )  --when no co-bor or co-mtgr
			THEN 8 
		WHEN _97 > ''   --when Co-borrower is present use CB race
			THEN 
				CASE  
					when (_189 = 'Y' and isnull(_479, '') <> 'FaceToFace') or  _1537 = 'Y' then 6
					when _1532 = 'Y' then 1 
					when _1533 = 'Y' then 2 
					when _1534 = 'Y' then 3
					when _1535 = 'Y' then 4 
					when _1536 = 'Y' then 5 
					when _1538 = 'Y' then 7
				END 
		 WHEN  _65_P2 > ''  --if coborrower above was null and Co-Mortgager is present use CM race
		 	THEN 
				CASE  
					when (_188_P2 = 'Y' and isnull(_479, '') <> 'FaceToFace') or _1529_P2 = 'Y' then 6 
					when _1524_P2 = 'Y' then 1 
					when _1525_P2 = 'Y' then 2 
					when _1526_P2 = 'Y' then 3
					when _1527_P2 = 'Y' then 4 
					when _1528_P2 = 'Y' then 5 
					when _1530_P2 = 'Y' then 7
				END  
	END AS 'Co_Applicant Race 1',
		
	'' as 'Co-Applicant Race 2',
	'' as 'Co-Applicant Race 3',
	'' as 'Co-Applicant Race 4',
	'' as 'Co-Applicant Race 5',

	case ls04._HMDA_X13
		when 'HOEPA Loan' then 'True' -- Should not happen
		else 'False'
	end as 'HOEPA Status', 

	CASE 
		when ls.LienPosition = 'FirstLien' then 'F'
		when ls.LienPosition = 'SecondLien' then 'S'
	End  as 'Lien Status',

	ls.LoanAmount as 'Loan Amount',
	
		
	CASE when ls01._19  = 'Purchase' then 1
		 when ls01._19 = 'Cash-Out Refinance' then 2
		 when ls01._19 = 'NoCash-Out Refinance' then 3
		 else ' '
	END as LoanPurpose,
	
	CASE when ls.LoanType = 'Conventional' then 1
		 when ls.LoanType = 'FHA' then 2
		 when ls.LoanType = 'VA' then 3
		 when ls.LoanType = 'FarmersHomeAdministration' then 4
	END as 'Loan Type',

	CASE
		when ls.OccupancyStatus = 'PrimaryResidence' then 'YES'
		when ls.OccupancyStatus = 'Investor' then 'NO'
		when ls.OccupancyStatus = 'SecondHome' then 'NO'
	END as 'Owner-Occupancy',
	
	Case when lS07._HMDA_X12  = 'Not Applicable' then 3
		 when lS07._HMDA_X12  = 'Preapproval was not requested' then 2
		 when lS07._HMDA_X12  = 'Preapproval was requested' then 1
		 else lS07._HMDA_X12
	END as preapprovals,
	
	
	Case 
		when _HMDA_X11 = 'One-to-fourFamily' then 1 
	    else null
	End AS  'Property Type',
	    
	ln02._1621 as 'num_units',
	
	 'NA' as 'Rate Spread',   --ls06._HMDA_X15 ??
	ld02._DENIAL_X11,
	ld04._DENIAL_X69,
	'' as 'Reasons for Denial 1',
	'' as 'Reasons for Denial 2',
	'' as 'Reasons for Denial 3',
	ls.city as 'City',
	ls.State AS 'State',
	        ---(_1389 * 12) / 1000 as [TINCOME]
	ls.TotalMonthlyIncome * 12  as 'Total Income',
	
case
		when _CX_FUNDDATE_1 is null then '0'
		-- Check the investor name
		when _2278 like 'Fannie %' then '1'
		when _2278 like 'GRI - Fannie %' then '1'
		when _2278 = 'FNMA' then '1'
		when _2278 like 'Freddie %' then '3'
		when _2278 like 'GRI - Freddie %' then '3'
		when _2278 = 'FHLMC' then '3'
		when _2278 in ('', 'A', 'B', 'C') then null  -- Errors that may show up
		else '6' -- Commercial
		
		-- The proper values in the dropdown
		--when 'Loan was not originated or not sold' then '0'  -- Should not happen for funded loans
		--when _1397 = 'Fannie Mae' then '1'
		--when _1397 = 'Ginnie Mae' then '2' -- Should not happen
		--when _1397 = 'Freddie Mac' then '3'
		--when _1397 = 'Farmer Mac' then '4' -- Should not happen
		--when _1397 = 'Private Securitization' then '5' -- Should not happen
		--when _1397 = 'Commercial Bank, Savings Bank, or Savings Association' then '6'
		--when _1397 = 'Life Ins. Company, Credit Union, Mortgage Bank or Finance Company' then '7' -- Should not happen
		--when _1397 = 'Affiliate Institution' then '8' -- Should not happen
		--when _1397 = 'Other type of purchaser' then '9' -- Should not happen
		-- The values actually defined in the field
		--when 'Loan was not originated' then '0' -- Should not happen for funded loans
		--when _1397 = 'FNMA' then '1'  -- 'Fannie Mae'
		--when _1397 = 'GNMA' then '2'  -- 'Ginnie Mae'
		--when _1397 = 'FHLMC' then '3'  -- 'Freddie Mac'
		--when _1397 = 'FAMC' then '4'  -- 'Farmer Mac' -- Should not happen
		--when _1397 = 'Commercial Bank' then '6'
		--when _1397 = 'Savings Bank' then '6'
		--when _1397 = 'Life Insurance Co.' then '7' -- Should not happen
		--else '0'  -- Don't guess
	end as 'Type of Purchaser',
	--_1397, _2278, -- For debugging as 'Type of Purchaser',
	left(ls.Zip,5) AS 'ZIP Code',

---------------------------------
-------HMDA Optional Fields-----
---------------------------------
	ln02._799 as 'APR',
	ls01._13 as   'County Name',

	CASE 
		when ls.Amortization = 'Fixed' then 1
		when ls.Amortization = 'AdjustableRate'  then 2
	END as   'Amortization Type',
	
	ls.Term  as 'Loan Term', 
	CONVERT(decimal(10,0),ls.Term/12) as smc_amortizationTERM,

	CASE when ls.Amortization = 'FIXED' then 1
		 when ls.Amortization = 'AdjustableRate' then 2
    END as  SMC_programTYPE,
    
	ld01._761 as 'Rate Lock Date',
	
	CASE
		 when ls03._479 = 'Telephone' then 'T'
		 when ls03._479 = 'FaceToFace' then 'F'
		 when ls03._479 = 'Internet' then 'I'
		 when ls03._479 = 'Mail' then 'M'
 	END AS  intview_app_method,

-----------------------------------------
-------HMDA User Definable Fields--------
-----------------------------------------
	ls.LTV as LTV,
	ln01._3 as NOTERATE,
	ln02._742 as BERATIO,   --720 Qual ratio top?
	ln04._740 as FERATIO,    --742Qual ratio bottom?
	ls05._2849 as CREDIT_SCORE,
	ln02._38 as BORR_AGE,
	ls.LoanProgram as LOAN_PROGRAM,
	costcenter AS SOURCE,
	
	ls07._NMLS_X3 as DOCTYPE,
	ls.LoanOfficerName as LO,
	ls02._2574 as UND,
	ls02._362 as processor,
	ls17._CX_CLOSER_1 as Closer,
	ln01._70 as coborrowerAge,
	ln02._356 as AppraisedValue,
	ln01._136 as PurchasedPrice,
	ls01._3238 as LO_NMLS,
	o.officename as OfficeName,
	costcenter as branch,
	ls05._SYS_X19 as appraisalFee,
	ls05._SYS_X20 as CrditReportFee ,
	ls05._SYS_X201  as ProcessingFee

	
 	
 				-- HMDA fields in ENCOMPASS - may not be used in this report
				--lS07._HMDA_X11  --1-4 FAM,
				--_HMDA_X13   --NOT A hOEPA LOAN,
				--_HMDA_X14   ---SECIUED BY FIRSTLIEN,
				--LS06._HMDA_X15  --BLANK,
				--_HMDA_X21,  -- denail reasons - most are blank
				--_HMDA_X22,-- denail reasons - most are blank
				--_HMDA_X23,-- denail reasons - most are blank
				--_HMDA_X24,  --SUBJECT PROPERTY EXCLUDED from HMDA
				--lS07._HMDA_X12 as preapprovals, -- all said 'not applicable'
				--LS06._CX_PREAPRVL  -- blank


from
	emdb.emdbuser.Loansummary ls
	LEFT outer join emdb.emdbuser.LOAN  loan on loan.loanid = ls.XrefId
	
	inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
	inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
	inner join emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
	inner join emdb.emdbuser.LOANXDB_S_06 ls06 on ls.XrefId = ls06.XrefId
	inner join emdb.emdbuser.LOANXDB_S_07 ls07 on ls.XrefId = ls07.XrefId
	inner join emdb.emdbuser.LOANXDB_S_08 ls08 on ls.XrefId = ls08.XrefId
	inner join emdb.emdbuser.LOANXDB_S_09 ls09 on ls.XrefId = ls09.XrefId
	inner join emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
	inner join emdb.emdbuser.LOANXDB_S_17 ls17 on ls.XrefId = ls17.XrefId
	
	inner join emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
	inner join emdb.emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId
	inner join emdb.emdbuser.LOANXDB_N_03 ln03 on ls.XrefId = ln03.XrefId
	inner join emdb.emdbuser.LOANXDB_N_04 ln04 on ls.XrefId = ln04.XrefId
	--inner join emdb.emdbuser.LOANXDB_N_07 ln07 on ls.XrefId = ln07.XrefId
	--inner join emdb.emdbuser.LOANXDB_N_09 ln09 on ls.XrefId = ln09.XrefId 
	
	inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
	inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
	inner join emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
	inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId

	left outer join chilhqpsql05.Admin.corp.Employee e on e.encompasslogin = ls.loanofficerid
	left outer join chilhqpsql05.Admin.corp.office o on o.officeid = e.officeid
	--left outer join chilhqpsql05.Admin.corp.employee empcorp on empcorp.employeeId = e.employeeid
    left outer join chilhqpsql05.Admin.corp.CostCenter c  on c.CostCenterID = e.costCenterId
	

where 

	 (ld01._749 between    '2012-01-01' and '2012-03-31'  ---@StartDate and @EndDate  --action date on HMDA screen
	  and _11 <> 'PREQUALIFICATION' 
	  and ls02._2626 <> 'Brokered' 
	  and ls06._HMDA_X24  <> 'Y')
 Or
  	(_CX_FUNDDATE_1 between  '2012-01-01' and '2012-03-31' --@StartDate and @EndDate   --- or funded loan
  	 and ls02._2626 <> 'Brokered'
   	 and ls06._HMDA_X24 <> 'Y')
  
  -- exec rs_HMDAforRATA '2012-01-01', '2012-01-10'
GO
