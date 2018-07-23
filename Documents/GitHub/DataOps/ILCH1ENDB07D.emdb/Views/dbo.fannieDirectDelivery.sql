SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[fannieDirectDelivery]
AS
SELECT     emdbuser.LOANXDB_S_02._364, emdbuser.LOANXDB_S_03._CUST05FV, emdbuser.LOANXDB_S_01._37, emdbuser.LOANXDB_D_01._2145, 
                      emdbuser.LOANXDB_N_02._2146, emdbuser.LOANXDB_D_01._2147, emdbuser.LOANXDB_N_09._2044, emdbuser.LOANXDB_N_01._2045, 
                      emdbuser.LOANXDB_N_09._2087, emdbuser.LOANXDB_S_02._1401, emdbuser.LOANXDB_S_01._1172, emdbuser.LOANXDB_S_01._1393, 
                      emdbuser.LOANXDB_D_02._MS_FUN, emdbuser.LOANXDB_N_02._1109, emdbuser.LOANXDB_N_01._3, emdbuser.LOANXDB_S_01._19, 
                      emdbuser.LOANXDB_N_02._325, emdbuser.LOANXDB_N_02._2, emdbuser.LOANXDB_S_03._15, emdbuser.LOANXDB_S_01._14, 
                      emdbuser.LOANXDB_S_01._1811, emdbuser.LOANXDB_N_01._5, emdbuser.LOANXDB_N_01._353, emdbuser.LOANXDB_N_01._976, 
                      emdbuser.LOANXDB_N_04._740, emdbuser.LOANXDB_N_02._742, emdbuser.LOANXDB_N_02._VASUMM_X23, emdbuser.LOANXDB_N_01._16, 
                      emdbuser.LOANXDB_S_01._1041, emdbuser.LOANXDB_N_01._689, emdbuser.LOANXDB_N_01._247, emdbuser.LOANXDB_N_03._1699, 
                      emdbuser.LOANXDB_N_01._697, emdbuser.LOANXDB_N_02.MS_LOCKDAYS, emdbuser.LOANXDB_S_02._CUST77FV, emdbuser.LOANXDB_N_02._4, 
                      emdbuser.LOANXDB_S_01._MS_STATUS, emdbuser.LOANXDB_D_04._MS_STATUSDATE, emdbuser.LOANXDB_D_01._682, 
                      emdbuser.LOANXDB_S_03._299, emdbuser.LOANXDB_N_02._688, emdbuser.LOANXDB_N_04._691, emdbuser.LOANXDB_S_03._675, 
                      emdbuser.LOANXDB_S_03._1946, emdbuser.LOANXDB_N_02._1947, emdbuser.LOANXDB_S_01._MORNET_X4, emdbuser.LOANXDB_S_04._1039, 
                      emdbuser.LOANXDB_S_05._L248 AS _CX_FDS_MICODE, emdbuser.LOANXDB_S_02._CX_MICERTNUM, emdbuser.LOANXDB_N_01._1107, 
                      ' ' AS _CX_FDS_LASTPAID, ' ' AS _CX_FDS_PAYEECODE, emdbuser.LOANXDB_S_02._CX_SFC2, emdbuser.LOANXDB_S_02._CX_SFC1, 
                      emdbuser.LOANXDB_S_02._CX_SFC3, emdbuser.LOANXDB_S_02._CX_SFC4, emdbuser.LOANXDB_S_02._CX_SFC5, 
                      emdbuser.LOANXDB_S_02._CX_SFC6, ' ' AS _CX_FDS_COMMENTS, emdbuser.LOANXDB_S_01._11, emdbuser.LOANXDB_S_02._12, 
                      emdbuser.LOANXDB_S_02._1012, emdbuser.LOANXDB_S_02._18, emdbuser.LOANXDB_N_02._356, emdbuser.LOANXDB_N_01._136, 
                      emdbuser.LOANXDB_N_09._CX_BEDROOMS_1, emdbuser.LOANXDB_N_09._CX_BEDROOMS_2, emdbuser.LOANXDB_N_09._CX_BEDROOMS_3, 
                      emdbuser.LOANXDB_N_09._CX_BEDROOMS_4, emdbuser.LOANXDB_N_09._CX_RENT_1, emdbuser.LOANXDB_N_09._CX_RENT_2, 
                      emdbuser.LOANXDB_N_09._CX_RENT_3, emdbuser.LOANXDB_N_09._CX_RENT_4, emdbuser.LOANXDB_S_03._65, 
                      emdbuser.LOANXDB_S_04._1524, emdbuser.LOANXDB_S_04._1525, emdbuser.LOANXDB_S_04._1526, emdbuser.LOANXDB_S_04._1527, 
                      emdbuser.LOANXDB_S_04._1528, emdbuser.LOANXDB_S_04._1529, emdbuser.LOANXDB_S_04._1530, emdbuser.LOANXDB_S_04._1523, 
                      'RETAIL' AS _CX_CHANNEL, emdbuser.LOANXDB_S_03._CUST78FV, ' ' AS _CX_HMPINFO62, ' ' AS _CX_HMPINFO63, 
                      emdbuser.LOANXDB_D_04._3054, emdbuser.LOANXDB_S_04._1543, emdbuser.LOANXDB_S_04._1544, emdbuser.LOANXDB_S_03._1051, 
                      emdbuser.LOANXDB_S_02._2826, emdbuser.LOANXDB_S_01.LOCKRATE_67, emdbuser.LOANXDB_S_09.LOCKRATE_1450, 
                      emdbuser.LOANXDB_S_09.LOCKRATE_1414, emdbuser.LOANXDB_N_01._1389, emdbuser.LOANXDB_S_04._1532, emdbuser.LOANXDB_S_04._1533, 
                      emdbuser.LOANXDB_S_04._1534, emdbuser.LOANXDB_S_04._1535, emdbuser.LOANXDB_S_04._1536, emdbuser.LOANXDB_S_04._1537, 
                      emdbuser.LOANXDB_S_04._1538, emdbuser.LOANXDB_S_04._1531, emdbuser.LOANXDB_D_01._1402, emdbuser.LOANXDB_D_02._1403, 
                      emdbuser.LOANXDB_S_05._L248 AS _L248_2, emdbuser.LOANXDB_N_02._38, emdbuser.LOANXDB_N_01._70, emdbuser.LOANXDB_S_02._471, 
                      emdbuser.LOANXDB_S_03._478, emdbuser.LOANXDB_S_05._4004, emdbuser.LOANXDB_S_05._4006, emdbuser.LOANXDB_S_02._4001, 
                      emdbuser.LOANXDB_S_02._4003, emdbuser.LOANXDB_S_02._4005, emdbuser.LOANXDB_S_02._4007, emdbuser.LOANXDB_S_01._97, 
                      emdbuser.LOANXDB_S_05._4000, emdbuser.LOANXDB_S_02.LOCKRATE_60, emdbuser.LOANXDB_S_09.LOCKRATE_1452, 
                      emdbuser.LOANXDB_S_09.LOCKRATE_1415, emdbuser.LOANXDB_N_03._1731, emdbuser.LOANXDB_N_03._1742, emdbuser.LOANXDB_S_03._965, 
                      emdbuser.LOANXDB_D_03._L770, emdbuser.LOANXDB_D_04._1996, emdbuser.LOANXDB_D_01._1961, emdbuser.LOANXDB_S_01._608, 
                      emdbuser.LOANXDB_S_02._411, emdbuser.LOANXDB_S_01._412, emdbuser.LOANXDB_S_01._413, emdbuser.LOANXDB_S_01._1174, 
                      emdbuser.LOANXDB_S_01._414, emdbuser.LOANXDB_S_01._VEND_X399, emdbuser.LOANXDB_S_02._VEND_X398, 
                      emdbuser.LOANXDB_S_02._2007, emdbuser.LOANXDB_S_02._2003, emdbuser.LOANXDB_S_03._420, emdbuser.LOANXDB_N_02._694, 
                      emdbuser.LOANXDB_N_02._695, emdbuser.LOANXDB_S_01._412 AS _412_2, emdbuser.LOANXDB_S_01._413 AS _413_2, 
                      emdbuser.LOANXDB_S_01._1174 AS _1174_2, emdbuser.LOANXDB_S_01._414 AS _414_2, 
                      emdbuser.LOANXDB_S_01._VEND_X399 AS _VEND_X399_2, emdbuser.LOANXDB_S_02._VEND_X398 AS _VEND_X398_2, 
                      emdbuser.LOANXDB_S_02._2007 AS _2007_2, emdbuser.LOANXDB_S_02._2003 AS _2003_2, emdbuser.LOANXDB_S_03._420 AS _420_2, 
                      emdbuser.LOANXDB_N_02._694 AS _694_2, emdbuser.LOANXDB_N_02._695 AS _695_2, emdbuser.LOANXDB_N_02._1948, 
                      emdbuser.LOANXDB_N_01._1177, emdbuser.LOANXDB_S_04._FE0115, emdbuser.LOANXDB_S_04._FE0215, emdbuser.LOANXDB_S_04._52, 
                      emdbuser.LOANXDB_S_06._84, emdbuser.LOANXDB_N_01._696, emdbuser.LOANXDB_S_01._1040, emdbuser.LOANXDB_N_03._428, 
                      emdbuser.LOANXDB_S_04._617, emdbuser.LOANXDB_S_02._MORNET_X67, emdbuser.LOANXDB_S_02._1959, emdbuser.LOANXDB_N_09._2551, 
                      emdbuser.LOANXDB_N_09._698, emdbuser.LOANXDB_S_03._1659, emdbuser.LOANXDB_S_01._13, emdbuser.LOANXDB_S_04._HMDA_X13, 
                      emdbuser.LOANXDB_S_04._934, emdbuser.LOANXDB_S_02._425, emdbuser.LOANXDB_N_09._1269, emdbuser.LOANXDB_N_01._337, 
                      emdbuser.LOANXDB_N_02._1045, emdbuser.LOANXDB_S_02._1728, ' ' AS ANNUAL_MIP, emdbuser.LOANXDB_D_01._2370, 
                      emdbuser.LOANXDB_S_01._2286, emdbuser.LOANXDB_D_01._CX_FUNDDATE_1, emdbuser.LOANXDB_N_07._SERVICE_X57, 
                      emdbuser.LOANXDB_D_03._SERVICE_X15, emdbuser.LOANXDB_N_06._SERVICE_X82, emdbuser.LOANXDB_D_01._1994, 
                      emdbuser.LOANXDB_S_04._CX_UWMIPCT_5, emdbuser.LOANXDB_D_02._NEWHUD_X332, emdbuser.LOANXDB_N_02._1299, 
                      emdbuser.LOANXDB_S_02._DU_LP_ID, emdbuser.LOANXDB_S_03._SERVICE_X4, emdbuser.LOANXDB_S_03._SERVICE_X5, 
                      emdbuser.LOANXDB_N_01._231, emdbuser.LOANXDB_N_03._L268, emdbuser.LOANXDB_S_01._230, emdbuser.LOANXDB_S_01._232, 
                      emdbuser.LOANXDB_N_02._235, emdbuser.LOANXDB_N_07._SERVICE_X81, emdbuser.LOANXDB_N_09._SERVICE_X103, 
                      emdbuser.LOANXDB_S_01._3238, emdbuser.LOANXDB_S_04._974, emdbuser.LOANXDB_S_01._3243, emdbuser.LOANXDB_S_03._SERVICE_X6, 
                      emdbuser.LOANXDB_S_03._SERVICE_X7, emdbuser.LOANXDB_N_06._SERVICE_X20, emdbuser.LOANXDB_S_05._660, 
                      emdbuser.LOANXDB_S_08._1628, emdbuser.LOANXDB_S_08._661, emdbuser.LOANXDB_S_08._1298
