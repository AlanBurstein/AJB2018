SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [comdesk].[CrSuisse_Export_OLD]
AS
SELECT        ls.LoanNumber, ISNULL(ls08.LOCKRATE_2868, '') AS BorrFirstName, ISNULL(ls08.LOCKRATE_2869, '') AS BorrLastName, ISNULL(ls08.LOCKRATE_2870, '') 
                         AS BorrSSN, ISNULL(ls08.LOCKRATE_2874, '') AS CoBorrFirstName, ISNULL(ls08.LOCKRATE_2875, '') AS CoBorrLastName, ISNULL(ls08.LOCKRATE_2876, '') 
                         AS CoBorrSSN, ISNULL(ls09.LOCKRATE_2853, '') AS CreditScore, ISNULL(ls09.LOCKRATE_2951, '') AS Purpose, ISNULL(ls04.LOCKRATE_2950, '') AS Occupancy, 
                         ISNULL(ls09.LOCKRATE_2947, '') AS PropertyType, ln06._LR_16 AS PropertyUnits, ISNULL(ls09.LOCKRATE_2942, '') AS PropertyAddress, 
                         ISNULL(ls09.LOCKRATE_2943, '') AS PropertyCity, ISNULL(ls08.LOCKRATE_2945, '') AS PropertyState, ISNULL(ls09.LOCKRATE_2946, '') AS PropertyZip, 
                         NULLIF (ln08.LOCKRATE_3038, 0) AS PurchasePrice, ln09.LOCKRATE_2949 AS AppraisedValue, ln09.LOCKRATE_3043 AS LoanAmount, ln08.LOCKRATE_353 AS LTV, 
                         ln05.LOCKRATE_976 AS CLTV, ln01.LOCKRATE_742 AS BackRatioDTI, ISNULL(ls09.LOCKRATE_2866, '') AS LoanProgram, ISNULL(ls04.LOCKRATE_2867, '') 
                         AS DocType, ISNULL(ls09.LOCKRATE_2961, '') AS ImpoundsWaived, 'Retail' AS OriginationChannel, ln08.LOCKRATE_2231 AS Rate, '' AS ServicingFee, 
                         '' AS LenderNetRate, NULLIF (ln05._2775, 0) AS GrossMargin, CONVERT(date, ld01._2220) AS PricingDate, CONVERT(date, ld01._2220) AS LockDate, CONVERT(int, 
                         ln07._2221) AS NumberOfDays, CONVERT(date, ld03.LOCKRATE_2222) AS LockExpiresDate, NULLIF (ln01._2232, 0) AS BasePrice, ISNULL(ls01._2233, '') 
                         AS BasePriceAdj1Desc, NULLIF (ln01._2234, 0) AS BasePriceAdj1Rate, ISNULL(ls01._2235, '') AS BasePriceAdj2Desc, NULLIF (ln01._2236, 0) AS BasePriceAdj2Rate, 
                         ISNULL(ls01._2237, '') AS BasePriceAdj3Desc, NULLIF (ln01._2238, 0) AS BasePriceAdj3Rate, ISNULL(ls01._2239, '') AS BasePriceAdj4Desc, NULLIF (ln01._2240, 0) 
                         AS BasePriceAdj4Rate, ISNULL(ls01._2241, '') AS BasePriceAdj5Desc, NULLIF (ln01._2242, 0) AS BasePriceAdj5Rate, ISNULL(ls03._2243, '') AS BasePriceAdj6Desc, 
                         NULLIF (ln08._2244, 0) AS BasePriceAdj6Rate, ISNULL(ls03._2245, '') AS BasePriceAdj7Desc, NULLIF (ln08._2246, 0) AS BasePriceAdj7Rate, ISNULL(ls03._2247, '') 
                         AS BasePriceAdj8Desc, NULLIF (ln08._2248, 0) AS BasePriceAdj8Rate, ISNULL(ls03._2249, '') AS BasePriceAdj9Desc, NULLIF (ln08._2250, 0) AS BasePriceAdj9Rate, 
                         ISNULL(ls15._3494, '') AS ExtendAdj1Desc, NULLIF (ln11._3495, 0) AS ExtendAdj1Rate, ISNULL(ls15._3496, '') AS ExtendAdj2Desc, NULLIF (ln11._3497, 0) 
                         AS ExtendAdj2Rate, ISNULL(ls15._3498, '') AS ExtendAdj3Desc, NULLIF (ln11._3499, 0) AS ExtendAdj3Rate, ISNULL(ls15._3500, '') AS ExtendAdj4Desc, 
                         NULLIF (ln11._3501, 0) AS ExtendAdj4Rate, ISNULL(ls15._3502, '') AS ExtendAdj5Desc, NULLIF (ln11._3503, 0) AS ExtendAdj5Rate, NULLIF (ln07._2295, 0) 
                         AS LoanPrice, CONVERT(date, ld01._CX_FUNDDATE_1) AS FundedDate, CONVERT(date, ld01._763) AS EstClosingDate, CONVERT(date, ld01._748) AS ClosedDate, 
                         CONVERT(date, ld01._2222) AS RateLockExpiresDate, CONVERT(date, ld01._1994) AS FundingCloseDate, CONVERT(date, ld01._2301) AS UnderwritingApprovalDate, 
                         CONVERT(date, ld01._2298) AS UnderwritingSubmittedDate, CONVERT(date, ld01._2305) AS UnderwritingClearToCloseDate, CONVERT(date, 
                         ld01._CX_PACKAGERECVD_1) AS ClosingPackageReceivedDate, CONVERT(date, ld02._REQUEST_X21) AS RequestAppraisalOrderedDate, 
                         ISNULL(ls09.LOCKRATE_2278, '') AS InvestorName, CONVERT(date, ld01._2370) AS PurchaseAdviceDate, ISNULL(ls05._CX_PREVINVEST_16, '') 
                         AS PreviousInvestor1, CONVERT(date, ld02._CX_LOCKCANCEL_16) AS LockCancel1, CONVERT(bit, CASE ls02._CX_SECCANCEL WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryCancel1, CONVERT(bit, CASE ls02._CX_SECRELOCK WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryRelock1, ISNULL(ls05._CX_PREVINVEST2_16, '') 
                         AS PreviousInvestor2, CONVERT(date, ld02._CX_LOCKCANCEL2_16) AS LockCancel2, CONVERT(bit, CASE ls02._CX_SECCANCEL2 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryCancel2, CONVERT(bit, CASE ls02._CX_SECRELOCK2 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryRelock2, ISNULL(ls05._CX_PREVINVEST3_16, '') 
                         AS PreviousInvestor3, CONVERT(date, ld02._CX_LOCKCANCEL3_16) AS LockCancel3, CONVERT(bit, CASE ls02._CX_SECCANCEL3 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryCancel3, CONVERT(bit, CASE ls02._CX_SECRELOCK3 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryRelock3, ISNULL(ls06._CX_PREVINVEST4_10, '') 
                         AS PreviousInvestor4, CONVERT(date, ld02._CX_LOCKCANCEL4_10) AS LockCancel4, CONVERT(bit, CASE ls02._CX_SECCANCEL4 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryCancel4, CONVERT(bit, CASE ls02._CX_SECRELOCK4 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryRelock4, ISNULL(ls06._CX_PREVINVEST5_10, '') 
                         AS PreviousInvestor5, CONVERT(date, ld02._CX_LOCKCANCEL5_10) AS LockCancel5, CONVERT(bit, CASE ls02._CX_SECCANCEL5 WHEN 'X' THEN 1 ELSE 0 END) 
                         AS SecondaryCancel5, CONVERT(bit, CASE ls02._CX_SECRELOCK5 WHEN 'X' THEN 1 ELSE 0 END) AS SecondaryRelock5
FROM            emdbuser.LoanXRef AS lx INNER JOIN
                         emdbuser.LoanSummary AS ls ON lx.XRefID = ls.XRefID INNER JOIN
                         emdbuser.LOANXDB_D_01 AS ld01 ON lx.XRefID = ld01.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_02 AS ld02 ON lx.XRefID = ld02.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_03 AS ld03 ON lx.XRefID = ld03.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_01 AS ln01 ON lx.XRefID = ln01.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_05 AS ln05 ON lx.XRefID = ln05.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_06 AS ln06 ON lx.XRefID = ln06.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_07 AS ln07 ON lx.XRefID = ln07.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_08 AS ln08 ON lx.XRefID = ln08.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_09 AS ln09 ON lx.XRefID = ln09.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_11 AS ln11 ON lx.XRefID = ln11.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_01 AS ls01 ON lx.XRefID = ls01.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 AS ls02 ON lx.XRefID = ls02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS ls03 ON lx.XRefID = ls03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 AS ls04 ON lx.XRefID = ls04.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS ls05 ON lx.XRefID = ls05.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 AS ls06 ON lx.XRefID = ls06.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_08 AS ls08 ON lx.XRefID = ls08.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_09 AS ls09 ON lx.XRefID = ls09.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_15 AS ls15 ON lx.XRefID = ls15.XrefId
WHERE        (NOT (ls.LoanFolder IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) AND (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls09.LOCKRATE_2278 IN ('GR Jumbo Elite')) AND 
                         (ld01._CX_FUNDDATE_1 IS NOT NULL) OR
                         (NOT (ls.LoanFolder IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) AND (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls09.LOCKRATE_2278 IN ('GR Jumbo Elite')) AND 
                         (ld03.LOCKRATE_2222 IS NULL OR
                         ld03.LOCKRATE_2222 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) OR
                         (NOT (ls.LoanFolder IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) AND (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL = 'X') AND 
                         (ls05._CX_PREVINVEST_16 IN ('GR Jumbo Elite')) AND (ld02._CX_LOCKCANCEL_16 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) OR
                         (NOT (ls.LoanFolder IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) AND (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL2 = 'X') AND 
                         (ls05._CX_PREVINVEST2_16 IN ('GR Jumbo Elite')) AND (ld02._CX_LOCKCANCEL2_16 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) OR
                         (NOT (ls.LoanFolder IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) AND (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL3 = 'X') AND 
                         (ls05._CX_PREVINVEST3_16 IN ('GR Jumbo Elite')) AND (ld02._CX_LOCKCANCEL3_16 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) OR
                         (NOT (ls.LoanFolder IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) AND (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL4 = 'X') AND 
                         (ls06._CX_PREVINVEST4_10 IN ('GR Jumbo Elite')) AND (ld02._CX_LOCKCANCEL4_10 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE())))) OR
                         (NOT (ls.LoanFolder IN ('Adverse Loans', 'Audit', 'ContourTemp', 'Knapp Contour', 'Samples'))) AND (ld01._2370 IS NULL OR
                         ld01._2370 >= CONVERT(datetime, DATEADD(day, - 7, CONVERT(date, GETDATE())))) AND (ls02._CX_SECCANCEL5 = 'X') AND 
                         (ls06._CX_PREVINVEST5_10 IN ('GR Jumbo Elite')) AND (ld02._CX_LOCKCANCEL5_10 >= CONVERT(datetime, DATEADD(day, - 5, CONVERT(date, GETDATE()))))
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "lx"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 95
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld01"
            Begin Extent = 
               Top = 6
               Left = 498
               Bottom = 125
               Right = 733
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld02"
            Begin Extent = 
               Top = 6
               Left = 771
               Bottom = 125
               Right = 1057
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld03"
            Begin Extent = 
               Top = 6
               Left = 1095
               Bottom = 125
               Right = 1345
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln01"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 291
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln05"
            Begin Extent = 
               Top = 127
               Left = 316
               Bottom = 246
               Right = 485
            End
            DisplayFlags = 280
            TopColumn = 0
', 'SCHEMA', N'comdesk', 'VIEW', N'CrSuisse_Export_OLD', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'         End
         Begin Table = "ln06"
            Begin Extent = 
               Top = 128
               Left = 503
               Bottom = 247
               Right = 698
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln07"
            Begin Extent = 
               Top = 129
               Left = 729
               Bottom = 248
               Right = 931
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln08"
            Begin Extent = 
               Top = 128
               Left = 962
               Bottom = 247
               Right = 1193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln09"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln11"
            Begin Extent = 
               Top = 126
               Left = 1231
               Bottom = 255
               Right = 1472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls01"
            Begin Extent = 
               Top = 247
               Left = 276
               Bottom = 366
               Right = 556
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls02"
            Begin Extent = 
               Top = 248
               Left = 588
               Bottom = 367
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03"
            Begin Extent = 
               Top = 250
               Left = 862
               Bottom = 369
               Right = 1136
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls04"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 485
               Right = 305
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls05"
            Begin Extent = 
               Top = 366
               Left = 315
               Bottom = 485
               Right = 556
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls06"
            Begin Extent = 
               Top = 367
               Left = 567
               Bottom = 486
               Right = 803
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls08"
            Begin Extent = 
               Top = 369
               Left = 818
               Bottom = 488
               Right = 1095
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls09"
            Begin Extent = 
               Top = 370
               Left = 1118
               Bottom = 489
               Right = 1311
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls15"
            Begin Extent = 
               Top = 486
               Left = 38
               Bottom = 615
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
', 'SCHEMA', N'comdesk', 'VIEW', N'CrSuisse_Export_OLD', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 15
         Column = 3510
         Alias = 1560
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1305
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'comdesk', 'VIEW', N'CrSuisse_Export_OLD', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=3
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'comdesk', 'VIEW', N'CrSuisse_Export_OLD', NULL, NULL
GO
