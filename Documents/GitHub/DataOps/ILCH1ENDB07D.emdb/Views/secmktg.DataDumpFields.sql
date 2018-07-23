SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [secmktg].[DataDumpFields]
AS
SELECT        ls02._364, ls03._CX_FINALOCODE_4, ls10._CX_LOCODE_1, ls01._CX_PAIDLO_3, ls02._CX_PAIDLOCODE_3, ls01._11, ls02._12, ls01._14, ls03._15, ls01._36, 
                         ls01._37, ls01._FR0104, ls02._FR0106, ls02._FR0107, ls03._FR0108, CONVERT(date, ld01._2149) AS _2149, CONVERT(date, ld03.LOCKRATE_2151) 
                         AS LOCKRATE_2151, CONVERT(date, ld03.LOCKRATE_2222) AS LOCKRATE_2222, ls09.LOCKRATE_1172, ls01.LOCKRATE_MORNET_X67, ls02._MORNET_X67, 
                         ls04.LOCKRATE_1130, ls02._1130, ls03.LOCKRATE_1401, ls02._1401, ls09.LOCKRATE_1811, ls09.LOCKRATE_19, ln08.LOCKRATE_2160, ls01._1041, 
                         ln08.LOCKRATE_136, ln08.LOCKRATE_356, ln08.LOCKRATE_353, ln01._976, ln02._4, ln01._697, ls05._CX_SECONDUNITS_16, ls03._VEND_X200, 
                         ls09.LOCKRATE_2853, ln01.LOCKRATE_VASUMM_X23, ln04._740, ln02._742, ln09.LOCKRATE_2965, ln02._2, ln09.LOCKRATE_3043, ls09.LOCKRATE_2961, 
                         ls01._2293, ls09.LOCKRATE_2962, ls01._2294, ln07._2150, ln08.LOCKRATE_2221, ln08.LOCKRATE_2231, ln08.LOCKRATE_2218, ln07._2295, 
                         ln01._CX_ACCTTOTCHRG_2, ls01._2286, ls01._2288, ls02._CX_AUSSOURCE_2, ls03._2316, ls02._CX_AUSRECOMMENDATION_2, ls01._1393, ln01._1107, 
                         ls09.LOCKRATE_2278, CONVERT(date, ld01._CX_PREAPPROVORDER_1) AS _CX_PREAPPROVORDER_1, CONVERT(date, ld01._2313) AS _2313, CONVERT(date, 
                         ld01._2298) AS _2298, CONVERT(date, ld01._2301) AS _2301, CONVERT(date, ld01._2303) AS _2303, CONVERT(date, ld01._2987) AS _2987, CONVERT(date, 
                         ld01._2305) AS _2305, CONVERT(date, ld01._748) AS _748, CONVERT(date, ld01._CX_FUNDDATE_1) AS _CX_FUNDDATE_1, CONVERT(date, ld01._2297) AS _2297, 
                         CONVERT(date, ld01._2370) AS _2370, ls04._CX_PROBLOANSUB_14, CONVERT(date, ld02._CX_PROBLOANSUBDT_14) AS _CX_PROBLOANSUBDT_14, 
                         ls02._CX_UWRUSH_1, ls01._CX_UWRUSHCOND_1, ls02._CX_PROBCONDO, ls02._CX_PROBCONDODESC, ls04._CX_PROBLOAN_5, CONVERT(date, 
                         ld02._CX_PROBLOANDT_5) AS _CX_PROBLOANDT_5, ls04._CX_PROBLOANCLS_14, CONVERT(date, ld02._CX_PROBLOANCLSDT_14) 
                         AS _CX_PROBLOANCLSDT_14, CONVERT(date, ld01._CX_TITLEORDER_1) AS _CX_TITLEORDER_1, CONVERT(date, ld01._CX_FLOODORDER_1) 
                         AS _CX_FLOODORDER_1, CONVERT(date, ld01._CX_INSURORDER_1) AS _CX_INSURORDER_1, CONVERT(date, ld02._CX_CONDODOCS_10) 
                         AS _CX_CONDODOCS_10, CONVERT(date, ld02._CX_SUBORD_10) AS _CX_SUBORD_10, CONVERT(date, ld02._CX_LOCKCANCEL_16) AS _CX_LOCKCANCEL_16, 
                         ls05._CX_PREVINVEST_16, CONVERT(date, ld02._CX_SECEXP) AS _CX_SECEXP, ls05._CX_SECNEGOTIATE_10, ls02._CX_SECCANCEL, ls02._CX_SECRELOCK, 
                         CONVERT(date, ld02._CX_LOCKCANCEL2_16) AS _CX_LOCKCANCEL2_16, ls05._CX_PREVINVEST2_16, CONVERT(date, ld02._CX_SECEXP2) AS _CX_SECEXP2, 
                         ls05._CX_SECNEGOTIATE2_10, ls02._CX_SECCANCEL2, ls02._CX_SECRELOCK2, CONVERT(date, ld02._CX_LOCKCANCEL3_16) AS _CX_LOCKCANCEL3_16, 
                         ls05._CX_PREVINVEST3_16, CONVERT(date, ld02._CX_SECEXP3) AS _CX_SECEXP3, ls05._CX_SECNEGOTIATE3_10, ls02._CX_SECCANCEL3, 
                         ls02._CX_SECRELOCK3, CONVERT(date, ld02._CX_LOCKCANCEL4_10) AS _CX_LOCKCANCEL4_10, ls06._CX_PREVINVEST4_10, CONVERT(date, 
                         ld02._CX_SECEXP4) AS _CX_SECEXP4, ls05._CX_SECNEGOTIATE4_10, ls02._CX_SECCANCEL4, ls02._CX_SECRELOCK4, CONVERT(date, 
                         ld02._CX_LOCKCANCEL5_10) AS _CX_LOCKCANCEL5_10, ls06._CX_PREVINVEST5_10, CONVERT(date, ld02._CX_SECEXP5) AS _CX_SECEXP5, 
                         ls05._CX_SECNEGOTIATE5_10, ls02._CX_SECCANCEL5, ls02._CX_SECRELOCK5, ls03._CX_SECEXTEND, ls03._CX_SECEXTEND2, ls03._CX_SECEXTEND3, 
                         ls02._CX_SECEXTEND4, ls03._CX_SECEXTEND5, ls02._CX_SECRUSH, ls01._CX_CLSRUSH_1, CONVERT(date, ld01._CX_CLSRUSHDATE_1) 
                         AS _CX_CLSRUSHDATE_1, ls02._CX_REDRAW_1, ls01.LOCKRATE_CURRENTSTATUS, ls01._MS_STATUS, ls04.Log_MS_DateTime_AssignedtoUW, CONVERT(date, 
                         ld02.Log_MS_Date_ConditionsSubmittedtoUW) AS Log_MS_Date_ConditionsSubmittedtoUW, CONVERT(date, ld02.Log_MS_Date_AssigntoClose) 
                         AS Log_MS_Date_AssigntoClose, CONVERT(date, ld01.Log_MS_Date_DocsSigning) AS Log_MS_Date_DocsSigning, ln02.LOCKRATE_REQUESTCOUNT, 
                         ls04._LOANFOLDER, ls09._CX_PCDISCLOSE, ls09._CX_PCOOKCNTY, ls09._CX_PCINSUR, ls09._CX_PCVOE, ls09._CX_PCAUS, ls09._CX_PCAPPRAISE, 
                         ls09._CX_PCMISDOCS, CONVERT(date, ld01._2013) AS _2013, CONVERT(date, ld01._2014) AS _2014, CONVERT(date, ld01._CX_PACKAGERECVD_1) 
                         AS _CX_PACKAGERECVD_1, CONVERT(date, ld02._1998) AS _1998, ls01._CX_UWINVALAUS, ls01._CX_UWINVALPRGPRD, ls01._CX_UWMISCINTSUB, 
                         ls01._CX_UWINCOMCREDITDOC, ls01._CX_UWMULTIRESTR, ls01._CX_UWMISCRESUB, ls01._CX_UWPIECEMAILCOND, ls01._CX_UWDOCNOTSUPPAUS, 
                         ln02._736, ls01._700, CONVERT(date, ld02._CX_SECORIGLOCK_16) AS _CX_SECORIGLOCK_16, CONVERT(date, ld02._CX_SECORIGLOCK2_16) 
                         AS _CX_SECORIGLOCK2_16, CONVERT(date, ld02._CX_SECORIGLOCK3_16) AS _CX_SECORIGLOCK3_16, CONVERT(date, ld02._CX_SECORIGLOCK4_10) 
                         AS _CX_SECORIGLOCK4_10, CONVERT(date, ld02._CX_SECORIGLOCK5_10) AS _CX_SECORIGLOCK5_10, CONVERT(date, ld01._CX_APPRORDER_4) 
                         AS _CX_APPRORDER_4, CONVERT(date, ld02._REQUEST_X21) AS _REQUEST_X21, ls02._411, CONVERT(date, ld01._CX_PCSUSPEND_1) AS _CX_PCSUSPEND_1, 
                         CONVERT(date, ld01._CX_CLSSCHED_1) AS _CX_CLSSCHED_1, CONVERT(date, ld01._1997) AS _1997, ls03._420, CONVERT(date, ld01._CX_RESPAAPP_1) 
                         AS _CX_RESPAAPP_1, CONVERT(date, ld02._3142) AS _3142, CONVERT(decimal(23, 10), NULL) AS _CX_COPYLOBPS, ls05._CX_SECMI_16, ls03._CX_UWREQMI, 
                         ls02._2626, CONVERT(date, ld02._CX_BROKERFUND_5) AS _CX_BROKERFUND_5, CONVERT(date, ld02._CX_BROKERCLOSE_5) AS _CX_BROKERCLOSE_5, 
                         ls01._984, CONVERT(decimal(23, 10), NULL) AS _CX_CORPOBJ, ln06._CX_BPSDIFFER, ln06._CX_BPNETGAINLOSS, ls03._CX_NUMUWCONDITION, 
                         ls03._CX_UWNUMCNDOREVD, CONVERT(date, ld04.Log_MS_Date_Processing) AS Log_MS_Date_Processing, ls07._CX_LOANSERVICER, 
                         ls10.LoanTeamMember_Name_MortgageConsultant, ls01.LoanTeamMember_Name_LoanCoordinator, ls03._CX_MCNAME_1, ls01._CX_LCNAME_1, CONVERT(date, 
                         ld01._CX_APPSENT_1) AS _CX_APPSENT_1, CONVERT(date, ld01._CX_APPRCVD_1) AS _CX_APPRCVD_1, CONVERT(date, ld02.Log_MS_Date_UWDecisionExpected)
                          AS Log_MS_Date_UWDecisionExpected, ln10._CX_UWC_COUNT_MC, ls01._1040, CONVERT(date, ld01._CX_SHPDATEASSIGN_1) AS _CX_SHPDATEASSIGN_1, 
                         ls15._3474, ln11._3475, ls15._3476, ln11._3477, ls15._3478, ln11._3479, ls10._2162, ls10._2164, ls10._2166, ls10._2168, ls10._2170, ls10._2172, ls10._2174, 
                         ls10._2176, ls10._2178, ls01._230, ln01._231, ln02._235, ln10._2163, ln10._2165, ln10._2167, ln10._2169, ln10._2171, ln10._2173, ln10._2175, ln10._2177, 
                         ln10._2179, ls02._CX_SECINVESTOR_10, ls05._2853
