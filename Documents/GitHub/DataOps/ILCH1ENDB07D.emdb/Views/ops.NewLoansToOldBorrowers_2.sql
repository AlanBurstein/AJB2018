SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ops].[NewLoansToOldBorrowers_2]
AS
SELECT DISTINCT 
                         ls1.LoanNumber, u1.first_name AS LOFirstName, ls1.BorrowerFirstName, ls1.BorrowerLastName, ls1.LoanType, ls1.DateCreated, ls1.LoanOfficerName AS LOname, 
                         u1.email AS LOemail, u1.phone AS LOPhone, ls2.LoanNumber AS OldLoanNumber, ls2.DateCreated AS OldDateCreated, ls01._11 AS Address, ls02._12 AS City, 
                         ls01._14 AS State, ls03._15 AS ZipCode, emp2.Email AS OldPaidLOemail, emp2.FirstName AS OldPaidLOname
FROM            emdbuser.LoanSummary AS ls1 INNER JOIN
                         emdbuser.LoanBorrowers AS lb1 ON ls1.Guid = lb1.Guid INNER JOIN
                         emdbuser.LoanSummary AS ls2 ON ls1.Guid <> ls2.Guid AND ls1.LoanOfficerId <> ls2.LoanOfficerId AND ls1.DateCreated > ls2.DateCreated INNER JOIN
                         emdbuser.LoanBorrowers AS lb2 ON ls2.Guid = lb2.Guid AND lb1.SSN = lb2.SSN INNER JOIN
                         emdbuser.users AS u1 ON ls1.LoanOfficerId = u1.userid LEFT OUTER JOIN
                         emdbuser.LoanFolder AS lf ON ls1.LoanFolder = lf.folderName INNER JOIN
                         emdbuser.LOANXDB_S_01 AS ls01 ON ls1.XRefID = ls01.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 AS ls02 ON ls1.XRefID = ls02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS ls03 ON ls1.XRefID = ls03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS ls03_02 ON ls2.XRefID = ls03_02.XrefId INNER JOIN
                         Admin.corp.LOCode AS emp2 ON emp2.LOCode = ls03_02._CX_FINALOCODE_4 INNER JOIN
                         Admin.corp.Employee AS emp1 ON u1.userid = emp1.EncompassLogin LEFT OUTER JOIN
                         ops.BadLoanSSNs AS ss ON lb1.SSN = ss.SSN
WHERE        (emp2.Active = 1) AND (CONVERT(date, ls1.DateCreated) = CONVERT(date, GETDATE())) AND (ls1.BorrowerLastName <> 'gg') AND (ls1.BorrowerFirstName <> 'gg') 
                         AND (lb1.FirstName <> 'gg') AND (lb1.LastName <> 'gg') AND (ISNULL(lf.folderType, 0) = 0) AND (ss.SSN IS NULL)

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
         Begin Table = "ls1"
            Begin Extent = 
               Top = 4
               Left = 246
               Bottom = 133
               Right = 496
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lb1"
            Begin Extent = 
               Top = 23
               Left = 40
               Bottom = 152
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls2"
            Begin Extent = 
               Top = 3
               Left = 559
               Bottom = 132
               Right = 809
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lb2"
            Begin Extent = 
               Top = 24
               Left = 845
               Bottom = 153
               Right = 1015
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u1"
            Begin Extent = 
               Top = 161
               Left = 6
               Bottom = 290
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lf"
            Begin Extent = 
               Top = 299
               Left = 33
               Bottom = 428
               Right = 203
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls01"
            Begin Extent = 
               Top = 300
               Left = 456
               Bottom = 429
               Right = 637
            End
            DisplayFlags = 280
            TopColumn = 0
   ', 'SCHEMA', N'ops', 'VIEW', N'NewLoansToOldBorrowers_2', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'      End
         Begin Table = "ls02"
            Begin Extent = 
               Top = 299
               Left = 654
               Bottom = 428
               Right = 826
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03"
            Begin Extent = 
               Top = 298
               Left = 844
               Bottom = 427
               Right = 1017
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03_02"
            Begin Extent = 
               Top = 161
               Left = 844
               Bottom = 290
               Right = 1051
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "emp2"
            Begin Extent = 
               Top = 157
               Left = 1120
               Bottom = 286
               Right = 1293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "emp1"
            Begin Extent = 
               Top = 163
               Left = 281
               Bottom = 292
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ss"
            Begin Extent = 
               Top = 300
               Left = 265
               Bottom = 395
               Right = 435
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
', 'SCHEMA', N'ops', 'VIEW', N'NewLoansToOldBorrowers_2', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'ops', 'VIEW', N'NewLoansToOldBorrowers_2', NULL, NULL
GO
