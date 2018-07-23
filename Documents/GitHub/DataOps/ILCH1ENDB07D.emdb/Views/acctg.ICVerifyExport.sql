SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [acctg].[ICVerifyExport]
AS
SELECT     CASE ls04._CX_ACCREV_5 WHEN 'X' THEN 'Return' ELSE 'Sale' END AS TransactionType, ls02._364 + ' ' + ls01._37 AS InvoiceComment, 
                      COALESCE (ls03._CX_CREDITCNUMBER_1, '') AS CardNumber, COALESCE (ls03._CX_CCARDEXPIRE_1, '') AS CardExpiration, 
                      COALESCE (ls10._CX_ACCCARDSECCODE, '') AS CardSecCode, COALESCE (CONVERT(varchar(24), CONVERT(money, ABS(ln02._CX_ACCOKAMT_5))), '') AS Amount, 
                      COALESCE (LEFT(ls04._CX_ACCCARDZIP_5, 5), '') AS ZIP, COALESCE (ls04._CX_ACCCARDADD_5, '') AS BillingAddress
FROM         emdbuser.LoanXRef AS lx INNER JOIN
                      emdbuser.LoanSummary AS ls ON lx.XRefID = ls.XRefID INNER JOIN
                      emdbuser.LOANXDB_S_01 AS ls01 ON lx.XRefID = ls01.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_02 AS ls02 ON lx.XRefID = ls02.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_03 AS ls03 ON lx.XRefID = ls03.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_04 AS ls04 ON lx.XRefID = ls04.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_02 AS ln02 ON lx.XRefID = ln02.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_10 AS ls10 ON lx.XRefID = ls10.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_02 AS ld02 ON lx.XRefID = ld02.XrefId LEFT OUTER JOIN
                      emdbuser.LoanFolder AS lf ON ls.LoanFolder = lf.folderName
WHERE     (ld02._CX_ACCCARDSTAMP_5 > '2011-10-01 00:00:00') AND (lf.folderType IS NULL OR
                      lf.folderType = 0)
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
         Begin Table = "ls01"
            Begin Extent = 
               Top = 6
               Left = 300
               Bottom = 125
               Right = 580
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls02"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 280
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03"
            Begin Extent = 
               Top = 126
               Left = 318
               Bottom = 245
               Right = 592
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls04"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 305
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln02"
            Begin Extent = 
               Top = 246
               Left = 343
               Bottom = 365
               Right = 581
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld02"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 485
               Right = 324
            End
            DisplayFlags = 280
            TopColumn =', 'SCHEMA', N'acctg', 'VIEW', N'ICVerifyExport', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' 0
         End
         Begin Table = "lf"
            Begin Extent = 
               Top = 7
               Left = 617
               Bottom = 126
               Right = 777
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls10"
            Begin Extent = 
               Top = 369
               Left = 343
               Bottom = 488
               Right = 611
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lx"
            Begin Extent = 
               Top = 6
               Left = 815
               Bottom = 95
               Right = 975
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4905
         Alias = 1530
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
', 'SCHEMA', N'acctg', 'VIEW', N'ICVerifyExport', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'acctg', 'VIEW', N'ICVerifyExport', NULL, NULL
GO
