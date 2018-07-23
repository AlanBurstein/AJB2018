SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [secmktg].[vDailyLocks]
AS
-- emdb part of view warehouse.secmktg.DailyLocks 
SELECT	ls03._CX_FINALOCODE_4,
		ld01._2298, 
		ld01._2301, 
		ld01._2303, 
		ld01._745, 
		ld01._2149, 
		ld01._2151, 
		ld01._748, 
		ld01._CX_FUNDDATE_1, 
		ld01._2370, 
		ld01._749,
		ls02._364 AS [Loan Number],
		ls01._37 AS [Last Name], 
		ls01._36 AS [First Name], 
		CASE 
			WHEN len(_2288) > 3 THEN _2288 
			WHEN len(_2286) > 3 THEN _2286 
			ELSE '' 
		END AS [Commitment Number],
		--ISNULL(NULLIF(ISNULL(NULLIF(LOCKRATE_2278, ''), _2278), ''), _CX_SECINVESTOR_10) AS [Final Investor],
		ISNULL(NULLIF(ISNULL(NULLIF(_2088, ''), _2278), ''), _CX_SECINVESTOR_10) AS [Final Investor],
		1 AS [Units],
		CONVERT(money, ln02._2) AS [Amount],
		ISNULL(NULLIF(LOCKRATE_19, ''), _19) AS [Purpose],
		ISNULL(NULLIF(LOCKRATE_3041, ''), _1130) AS [ProdCode],
		ISNULL(NULLIF(LOCKRATE_1401, ''), _1401) AS [ProdDescript],	
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
			WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%' OR _1401 LIKE '%High%Balance%' OR _1401 LIKE '%Agency%Conforming%') AND _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'Agency Jumbo Fixed' 
			WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%' OR _1401 LIKE '%High%Balance%' OR _1401 LIKE '%Agency%Conforming%') AND _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _608 = 'Fixed' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'Agency Jumbo Fixed' 
			/*Agency Jumbo ARM*/		
			WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%' OR _1401 LIKE '%High%Balance%' OR _1401 LIKE '%Agency%Conforming%') AND _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 417000) OR (_16 = 2 AND _2 > 533850) OR (_16 = 3 AND _2 > 645300) OR (_16 = 4 AND _2 > 801950)) THEN 'Conf ARM' 
			WHEN (_1401 LIKE '%Agency%Jumbo%' OR _1401 LIKE '%Agency%High Balance%' OR _1401 LIKE '%Conforming%Jumbo%' OR _1401 LIKE '%Jumbo%Conforming%' OR _1401 LIKE '%Conforming%High Balance%' OR _1401 LIKE '%Super%Conforming%' OR _1401 LIKE '%Conforming%Plus%' OR _1401 LIKE '%High%Balance%' OR _1401 LIKE '%Agency%Conforming%') AND _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _608 = 'AdjustableRate' AND _1401 NOT LIKE '%FHA%' AND _1401 NOT LIKE '%VA%' AND ((_16 = 1 AND _2 > 625500) OR (_16 = 2 AND _2 > 800775) OR (_16 = 3 AND _2 > 967950) OR (_16 = 4 AND _2 > 1202925)) THEN 'Conf ARM'
			/*FHA/VA/USDA*/	
			WHEN (_1172 IN ('FHA') OR _1172 IN ('VA') OR _1172 IN ('FarmersHomeAdministration')) AND (_2278 NOT IN ('Fannie Mae', 'Freddie Mac')) THEN 'FHA' 
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
		END AS [Product], 
		ln01._3 AS [Note Rate], 
		CONVERT(date, ISNULL(ld01._CX_APPSENT_1, ld01._2149)) AS [Application Date], 
		CONVERT(date, ld01._2149) AS [Locked Date], 
		CONVERT(date, ld01._748) AS [Closed Date], 
		CONVERT(date, ld01._CX_FUNDDATE_1) AS [Funded Date], 
		CONVERT(date, ld01._2370) AS [Purchased Date], 
		ls03._VEND_X200 AS Warehouse,
		_CX_SECPENDING as [Pending]
FROM	emdb.emdbuser.LoanXRef AS lx INNER JOIN
		emdb.emdbuser.LOANXDB_S_01 AS ls01 ON lx.XRefID = ls01.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_N_01 AS ln01 ON lx.XRefID = ln01.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_N_02 AS ln02 ON lx.XRefID = ln02.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_N_03 AS ln03 ON lx.XRefID = ln03.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_N_04 AS ln04 ON lx.XRefID = ln04.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_N_05 AS ln05 WITH (FORCESEEK) ON lx.XRefID = ln05.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_N_06 AS ln06 WITH (FORCESEEK) ON lx.XRefID = ln06.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_N_07 AS ln07 ON lx.XRefID = ln07.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_D_01 AS ld01 ON lx.XRefID = ld01.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_D_02 AS ld02 ON lx.XRefID = ld02.XrefId INNER JOIN -- was uncommeted prior to 2-12-15
		emdb.emdbuser.LOANXDB_S_02 AS ls02 ON lx.XRefID = ls02.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_S_03 AS ls03 ON lx.XRefID = ls03.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_S_04 AS ls04 WITH (FORCESEEK) ON lx.XRefID = ls04.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_S_04 AS ls04 ON lx.XRefID = ls04.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_S_05 AS ls05 ON lx.XRefID = ls05.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_S_06 AS ls06 WITH (FORCESEEK) ON lx.XRefID = ls06.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_S_07 AS ls07 ON lx.XRefID = ls07.XrefId INNER JOIN
		--emdb.emdbuser.LOANXDB_S_08 AS ls08 WITH (FORCESEEK) ON lx.XRefID = ls08.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_S_09 AS ls09 ON lx.XRefID = ls09.XrefId INNER JOIN
		emdb.emdbuser.LOANXDB_S_10 AS ls10 ON lx.XRefID = ls10.XrefId INNER JOIN
		emdb.emdbuser.LoanSummary as LS on lx.XRefID	= ls.XRefID	LEFT OUTER JOIN		-- added left outer join on 2-13-15
		Analytics.dbo.LoanMap_InvestorName as IVN on ls02._2278 = IVN.InvestorName		-- added join 2-12-15
WHERE
	(((ld01._2149 BETWEEN GETDATE() - 14 AND GETDATE() + 1)
	  AND (LEN(ls02._2278) > 2)
	  and not (_CX_SECRELOCK = 'x' and _CX_LOCKCANCEL_16 >= _2149	
		or _CX_SECRELOCK2 = 'x' and _CX_LOCKCANCEL2_16 >= _2149		
		or _CX_SECRELOCK3 = 'x' and _CX_LOCKCANCEL3_16 >= _2149		
		or _CX_SECRELOCK4 = 'x' and _CX_LOCKCANCEL4_10 >= _2149		
		or _CX_SECRELOCK5 = 'x' and _CX_LOCKCANCEL5_10 >= _2149)
	  and IVN.IsCorrespondent = 1	)	
	OR ((_CX_SECPENDING = 'x')
	  AND (_2149 IS NULL)))											
  									
  and  LoanFolder not in ('GriOnline - Testing','Samples')			
  
  
  
  -- removed the below and replaced with the above where clause on 2-12-15
  
	--  WHERE	(((ld01._2149 BETWEEN GETDATE() - 14 AND GETDATE() + 1) AND (LEN(ls02._2278) > 2)) 
	--OR		((_CX_SECPENDING = 'x') AND (_2149 IS NULL)))
	--AND		_2626 = 'CORRESPONDENT'






GO
