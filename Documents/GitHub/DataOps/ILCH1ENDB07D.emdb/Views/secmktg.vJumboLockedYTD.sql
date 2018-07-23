SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--USE [Warehouse]
--GO

--/****** Object:  View [secmktg].[JumboLockedYTD]    Script Date: 09/27/2013 13:39:20 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--ALTER VIEW [secmktg].[JumboLockedYTD]
--AS
CREATE VIEW [secmktg].[vJumboLockedYTD]
AS
SELECT 

_364 AS [Loan],
CASE
	WHEN ISNULL(_CX_FINALOCODE_4,'') = '' THEN _CX_PAIDLO_3
	ELSE e.displayName
END AS [VP],
_LOANFOLDER AS [Loanfolder],
ISNULL(NULLIF(LOCKRATE_2278, ''), _CX_SECINVESTOR_10) AS [Investor],
_14 AS [PropState],
ISNULL(NULLIF(LOCKRATE_2965, 0), _2) AS [LoanAmount],
LOCKRATE_2160 AS [Rate],
ISNULL(NULLIF(LOCKRATE_2853, 0), _2853) AS [FICO],
_742 AS [DTI],
ISNULL(NULLIF(LOCKRATE_353, 0), _353) AS [LTV],
_976 AS [CLTV],
ISNULL(NULLIF(LOCKRATE_19, ''), _19) AS [Purpose],
_2626 AS [Channel],
_CX_SECONDUNITS_16 AS [Units],
ISNULL(NULLIF(LOCKRATE_1811, ''), _1811) AS [Occupancy],
ISNULL(NULLIF(LOCKRATE_MORNET_X67, ''), _MORNET_X67) AS [DocType],
_1041 AS [PropType],
ISNULL(NULLIF(LOCKRATE_3041, ''), _1130) AS [ProdCode],
ISNULL(NULLIF(_1401, ''), LOCKRATE_1401) AS [ProdDescript],
CONVERT(date,_2149) AS [Locked],

Case When(CONVERT(date,_2149) between DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),0) and DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),14)) Then 'CurrentMonthFirstHalf'
      When (CONVERT(date,_2149) between DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),15) and DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+1,0))) Then 'CurrentMonthSecondHalf' 
      Else 'null'
End As [LockedCurrentMonthHalf],

Case When MONTH(_2149)=MONTH(GETDATE()) AND (YEAR(_2149)=YEAR(GETDATE())) Then 'CurrentMonth' 
      When MONTH(DATEADD(MONTH,1,_2149))=MONTH(GETDATE()) AND (YEAR(_2149)=YEAR(GETDATE())) Then 'PreviousMonth' 
      Else 'null' 
End As [LockedMonth],

CASE 
		/*Other*/
		WHEN (_1172 IN ('HELOC') OR _420 LIKE 'Second%' OR _1401 LIKE '%HELOC%' OR _1401 LIKE '%HECM%' OR _1401 LIKE '%Reverse%') THEN 'Other Amortization Type' 
		/*GR Jumbo*/	
		WHEN _2278 IN ('GR Jumbo Premier', 'GR Jumbo Elite', 'GR Jumbo Platinum') AND _608 = 'Fixed' THEN 'Jumbo Fixed' 
		WHEN _2278 IN ('GR Jumbo Premier', 'GR Jumbo Elite', 'GR Jumbo Platinum') AND _608 = 'AdjustableRate' THEN 'Jumbo ARM' 
		/*Alliant*/
		WHEN (_1401 LIKE '%Alliant%' OR _2278 LIKE '%Alliant%') AND _14 NOT IN ('HI', 'AK') AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'Jumbo ARM' 
		WHEN (_1401 LIKE '%Alliant%' OR _2278 LIKE '%Alliant%') AND _14 IN ('HI', 'AK') AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'Jumbo ARM' 
		WHEN _2278 LIKE '%Alliant%' THEN 'Conf ARM' 
		WHEN _1401 LIKE '%Alliant%' THEN 'Conf ARM'
		/*Agency Jumbo Fixed*/		
		WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%') AND _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'Agency Jumbo Fixed' 
		WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%') AND _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'Agency Jumbo Fixed' 
		/*Agency Jumbo ARM*/		
		WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%') AND _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'Agency Jumbo ARM' 
		WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%') AND _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'Agency Jumbo ARM' 
		/*FHA Jumbo Fixed*/	
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'FHA Jumbo Fixed' 
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'FHA Jumbo Fixed' 
		/*VA Jumbo Fixed*/
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'VA Jumbo Fixed' 
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'VA Jumbo Fixed'		
		/*FHA Fixed*/	
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 <= 417000) OR (_16 = 2 AND _2 <= 533850) OR (_16 = 3 AND _2 <= 645300) OR (_16 = 4 AND _2 <= 801950)) THEN 'FHA Fixed' 
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 <= 625500) OR (_16 = 2 AND _2 <= 800775) OR (_16 = 3 AND _2 <= 967950) OR (_16 = 4 AND _2 <= 1202925)) THEN 'FHA Fixed'
		/*VA Fixed*/
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 <= 417000) OR (_16 = 2 AND _2 <= 533850) OR (_16 = 3 AND _2 <= 645300) OR (_16 = 4 AND _2 <= 801950)) THEN 'VA Fixed' 
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 <= 625500) OR (_16 = 2 AND _2 <= 800775) OR (_16 = 3 AND _2 <= 967950) OR (_16 = 4 AND _2 <= 1202925)) THEN 'VA Fixed'		
		/*FHA Jumbo ARM*/	
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'FHA Jumbo ARM' 
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'FHA Jumbo ARM' 
		/*VA Jumbo ARM*/
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'VA Jumbo ARM' 
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'VA Jumbo ARM' 
		/*FHA ARM*/	
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 <= 417000) OR (_16 = 2 AND _2 <= 533850) OR (_16 = 3 AND _2 <= 645300) OR (_16 = 4 AND _2 <= 801950)) THEN 'FHA Fixed' 
		WHEN _1401 LIKE '%FHA%' AND _1172 IN ('FHA') AND _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 <= 625500) OR (_16 = 2 AND _2 <= 800775) OR (_16 = 3 AND _2 <= 967950) OR (_16 = 4 AND _2 <= 1202925)) THEN 'FHA Fixed' 
		/*VA ARM*/
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 <= 417000) OR (_16 = 2 AND _2 <= 533850) OR (_16 = 3 AND _2 <= 645300) OR (_16 = 4 AND _2 <= 801950)) THEN 'VA Fixed' 
		WHEN _1401 LIKE '%VA%' AND _1172 IN ('VA') AND _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND ((_16 = 1 AND _2 <= 625500) OR (_16 = 2 AND _2 <= 800775) OR (_16 = 3 AND _2 <= 967950) OR (_16 = 4 AND _2 <= 1202925)) THEN 'VA Fixed' 
		/*Rural Development*/
		WHEN _1172 IN ('FarmersHomeAdministration') THEN 'Rural Development' 
		/*Conf ARM*/
		WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND ((_16 = 1 AND _2 <= 417000) OR (_16 = 2 AND _2 <= 533850) OR (_16 = 3 AND _2 <= 645300) OR (_16 = 4 AND _2 <= 801950)) THEN 'Conf ARM' 
		WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _2 <= 417000 AND _608 = 'AdjustableRate' THEN 'Conf ARM' 
		WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND ((_16 = 1 AND _2 <= 625500) OR (_16 = 2 AND _2 <= 800775) OR (_16 = 3 AND _2 <= 967950) OR (_16 = 4 AND _2 <= 1202925)) THEN 'Conf ARM' 
		WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _2 <= 625500 AND _608 = 'AdjustableRate' THEN 'Conf ARM'
		/*Conf Fixed*/
		WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND ((_16 = 1 AND _2 <= 417000) OR (_16 = 2 AND _2 <= 533850) OR (_16 = 3 AND _2 <= 645300) OR (_16 = 4 AND _2 <= 801950)) THEN 'Conf Fixed' 
		WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _2 <= 417000 AND _608 = 'Fixed' THEN 'Conf Fixed'
		WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND ((_16 = 1 AND _2 <= 625500) OR (_16 = 2 AND _2 <= 800775) OR (_16 = 3 AND _2 <= 967950) OR (_16 = 4 AND _2 <= 1202925)) THEN 'Conf Fixed' 
		WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _2 <= 625500 AND _608 = 'Fixed' THEN 'Conf Fixed'
		WHEN (_2278 LIKE 'Fannie Mae%' OR _2278 LIKE 'GRI - Fannie Mae%' OR _2278 LIKE 'Freddie%' OR _2278 LIKE 'GRI - Freddie Mac%') AND _2 <= 417000 AND _608 = 'Fixed' THEN 'Conf Fixed' 
		WHEN (_2278 LIKE 'Fannie Mae%' OR _2278 LIKE 'GRI - Fannie Mae%' OR _2278 LIKE 'Freddie%' OR _2278 LIKE 'GRI - Freddie Mac%') AND _2 <= 417000 AND _608 = 'AdjustableRate' THEN 'Conf ARM' 
		WHEN _1401 LIKE 'GR - Freddie%' THEN 'Conf Fixed' 
		WHEN _2278 LIKE 'GRI - Freddie Mac%' THEN 'Conf Fixed' 
		WHEN _2278 LIKE 'Freddie Mac%' THEN 'Conf Fixed' 
		/*Jumbo ARM*/
		WHEN _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'Jumbo ARM' 
		WHEN _14 NOT IN ('HI', 'AK') AND _2 > 417000 AND _608 = 'AdjustableRate' THEN 'Jumbo ARM' 
		WHEN _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'Jumbo ARM' 
		WHEN _14 IN ('HI', 'AK') AND _2 > 625500 AND _608 = 'AdjustableRate' THEN 'Jumbo ARM'
		/*Sovereign Broker*/
		WHEN _2278 IN ('Sovereign Broker') AND _1401 LIKE '%High%Balance%' THEN 'Agency Jumbo Fixed'
		/*Jumbo Fixed*/
		WHEN _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'Jumbo Fixed' 
		WHEN _14 NOT IN ('HI', 'AK') AND _2 > 417000 AND _608 = 'Fixed' THEN 'Jumbo Fixed'
		WHEN _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'Jumbo Fixed' 
		WHEN _14 IN ('HI', 'AK') AND _2 > 625500 AND _608 = 'Fixed' THEN 'Jumbo Fixed'
		/*All Else*/
		ELSE 'Other Amortization Type'
