SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [reports].[LicensingLoanDetailsFields] AS
/* who				when				what
??					2012-11-08 16:51	made view with some query generator ( probably bhawley )
petervandivier		2016-01-06			check in, gitpush, syntax edit, & and modify for update request from Rebecca Blabolil
petervandivier		2016-01-14			add n08._3121 per Amanda Brown. change inner to left join to avoid SrefId corruption
petervandivier		2016-02-04			add d03._LE1_X1, d03._CD1_X1, n10._1206 per catherine cain
*/
SELECT 
	s02._364, 
	s04._LOANFOLDER, 
	_CX_RESPAAPP_1 =		CONVERT(date, d01._CX_RESPAAPP_1), 
	_745 =					CONVERT(date, d01._745), 
	_3148 =					CONVERT(date, d02._3148), 
	_3150 =					CONVERT(date, d02._3150), 
	_2025 =					CONVERT(date, CASE WHEN isdate(_2025) = 1 THEN _2025 END, 101), 
	_CX_APPRCVD_1 =			CONVERT(date, d01._CX_APPRCVD_1), 
	_761 =					CONVERT(date, d01._761), 
	_2298 =					CONVERT(date, d01._2298), 
	Log_MS_Date_Approval =	CONVERT(date, d01.Log_MS_Date_Approval), 
	_CX_PREAPRVLDATE =		CONVERT(date, d03._CX_PREAPRVLDATE), 
	_749 =					CONVERT(date, d01._749), 
	s01._1393, 
	s01._MS_STATUS, 
	_748 =					CONVERT(date, d01._748), 
	_CX_FUNDDATE_1 =		CONVERT(date, d01._CX_FUNDDATE_1), 
	s03._VEND_X200, 
	_2370 =					CONVERT(date, d01._2370), 
	s02._2626, 
	s01._11, 
	s02._12, 
	s01._14, 
	s03._15, 
	n01._16, 
	s06._24, 
	n04._26, 
	s01._700, 
	s08._1396, 
	s01._1395, 
	s01._699, 
	s01._37, 
	s01._36, 
	s05._4002, 
	s03._65, 
	s02._471, 
	s05._4006, 
	s10._4002_P2, 
	s01._69, 
	s10._37_P2, 
	s01._68, 
	s10._36_P2, 
	s01._97, 
	s10._65_P2, 
	s04._188, 
	s04._189, 
	s09._188_P2, 
	s03._478, 
	s09._471_P2, 
	s04._1523, 
	s04._1531, 
	s09._1523_P2, 
	s04._1524, 
	s04._1525, 
	s04._1526, 
	s04._1527, 
	s04._1528, 
	s04._1529, 
	s04._1530, 
	s04._1532, 
	s08._1524_P2, 
	s04._1533, 
	s08._1525_P2, 
	s04._1534, 
	s08._1526_P2, 
	s04._1535, 
	s08._1527_P2, 
	s04._1536, 
	s08._1528_P2, 
	s04._1537, 
	s08._1529_P2, 
	s04._1538, 
	s08._1530_P2, 
	s01._FR0104, 
	s02._FR0106, 
	s02._FR0107, 
	s03._FR0108, 
	s01._66, 
	n02._38, 
	s02._955, 
	n10._CX_PAIR1_BORROWER_FICO, 
	n10._CX_PAIR1_COBORROWER_FICO, 
	n10._CX_PAIR2_BORROWER_FICO, 
	n02._VASUMM_X23, 
	n02._736, 
	n01._1389, 
	s03._420, 
	n02._2, 
	n02._356, 
	s01._19, 
	s10._1172, 
	s01._1041, 
	s01._1811, 
	s02._1401, 
	s02._MORNET_X67, 
	n01._3, 
	n02._799, 
	n11._CX_DOCMAGIC_FINAL_APR, 
	n01._353, 
	n01._976, 
	n04._740, 
	n02._742, 
	n02._4, 
	s01._608, 
	_3054 =					CONVERT(date, d04._3054), 
	_NEWHUD_X332 =			CONVERT(date, d02._NEWHUD_X332), 
	s08._2963, 
	s01._2293, 
	s07._HMDA_X12, 
	n02._1093, 
	n05._NEWHUD_X12, 
	n05._NEWHUD_X13, 
	n06._NEWHUD_X16, 
	n07._CX_CORPOBJ, 
	_CX_BROKERCHKRCVD_2 =	CONVERT(date, d01._CX_BROKERCHKRCVD_2), 
	n02._CX_BRKLOANCHKAMT_2, 
	n04._NEWHUD_X609, 
	n07._NEWHUD_X610, 
	n01._CX_CCARDAMT_1, 
	s02._411, 
	s01._412, 
	s01._413, 
	s01._1174, 
	s01._414, 
	s10._L252, 
	s02._CX_PROPSELLER_2, 
	s04._319, 
	s06._313, 
	s04._321, 
	s02._2278, 
	s02._CX_SECINVESTOR_10, 
	s04._617, 
	s04._974, 
	s07._CX_LOANSERVICER, 
	s04._2306, 
	s01._317, 
	s06._1612, 
	s01._CX_PAIDLO_3, 
	s01._CX_LCNAME_1, 
	s01.LoanTeamMember_Name_LoanCoordinator, 
	s03._CX_MCNAME_1, 
	s10.LoanTeamMember_Name_MortgageConsultant, 
	s02._2574, 
	s02._362, 
	s17._CX_CLOSER_1, 
	s10._CX_SANAME_1, 
	s07.LoanTeamMember_Name_FileStarter, 
	s03._1822, 
	s04._HMDA_X13, 
	s07._HMDA_X21, 
	s07._HMDA_X22, 
	s07._HMDA_X23, 
	s03._479, 
	n11._FR0112, 
	n11._FR0124, 
	n04._FE0113, 
	n11._FE0133, 
	n12._FR0312, 
	n11._FR0324, 
	n11._BE0113, 
	n11._BE0133, 
	s03._CX_EMPLOAN, 
	ba.[Address], 
	_3238, 
	_NMLS_X9, 
	_3142,
	d02._3152, 
	_BE0102, 
	_BE0104, 
	_BE0105, 
	_BE0106, 
	_BE0107, 
	_CE0102, 
	_CE0104, 
	_CE0105, 
	_CE0106, 
	_CE0107,
	s20._QM_X24,
	n08._3121,
	n10._1206,
	d03._CD1_X1,
	d03._LE1_X1
