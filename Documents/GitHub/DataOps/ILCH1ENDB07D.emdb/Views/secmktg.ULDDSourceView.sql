SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [secmktg].[ULDDSourceView]
AS
SELECT        ls02._364, ls05._4002, ls02._1401, ln01._3, ls01._11, ls02._12, ls01._14, ls03._15, ls01._1811, ln01._353, ln02._VASUMM_X23, ls01._1041, ls03._1051, ln01._689, 
                         ln03._1699, ld04._3054, ln02._4, ls03._299, ls03._675, ls01._MORNET_X4, ls04._1039, ls05._L248, ls02._CX_MICERTNUM, ln01._1107, ls02._CX_SFC1, 
                         ls02._CX_SFC2, ls02._CX_SFC3, ls02._CX_SFC4, ls02._CX_SFC5, ls02._CX_SFC6, ls02._1012, ls02._18, ln02._356, ln01._136, ln09._CX_BEDROOMS_1, 
                         ln04._CX_BEDROOMS_2, ln04._CX_BEDROOMS_3, ln04._CX_BEDROOMS_4, ln09._CX_RENT_1, ln09._CX_RENT_2, ln09._CX_RENT_3, ln09._CX_RENT_4, 
                         ls03._65, ls04._1524, ls04._1525, ls04._1526, ls04._1527, ls04._1528, ls04._1529, ls04._1530, ls04._1523, ln01._1389, ls04._1532, ls04._1533, ls04._1534, 
                         ls04._1535, ls04._1536, ls04._1537, ls04._1538, ls04._1531, ld01._1402, ld02._1403, ln02._38, ln01._70, ls02._471, ls03._478, ls05._4004, ls05._4006, ls02._4001, 
                         ls02._4003, ls02._4005, ls02._4007, ls01._97, ls05._4000, ln03._1742, ls01._608, ln07._SERVICE_X57, ln06._SERVICE_X82, ls08._1298, ls04._CX_UWMIPCT_5, 
                         ln06._SERVICE_X20, ln01._231, ln03._L268, ls01._230, ls01._232, ln02._235, ln04._253, ln10._1630, ls06._661, ln04._254, ln07._SERVICE_X81, ls01._3238, 
                         ls04._974, ls01._3243, ld03._SERVICE_X15, ld01._682, ls01._2288, ls02._CX_AUSSOURCE_2, ls02._CX_AUSRECOMMENDATION_2, ls03._CX_UWREQMI, 
                         ld04._ULDD_X30, ld04._ULDD_X58, ln10._ULDD_X3, ln10._ULDD_X56, ln10._ULDD_X59, ln10._ULDD_X169, ln10._ULDD_X138, ln10._ULDD_X176, 
                         ln10._ULDD_X168, ln10._ULDD_X105, ln10._ULDD_X110, ls10._ULDD_X7, ls10._ULDD_X9, ls10._ULDD_X8, ls10._ULDD_X31, ls12._ULDD_X32, ls12._ULDD_X89, 
                         ls12._ULDD_X24, ls01._2356, ls12._ULDD_X172, ls12._ULDD_X143, ls12._ULDD_X120, ls12._ULDD_X140, ls12._ULDD_X177, ls12._ULDD_X28, ls04._934, 
                         ls03._965, ls01._985, ls04._352, ls04._1066, ls05._541, ls05._CX_INSFLDPOLICYNO, ls06._1414, ls06._1450, ls01._67, ls06._1415, ls06._1452, ls01._60, 
                         ls12._2847, ls08._1108, ls04._CASASRN_X13, ls07._CX_LOANSERVICER, ls16._3050, ls12._466, ls12._467, ls12._ULDD_X18, ls12._ULDD_X11, ls12._ULDD_X106, 
                         ld01._CX_FUNDDATE_1, ln02._695, ls01._19, ln03._1731, ln01._696, ln01._697, ld02._NEWHUD_X332, ln06._NEWHUD_X557, ln09._2625, ls03._SYS_X1, 
                         ln03._1700, ln11._1758, ln11._1759, ld03._SERVICE_X14, ln12._CX_FINAL_VALUE_1, ld03._L770, ld01._745, ln14._ULDD_FNM_HMDA_X15, ls06._1416, ls06._1417, 
                         ls06._1418, ls06._1419, ld01._761, ls21._ULDD_X38, ls21._ULDD_X129, ls13._ULDD_X142, ln02._1045, ln13._ULDD_FNM_X50, ls08._403, ls12._ULDD_X29, 
                         ls01._1040, ln03._1199, ln02._CX_TOTUFMIP_1, ln03._428, ln09._1732, ln12._1540, ls10._CASASRN_X167, ls10._CASASRN_X168, ln01._976, 
                         ls26._ULDD_FNM_PropertyFormType, ls26._ULDD_FRE_PropertyFormType, ln12._CX_MRTG_COUNT, ln14._ULDD_TotalMortgagedPropertiesCount, 
                         ln06._NEWHUD_X15, ln03._1548, ln14._CASASRN_X78, ln02._912, ln14._ULDD_RefinanceCashOutAmount, ln02._688, ls17._300, ls17._265, ls17._266, ls25._1057, 
                         ls25._1197, ls04._FE0115, ls04._FE0215, ls26._ULDD_ManufacturedHomeWidthType, ln12._967, ls17._34, ls01._69, ls10._37_P2, ls08._1524_P2, ls08._1525_P2, 
                         ls08._1526_P2, ls08._1527_P2, ls08._1528_P2, ls08._1529_P2, ls08._1530_P2, ls09._1523_P2, ld04._1402_P2, ln10._38_P2, ls09._471_P2, ls10._4000_P2, 
                         ls10._4002_P2, ls10._36_P2, ls10._65_P2, ls10._1414_P2, ls04._1450_P2, ls10._67_P2, ls07._403_P2, ln05._1758_P2, ls21._265_P2, ls25._1057_P2, 
                         ls10._FE0115_P2
