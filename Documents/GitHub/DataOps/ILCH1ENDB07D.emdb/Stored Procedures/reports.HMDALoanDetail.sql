SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Hawley, Darlene Gorman
-- Create date: 7/11/2012
-- Description:	Retrieve the HMDA data for a date range, according to the current requirements
-- =============================================
CREATE PROCEDURE [reports].[HMDALoanDetail] 
	@StartDate datetime, 
	@EndDate datetime
AS
select
	actiontaken,
	actiontakendate,
	_CX_FUNDDATE_1,
	_748,
	
	ls.LoanNumber as [APLNNO], -- _364
	_36 + ' ' + _37 as [APPNAME], -- BorrowerFirstName + ' ' + BorrowerLastName
	nullif(_11, '') as [PROPSTREET],
	nullif(_12, '') as [PROPCITY],
	nullif(_14, '') as [PROPSTATE],
	nullif(_15, '') as [PROPZIP],
	convert(char(10), isnull(_745, _CX_RESPAAPP_1), 101) as [APDATE],
	_745, _CX_RESPAAPP_1,
	case _1172
		when 'Conventional' then 1
		when 'FHA' then 2
		when 'VA' then 3
		when 'FarmersHomeAdministration' then 4
		--else null -- Should not happen
	end as [LNTYPE],
	_1172, _1063, -- For debugging
	case
		when _HMDA_X11 = 'One-to-fourFamily' then 1
		when _HMDA_X11 = 'Manufactured Housing' then 2  -- Should not happen
		when _HMDA_X11 = 'Multifamily Dwelling' then 3  -- Should not happen
		when _1041 = 'Manufactured Housing' then 2  -- Should not happen
		else 1  -- OK to guess in this case
	end as [PROPTYPE],  -- In theory, should always be 1
	case _19
		when 'Purchase' then 1
		when 'ConstructionOnly' then 2  -- Should not happen
		when 'ConstructionToPerman' then 2  -- Should not happen
		when 'Cash-Out Refinance' then 3
		when 'NoCash-Out Refinance' then 3
		--else null -- Other not supported by HMDA, empty needs filling in
	end as [LNPURPOSE],
	case _1811
		when 'PrimaryResidence' then 1
		when 'SecondHome' then 2
		when 'Investor' then 2
		--else 1 -- Loan not filled in correctly, likely primary; don't guess though
	end as [OCCUPANCY],
	case _1811
		when 'PrimaryResidence' then 'P'
		when 'SecondHome' then 'V'
		when 'Investor' then 'I'
		--else 'P' -- Loan not filled in correctly, likely primary; don't guess though
	end as [OCCUPYURLA],  -- QuestSoft says this is required
	_1811, -- For debugging
	_2 / 1000 as [LNAMOUNT],
	3 as [PREAPPR], -- We don't do pre-approvals, so always N/A
	case
		when _CX_FUNDDATE_1 is not null then 1 -- _1393 should be 'Loan Originated'
		-- Otherwise, the loan has not funded; the rest of the choices explain why not...
		--when _1393 = 'Active Loan' then null -- Should not happen for closed loans
		--when _1393 = 'Loan Originated' then 1 -- Should not happen when there is no funding date
		when _1393 = 'Application approved but not accepted' then 2
		when _1393 = 'Application denied' then 3
		when _1393 = 'Application withdrawn' then 4
		when _1393 = 'File Closed for incompleteness' then 5
		--when _1393 = 'Loan purchased by financial institution' then 6  -- Should not happen ("financial institution" means us, and we don't)
		--when _1393 = 'Preapproval request denied by financial institution' then 7  -- Should not happen, we don't do preapprovals
		--when _1393 = 'Preapproval request approved but not accepted' then 8  -- Should not happen, we don't do preapprovals
		--else null -- Not filled in properly
	end as [ACTION],
	_CX_FUNDDATE_1, _1393, -- For debugging
	convert(char(10), isnull(_CX_FUNDDATE_1, _749), 101) as [ACTDATE],
	(_1389 * 12) / 1000 as [TINCOME],
	_1389, _736, -- For debugging
	
	-- For ethnicity/race/sex, "Not applicable" only applies to loans we purchased from others,
	-- or loans to businesses or other non-human entities. We don't do either of these, so we
	-- translate "Not applicable" to mean "Information not provided".
	
	-- There isn't really a reliable flag for whether there's a co-applicant, so we check for
	-- whether the co-applicant's last name is empty instead.
	
	-- Starting in 2011, for applications made in person (face-to-face) we are required to ignore
	-- the "I do not wish to furnish this information" options and guess their ethnicity/race/sex.
	
	-- Starting in 2012 we are treating the first co-mortgagor as the co-applicant if there is no
	-- co-applicant specified. We may also apply this rule to resubmissions of prior year data.
	
	case
		when _188 = 'Y' and isnull(_479, '') <> 'FaceToFace' then 3
		when _1523 = 'Hispanic or Latino' then 1
		when _1523 = 'Not Hispanic or Latino' then 2
		when _1523 = 'Information not provided' then 3
		--when _1523 = 'Not applicable' then 4  -- Should not happen
		else 3
	end as [APETH],
	case
		--when isnull(_4004, '') = '' then 5
		when isnull(_4004, '') = '' then
			case
				when isnull(_4002_P2, '') = '' then 5
				when _188_P2 = 'Y' and isnull(_479, '') <> 'FaceToFace' then 3
				when _1523_P2 = 'Hispanic or Latino' then 1
				when _1523_P2 = 'Not Hispanic or Latino' then 2
				when _1523_P2 = 'Information not provided' then 3
				--when _1523_P2 = 'Not applicable' then 4  -- Should not happen
				else 3
			end
		when _189 = 'Y' and isnull(_479, '') <> 'FaceToFace' then 3
		when _1531 = 'Hispanic or Latino' then 1
		when _1531 = 'Not Hispanic or Latino' then 2
		when _1531 = 'Information not provided' then 3
		--when _1531 = 'Not applicable' then 4  -- Should not happen
		else 3
	end as [CAPETH],
	convert(int, case
		when _188 = 'Y' and isnull(_479, '') <> 'FaceToFace' then '6'
		else coalesce(nullif(
			case _1524 when 'Y' then '1' else '' end +
			case _1525 when 'Y' then '2' else '' end +
			case _1526 when 'Y' then '3' else '' end +
			case _1527 when 'Y' then '4' else '' end +
			case _1528 when 'Y' then '5' else '' end +
			case
				when _1524 = 'Y' or _1525 = 'Y' or _1526 = 'Y'
					or _1527 = 'Y' or _1528 = 'Y' then ''
				when _1529 = 'Y' or _1530 = 'Y' then '6'
				--when _1529 = 'Y' then '6'
				--when _1530 = 'Y' then '7'
				else ''
			end
		, ''), '6')
	end) as [APRACE],
	convert(int, case
		--when isnull(_4004, '') = '' then '8'
		when isnull(_4004, '') = '' then
			case
				when isnull(_4002_P2, '') = '' then '8'
				when _188_P2 = 'Y' and isnull(_479, '') <> 'FaceToFace' then '6'
				else coalesce(nullif(
					case _1524_P2 when 'Y' then '1' else '' end +
					case _1525_P2 when 'Y' then '2' else '' end +
					case _1526_P2 when 'Y' then '3' else '' end +
					case _1527_P2 when 'Y' then '4' else '' end +
					case _1528_P2 when 'Y' then '5' else '' end +
					case
						when _1524_P2 = 'Y' or _1525_P2 = 'Y' or _1526_P2 = 'Y'
							or _1527_P2 = 'Y' or _1528_P2 = 'Y' then ''
						when _1529_P2 = 'Y' or _1530_P2 = 'Y' then '6'
						--when _1529_P2 = 'Y' then '6'
						--when _1530_P2 = 'Y' then '7'
						else ''
					end
				, ''), '6')
			end
		when _189 = 'Y' and isnull(_479, '') <> 'FaceToFace' then '6'
		else coalesce(nullif(
			case _1532 when 'Y' then '1' else '' end +
			case _1533 when 'Y' then '2' else '' end +
			case _1534 when 'Y' then '3' else '' end +
			case _1535 when 'Y' then '4' else '' end +
			case _1536 when 'Y' then '5' else '' end +
			case
				when _1532 = 'Y' or _1533 = 'Y' or _1534 = 'Y'
					or _1535 = 'Y' or _1536 = 'Y' then ''
				when _1537 = 'Y' or _1538 = 'Y' then '6'
				--when _1537 = 'Y' then '6'
				--when _1538 = 'Y' then '7'
				else ''
			end
		, ''), '6')
	end) as [CAPRACE],
	case
		when _188 = 'Y' and isnull(_479, '') <> 'FaceToFace' then 3
		when _471 = 'Male' then 1
		when _471 = 'Female' then 2
		when _471 = 'Not Provided/Unknown' then 3
		--when _471 = 'Not Applicable' then 4  -- Should not happen
		else 3
	end as [APSEX],
	case
		--when isnull(_4004, '') = '' then 5
		when isnull(_4004, '') = '' then
			case
				when isnull(_4002_P2, '') = '' then 5
				when _188_P2 = 'Y' and isnull(_479, '') <> 'FaceToFace' then 3
				when _471_P2 = 'Male' then 1
				when _471_P2 = 'Female' then 2
				when _471_P2 = 'Not Provided/Unknown' then 3
				--when _471_P2 = 'Not Applicable' then 4  -- Should not happen
				else 3
			end
		when _189 = 'Y' and isnull(_479, '') <> 'FaceToFace' then 3
		when _478 = 'Male' then 1
		when _478 = 'Female' then 2
		when _478 = 'Not Provided/Unknown' then 3
		--when _478 = 'Not Applicable' then 4  -- Should not happen
		else 3
	end as [CAPSEX],
	case _479
		when 'FaceToFace' then 'F'
		when 'Internet' then 'I'
		when 'Mail' then 'M'
		when 'Telephone' then 'T'
		else 'O' -- Could be unspecified
	end as [APPTAKENBY],
	case
		when _CX_FUNDDATE_1 is null then 0
		-- Check the investor name
		when _2278 like 'Fannie %' then 1
		when _2278 like 'GRI - Fannie %' then 1
		when _2278 = 'FNMA' then 1
		when _2278 like 'Freddie %' then 3
		when _2278 like 'GRI - Freddie %' then 3
		when _2278 = 'FHLMC' then 3
		when _2278 in ('', 'A', 'B', 'C') then null  -- Errors that may show up
		else 6 -- Commercial
		
		-- The proper values in the dropdown
		--when 'Loan was not originated or not sold' then 0  -- Should not happen for funded loans
		--when _1397 = 'Fannie Mae' then 1
		--when _1397 = 'Ginnie Mae' then 2 -- Should not happen
		--when _1397 = 'Freddie Mac' then 3
		--when _1397 = 'Farmer Mac' then 4 -- Should not happen
		--when _1397 = 'Private Securitization' then 5 -- Should not happen
		--when _1397 = 'Commercial Bank, Savings Bank, or Savings Association' then 6
		--when _1397 = 'Life Ins. Company, Credit Union, Mortgage Bank or Finance Company' then 7 -- Should not happen
		--when _1397 = 'Affiliate Institution' then 8 -- Should not happen
		--when _1397 = 'Other type of purchaser' then 9 -- Should not happen
		-- The values actually defined in the field
		--when 'Loan was not originated' then 0 -- Should not happen for funded loans
		--when _1397 = 'FNMA' then 1  -- 'Fannie Mae'
		--when _1397 = 'GNMA' then 2  -- 'Ginnie Mae'
		--when _1397 = 'FHLMC' then 3  -- 'Freddie Mac'
		--when _1397 = 'FAMC' then 4  -- 'Farmer Mac' -- Should not happen
		--when _1397 = 'Commercial Bank' then 6
		--when _1397 = 'Savings Bank' then 6
		--when _1397 = 'Life Insurance Co.' then 7 -- Should not happen
		--else 0  -- Don't guess
	end as [PURCHTYPE],
	_1397, _2278, -- For debugging
	case
		-- Directly specified
		when _1172 = 'HELOC' then 'H' -- Should not happen
		when _608 = 'GraduatedPaymentMortgage' then 'G' -- Should not happen
		when _608 = 'Fixed' then case _1659 when 'Y' then 'FB' else 'F' end
		when _608 = 'AdjustableRate' then  -- All ARMs are hybrid
			case when _995 like '%HECM%' then 'RS' else 'AH' end -- 'RS' should not happen
		when _608 = 'OtherAmortizationType' and _994 like '%HECM%' then 'RS' -- Should not happen
		when _608 = 'OtherAmortizationType' and _994 like '%HELOC%' then 'H' -- Should not happen
		-- Specified by naming convention in the Loan Program
		--when _1401 like '%Fixed%' then case _1659 when 'Y' then 'FB' else 'F' end
		--when _1401 like '%ARM%' then 'AH'  -- All ARMs are hybrid
		--when _1401 = 'Reverse' then 'R' -- Should not happen
		--when _1401 like '%HECM%' then 'RS' -- Should not happen
		--when _1401 = 'HELOC' or _1401 like '%HELOC%' then 'H' -- Should not happen
	end as [AMORTTYPE],  -- Only 'AH', 'F' and 'FB' should happen
	_608, _994, _995, _1401, -- For debugging
	convert(char(10), _761, 101) as [LOCKDATE],
	_799 as [APR],
	_325 as [LOAN_TERM],
	_696 as [INITADJMOS],  -- For adjustable rate loan
	--_HMDA_X15 as [SPREAD],  -- This will be calculated by QuestSoft
	case _HMDA_X13
		when 'HOEPA Loan' then 1 -- Should not happen
		else 2
	end as [HOEPA],
	--case _HMDA_X14  -- Generally not set properly
	--	when 'Secured by a first lien' then 1
	--	when 'Secured by a subordinate lien' then 2
	--	when 'Not secured by a lien' then 3
	--	when 'Not applicable' then 4
	--	else case _420 when 'Second Lien' then 2 else 1 end
	--end as [LIENSTAT],
	case _420 when 'Second Lien' then 2 else 1 end as [LIENSTAT],
	--case _2626
	--	when 'Correspondent' then 3
	--	when 'Brokered' then 5
	--	else 3 -- Loan not filled in correctly, likely Correspondant
	--end as [CHANNEL] --,  -- QuestSoft says this is required
	3 as [CHANNEL]  -- We are only reporting Correspondent channel, and 2626 is often wrong.

from  emdb.emdbuser.LoanSummary ls 
--inner join emdb.dbo.HMDA_Export_Loans hl on hl.LoanNumber = ls.LoanNumber
inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls01.XrefId = ls.XrefId
--inner join emdb.emdbuser.users usr on ls01._LOID = usr.userid
--inner join emdb.emdbuser.org_chart as org on Usr.org_id = org.oid
inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
inner join emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
inner join emdb.emdbuser.LOANXDB_S_06 ls06 on ls.XrefId = ls06.XrefId
inner join emdb.emdbuser.LOANXDB_S_07 ls07 on ls.XrefId = ls07.XrefId
inner join emdb.emdbuser.LOANXDB_S_08 ls08 on ls.XrefId = ls08.XrefId
inner join emdb.emdbuser.LOANXDB_S_09 ls09 on ls.XrefId = ls09.XrefId
inner join emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
inner join emdb.emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId
inner join emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId
--inner join emdb.emdbuser.LOANXDB_N_03 ln03 on ls.XrefId = ln03.XrefId
--inner join emdb.emdbuser.LOANXDB_N_04 ln04 on ls.XrefId = ln04.XrefId
--inner join emdb.emdbuser.LOANXDB_N_05 ln05 on ls.XrefId = ln05.XrefId
--inner join emdb.emdbuser.LOANXDB_N_06 ln06 on ls.XrefId = ln06.XrefId
--inner join emdb.emdbuser.LOANXDB_N_07 ln07 on ls.XrefId = ln07.XrefId
--inner join emdb.emdbuser.LOANXDB_N_08 ln08 on ls.XrefId = ln08.XrefId
--inner join emdb.emdbuser.LOANXDB_N_09 ln09 on ls.XrefId = ln09.XrefId
inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId
--inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
--inner join emdb.emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
--inner join emdb.emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId

where 
not (_11 in ('PREQUALIFICATION'))
 
and 
	(
	_CX_FUNDDATE_1  between        @StartDate and @EndDate
or 
	(ActionTaken in ('Preapproval request denied by financial institution',
                    'Application approved but not accepted',
                    'Preapproval request approved but not accepted',
					'Application withdrawn',
					'Application denied',
					'File Closed for incompleteness') 
	and actiontakendate between @StartDate and @EndDate)
	)

  
	--and (_CX_FUNDDATE_1 is null or _1397 in (
	--	'Fannie Mae','FNMA','Ginnie Mae','GNMA','Freddie Mac','FHLMC','Farmer Mac','FAMC',
	--	'Private Securitization','Commercial Bank, Savings Bank, or Savings Association',
	--	'Life Ins. Company, Credit Union, Mortgage Bank or Finance Company',
	--	'Commercial Bank','Savings Bank','Life Insurance Co.','Affiliate Institution',
	--	'Other type of purchaser'
	--))
	--and _608 = 'OtherAmortizationType' --_1172 <> 'HELOC' and (_994 like '%HELOC%' or _995 like '%HELOC%')

--order by ls.LoanNumber --_364

--              exec dbo.rs_HMDALoanDetail '2012-04-01', '2012-06-30'

GO
