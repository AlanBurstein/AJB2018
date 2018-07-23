SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [secmktg].[DailyLocks]
AS
SELECT        d.Division AS [GR Division], o.officeName AS Office, e.DisplayName AS [Loan Officer], secmktg.[LoanStatus-2](ld01._2298, ld01._2301, ld01._2303, ld01._745, 
                         ld01._2149, ld01._2151, ld01._748, ld01._CX_FUNDDATE_1, ld01._2370, ld01._749, GETDATE()) AS Status, 'Encompass' AS LOS, 'EC' AS Filename, 
                         ls02._364 AS [Loan Number], ls01._37 AS [Last Name], ls01._36 AS [First Name], CASE WHEN len(_2288) > 3 THEN _2288 WHEN len(_2286) 
                         > 3 THEN _2286 ELSE '' END AS [Commitment Number], secmktg.[FinalInvestor-2](ls02._2278) AS [Final Investor], 1 AS Units, CONVERT(money, ln02._2) AS Amount, 
                         CASE WHEN _420 LIKE 'First%' THEN '1' WHEN _420 LIKE 'Second%' THEN '2' WHEN _420 IS NULL AND _1172 NOT IN ('HELOC') THEN '1' WHEN _420 IS NULL 
                         AND _1172 IN ('HELOC') THEN '2' WHEN _420 = 0 THEN '1' ELSE _420 END AS [Lien Position], 
                         CASE WHEN _2278 LIKE 'Alliant%' THEN 'Y' WHEN _1401 LIKE 'Alliant%' THEN 'Y' WHEN len(_vend_x200) 
                         > 2 THEN 'N' WHEN _2626 = 'Correspondent' THEN 'N' WHEN _2626 LIKE 'Banked%Retal' THEN 'N' WHEN _2626 LIKE 'Banked%Wholesale' THEN 'N' WHEN _2626 =
                          'Brokered' THEN 'Y' WHEN _2278 LIKE '%Correspondent%' THEN 'N' WHEN _2278 LIKE '%Broker%' THEN 'Y' WHEN _2278 LIKE 'GRI%' THEN 'N' WHEN _2278 LIKE
                          'Alliant%' THEN 'Y' WHEN ld01._2149 IS NOT NULL THEN 'N' WHEN ld01._2149 IS NULL THEN 'Y' ELSE _2626 END AS Brokered, 
                         CASE WHEN _19 = 'Cash-Out Refinance' THEN 'Refinance' WHEN _19 = 'NoCash-Out Refinance' THEN 'Refinance' WHEN _19 = 'Purchase' THEN 'Purchase' ELSE 'Purchase'
                          END AS Purpose, UPPER(ls02._1130) AS Program, CASE WHEN _1172 IN ('HELOC') 
                         THEN 'Second Lien' WHEN _420 LIKE 'Second%' THEN 'Second Lien' WHEN _1401 LIKE '%CES%Second%' THEN 'Second Lien' WHEN _1401 LIKE '%HELOC%Second%'
                          THEN 'Second Lien' WHEN _2278 IN ('PHH Mortgage') AND _2 > 417000 AND _608 = 'Fixed' THEN 'Conf Fixed' WHEN _2278 IN ('PHH Mortgage') AND 
                         _2 > 417000 AND _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN (_2278 LIKE 'Fannie Mae%' OR
                         _2278 LIKE 'GRI - Fannie Mae%' OR
                         _2278 LIKE 'Freddie%' OR
                         _2278 LIKE 'GRI - Freddie Mac%') AND _2 > 417000 AND _608 = 'Fixed' THEN 'Conf Fixed' WHEN (_2278 LIKE 'Fannie Mae%' OR
                         _2278 LIKE 'GRI - Fannie Mae%' OR
                         _2278 LIKE 'Freddie%' OR
                         _2278 LIKE 'GRI - Freddie Mac%') AND _2 > 417000 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1401 LIKE 'GR - Freddie%' THEN 'FHLMC Fixed' WHEN _2278 LIKE 'GRI - Freddie Mac%' THEN 'FHLMC Fixed' WHEN
                          _2278 LIKE 'Freddie Mac%' THEN 'FHLMC Fixed' WHEN _2278 LIKE 'Alliant%' THEN 'Alliant ARM' WHEN _1401 LIKE 'Alliant%' THEN 'Alliant ARM' WHEN _2278 IN ('GR Jumbo Premier')
                          AND _608 = 'Fixed' THEN 'Jumbo Fixed' WHEN _2278 IN ('GR Jumbo Premier') AND _608 = 'AdjustableRate' THEN 'Jumbo ARM' WHEN _1130 IN ('C30HB', 'C15HB', 
                         'AJ30', 'AJ15') 
                         THEN 'Agency Jumbo Fixed' WHEN _1401 LIKE '%Fixed%Agency%Jumbo%' THEN 'Agency Jumbo Fixed' WHEN _1401 LIKE '%Agency%Jumbo%Fixed%' THEN 'Agency Jumbo Fixed'
                          WHEN _1401 LIKE '%Agency%Jumbo%Plus%' THEN 'Agency Jumbo Fixed' WHEN _1401 LIKE '%Agency%Jumbo%ARM%' THEN 'Agency Jumbo ARM' WHEN _1401 LIKE
                          '%GNMA%High%Balance%Fixed%' THEN 'FHA Jumbo Fixed' WHEN _1401 LIKE '%GNMA%High%Balance%ARM%' THEN 'FHA Jumbo ARM' WHEN _1401 LIKE '%High%Balance%Fixed%'
                          THEN 'Agency Jumbo Fixed' WHEN _1401 LIKE '%High%Balance%ARM%' THEN 'Agency Jumbo ARM' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') 
                         AND _16 = 1 AND _2 <= 417000 AND _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _16 = 2 AND 
                         _2 <= 533850 AND _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _16 = 3 AND _2 <= 645300 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _16 = 4 AND _2 <= 801950 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _2 <= 417000 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _16 = 1 AND _2 <= 417000 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _16 = 2 AND _2 <= 533850 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _16 = 3 AND _2 <= 645300 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _16 = 4 AND _2 <= 801950 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 NOT IN ('HI', 'AK') AND _2 <= 417000 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 1 AND _2 <= 625500 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 2 AND _2 <= 800775 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 3 AND _2 <= 967950 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 4 AND _2 <= 1202925 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _2 <= 625500 AND 
                         _608 = 'Fixed' THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 1 AND _2 <= 625500 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 2 AND _2 <= 800775 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 3 AND _2 <= 967950 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _16 = 4 AND _2 <= 1202925 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _14 IN ('HI', 'AK') AND _2 <= 625500 AND 
                         _608 = 'AdjustableRate' THEN 'Conf ARM' WHEN _1172 IN ('Conventional') AND _2 > 417000 AND _608 = 'Fixed' THEN 'Jumbo Fixed' WHEN _1172 IN ('Conventional')
                          AND _2 > 417000 AND _608 = 'AdjustableRate' THEN 'Jumbo ARM' WHEN _1172 IN ('FHA', 'VA') AND _608 = 'Fixed' THEN 'FHA Fixed' WHEN _1172 IN ('FHA', 'VA') 
                         AND _608 = 'AdjustableRate' THEN 'FHA ARM' WHEN _1172 IN ('FHA', 'VA') AND _608 IS NULL THEN 'FHA Fixed' WHEN len(_1172) < 2 AND len(_14) < 2 AND 
                         _16 = 0 AND _2 = 0 AND len(_608) < 2 THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND _2 <= 417000 THEN 'Conf Fixed' WHEN _1172 IN ('Conventional') AND
                          _2 > 417000 THEN 'Jumbo Fixed' WHEN _1401 LIKE '%Conforming%Fixed%' THEN 'Conf Fixed' WHEN _1401 LIKE '%FHLMC%' THEN 'Conf Fixed' WHEN _1401 LIKE
                          '%Conforming%ARM%' THEN 'Conf ARM' WHEN _1401 LIKE '%FHA%Fixed%' THEN 'FHA Fixed' WHEN _1401 LIKE '%FHA%ARM%' THEN 'FHA ARM' WHEN _1401 LIKE
                          '%FHA%Fixed%' THEN 'FHA Fixed' WHEN _1401 LIKE '%FHA%ARM%' THEN 'FHA ARM' WHEN _1401 LIKE '%JB Nutter%' THEN 'FHA Fixed' WHEN _1172 IN ('FarmersHomeAdministration')
                          THEN 'FHA Fixed' WHEN _1172 IN ('Other') AND _608 = 'AdjustableRate' AND _1130 LIKE 'J%' THEN 'Jumbo ARM' WHEN _1172 IN ('Other') AND _608 = 'Fixed' AND 
                         _1130 LIKE 'J%' THEN 'Jumbo Fixed' ELSE _1172 + ' ' + _608 END AS Product, ln01._3 AS [Note Rate], CONVERT(date, ISNULL(ld01._CX_APPSENT_1, ld01._2149)) 
                         AS [Application Date], CONVERT(date, ld01._2149) AS [Locked Date], CONVERT(date, ld01._748) AS [Closed Date], CONVERT(date, ld01._CX_FUNDDATE_1) 
                         AS [Funded Date], CONVERT(date, ld01._2370) AS [Purchased Date], ls03._VEND_X200 AS Warehouse