FROM emdbuser.LOANXDB_S_01 AS s01 
LEFT JOIN emdbuser.LOANXDB_S_02 AS s02 ON s01.XrefId = s02.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_03 AS s03 ON s01.XrefId = s03.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_04 AS s04 ON s01.XrefId = s04.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_05 AS s05 ON s01.XrefId = s05.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_06 AS s06 ON s01.XrefId = s06.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_07 AS s07 ON s01.XrefId = s07.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_08 AS s08 ON s01.XrefId = s08.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_09 AS s09 ON s01.XrefId = s09.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_10 AS s10 ON s01.XrefId = s10.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_16 AS s16 ON s01.XrefId = s16.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_17 AS s17 ON s01.XrefId = s17.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_18 AS s18 ON s01.XrefId = s18.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_19 AS s19 ON s01.XrefId = s19.XrefId 
LEFT JOIN emdbuser.LOANXDB_S_20 AS s20 ON s01.XrefId = s20.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_01 AS n01 ON s01.XrefId = n01.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_02 AS n02 ON s01.XrefId = n02.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_04 AS n04 ON s01.XrefId = n04.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_05 AS n05 ON s01.XrefId = n05.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_06 AS n06 ON s01.XrefId = n06.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_07 AS n07 ON s01.XrefId = n07.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_08 AS n08 ON s01.XrefId = n08.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_10 AS n10 ON s01.XrefId = n10.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_11 AS n11 ON s01.XrefId = n11.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_12 AS n12 ON s01.XrefId = n12.XrefId 
LEFT JOIN emdbuser.LOANXDB_N_03 AS n03 ON s01.XrefId = n03.XrefId 
LEFT JOIN emdbuser.LOANXDB_D_01 AS d01 ON s01.XrefId = d01.XrefId 
LEFT JOIN emdbuser.LOANXDB_D_02 AS d02 ON s01.XrefId = d02.XrefId 
LEFT JOIN emdbuser.LOANXDB_D_03 AS d03 ON s01.XrefId = d03.XrefId 
LEFT JOIN emdbuser.LOANXDB_D_04 AS d04 ON s01.XrefId = d04.XrefId 
LEFT OUTER JOIN reports.BadAddresses AS ba ON s01._11 = ba.[Address] 



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
         Begin Table = "s05"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s06"
            Begin Extent = 
               Top = 138
               Left = 330
               Bottom = 267
               Right = 577
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s07"
            Begin Extent = 
               Top = 138
               Left = 615
               Bottom = 267
               Right = 899
            End
            DisplayFlags = 280
            TopColumn = 0
 ', 'SCHEMA', N'reports', 'VIEW', N'LicensingLoanDetailsFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'        End
         Begin Table = "s08"
            Begin Extent = 
               Top = 138
               Left = 937
               Bottom = 267
               Right = 1233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s09"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s10"
            Begin Extent = 
               Top = 270
               Left = 281
               Bottom = 399
               Right = 625
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s17"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 531
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n01"
            Begin Extent = 
               Top = 270
               Left = 663
               Bottom = 399
               Right = 926
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n02"
            Begin Extent = 
               Top = 270
               Left = 964
               Bottom = 399
               Right = 1210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n04"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 531
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n05"
            Begin Extent = 
               Top = 402
               Left = 314
               Bottom = 531
               Right = 489
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n06"
            Begin Extent = 
               Top = 402
               Left = 527
               Bottom = 531
               Right = 732
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n07"
            Begin Extent = 
               Top = 402
               Left = 770
               Bottom = 531
               Right = 987
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n10"
            Begin Extent = 
               Top = 402
               Left = 1025
               Bottom = 531
               Right = 1355
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n11"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 663
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n12"
            Begin Extent = 
               Top = 534
               Left = 317
               Bottom = 663
               Right = 525
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n03"
            Begin Extent = 
               Top = 534
               Left = 563
               Bottom = 663
               Right = 799
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d01"
            Begin Extent = 
               Top = 534
               Left = 837', 'SCHEMA', N'reports', 'VIEW', N'LicensingLoanDetailsFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'
               Bottom = 663
               Right = 1083
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d02"
            Begin Extent = 
               Top = 666
               Left = 38
               Bottom = 795
               Right = 346
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d03"
            Begin Extent = 
               Top = 666
               Left = 384
               Bottom = 795
               Right = 645
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d04"
            Begin Extent = 
               Top = 666
               Left = 683
               Bottom = 795
               Right = 961
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ba"
            Begin Extent = 
               Top = 534
               Left = 1121
               Bottom = 612
               Right = 1291
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
         Column = 5715
         Alias = 1605
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
', 'SCHEMA', N'reports', 'VIEW', N'LicensingLoanDetailsFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=3
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'reports', 'VIEW', N'LicensingLoanDetailsFields', NULL, NULL
GO
