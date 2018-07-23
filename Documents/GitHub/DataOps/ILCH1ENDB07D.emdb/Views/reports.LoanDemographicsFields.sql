SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [reports].[LoanDemographicsFields]
AS
SELECT        s02._12, s01._14, n02._38, s02._471, s06._53, s04._52, s05._4006, s10._4002_P2, n01._70, n10._38_P2, s03._478, s09._471_P2, s06._85, s06._84, n02._736, 
                         n02._2, n02._356, s01._1041, d01._CX_FUNDDATE_1
FROM            emdbuser.LoanSummary AS ls INNER JOIN
                         emdbuser.LOANXDB_D_01 AS d01 ON d01.XrefId = ls.XRefID INNER JOIN
                         emdbuser.LOANXDB_N_01 AS n01 ON d01.XrefId = n01.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS n02 ON d01.XrefId = n02.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_10 AS n10 ON d01.XrefId = n10.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_01 AS s01 ON d01.XrefId = s01.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 AS s02 ON d01.XrefId = s02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS s03 ON d01.XrefId = s03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 AS s04 ON d01.XrefId = s04.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS s05 ON d01.XrefId = s05.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 AS s06 ON d01.XrefId = s06.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_09 AS s09 ON d01.XrefId = s09.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS s10 ON d01.XrefId = s10.XrefId
WHERE        (NOT (ls.LoanFolder IN ('(Trash)', 'Samples')))
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
         Top = -305
         Left = 0
      End
      Begin Tables = 
         Begin Table = "d01"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n01"
            Begin Extent = 
               Top = 6
               Left = 322
               Bottom = 135
               Right = 585
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n02"
            Begin Extent = 
               Top = 6
               Left = 623
               Bottom = 135
               Right = 869
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n10"
            Begin Extent = 
               Top = 6
               Left = 907
               Bottom = 135
               Right = 1237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s01"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 360
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s02"
            Begin Extent = 
               Top = 138
               Left = 398
               Bottom = 267
               Right = 656
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s03"
            Begin Extent = 
               Top = 138
               Left = 694
               Bottom = 267
               Right = 990
            End
            DisplayFlags = 280
            TopColumn = 0', 'SCHEMA', N'reports', 'VIEW', N'LoanDemographicsFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'
         End
         Begin Table = "s04"
            Begin Extent = 
               Top = 138
               Left = 1028
               Bottom = 267
               Right = 1312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s05"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s06"
            Begin Extent = 
               Top = 270
               Left = 330
               Bottom = 399
               Right = 577
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s09"
            Begin Extent = 
               Top = 270
               Left = 615
               Bottom = 399
               Right = 820
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s10"
            Begin Extent = 
               Top = 270
               Left = 858
               Bottom = 399
               Right = 1202
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 531
               Right = 288
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
         Column = 1440
         Alias = 900
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
', 'SCHEMA', N'reports', 'VIEW', N'LoanDemographicsFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'reports', 'VIEW', N'LoanDemographicsFields', NULL, NULL
GO