FROM            emdbuser.LOANXDB_S_01 AS ls01 INNER JOIN
                         emdbuser.LOANXDB_S_04 AS ls04 ON ls01.XrefId = ls04.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_02 AS ls02 ON ls01.XrefId = ls02.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_03 AS ls03 ON ls01.XrefId = ls03.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_05 AS ls05 ON ls01.XrefId = ls05.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_06 AS ls06 ON ls01.XrefId = ls06.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_07 AS ls07 ON ls01.XrefId = ls07.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_09 AS ls09 ON ls01.XrefId = ls09.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_10 AS ls10 ON ls01.XrefId = ls10.XrefId INNER JOIN
                         emdbuser.LOANXDB_S_15 AS ls15 ON ls01.XrefId = ls15.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_01 AS ln01 ON ls01.XrefId = ln01.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_02 AS ln02 ON ls01.XrefId = ln02.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_03 AS ln03 ON ls01.XrefId = ln03.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_04 AS ln04 ON ls01.XrefId = ln04.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_06 AS ln06 ON ls01.XrefId = ln06.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_07 AS ln07 ON ls01.XrefId = ln07.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_08 AS ln08 ON ls01.XrefId = ln08.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_09 AS ln09 ON ls01.XrefId = ln09.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_10 AS ln10 ON ls01.XrefId = ln10.XrefId INNER JOIN
                         emdbuser.LOANXDB_N_11 AS ln11 ON ls01.XrefId = ln11.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_01 AS ld01 ON ls01.XrefId = ld01.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_02 AS ld02 ON ls01.XrefId = ld02.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_03 AS ld03 ON ls01.XrefId = ld03.XrefId INNER JOIN
                         emdbuser.LOANXDB_D_04 AS ld04 ON ls01.XrefId = ld04.XrefId