END AS [Product]

FROM
	emdbuser.Loansummary ls
	JOIN emdbuser.LOANXDB_S_01 ls01 ON ls01.XrefId = ls.XrefId
	JOIN emdbuser.LOANXDB_S_02 ls02 ON ls01.XrefId = ls02.XrefId
	JOIN emdbuser.LOANXDB_S_03 ls03 ON ls01.XrefId = ls03.XrefId
	JOIN emdbuser.LOANXDB_S_04 ls04 ON ls01.XrefId = ls04.XrefId
	JOIN emdbuser.LOANXDB_S_05 ls05 ON ls01.XrefId = ls05.XrefId
	JOIN emdbuser.LOANXDB_S_09 ls09 ON ls01.XrefId = ls09.XrefId
	JOIN emdbuser.LOANXDB_S_10 ls10 ON ls01.XrefId = ls10.XrefId
	JOIN emdbuser.LOANXDB_D_01 ld01 ON ls01.XrefId = ld01.XrefId
	JOIN emdbuser.LOANXDB_D_02 ld02 ON ls01.XrefId = ld02.XrefId
	JOIN emdbuser.LOANXDB_N_01 ln01 ON ls01.XrefId = ln01.XrefId
	JOIN emdbuser.LOANXDB_N_02 ln02 ON ls01.XrefId = ln02.XrefId
	JOIN emdbuser.LOANXDB_N_07 ln07 ON ls01.XrefId = ln07.XrefId
	JOIN emdbuser.LOANXDB_N_08 ln08 ON ls01.XrefId = ln08.XrefId
	JOIN emdbuser.LOANXDB_N_09 ln09 ON ls01.XrefId = ln09.XrefId
	left join corp.LOCode lo on _CX_FINALOCODE_4 = lo.LOCode
	left join corp.Employee e on lo.EmployeeID = e.employeeId
	left join corp.Office o on o.officeId = e.officeId

WHERE
YEAR(_2149) = YEAR(GETDATE()) AND _2 > 417000


----DROP INDEX UNQ_vJumboLockedYTD_Loan_Locked_LoanAmount ON [vJumboLockedYTD]
--CREATE UNIQUE CLUSTERED INDEX UNQ_vJumboLockedYTD_Loan_Locked_LoanAmount
--    ON [secmktg].[vJumboLockedYTD] ([Loan], [Locked], [LoanAmount])
--WITH 
--(
--	PAD_INDEX				= ON, 
--	STATISTICS_NORECOMPUTE  = OFF, 
--	SORT_IN_TEMPDB			= OFF, 
--	IGNORE_DUP_KEY			= OFF, 
--	DROP_EXISTING			= OFF, 
--	ONLINE					= ON, 
--	ALLOW_ROW_LOCKS			= ON, 
--	ALLOW_PAGE_LOCKS		= ON, 
--	FILLFACTOR				= 95
--) 
--ON [PRIMARY]
--GO
GO
