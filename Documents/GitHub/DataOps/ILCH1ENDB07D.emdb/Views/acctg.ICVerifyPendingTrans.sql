SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [acctg].[ICVerifyPendingTrans]
AS
SELECT     ls02._364 AS LoanNumber, ld01._CX_ACCTDATECHRG_2 AS ChargeDate1, ld01._CX_ACCTDATECHRG2_2 AS ChargeDate2, 
                      ld01._CX_ACCTDATECHRG3_3 AS ChargeDate3, ld01._CX_ACCTDATECHRG4_3 AS ChargeDate4, ln02._CX_ACCOKAMT_5 AS Amount, 
                      ld02._CX_ACCCARDSTAMP_5 AS RequestDate, CONVERT(bit, CASE ls04._CX_ACCREV_5 WHEN 'X' THEN 0 ELSE 1 END) AS Sale
FROM         emdbuser.LoanSummary AS ls INNER JOIN
                      emdbuser.LOANXDB_S_02 AS ls02 ON ls.XRefID = ls02.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_04 AS ls04 ON ls.XRefID = ls04.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_02 AS ln02 ON ls.XRefID = ln02.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_01 AS ld01 ON ls.XRefID = ld01.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_02 AS ld02 ON ls.XRefID = ld02.XrefId
WHERE     (ld02._CX_ACCCARDSTAMP_5 IS NOT NULL)
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
         Begin Table = "ls"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls02"
            Begin Extent = 
               Top = 6
               Left = 300
               Bottom = 125
               Right = 542
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls04"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 305
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln02"
            Begin Extent = 
               Top = 6
               Left = 580
               Bottom = 125
               Right = 818
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld01"
            Begin Extent = 
               Top = 126
               Left = 343
               Bottom = 245
               Right = 578
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
         Alias = 1395
         Table', 'SCHEMA', N'acctg', 'VIEW', N'ICVerifyPendingTrans', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' = 1170
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
', 'SCHEMA', N'acctg', 'VIEW', N'ICVerifyPendingTrans', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'acctg', 'VIEW', N'ICVerifyPendingTrans', NULL, NULL
GO