FROM         emdbuser.LOANXDB_S_02 INNER JOIN
                      emdbuser.LOANXDB_S_01 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_S_01.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_01 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_D_01.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_02 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_02.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_01 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_01.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_03 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_S_03.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_02 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_D_02.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_09 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_09.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_04 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_04.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_03 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_03.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_05 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_05.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_06 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_06.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_07 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_07.XrefId INNER JOIN
                      emdbuser.LOANXDB_N_08 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_N_08.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_04 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_S_04.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_05 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_S_05.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_09 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_S_09.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_03 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_D_03.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_06 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_S_06.XrefId INNER JOIN
                      emdbuser.LOANXDB_D_04 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_D_04.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_08 ON emdbuser.LOANXDB_S_02.XrefId = emdbuser.LOANXDB_S_08.XrefId INNER JOIN
                      emdbuser.LOANXDB_S_05 AS LOANXDB_S_05_1 ON emdbuser.LOANXDB_S_02.XrefId = LOANXDB_S_05_1.XrefId
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[39] 4[30] 2[31] 3) )"
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
         Begin Table = "LOANXDB_S_02 (emdbuser)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 280
            End
            DisplayFlags = 280
            TopColumn = 52
         End
         Begin Table = "LOANXDB_S_01 (emdbuser)"
            Begin Extent = 
               Top = 7
               Left = 312
               Bottom = 126
               Right = 592
            End
            DisplayFlags = 280
            TopColumn = 55
         End
         Begin Table = "LOANXDB_D_01 (emdbuser)"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 97
         End
         Begin Table = "LOANXDB_N_02 (emdbuser)"
            Begin Extent = 
               Top = 126
               Left = 311
               Bottom = 245
               Right = 549
            End
            DisplayFlags = 280
            TopColumn = 42
         End
         Begin Table = "LOANXDB_N_01 (emdbuser)"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 291
            End
            DisplayFlags = 280
            TopColumn = 56
         End
         Begin Table = "LOANXDB_S_03 (emdbuser)"
            Begin Extent = 
               Top = 774
               Left = 38
               Bottom = 893
               Right = 312
            End
            DisplayFlags = 280
            TopColumn = 196
         End
         Begin Table = "LOANXDB_D_02 (emdbuser)"
            Begin Extent = 
               Top = 615
              ', 'SCHEMA', N'dbo', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' Left = 38
               Bottom = 734
               Right = 324
            End
            DisplayFlags = 280
            TopColumn = 50
         End
         Begin Table = "LOANXDB_N_09 (emdbuser)"
            Begin Extent = 
               Top = 274
               Left = 329
               Bottom = 393
               Right = 531
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "LOANXDB_N_04 (emdbuser)"
            Begin Extent = 
               Top = 372
               Left = 38
               Bottom = 491
               Right = 267
            End
            DisplayFlags = 280
            TopColumn = 45
         End
         Begin Table = "LOANXDB_N_03 (emdbuser)"
            Begin Extent = 
               Top = 774
               Left = 350
               Bottom = 893
               Right = 576
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOANXDB_N_05 (emdbuser)"
            Begin Extent = 
               Top = 774
               Left = 614
               Bottom = 900
               Right = 821
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOANXDB_N_06 (emdbuser)"
            Begin Extent = 
               Top = 894
               Left = 38
               Bottom = 1013
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOANXDB_N_07 (emdbuser)"
            Begin Extent = 
               Top = 894
               Left = 271
               Bottom = 1013
               Right = 473
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOANXDB_N_08 (emdbuser)"
            Begin Extent = 
               Top = 894
               Left = 511
               Bottom = 1013
               Right = 742
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "LOANXDB_S_04 (emdbuser)"
            Begin Extent = 
               Top = 156
               Left = 569
               Bottom = 275
               Right = 836
            End
            DisplayFlags = 280
            TopColumn = 99
         End
         Begin Table = "LOANXDB_S_05 (emdbuser)"
            Begin Extent = 
               Top = 276
               Left = 569
               Bottom = 395
               Right = 810
            End
            DisplayFlags = 280
            TopColumn = 101
         End
         Begin Table = "LOANXDB_S_09 (emdbuser)"
            Begin Extent = 
               Top = 395
               Left = 305
               Bottom = 514
               Right = 498
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "LOANXDB_D_03 (emdbuser)"
            Begin Extent = 
               Top = 396
               Left = 536
               Bottom = 515
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "LOANXDB_S_06 (emdbuser)"
            Begin Extent = 
               Top = 492
               Left = 38
               Bottom = 611
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "LOANXDB_D_04 (emdbuser)"
            Begin Extent = 
               Top = 619
               Left = 362
               Bottom = 738
               Right = 555
            End
            DisplayFlags = 280', 'SCHEMA', N'dbo', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'
            TopColumn = 0
         End
         Begin Table = "LOANXDB_S_08 (emdbuser)"
            Begin Extent = 
               Top = 6
               Left = 630
               Bottom = 121
               Right = 852
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LOANXDB_S_05_1"
            Begin Extent = 
               Top = 516
               Left = 593
               Bottom = 631
               Right = 826
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
         Column = 3945
         Alias = 900
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
', 'SCHEMA', N'dbo', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=3
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'fannieDirectDelivery', NULL, NULL
GO
