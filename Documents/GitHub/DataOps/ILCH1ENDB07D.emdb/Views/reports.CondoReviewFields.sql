SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [reports].[CondoReviewFields]
AS
SELECT        s8._1298, s1._11, s2._12, s1._14, s3._15, s13._1553, n10._ULDD_X176, s12._ULDD_X177, s2._1012, s16._3050, d3._CX_UWCONDOAPPR, 
                         d3._CX_UWCONDOSUS, s10._CX_UWCONDOREV, s10._CX_UWCONDOREVTYP, s16._CX_CNDO_GENCMTS, s16._CX_CNDO_RSNDECL, s16._CX_CNDO_LIT, 
                         s10._CX_CNDO_LITACPT, s16._CX_CNDO_LITNOTACPT, s16._CX_CNDO_PREVLOAN
FROM            emdbuser.LOANXDB_S_01 AS s1 INNER JOIN
                         emdbuser.LOANXDB_S_02 AS s2 ON s1.XrefId = s2.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS s3 ON s1.XrefId = s3.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_08 AS s8 ON s1.XrefId = s8.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS s10 ON s1.XrefId = s10.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_12 AS s12 ON s1.XrefId = s12.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_13 AS s13 ON s1.XrefId = s13.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_16 AS s16 ON s1.XrefId = s16.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_10 AS n10 ON s1.XrefId = n10.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_03 AS d3 ON s1.XrefId = d3.XrefId
WHERE        (d3._CX_UWCONDOAPPR IS NOT NULL) OR
                         (d3._CX_UWCONDOSUS IS NOT NULL)
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
         Begin Table = "s3"
            Begin Extent = 
               Top = 6
               Left = 694
               Bottom = 135
               Right = 990
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s8"
            Begin Extent = 
               Top = 6
               Left = 1028
               Bottom = 135
               Right = 1324
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s10"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 382
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s12"
            Begin Extent = 
               Top = 138
               Left = 420
               Bottom = 267
               Right = 658
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s13"
            Begin Extent = 
               Top = 138
               Left = 696
               Bottom = 267
               Right = 990
            End
            DisplayFlags = 280
            TopColumn = 0
     ', 'SCHEMA', N'reports', 'VIEW', N'CondoReviewFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    End
         Begin Table = "s16"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 374
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n10"
            Begin Extent = 
               Top = 138
               Left = 1028
               Bottom = 267
               Right = 1358
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d3"
            Begin Extent = 
               Top = 270
               Left = 412
               Bottom = 399
               Right = 673
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
', 'SCHEMA', N'reports', 'VIEW', N'CondoReviewFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'reports', 'VIEW', N'CondoReviewFields', NULL, NULL
GO
