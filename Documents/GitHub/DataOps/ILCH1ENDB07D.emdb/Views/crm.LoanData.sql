SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [crm].[LoanData]
AS
SELECT ISNULL(s02._364, '') AS LoanNumber, 
	ISNULL(s03._CX_FINALOCODE_4, '') AS LOCode, 
	CONVERT(date, d02._MS_START) AS DateAdded, 
	CONVERT(date, d01._CX_APPRCVD_1) AS DateAppIn, 
	CONVERT(date, d01._CX_RESPAAPP_1) AS RespaAppDate,
	CONVERT(date, d01._745) AS DateApplied,
	CONVERT(date, d01._2298) AS DateSubmittedToUW, 
	CONVERT(date, d01.Log_MS_Date_Approval) AS DateApproved, 
	CONVERT(date, d03.LOCKRATE_2149) AS DateLocked, 
	CONVERT(date, d01._748) AS DateClosed, 
	CONVERT(date, d01._CX_FUNDDATE_1) AS DateFunded,
	CONVERT(date, d01._2370) AS DateSold,
	DATEADD(year, 1, CONVERT(date, d01._CX_FUNDDATE_1)) AS LoanAnniversary, 
	n02._2 AS LoanAmount, 
	n01._3 AS InterestRate, 
	n01._353 AS LTV, 
	n01._976 AS CLTV, 
	n01._2203 AS YSP, 
	n10._CX_PAIR1_BORROWER_FICO AS FICO, 
	n01.LOCKRATE_742 AS DTI, 
	ISNULL(s01._19, '') AS LoanPurpose, 
	ISNULL(s10._1172, '') AS LoanType, 
	ISNULL(s01._608, '') AS AmortType, 
	n02._4 AS AmortTerm, 
	ISNULL(s13._1553, '') AS PropertyType, 
	ISNULL(s01._11, '') AS PropertyStreet, 
	ISNULL(s02._12, '') AS PropertyCity, 
	ISNULL(s01._14, '') AS PropertyState, 
	ISNULL(s03._15, '') AS PropertyZip,
	ISNULL(s01._36, '') AS BorrFirstName, 
	ISNULL(s01._37, '') AS BorrLastName, 
	ISNULL(s01._66, '') AS BorrHomePhone, 
	ISNULL(s01._FE0117, '') AS BorrWorkPhone, 
	ISNULL(s01._1490, '') AS BorrCellPhone, 
	ISNULL(s01._1240, '') AS BorrEmail, 
	CONVERT(date, d01._1402) AS BorrBirthday, 
	CONVERT(bit, CASE s04._FE0115 WHEN 'Y' THEN 1 WHEN 'N' THEN 0 END) AS BorrSelfEmployed, 
	ISNULL(RIGHT(s03._65, 4), '') AS BorrSSN4, 
	CONVERT(date, d01._CX_PREAPPROVORDER_1) AS PreApprovalOrdered, 
	ISNULL(s07._CX_DOCMI, '') AS MortgageInsuranceType, 
	ISNULL(s16._CX_MI_DROP_01, '') AS MortgageInsuranceCompany, 
	CONVERT(date, d01._CX_APPSENT_1) AS InitialAppSent,
	ls.[Guid],
	CONVERT(bit, CASE WHEN s04._LOANFOLDER LIKE 'Adverse%' THEN 1 ELSE 0 END) as IsAdverse
FROM emdbuser.LOANXDB_S_01 AS s01 INNER JOIN
    emdbuser.LOANXDB_S_02 AS s02 ON s01.XrefId = s02.XrefId INNER JOIN
    emdbuser.LOANXDB_S_03 AS s03 ON s01.XrefId = s03.XrefId INNER JOIN
    emdbuser.LOANXDB_S_04 AS s04 ON s01.XrefId = s04.XrefId INNER JOIN
    emdbuser.LOANXDB_S_07 AS s07 ON s01.XrefId = s07.XrefId INNER JOIN
    emdbuser.LOANXDB_S_10 AS s10 ON s01.XrefId = s10.XrefId INNER JOIN
    emdbuser.LOANXDB_S_13 AS s13 ON s01.XrefId = s13.XrefId INNER JOIN
    emdbuser.LOANXDB_S_16 AS s16 ON s01.XrefId = s16.XrefId INNER JOIN
    emdbuser.LOANXDB_N_01 AS n01 ON s01.XrefId = n01.XrefId INNER JOIN
    emdbuser.LOANXDB_N_02 AS n02 ON s01.XrefId = n02.XrefId INNER JOIN
    emdbuser.LOANXDB_N_07 AS n07 ON s01.XrefId = n07.XrefId INNER JOIN
    emdbuser.LOANXDB_N_10 AS n10 ON s01.XrefId = n10.XrefId INNER JOIN
    emdbuser.LOANXDB_D_01 AS d01 ON s01.XrefId = d01.XrefId INNER JOIN
    emdbuser.LOANXDB_D_02 AS d02 ON s01.XrefId = d02.XrefId INNER JOIN
    emdbuser.LOANXDB_D_03 AS d03 ON s01.XrefId = d03.XrefId INNER JOIN
	emdbuser.LoanSummary AS ls ON s01.XrefId = ls.XRefID
WHERE     (NOT (s04._LOANFOLDER IN ('(Trash)', 'Samples'))) OR
                      (s04._LOANFOLDER = 'Samples') AND (s03._CX_FINALOCODE_4 IN ('4225', '6721', '7266'))




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
         Top = -148
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
         Begin Table = "s07"
            Begin Extent = 
               Top = 234
               Left = 20
               Bottom = 363
               Right = 304
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s10"
            Begin Extent = 
               Top = 313
               Left = 230
               Bottom = 442
               Right = 574
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s13"
            Begin Extent = 
               Top = 335
               Left = 717
               Bottom = 464
               Right = 1011
            End
            DisplayFlags = 280
            TopColumn = ', 'SCHEMA', N'crm', 'VIEW', N'LoanData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'0
         End
         Begin Table = "s16"
            Begin Extent = 
               Top = 443
               Left = 29
               Bottom = 572
               Right = 365
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n01"
            Begin Extent = 
               Top = 180
               Left = 1088
               Bottom = 309
               Right = 1351
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n02"
            Begin Extent = 
               Top = 186
               Left = 764
               Bottom = 315
               Right = 1010
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n07"
            Begin Extent = 
               Top = 615
               Left = 30
               Bottom = 744
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n10"
            Begin Extent = 
               Top = 330
               Left = 1117
               Bottom = 459
               Right = 1447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d01"
            Begin Extent = 
               Top = 137
               Left = 124
               Bottom = 266
               Right = 370
            End
            DisplayFlags = 280
            TopColumn = 72
         End
         Begin Table = "d02"
            Begin Extent = 
               Top = 174
               Left = 405
               Bottom = 303
               Right = 713
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d03"
            Begin Extent = 
               Top = 473
               Left = 497
               Bottom = 602
               Right = 758
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
         Column = 7410
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
', 'SCHEMA', N'crm', 'VIEW', N'LoanData', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'crm', 'VIEW', N'LoanData', NULL, NULL
GO
