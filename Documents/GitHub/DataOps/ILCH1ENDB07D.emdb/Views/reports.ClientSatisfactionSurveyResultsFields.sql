SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [reports].[ClientSatisfactionSurveyResultsFields]
AS
SELECT        ls.Guid, s03._CX_FINALOCODE_4, s01._37, s01._36, s01._66, s01._1490, s01._1240, s01._FR0104, s02._FR0106, s02._FR0107, s03._FR0108, s03._1822, 
                         s02._364, n02._2, s10._1172, s01._19, s02._CX_SECRELOCK, s02._CX_SECRELOCK2, s02._CX_SECRELOCK3, s02._CX_SECRELOCK4, s02._CX_SECRELOCK5, 
                         CONVERT(date, d02._MS_START) AS _MS_START, CONVERT(date, d01._CX_RESPAAPP_1) AS _CX_RESPAAPP_1, CONVERT(date, d01._748) AS _748, 
                         CONVERT(date, d01._CX_FUNDDATE_1) AS _CX_FUNDDATE_1, s02._2278, s02._411, s03._CX_MCNAME_1, s01._CX_LCNAME_1, s17._CX_CLOSER_1, d.DivisionID,
                          d.Division, r.RegionID, r.Region, c.CostCenter, c.CostCenterName, CONVERT(int, o.officeId) AS OfficeID, o.officeName AS Office, lo.EmployeeID AS LoanOfficerID, 
                         lo.DisplayName AS LoanOfficer
FROM            emdbuser.LoanSummary AS ls WITH (nolock) INNER JOIN
                         emdbuser.LOANXDB_S_01 AS s01 WITH (nolock) ON ls.XRefID = s01.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 AS s02 WITH (nolock) ON s01.XrefId = s02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS s03 WITH (nolock) ON s01.XrefId = s03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 AS s04 WITH (nolock) ON s01.XrefId = s04.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS s05 WITH (nolock) ON s01.XrefId = s05.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 AS s06 WITH (nolock) ON s01.XrefId = s06.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS s10 WITH (nolock) ON s01.XrefId = s10.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_17 AS s17 WITH (nolock) ON s01.XrefId = s17.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS n02 WITH (nolock) ON s01.XrefId = n02.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_01 AS d01 WITH (nolock) ON s01.XrefId = d01.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_02 AS d02 WITH (nolock) ON s01.XrefId = d02.XrefId LEFT OUTER JOIN
                         Admin.corp.LOCode AS lo WITH (nolock) ON s03._CX_FINALOCODE_4 = lo.LOCode LEFT OUTER JOIN
                         Admin.corp.Office AS o WITH (nolock) ON lo.OfficeID = o.officeId LEFT OUTER JOIN
                         Admin.corp.CostCenter AS c WITH (nolock) ON lo.CostCenterID = c.CostCenterID LEFT OUTER JOIN
                         Admin.corp.Region AS r WITH (nolock) ON c.RegionID = r.RegionID LEFT OUTER JOIN
                         Admin.corp.Division AS d WITH (nolock) ON r.DivisionID = d.DivisionID
WHERE        (ls.Guid IN
                             (SELECT        loan_number
                               FROM            ReplicatedTables.dbo.SurveyList WITH (nolock)))
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
               Bottom = 135
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s01"
            Begin Extent = 
               Top = 6
               Left = 326
               Bottom = 135
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s02"
            Begin Extent = 
               Top = 6
               Left = 686
               Bottom = 135
               Right = 944
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s03"
            Begin Extent = 
               Top = 6
               Left = 982
               Bottom = 135
               Right = 1278
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s04"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 322
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s05"
            Begin Extent = 
               Top = 138
               Left = 360
               Bottom = 267
               Right = 614
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s06"
            Begin Extent = 
               Top = 138
               Left = 652
               Bottom = 267
               Right = 899
            End
            DisplayFlags = 280
            TopColumn = 0
   ', 'SCHEMA', N'reports', 'VIEW', N'ClientSatisfactionSurveyResultsFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'      End
         Begin Table = "s10"
            Begin Extent = 
               Top = 138
               Left = 937
               Bottom = 267
               Right = 1281
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s17"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n02"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d01"
            Begin Extent = 
               Top = 270
               Left = 322
               Bottom = 399
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d02"
            Begin Extent = 
               Top = 270
               Left = 606
               Bottom = 399
               Right = 914
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lo"
            Begin Extent = 
               Top = 6
               Left = 1316
               Bottom = 135
               Right = 1489
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 138
               Left = 1319
               Bottom = 267
               Right = 1508
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 270
               Left = 952
               Bottom = 399
               Right = 1132
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 270
               Left = 1170
               Bottom = 399
               Right = 1354
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 514
               Right = 208
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
', 'SCHEMA', N'reports', 'VIEW', N'ClientSatisfactionSurveyResultsFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'reports', 'VIEW', N'ClientSatisfactionSurveyResultsFields', NULL, NULL
GO
