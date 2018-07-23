SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [reports].[FrontDeskFields]
AS
SELECT        s4._LOANFOLDER AS LoanFolder, s1._36, s1._37, s5._CX_FINALLONAME, s2._364, n2._1109, CONVERT(date, d1._CX_FUNDDATE_1) AS _CX_FUNDDATE_1, s1._11, 
                         s1._14, CONVERT(date, d1._2014) AS _2014, s3._1051, CONVERT(date, d1._1997) AS _1997, s2._2278, s1._68, s1._69, s1._1040
FROM            emdbuser.LOANXDB_S_01 AS s1 INNER JOIN
                         emdbuser.LOANXDB_S_02 AS s2 ON s1.XrefId = s2.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS s3 ON s1.XrefId = s3.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 AS s4 ON s1.XrefId = s4.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS s5 ON s1.XrefId = s5.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_01 AS d1 ON s1.XrefId = d1.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS n2 ON s1.XrefId = n2.XrefId
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
               Left = 326
               Bottom = 135
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s2"
            Begin Extent = 
               Top = 6
               Left = 686
               Bottom = 135
               Right = 944
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s3"
            Begin Extent = 
               Top = 6
               Left = 982
               Bottom = 135
               Right = 1278
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
         Begin Table = "s5"
            Begin Extent = 
               Top = 138
               Left = 360
               Bottom = 267
               Right = 614
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d1"
            Begin Extent = 
               Top = 138
               Left = 652
               Bottom = 267
               Right = 898
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n2"
            Begin Extent = 
               Top = 138
               Left = 936
               Bottom = 267
               Right = 1182
            End
            DisplayFlags = 280
            TopColumn = 0
     ', 'SCHEMA', N'reports', 'VIEW', N'FrontDeskFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    End
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
', 'SCHEMA', N'reports', 'VIEW', N'FrontDeskFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'reports', 'VIEW', N'FrontDeskFields', NULL, NULL
GO
