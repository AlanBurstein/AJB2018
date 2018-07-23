SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [comdesk].[BAML_Export]
AS
SELECT        ISNULL(ls02._364, '') AS LoanNumber, ISNULL(ls08.LOCKRATE_2868, '') AS BorrFirstName, ISNULL(ls08.LOCKRATE_2869, '') AS BorrLastName, 
                         ISNULL(ls08.LOCKRATE_2870, '') AS BorrSSN, ISNULL(ls08.LOCKRATE_2874, '') AS CoBorrFirstName, ISNULL(ls08.LOCKRATE_2875, '') AS CoBorrLastName, 
                         ISNULL(ls08.LOCKRATE_2876, '') AS CoBorrSSN, ISNULL(ls09.LOCKRATE_2853, '') AS CreditScore, ISNULL(ls09.LOCKRATE_2951, '') AS Purpose, 
                         ISNULL(ls04.LOCKRATE_2950, '') AS Occupancy, ISNULL(ls09.LOCKRATE_2947, '') AS PropertyType, ln06._LR_16 AS PropertyUnits, ISNULL(ls09.LOCKRATE_2942, 
                         '') AS PropertyAddress, ISNULL(ls09.LOCKRATE_2943, '') AS PropertyCity, ISNULL(ls08.LOCKRATE_2945, '') AS PropertyState, ISNULL(ls09.LOCKRATE_2946, '') 
                         AS PropertyZip, NULLIF (ln08.LOCKRATE_3038, 0) AS PurchasePrice, ln09.LOCKRATE_2949 AS AppraisedValue, ln09.LOCKRATE_3043 AS LoanAmount, 
                         ln08.LOCKRATE_353 AS LTV, ln05.LOCKRATE_976 AS CLTV, ln01.LOCKRATE_742 AS BackRatioDTI, ISNULL(ls09.LOCKRATE_2866, '') AS LoanProgram, 
                         ISNULL(ls04.LOCKRATE_2867, '') AS DocType, ISNULL(ls09.LOCKRATE_2961, '') AS ImpoundsWaived, 'Retail' AS OriginationChannel, ln08.LOCKRATE_2231 AS Rate,
                          '' AS ServicingFee, '' AS LenderNetRate, NULLIF (ln05._2775, 0) AS GrossMargin, CONVERT(date, ld01._2220) AS PricingDate, CONVERT(date, ld01._2220) 
                         AS LockDate, CONVERT(int, ln07._2221) AS NumberOfDays, CONVERT(date, ld03.LOCKRATE_2222) AS LockExpiresDate, NULLIF (ln01._2232, 0) AS BasePrice, 
                         ISNULL(ls01._2233, '') AS BasePriceAdj1Desc, NULLIF (ln01._2234, 0) AS BasePriceAdj1Rate, ISNULL(ls01._2235, '') AS BasePriceAdj2Desc, NULLIF (ln01._2236, 0) 
                         AS BasePriceAdj2Rate, ISNULL(ls01._2237, '') AS BasePriceAdj3Desc, NULLIF (ln01._2238, 0) AS BasePriceAdj3Rate, ISNULL(ls01._2239, '') AS BasePriceAdj4Desc, 
                         NULLIF (ln01._2240, 0) AS BasePriceAdj4Rate, ISNULL(ls01._2241, '') AS BasePriceAdj5Desc, NULLIF (ln01._2242, 0) AS BasePriceAdj5Rate, ISNULL(ls03._2243, '') 
                         AS BasePriceAdj6Desc, NULLIF (ln08._2244, 0) AS BasePriceAdj6Rate, ISNULL(ls03._2245, '') AS BasePriceAdj7Desc, NULLIF (ln08._2246, 0) AS BasePriceAdj7Rate, 
                         ISNULL(ls03._2247, '') AS BasePriceAdj8Desc, NULLIF (ln08._2248, 0) AS BasePriceAdj8Rate, ISNULL(ls03._2249, '') AS BasePriceAdj9Desc, NULLIF (ln08._2250, 0) 
                         AS BasePriceAdj9Rate, NULLIF (ln07._2295, 0) AS GRILoanPrice, CONVERT(date, ld01._CX_FUNDDATE_1) AS FundedDate, CONVERT(date, ld01._763) 
                         AS EstClosingDate, CONVERT(date, ld01._748) AS ClosedDate, CONVERT(date, ld01._2222) AS RateLockExpiresDate, CONVERT(date, ld01._1994) 
                         AS FundingCloseDate, CONVERT(date, ld01._2301) AS UnderwritingApprovalDate, CONVERT(date, ld01._2298) AS UnderwritingSubmittedDate, CONVERT(date, 
                         ld01._2305) AS UnderwritingClearToCloseDate, CONVERT(date, ld01._CX_PACKAGERECVD_1) AS ClosingPackageReceivedDate, CONVERT(date, 
                         ld02._REQUEST_X21) AS RequestAppraisalOrderedDate, ISNULL(ls09.LOCKRATE_2278, '') AS InvestorName, CONVERT(date, ld01._2370) AS PurchaseAdviceDate, 
                         ISNULL(ls05._CX_PREVINVEST_16, '') AS PreviousInvestor1, CONVERT(date, ld02._CX_LOCKCANCEL_16) AS LockCancel1, CONVERT(bit, 
                         CASE ls02._CX_SECCANCEL WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryCancel1, CONVERT(bit, CASE ls02._CX_SECRELOCK WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryRelock1, ISNULL(ls05._CX_PREVINVEST2_16, '') AS PreviousInvestor2, CONVERT(date, ld02._CX_LOCKCANCEL2_16) AS LockCancel2, CONVERT(bit, 
                         CASE ls02._CX_SECCANCEL2 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryCancel2, CONVERT(bit, CASE ls02._CX_SECRELOCK2 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryRelock2, ISNULL(ls05._CX_PREVINVEST3_16, '') AS PreviousInvestor3, CONVERT(date, ld02._CX_LOCKCANCEL3_16) AS LockCancel3, CONVERT(bit, 
                         CASE ls02._CX_SECCANCEL3 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryCancel3, CONVERT(bit, CASE ls02._CX_SECRELOCK3 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryRelock3, ISNULL(ls06._CX_PREVINVEST4_10, '') AS PreviousInvestor4, CONVERT(date, ld02._CX_LOCKCANCEL4_10) AS LockCancel4, CONVERT(bit, 
                         CASE ls02._CX_SECCANCEL4 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryCancel4, CONVERT(bit, CASE ls02._CX_SECRELOCK4 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryRelock4, ISNULL(ls06._CX_PREVINVEST5_10, '') AS PreviousInvestor5, CONVERT(date, ld02._CX_LOCKCANCEL5_10) AS LockCancel5, CONVERT(bit, 
                         CASE ls02._CX_SECCANCEL5 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryCancel5, CONVERT(bit, CASE ls02._CX_SECRELOCK5 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryRelock5
FROM                     emdbuser.LOANXDB_D_01 ld01 ( nolock ) inner join
                         emdbuser.LOANXDB_D_02 ld02 ( nolock ) ON ld01.XRefID = ld02.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_03 ld03 ( nolock ) ON ld01.XRefID = ld03.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_01 ln01 ( nolock ) ON ld01.XRefID = ln01.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_05 ln05 ( nolock ) ON ld01.XRefID = ln05.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_06 ln06 ( nolock ) ON ld01.XRefID = ln06.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_07 ln07 ( nolock ) ON ld01.XRefID = ln07.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_08 ln08 ( nolock ) ON ld01.XRefID = ln08.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_09 ln09 ( nolock ) ON ld01.XRefID = ln09.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_01 ls01 ( nolock ) ON ld01.XRefID = ls01.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 ls02 ( nolock ) ON ld01.XRefID = ls02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 ls03 ( nolock ) ON ld01.XRefID = ls03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 ls04 ( nolock ) ON ld01.XRefID = ls04.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 ls05 ( nolock ) ON ld01.XRefID = ls05.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 ls06 ( nolock ) ON ld01.XRefID = ls06.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_08 ls08 ( nolock ) ON ld01.XRefID = ls08.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_09 ls09 ( nolock ) ON ld01.XRefID = ls09.XrefId
WHERE		LD01.XRefID in (

		select	distinct LD01.XRefID
		from	emdbuser.LOANXDB_D_01 LD01 
			inner join emdbuser.LOANXDB_D_02 LD02 on LD01.XRefID = LD02.XRefID
			inner join emdbuser.LOANXDB_D_03 LD03 on LD01.XRefID = LD03.XRefID
			inner join emdbuser.LOANXDB_S_02 LS02 on LD01.XRefID = LS02.XRefID
			inner join emdbuser.LOANXDB_S_04 LS04 on LD01.XRefID = LS04.XRefID
			inner join emdbuser.LOANXDB_S_05 LS05 on LD01.XRefID = LS05.XRefID
			inner join emdbuser.LOANXDB_S_06 LS06 on LD01.XRefID = LS06.XRefID
			inner join emdbuser.LOANXDB_S_09 LS09 on LD01.XRefID = LS09.XRefID
		where
			( ld01._2370 IS NULL OR ld01._2370 >= CONVERT( datetime, DATEADD( day, - 7, CONVERT( date, GETDATE())))) 
			AND 
			( ls04._LOANFOLDER NOT IN ( 'Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples' ))
			AND			
				(
					( ls09.LOCKRATE_2278 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier') AND ld01._CX_FUNDDATE_1 IS NOT NULL )
					 OR
					 ( ls09.LOCKRATE_2278 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier') AND 
						( ld03.LOCKRATE_2222 IS NULL OR ld03.LOCKRATE_2222 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))))
					 OR
					 ( ls02._CX_SECCANCEL = 'X' AND ls05._CX_PREVINVEST_16 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier') AND 
						ld02._CX_LOCKCANCEL_16 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE()))))
					 OR
					 ( ls02._CX_SECCANCEL2 = 'X' AND ls05._CX_PREVINVEST2_16 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier') AND 
						ld02._CX_LOCKCANCEL2_16 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) 
					 OR                       
					 ( ls02._CX_SECCANCEL3 = 'X' AND ls05._CX_PREVINVEST3_16 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier') AND 
						ld02._CX_LOCKCANCEL3_16 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) 
					 OR
					 ( ls02._CX_SECCANCEL4 = 'X' AND ls06._CX_PREVINVEST4_10 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier') AND 
						ld02._CX_LOCKCANCEL4_10 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) 
					 OR
					 ( ls02._CX_SECCANCEL5 = 'X' AND ls06._CX_PREVINVEST5_10 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier') AND 
						ld02._CX_LOCKCANCEL5_10 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE()))))
				)
                      )
/*
WHERE        (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls09.LOCKRATE_2278 IN ('Guaranteed Rate Jumbo Premier', 
                         'GR Jumbo Premier')) AND (ld01._CX_FUNDDATE_1 IS NOT NULL) AND (NOT (ls04._LOANFOLDER IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 
                         'Samples'))) 
                         
                         OR
                         (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls09.LOCKRATE_2278 IN ('Guaranteed Rate Jumbo Premier', 
                         'GR Jumbo Premier')) AND (ld03.LOCKRATE_2222 IS NULL OR
                         ld03.LOCKRATE_2222 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) AND (NOT (ls04._LOANFOLDER IN ('Adverse Loans', 'Audit', 
                         'ContourTemp', 'Knapp Contour', 'Samples'))) OR
                         (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL = 'X') AND 
                         (ls05._CX_PREVINVEST_16 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier')) AND (ld02._CX_LOCKCANCEL_16 >= CONVERT(datetime, DATEADD(day, - 5, 
                         CONVERT(date, GETDATE())))) AND (NOT (ls04._LOANFOLDER IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) OR
                         (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL2 = 'X') AND 
                         (ls05._CX_PREVINVEST2_16 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier')) AND (ld02._CX_LOCKCANCEL2_16 >= CONVERT(datetime, DATEADD(day, 
                         - 5, CONVERT(date, GETDATE())))) AND (NOT (ls04._LOANFOLDER IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) OR
                         (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL3 = 'X') AND 
                         (ls05._CX_PREVINVEST3_16 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier')) AND (ld02._CX_LOCKCANCEL3_16 >= CONVERT(datetime, DATEADD(day, 
                         - 5, CONVERT(date, GETDATE())))) AND (NOT (ls04._LOANFOLDER IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) OR
                         (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL4 = 'X') AND 
                         (ls06._CX_PREVINVEST4_10 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier')) AND (ld02._CX_LOCKCANCEL4_10 >= CONVERT(datetime, DATEADD(day, 
                         - 5, CONVERT(date, GETDATE())))) AND (NOT (ls04._LOANFOLDER IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) OR
                         (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL5 = 'X') AND 
                         (ls06._CX_PREVINVEST5_10 IN ('Guaranteed Rate Jumbo Premier', 'GR Jumbo Premier')) AND (ld02._CX_LOCKCANCEL5_10 >= CONVERT(datetime, DATEADD(day, 
                         - 5, CONVERT(date, GETDATE())))) AND (NOT (ls04._LOANFOLDER IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples')))
*/
GO