FROM            emdbuser.LOANXDB_D_02 AS ld02 INNER JOIN
                         emdbuser.LOANXDB_D_01 AS ld01 ON ld02.XrefId = ld01.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_03 AS ld03 ON ld02.XrefId = ld03.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_04 AS ld04 ON ld02.XrefId = ld04.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_01 AS ln01 ON ld02.XrefId = ln01.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS ln02 ON ld02.XrefId = ln02.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_03 AS ln03 ON ld02.XrefId = ln03.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_04 AS ln04 ON ld02.XrefId = ln04.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_06 AS ln06 ON ld02.XrefId = ln06.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_07 AS ln07 ON ld02.XrefId = ln07.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_08 AS ln08 ON ld02.XrefId = ln08.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_09 AS ln09 ON ld02.XrefId = ln09.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_10 AS ln10 ON ld02.XrefId = ln10.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_11 AS ln11 ON ld02.XrefId = ln11.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_12 AS ln12 ON ld02.XrefId = ln12.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_13 AS ln13 ON ld02.XrefId = ln13.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_14 AS ln14 ON ld02.XrefId = ln14.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_01 AS ls01 ON ld02.XrefId = ls01.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 AS ls02 ON ld02.XrefId = ls02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS ls03 ON ld02.XrefId = ls03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_04 AS ls04 ON ld02.XrefId = ls04.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS ls05 ON ld02.XrefId = ls05.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 AS ls06 ON ld02.XrefId = ls06.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_07 AS ls07 ON ld02.XrefId = ls07.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_08 AS ls08 ON ld02.XrefId = ls08.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_09 AS ls09 ON ld02.XrefId = ls09.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS ls10 ON ld02.XrefId = ls10.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_12 AS ls12 ON ld02.XrefId = ls12.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_13 AS ls13 ON ld02.XrefId = ls13.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_16 AS ls16 ON ld02.XrefId = ls16.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_17 AS ls17 ON ld02.XrefId = ls17.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_21 AS ls21 ON ld02.XrefId = ls21.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_25 AS ls25 ON ld02.XrefId = ls25.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_26 AS ls26 ON ld02.XrefId = ls26.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_05 AS ln05 ON ld02.XrefId = ln05.XrefId
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[50] 4[21] 2[16] 3) )"
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
         Begin Table = "ld02"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 315
            End
            DisplayFlags = 280
            TopColumn = 80
         End
         Begin Table = "ld01"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 453
            End
            DisplayFlags = 280
            TopColumn = 33
         End
         Begin Table = "ld03"
            Begin Extent = 
               Top = 6
               Left = 491
               Bottom = 114
               Right = 732
            End
            DisplayFlags = 280
            TopColumn = 41
         End
         Begin Table = "ld04"
            Begin Extent = 
               Top = 114
               Left = 353
               Bottom = 222
               Right = 627
            End
            DisplayFlags = 280
            TopColumn = 64
         End
         Begin Table = "ln01"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 53
         End
         Begin Table = "ln02"
            Begin Extent = 
               Top = 222
               Left = 320
               Bottom = 330
               Right = 549
            End
            DisplayFlags = 280
            TopColumn = 88
         End
         Begin Table = "ln03"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 255
            End
            DisplayFlags = 280
            To', 'SCHEMA', N'secmktg', 'VIEW', N'ULDDSourceView', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'pColumn = 12
         End
         Begin Table = "ln04"
            Begin Extent = 
               Top = 330
               Left = 293
               Bottom = 438
               Right = 513
            End
            DisplayFlags = 280
            TopColumn = 98
         End
         Begin Table = "ln06"
            Begin Extent = 
               Top = 330
               Left = 551
               Bottom = 438
               Right = 737
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln07"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 85
         End
         Begin Table = "ln08"
            Begin Extent = 
               Top = 438
               Left = 269
               Bottom = 546
               Right = 491
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln09"
            Begin Extent = 
               Top = 438
               Left = 529
               Bottom = 546
               Right = 740
            End
            DisplayFlags = 280
            TopColumn = 83
         End
         Begin Table = "ln10"
            Begin Extent = 
               Top = 546
               Left = 38
               Bottom = 654
               Right = 333
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln11"
            Begin Extent = 
               Top = 6
               Left = 770
               Bottom = 135
               Right = 1011
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln12"
            Begin Extent = 
               Top = 138
               Left = 665
               Bottom = 319
               Right = 907
            End
            DisplayFlags = 280
            TopColumn = 24
         End
         Begin Table = "ln13"
            Begin Extent = 
               Top = 1124
               Left = 647
               Bottom = 1243
               Right = 883
            End
            DisplayFlags = 280
            TopColumn = 46
         End
         Begin Table = "ln14"
            Begin Extent = 
               Top = 324
               Left = 775
               Bottom = 453
               Right = 995
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls01"
            Begin Extent = 
               Top = 546
               Left = 371
               Bottom = 654
               Right = 657
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls02"
            Begin Extent = 
               Top = 654
               Left = 38
               Bottom = 762
               Right = 271
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03"
            Begin Extent = 
               Top = 654
               Left = 309
               Bottom = 762
               Right = 574
            End
            DisplayFlags = 280
            TopColumn = 141
         End
         Begin Table = "ls04"
            Begin Extent = 
               Top = 762
               Left = 38
               Bottom = 870
               Right = 296
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls05"
            Begin Extent = 
               To', 'SCHEMA', N'secmktg', 'VIEW', N'ULDDSourceView', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'p = 762
               Left = 334
               Bottom = 870
               Right = 566
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls06"
            Begin Extent = 
               Top = 870
               Left = 38
               Bottom = 978
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls07"
            Begin Extent = 
               Top = 870
               Left = 303
               Bottom = 978
               Right = 559
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls08"
            Begin Extent = 
               Top = 978
               Left = 38
               Bottom = 1086
               Right = 306
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls09"
            Begin Extent = 
               Top = 978
               Left = 344
               Bottom = 1086
               Right = 528
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls10"
            Begin Extent = 
               Top = 1086
               Left = 38
               Bottom = 1194
               Right = 348
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls12"
            Begin Extent = 
               Top = 1086
               Left = 386
               Bottom = 1194
               Right = 609
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "ls13"
            Begin Extent = 
               Top = 1248
               Left = 649
               Bottom = 1377
               Right = 943
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls16"
            Begin Extent = 
               Top = 1194
               Left = 38
               Bottom = 1302
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls17"
            Begin Extent = 
               Top = 1380
               Left = 371
               Bottom = 1509
               Right = 666
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls21"
            Begin Extent = 
               Top = 1199
               Left = 378
               Bottom = 1328
               Right = 611
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls25"
            Begin Extent = 
               Top = 1380
               Left = 704
               Bottom = 1509
               Right = 968
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls26"
            Begin Extent = 
               Top = 1302
               Left = 38
               Bottom = 1431
               Right = 333
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "ln05"
            Begin Extent = 
               Top = 6
               Left = 1049
               Bottom = 135
               Right = 1321
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
      Begin ColumnWid', 'SCHEMA', N'secmktg', 'VIEW', N'ULDDSourceView', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane4', N'ths = 11
         Column = 3390
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
', 'SCHEMA', N'secmktg', 'VIEW', N'ULDDSourceView', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=4
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'secmktg', 'VIEW', N'ULDDSourceView', NULL, NULL
GO
