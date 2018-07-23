SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [crm].[LoanDataAdvanced (old)]
AS
SELECT        ISNULL(s02._364, '') AS LoanNumber, ISNULL(s03._CX_FINALOCODE_4, '') AS LOCode, CONVERT(date, d02._MS_START) AS DateAdded, CONVERT(date, 
                         ISNULL(d01._CX_RESPAAPP_1, d01._745)) AS DateApplied, CONVERT(date, d01._748) AS DateClosed, CONVERT(date, d01._CX_FUNDDATE_1) AS DateFunded, 
                         DATEADD(year, 1, CONVERT(date, d01._CX_FUNDDATE_1)) AS LoanAnniversary, n02._2 AS LoanAmount, n01._353 AS LTV, n01._976 AS CLTV, 
                         n03._CX_CORPOBJ AS YSP, n10._CX_PAIR1_BORROWER_FICO AS FICO, n01.LOCKRATE_742 AS DTI, ISNULL(s10._1172, '') AS LoanType, ISNULL(s01._608, '') 
                         AS AmortType, n02._4 AS AmortTerm, ISNULL(s13._1553, '') AS PropertyType, ISNULL(s01._11, '') AS PropertyStreet, ISNULL(s02._12, '') AS PropertyCity, 
                         ISNULL(s01._14, '') AS PropertyState, ISNULL(s03._15, '') AS PropertyZip, ISNULL(s01._36, '') AS Borr1FirstName, ISNULL(s01._37, '') AS Borr1LastName, 
                         ISNULL(s01._66, '') AS Borr1HomePhone, ISNULL(s01._FE0117, '') AS Borr1WorkPhone, ISNULL(s01._1490, '') AS Borr1CellPhone, ISNULL(s01._1240, '') 
                         AS Borr1Email, CONVERT(date, d01._1402) AS Borr1Birthday, CONVERT(bit, CASE s04._FE0115 WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END) AS Borr1SelfEmployed, 
                         ISNULL(CASE ISNULL(s05._4004, '') WHEN '' THEN s10._36_P2 ELSE s01._68 END, '') AS Borr2FirstName, ISNULL(CASE ISNULL(s05._4004, '') 
                         WHEN '' THEN s10._37_P2 ELSE s01._69 END, '') AS Borr2LastName, ISNULL(CASE ISNULL(s05._4004, '') WHEN '' THEN '?' ELSE s02._98 END, '') 
                         AS Borr2HomePhone, ISNULL(CASE ISNULL(s05._4004, '') WHEN '' THEN s10._FE0117_P2 ELSE s04._FE0217 END, '') AS Borr2WorkPhone, 
                         ISNULL(CASE ISNULL(s05._4004, '') WHEN '' THEN '?' ELSE s01._1490 END, '') AS Borr2CellPhone, ISNULL(CASE ISNULL(s05._4004, '') 
                         WHEN '' THEN '?' ELSE s01._1268 END, '') AS Borr2Email, CONVERT(date, CASE ISNULL(s05._4004, '') WHEN '' THEN d04._1402_P2 ELSE d02._1403 END) 
                         AS Borr2Birthday, CONVERT(bit, CASE (CASE ISNULL(s05._4004, '') WHEN '' THEN s10._FE0115_P2 ELSE s04._FE0215 END) 
                         WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END) AS Borr2SelfEmployed
FROM            emdbuser.LOANXDB_S_01 AS s01 INNER JOIN
                         emdbuser.LOANXDB_S_02 AS s02 ON s01.XrefId = s02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS s03 ON s01.XrefId = s03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS s05 ON s01.XrefId = s05.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 AS s06 ON s01.XrefId = s06.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS s10 ON s01.XrefId = s10.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_13 AS s13 ON s01.XrefId = s13.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_01 AS n01 ON s01.XrefId = n01.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS n02 ON s01.XrefId = n02.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_03 AS n03 ON s01.XrefId = n03.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_10 AS n10 ON s01.XrefId = n10.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_01 AS d01 ON s01.XrefId = d01.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_02 AS d02 ON s01.XrefId = d02.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_04 AS d04 ON s01.XrefId = d04.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 AS s04 ON s01.XrefId = s04.XrefId
WHERE        (NOT (s04._LOANFOLDER IN
                             (SELECT        folderName
                               FROM            emdbuser.LoanFolder)))

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
         Begin Table = "s01"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 360
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s02"
            Begin Extent = 
               Top = 6
               Left = 398
               Bottom = 135
               Right = 656
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s03"
            Begin Extent = 
               Top = 6
               Left = 694
               Bottom = 135
               Right = 990
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s04"
            Begin Extent = 
               Top = 6
               Left = 1028
               Bottom = 135
               Right = 1312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s10"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 382
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s13"
            Begin Extent = 
               Top = 270
               Left = 694
               Bottom = 399
               Right = 988
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n01"
            Begin Extent = 
               Top = 138
               Left = 952
               Bottom = 267
               Right = 1215
            End
            DisplayFlags = 280
            TopColumn = 0
', 'SCHEMA', N'crm', 'VIEW', N'LoanDataAdvanced (old)', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'         End
         Begin Table = "n02"
            Begin Extent = 
               Top = 138
               Left = 668
               Bottom = 267
               Right = 914
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n03"
            Begin Extent = 
               Top = 270
               Left = 420
               Bottom = 399
               Right = 656
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n10"
            Begin Extent = 
               Top = 270
               Left = 1026
               Bottom = 399
               Right = 1356
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d01"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d02"
            Begin Extent = 
               Top = 138
               Left = 322
               Bottom = 267
               Right = 630
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s05"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 531
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d04"
            Begin Extent = 
               Top = 402
               Left = 330
               Bottom = 531
               Right = 608
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s06"
            Begin Extent = 
               Top = 402
               Left = 646
               Bottom = 531
               Right = 893
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
         Alias = 1635
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
', 'SCHEMA', N'crm', 'VIEW', N'LoanDataAdvanced (old)', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'crm', 'VIEW', N'LoanDataAdvanced (old)', NULL, NULL
GO
