SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [reports].[InactiveCustomersFields]
AS
SELECT        s1._36, s1._37, s3._65, CONVERT(date, d1._1402) AS _1402, s1._68, s1._69, s1._97, CONVERT(date, d2._1403) AS _1403, s2._1401, s9.LOCKRATE_19, s10._1172, 
                         s1._608, s1._11, s2._12, s1._14, s3._15, s1._66, s1._FE0117, s1._1490, s1._1240, s1._1268, s2._364, CONVERT(money, n2._2) AS _2, n4._CX_LTVNEW_10, 
                         n4._CX_CLTVNEW_10, CONVERT(date, d1._CX_FUNDDATE_1) AS _CX_FUNDDATE_1, n1._3, n1._5, s9.LOCKRATE_2853, s9.LOCKRATE_1041, CONVERT(int, n1._16) 
                         AS _16, s9.LOCKRATE_1811, n2._356, s6._FE0102, s6._FE0110, n4._910, s6._FE0202, s6._FE0210, n4._911, s5._CX_FINALLONAME, s3._CX_FINALOCODE_4, 
                         n3._427, d1._2370, n2._742, n2._4, n3._428, s1._FR0104, s2._FR0106, s2._FR0107, s3._FR0108
FROM            emdbuser.LOANXDB_D_01 AS d1 INNER JOIN
                         emdbuser.LOANXDB_D_02 AS d2 ON d1.XrefId = d2.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_01 AS s1 ON d1.XrefId = s1.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 AS s2 ON d1.XrefId = s2.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS s3 ON d1.XrefId = s3.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS s5 ON d1.XrefId = s5.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 AS s6 ON d1.XrefId = s6.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_09 AS s9 ON d1.XrefId = s9.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS s10 ON d1.XrefId = s10.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_01 AS n1 ON d1.XrefId = n1.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS n2 ON d1.XrefId = n2.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_03 AS n3 ON d1.XrefId = n3.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_04 AS n4 ON d1.XrefId = n4.XrefId
WHERE        (d1._CX_FUNDDATE_1 IS NOT NULL)





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
         Begin Table = "s3"
            Begin Extent = 
               Top = 6
               Left = 902
               Bottom = 135
               Right = 1198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s1"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 135
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s2"
            Begin Extent = 
               Top = 6
               Left = 606
               Bottom = 135
               Right = 864
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s5"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s6"
            Begin Extent = 
               Top = 138
               Left = 330
               Bottom = 267
               Right = 577
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s9"
            Begin Extent = 
               Top = 138
               Left = 615
               Bottom = 267
               Right = 820
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s10"
            Begin Extent = 
               Top = 138
               Left = 858
               Bottom = 267
               Right = 1202
            End
            DisplayFlags = 280
            TopColumn = 0
    ', 'SCHEMA', N'reports', 'VIEW', N'InactiveCustomersFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'     End
         Begin Table = "d1"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d2"
            Begin Extent = 
               Top = 270
               Left = 322
               Bottom = 399
               Right = 630
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n1"
            Begin Extent = 
               Top = 270
               Left = 668
               Bottom = 399
               Right = 931
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n2"
            Begin Extent = 
               Top = 270
               Left = 969
               Bottom = 399
               Right = 1215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n3"
            Begin Extent = 
               Top = 402
               Left = 314
               Bottom = 531
               Right = 550
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n4"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 531
               Right = 276
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
', 'SCHEMA', N'reports', 'VIEW', N'InactiveCustomersFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'reports', 'VIEW', N'InactiveCustomersFields', NULL, NULL
GO
