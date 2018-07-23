SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [secmktg].[fannieDirectDelivery]
AS
SELECT     ls02._364, ls03._CUST05FV, ls01._37, ld01._2145, ln02._2146, ld01._2147, ln09._2044, ln01._2045, ln09._2087, ls02._1401, ls10._1172, ls01._1393, ld02._MS_FUN, 
                      ln02._1109, ln01._3, ls01._19, ln02._325, ln02._2, ls03._15, ls01._14, ls01._1811, ln01._5, ln01._353, ln01._976, ln04._740, ln02._742, ln02._VASUMM_X23, ln01._16, 
                      ls01._1041, ln01._689, ln01._247, ln03._1699, ln01._697, ln02.MS_LOCKDAYS, ls02._CUST77FV, ln02._4, ls01._MS_STATUS, ld04._MS_STATUSDATE, ld01._682, 
                      ls03._299, ln02._688, ln04._691, ls03._675, ls03._1946, ln02._1947, ls01._MORNET_X4, ls04._1039, ls05._L248 AS _CX_FDS_MICODE, ls02._CX_MICERTNUM, 
                      ln01._1107, ' ' AS _CX_FDS_LASTPAID, ' ' AS _CX_FDS_PAYEECODE, ls02._CX_SFC2, ls02._CX_SFC1, ls02._CX_SFC3, ls02._CX_SFC4, ls02._CX_SFC5, 
                      ls02._CX_SFC6, ' ' AS _CX_FDS_COMMENTS, ls01._11, ls02._12, ls02._1012, ls02._18, ln02._356, ln01._136, ln09._CX_BEDROOMS_1, ln09._CX_BEDROOMS_2, 
                      ln09._CX_BEDROOMS_3, ln09._CX_BEDROOMS_4, ln09._CX_RENT_1, ln09._CX_RENT_2, ln09._CX_RENT_3, ln09._CX_RENT_4, ls03._65, ls04._1524, ls04._1525, 
                      ls04._1526, ls04._1527, ls04._1528, ls04._1529, ls04._1530, ls04._1523, 'RETAIL' AS _CX_CHANNEL, ls03._CUST78FV, ' ' AS _CX_HMPINFO62, 
                      ' ' AS _CX_HMPINFO63, ld04._3054, ls04._1543, ls04._1544, ls03._1051, ls02._2826, ls01.LOCKRATE_67, ls09.LOCKRATE_1450, ls09.LOCKRATE_1414, ln01._1389, 
                      ls04._1532, ls04._1533, ls04._1534, ls04._1535, ls04._1536, ls04._1537, ls04._1538, ls04._1531, ld01._1402, ld02._1403, ls05._L248 AS _L248_2, ln02._38, 
                      ln01._70, ls02._471, ls03._478, ls05._4004, ls05._4006, ls02._4001, ls02._4003, ls02._4005, ls02._4007, ls01._97, ls05._4000, ls02.LOCKRATE_60, 
                      ls09.LOCKRATE_1452, ls09.LOCKRATE_1415, ln03._1731, ln03._1742, ls03._965, ld03._L770, ld04._1996, ld01._1961, ls01._608, ls02._411, ls01._412, ls01._413, 
                      ls01._1174, ls01._414, ls01._VEND_X399, ls02._VEND_X398, ls02._2007, ls02._2003, ls03._420, ln02._694, ln02._695, ls01._412 AS _412_2, ls01._413 AS _413_2, 
                      ls01._1174 AS _1174_2, ls01._414 AS _414_2, ls01._VEND_X399 AS _VEND_X399_2, ls02._VEND_X398 AS _VEND_X398_2, ls02._2007 AS _2007_2, 
                      ls02._2003 AS _2003_2, ls03._420 AS _420_2, ln02._694 AS _694_2, ln02._695 AS _695_2, ln02._1948, ln01._1177, ls04._FE0115, ls04._FE0215, ls04._52, ls06._84, 
                      ln01._696, ls01._1040, ln03._428, ls04._617, ls02._MORNET_X67, ls02._1959, ln09._2551, ln09._698, ls03._1659, ls01._13, ls04._HMDA_X13, ls04._934, ls02._425, 
                      ln09._1269, ln01._337, ln02._1045, ls02._1728, ' ' AS ANNUAL_MIP, ld01._2370, ls01._2286, ld01._CX_FUNDDATE_1, ln07._SERVICE_X57, ld03._SERVICE_X15, 
                      ln06._SERVICE_X82, ld01._1994, ls04._CX_UWMIPCT_5, ld02._NEWHUD_X332, ln02._1299, ls02._DU_LP_ID, ls03._SERVICE_X4, ls03._SERVICE_X5, ln01._231, 
                      ln03._L268, ls01._230, ls01._232, ln02._235, ln07._SERVICE_X81, ln09._SERVICE_X103, ls01._3238, ls04._974, ls01._3243, ls03._SERVICE_X6, ls03._SERVICE_X7, 
                      ln06._SERVICE_X20, ls05._660, ls08._1628, ls08._661, ls08._1298, ln04._102, ln10._253, ln10._254, ln10._1630, ls08._403, ls01._67, ls01._60, ls01._2288, 
                      ln10._2202, ls02._CX_AUSSOURCE_2, ls02._CX_AUSRECOMMENDATION_2, ld02._3142, ls01._2293, ls03._CX_UWREQMI, ls05._CX_INSHAZPOLICYNO, 
                      ls07._CX_INSHAZPAYEEID, ls07._CX_INSFLDCERTNO, ld03._SERVICE_X14, ls07._CX_INSFLDPAYEEID, ld04._ULDD_X17, ld04._ULDD_X30, ld04._ULDD_X58, 
                      ln10._ULDD_X3, ln10._ULDD_X56, ln10._ULDD_X59, ln10._ULDD_X169, ln10._ULDD_X138, ln10._ULDD_X139, ln10._ULDD_X168, ln10._ULDD_X105, 
                      ln10._ULDD_X110, ls10._ULDD_X7, ls10._ULDD_X9, ls10._ULDD_X132, ls10._ULDD_X178, ls10._ULDD_X8, ls10._ULDD_X31, 
                      emdbuser.LOANXDB_S_12._ULDD_X32, emdbuser.LOANXDB_S_12._ULDD_X89, emdbuser.LOANXDB_S_12._ULDD_X67, emdbuser.LOANXDB_S_12._ULDD_X18, 
                      emdbuser.LOANXDB_S_12._ULDD_X24, emdbuser.LOANXDB_S_12._ULDD_X29, emdbuser.LOANXDB_S_12._ULDD_X172, emdbuser.LOANXDB_S_12._ULDD_X177, 
                      emdbuser.LOANXDB_S_12._ULDD_X127, emdbuser.LOANXDB_S_12._ULDD_X120, emdbuser.LOANXDB_S_12._ULDD_X140, 
                      emdbuser.LOANXDB_S_12._ULDD_X143, emdbuser.LOANXDB_S_12._ULDD_X147, emdbuser.LOANXDB_S_12._ULDD_X111, 
                      emdbuser.LOANXDB_S_12._ULDD_X11, emdbuser.LOANXDB_S_12._ULDD_X113, emdbuser.LOANXDB_S_12._ULDD_X106, 
                      emdbuser.LOANXDB_S_12._ULDD_X108, emdbuser.LOANXDB_S_12._ULDD_FRE_AutoUWDec, emdbuser.LOANXDB_S_12._ULDD_X104, ln02._1045 AS Expr1, 
                      ls04._352, ln02._736, ld01._745, ls10._CASASRN_X167, ls04._1066, ls05._541, ls05._CX_INSFLDPOLICYNO, ls06._1450, ls06._1414, ls06._1415, ls06._1452, 
                      ls06._HMDA_X15, ls10._1290, ls01._985, emdbuser.LOANXDB_S_12._2847, ls10._1551, emdbuser.LOANXDB_S_12._466, emdbuser.LOANXDB_S_12._467, 
                      ls10._676, emdbuser.LOANXDB_S_12._ULDD_X28, emdbuser.LOANXDB_S_12._ULDD_X49, ls08._1108, ls01._2356, ln10._ULDD_X176, ls04._VEND_X263, 
                      ln02._912, ls04._CASASRN_X13, ld02._3152, ls03._CX_APPRCOMMENTS_4, ls07._CX_LOANSERVICER, ln08._HUD23, ln01._1085, 
                      emdbuser.LOANXDB_S_16._3050