FROM            [GRCHILHQ-SQ-03].emdb.emdbuser.LoanXRef AS lx INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_01 AS ls01 ON lx.XRefID = ls01.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_N_01 AS ln01 ON lx.XRefID = ln01.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_N_02 AS ln02 ON lx.XRefID = ln02.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_N_03 AS ln03 ON lx.XRefID = ln03.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_N_04 AS ln04 ON lx.XRefID = ln04.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_N_05 AS ln05 ON lx.XRefID = ln05.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_N_06 AS ln06 ON lx.XRefID = ln06.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_N_07 AS ln07 ON lx.XRefID = ln07.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_D_01 AS ld01 ON lx.XRefID = ld01.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_D_02 AS ld02 ON lx.XRefID = ld02.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_02 AS ls02 ON lx.XRefID = ls02.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_03 AS ls03 ON lx.XRefID = ls03.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_04 AS ls04 ON lx.XRefID = ls04.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_05 AS ls05 ON lx.XRefID = ls05.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_06 AS ls06 ON lx.XRefID = ls06.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_07 AS ls07 ON lx.XRefID = ls07.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_08 AS ls08 ON lx.XRefID = ls08.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_09 AS ls09 ON lx.XRefID = ls09.XrefId INNER JOIN
                         [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_10 AS ls10 ON lx.XRefID = ls10.XrefId INNER JOIN
                         Admin.corp.LOCode AS e ON e.LOCode = ls03._CX_FINALOCODE_4 INNER JOIN
                         Admin.corp.CostCenter ON e.CostCenterID = Admin.corp.CostCenter.CostCenterID INNER JOIN
                         Admin.corp.Region ON Admin.corp.CostCenter.RegionID = Admin.corp.Region.RegionID INNER JOIN
                         Admin.corp.Division AS d ON Admin.corp.Region.DivisionID = d.DivisionID INNER JOIN
                         Admin.corp.Office AS o ON e.OfficeID = o.officeId
WHERE        (ld01._2149 BETWEEN GETDATE() - 14 AND GETDATE() + 1) AND (LEN(ls02._2278) > 2)


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
      ActivePaneConfig = 0
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
         Begin Table = "ls01"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 516
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln01"
            Begin Extent = 
               Top = 6
               Left = 554
               Bottom = 125
               Right = 807
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln02"
            Begin Extent = 
               Top = 6
               Left = 845
               Bottom = 125
               Right = 1083
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln03"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln04"
            Begin Extent = 
               Top = 126
               Left = 302
               Bottom = 245
               Right = 531
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln05"
            Begin Extent = 
               Top = 6
               Left = 1121
               Bottom = 125
               Right = 1290
            End
            DisplayFlags = 280
            TopColumn = 0', 'SCHEMA', N'secmktg', 'VIEW', N'DailyLocks', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'
         End
         Begin Table = "ln06"
            Begin Extent = 
               Top = 126
               Left = 569
               Bottom = 245
               Right = 764
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln07"
            Begin Extent = 
               Top = 126
               Left = 802
               Bottom = 245
               Right = 1004
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld01"
            Begin Extent = 
               Top = 126
               Left = 1042
               Bottom = 245
               Right = 1277
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld02"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 324
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls02"
            Begin Extent = 
               Top = 246
               Left = 362
               Bottom = 365
               Right = 604
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03"
            Begin Extent = 
               Top = 246
               Left = 642
               Bottom = 365
               Right = 916
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls04"
            Begin Extent = 
               Top = 246
               Left = 954
               Bottom = 365
               Right = 1221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls05"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 485
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls06"
            Begin Extent = 
               Top = 366
               Left = 317
               Bottom = 485
               Right = 553
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls07"
            Begin Extent = 
               Top = 366
               Left = 906
               Bottom = 485
               Right = 1171
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls08"
            Begin Extent = 
               Top = 366
               Left = 591
               Bottom = 485
               Right = 868
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls09"
            Begin Extent = 
               Top = 594
               Left = 38
               Bottom = 713
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls10"
            Begin Extent = 
               Top = 678
               Left = 904
               Bottom = 797
               Right = 1223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 486
               Left = 38
               Bottom = 581
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CostCenter (Admin.corp)"
            Begin Extent = 
               ', 'SCHEMA', N'secmktg', 'VIEW', N'DailyLocks', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'Top = 486
               Left = 499
               Bottom = 615
               Right = 679
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Region (Admin.corp)"
            Begin Extent = 
               Top = 486
               Left = 717
               Bottom = 615
               Right = 901
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 486
               Left = 939
               Bottom = 598
               Right = 1109
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 486
               Left = 1147
               Bottom = 615
               Right = 1336
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3060
         Alias = 2025
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
         Or = 1350
      End
   End
End
', 'SCHEMA', N'secmktg', 'VIEW', N'DailyLocks', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=3
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'secmktg', 'VIEW', N'DailyLocks', NULL, NULL
GO