WHERE        (NOT (ls04._LOANFOLDER IN ('Samples', '(Trash)')))
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
         Begin Table = "ls01"
            Begin Extent = 
               Top = 6
               Left = 326
               Bottom = 135
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls04"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 322
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls02"
            Begin Extent = 
               Top = 6
               Left = 686
               Bottom = 135
               Right = 944
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls03"
            Begin Extent = 
               Top = 6
               Left = 982
               Bottom = 135
               Right = 1278
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls05"
            Begin Extent = 
               Top = 138
               Left = 360
               Bottom = 267
               Right = 614
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls06"
            Begin Extent = 
               Top = 138
               Left = 652
               Bottom = 267
               Right = 899
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls07"
            Begin Extent = 
               Top = 138
               Left = 937
               Bottom = 267
               Right = 1221
            End
            DisplayFlags = 280
            TopCol', 'SCHEMA', N'secmktg', 'VIEW', N'DataDumpFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'umn = 0
         End
         Begin Table = "ls09"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 399
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls10"
            Begin Extent = 
               Top = 270
               Left = 281
               Bottom = 399
               Right = 625
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ls15"
            Begin Extent = 
               Top = 666
               Left = 973
               Bottom = 795
               Right = 1200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln01"
            Begin Extent = 
               Top = 270
               Left = 663
               Bottom = 399
               Right = 926
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln02"
            Begin Extent = 
               Top = 270
               Left = 964
               Bottom = 399
               Right = 1210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln03"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 531
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln04"
            Begin Extent = 
               Top = 402
               Left = 312
               Bottom = 531
               Right = 550
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln06"
            Begin Extent = 
               Top = 402
               Left = 588
               Bottom = 531
               Right = 793
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln07"
            Begin Extent = 
               Top = 402
               Left = 831
               Bottom = 531
               Right = 1048
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln08"
            Begin Extent = 
               Top = 402
               Left = 1086
               Bottom = 531
               Right = 1335
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln09"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 663
               Right = 272
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln10"
            Begin Extent = 
               Top = 666
               Left = 354
               Bottom = 795
               Right = 684
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ln11"
            Begin Extent = 
               Top = 666
               Left = 705
               Bottom = 795
               Right = 946
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld01"
            Begin Extent = 
               Top = 534
               Left = 310
               Bottom = 663
               Right = 556
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld02"
            Begin Extent = 
               Top = 534', 'SCHEMA', N'secmktg', 'VIEW', N'DataDumpFields', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'
               Left = 594
               Bottom = 663
               Right = 902
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld03"
            Begin Extent = 
               Top = 534
               Left = 940
               Bottom = 663
               Right = 1201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ld04"
            Begin Extent = 
               Top = 666
               Left = 38
               Bottom = 795
               Right = 316
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
', 'SCHEMA', N'secmktg', 'VIEW', N'DataDumpFields', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=3
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'secmktg', 'VIEW', N'DataDumpFields', NULL, NULL
GO