FROM         emdbuser.LOANXDB_S_02 AS ls02 INNER JOIN
                      emdbuser.LoanXRef AS lx ON ls02.XrefId = lx.XRefID INNER JOIN
                      emdbuser.LOANXDB_S_07 AS ls07 ON lx.XRefID = ls07.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_10 AS ls10 ON lx.XRefID = ls10.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_10 AS ln10 ON lx.XRefID = ln10.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_07 AS ln07 ON lx.XRefID = ln07.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_08 AS ln08 ON lx.XRefID = ln08.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_06 AS ln06 ON lx.XRefID = ln06.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_03 AS ls03 ON lx.XRefID = ls03.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_03 AS ln03 ON lx.XRefID = ln03.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_05 AS ln05 ON lx.XRefID = ln05.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_04 AS ld04 ON lx.XRefID = ld04.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_02 AS ld02 ON lx.XRefID = ld02.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_06 AS ls06 ON lx.XRefID = ls06.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_04 AS ln04 ON lx.XRefID = ln04.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_09 AS ls09 ON lx.XRefID = ls09.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_03 AS ld03 ON lx.XRefID = ld03.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_09 AS ln09 ON lx.XRefID = ln09.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_01 AS ln01 ON lx.XRefID = ln01.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_01 AS ld01 ON lx.XRefID = ld01.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_02 AS ln02 ON lx.XRefID = ln02.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_08 AS ls08 ON lx.XRefID = ls08.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_05 AS ls05 ON lx.XRefID = ls05.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_04 AS ls04 ON lx.XRefID = ls04.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_01 AS ls01 ON lx.XRefID = ls01.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_12 ON ls02.XrefId = emdbuser.LOANXDB_S_12.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_16 ON ls02.XrefId = emdbuser.LOANXDB_S_16.XrefId
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[44] 2[27] 3) )"
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
         Top = -936
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ls02"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 280
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lx"
            Begin Extent = 
               Top = 11
               Left = 992
               Bottom = 229
               Right = 1152
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls07"
            Begin Extent = 
               Top = 890
               Left = 326
               Bottom = 1054
               Right = 578
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls10"
            Begin Extent = 
               Top = 880
               Left = 32
               Bottom = 999
               Right = 300
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln10"
            Begin Extent = 
               Top = 925
               Left = 600
               Bottom = 1040
               Right = 812
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln07"
            Begin Extent = 
               Top = 794
               Left = 582
               Bottom = 913
               Right = 784
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln08"
            Begin Extent = 
               Top = 661
               Left = 579
               Bottom = 780
               Right = 810
            End
            DisplayFlags = 280
            To', 'SCHEMA', N'secmktg', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'pColumn = 0
         End
         Begin Table = "ln06"
            Begin Extent = 
               Top = 755
               Left = 353
               Bottom = 874
               Right = 548
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03"
            Begin Extent = 
               Top = 750
               Left = 40
               Bottom = 869
               Right = 314
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln03"
            Begin Extent = 
               Top = 524
               Left = 578
               Bottom = 643
               Right = 804
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln05"
            Begin Extent = 
               Top = 508
               Left = 324
               Bottom = 617
               Right = 531
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld04"
            Begin Extent = 
               Top = 619
               Left = 362
               Bottom = 738
               Right = 555
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld02"
            Begin Extent = 
               Top = 615
               Left = 38
               Bottom = 734
               Right = 324
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls06"
            Begin Extent = 
               Top = 492
               Left = 38
               Bottom = 611
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln04"
            Begin Extent = 
               Top = 372
               Left = 38
               Bottom = 491
               Right = 267
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls09"
            Begin Extent = 
               Top = 383
               Left = 315
               Bottom = 502
               Right = 508
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld03"
            Begin Extent = 
               Top = 396
               Left = 536
               Bottom = 515
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln09"
            Begin Extent = 
               Top = 258
               Left = 329
               Bottom = 377
               Right = 531
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln01"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 291
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld01"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln02"
            Begin Extent = 
               Top = 126
               Left = 311
               Bottom = 245
               Right = 549
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls08"
            Begin Extent = 
               Top = 17
   ', 'SCHEMA', N'secmktg', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'            Left = 598
               Bottom = 132
               Right = 820
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls05"
            Begin Extent = 
               Top = 276
               Left = 569
               Bottom = 395
               Right = 810
            End
            DisplayFlags = 280
            TopColumn = 106
         End
         Begin Table = "ls04"
            Begin Extent = 
               Top = 156
               Left = 569
               Bottom = 275
               Right = 836
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls01"
            Begin Extent = 
               Top = 7
               Left = 356
               Bottom = 126
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOANXDB_S_12 (emdbuser)"
            Begin Extent = 
               Top = 281
               Left = 1005
               Bottom = 400
               Right = 1223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOANXDB_S_16 (emdbuser)"
            Begin Extent = 
               Top = 1056
               Left = 38
               Bottom = 1164
               Right = 340
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
      Begin ColumnWidths = 225
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 15', 'SCHEMA', N'secmktg', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane4', N'00
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
         Column = 3945
         Alias = 2010
         Table = 3225
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
', 'SCHEMA', N'secmktg', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=4
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'secmktg', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
