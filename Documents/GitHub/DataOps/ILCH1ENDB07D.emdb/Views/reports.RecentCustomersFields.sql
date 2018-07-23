SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [reports].[RecentCustomersFields]
AS
SELECT        s1._36, s1._37, s2._12, s1._14, CONVERT(bigint, n2._2) AS _2, CONVERT(date, d2._MS_START) AS _MS_START, CONVERT(date, d1._CX_RESPAAPP_1) 
                         AS _CX_RESPAAPP_1, CONVERT(date, d1._745) AS _745, CONVERT(date, CASE WHEN isdate(_2025) = 1 THEN _2025 END, 101) AS _2025, CONVERT(date, 
                         d3._CX_CRRPTORDERED) AS _CX_CRRPTORDERED, CONVERT(date, d1._748) AS _748, CONVERT(date, d1._CX_FUNDDATE_1) AS _CX_FUNDDATE_1, 
                         s10._1172
FROM            emdbuser.LOANXDB_S_01 AS s1 INNER JOIN
                         emdbuser.LOANXDB_S_02 AS s2 ON s1.XrefId = s2.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS s10 ON s1.XrefId = s10.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS n2 ON s1.XrefId = n2.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_01 AS d1 ON s1.XrefId = d1.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_02 AS d2 ON s1.XrefId = d2.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_03 AS d3 ON s1.XrefId = d3.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 AS s4 ON s1.XrefId = s4.XrefId
WHERE        (s4._LOANFOLDER NOT IN ('(Trash)', 'Samples')) AND (d2._MS_START >= '2012-01-01')
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
         Begin Table = "s1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 360
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s2"
            Begin Extent = 
               Top = 6
               Left = 398
               Bottom = 135
               Right = 656
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s10"
            Begin Extent = 
               Top = 138
               Left = 1005
               Bottom = 267
               Right = 1349
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n2"
            Begin Extent = 
               Top = 6
               Left = 694
               Bottom = 135
               Right = 940
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d1"
            Begin Extent = 
               Top = 6
               Left = 978
               Bottom = 135
               Right = 1224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d2"
            Begin Extent = 
               Top = 138
               Left = 360
               Bottom = 267
               Right = 668
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d3"
            Begin Extent = 
               Top = 138
               Left = 706
               Bottom = 267
               Right = 967
            End
            DisplayFlags = 280
            TopColumn = 0
     ', 'SCHEMA', N'reports', 'VIEW', N'RecentCustomersFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    End
         Begin Table = "s4"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 322
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
', 'SCHEMA', N'reports', 'VIEW', N'RecentCustomersFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'reports', 'VIEW', N'RecentCustomersFields', NULL, NULL
GO
