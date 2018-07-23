SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[org_chart_full]
AS
WITH info AS (SELECT     oid, parent, company_name, address1, address2, city, state, zip, phone, fax
                               FROM         emdbuser.org_chart AS org_chart_info
                               WHERE     (NULLIF (company_name, '') IS NOT NULL)
                               UNION ALL
                               SELECT     oci.oid, oci.parent, ii.company_name, ii.address1, ii.address2, ii.city, ii.state, ii.zip, ii.phone, ii.fax
                               FROM         emdbuser.org_chart AS oci INNER JOIN
                                                     info AS ii ON oci.parent = ii.oid
                               WHERE     (NULLIF (oci.company_name, '') IS NULL)), nmls AS
    (SELECT     oid, parent, nmls_code
      FROM          emdbuser.org_chart AS org_chart_nmls
      WHERE      (NULLIF (nmls_code, '') IS NOT NULL)
      UNION ALL
      SELECT     ocn.oid, ocn.parent, nn.nmls_code
      FROM         emdbuser.org_chart AS ocn INNER JOIN
                            nmls AS nn ON ocn.parent = nn.oid
      WHERE     (NULLIF (ocn.nmls_code, '') IS NULL)), mersmin AS
    (SELECT     oid, parent, mersmin_code
      FROM          emdbuser.org_chart AS org_chart_mersmin_0
      WHERE      (oid = parent)
      UNION
      SELECT     oid, parent, mersmin_code
      FROM         emdbuser.org_chart AS org_chart_mersmin
      WHERE     (NULLIF (mersmin_code, '') IS NOT NULL)
      UNION ALL
      SELECT     ocm.oid, ocm.parent, mm.mersmin_code
      FROM         emdbuser.org_chart AS ocm INNER JOIN
                            mersmin AS mm ON ocm.parent = mm.oid
      WHERE     (NULLIF (ocm.mersmin_code, '') IS NULL) AND (ocm.oid <> ocm.parent))
    SELECT     oc.oid, oc.org_name, oc.description, oc.parent, i.company_name, i.address1, i.address2, i.city, i.state, i.zip, i.phone, i.fax, oc.depth, n.nmls_code, m.mersmin_code,
                             oc.license_lender_type, oc.license_home_state, oc.license_statutory_maryland, oc.license_statutory_kansas, oc.license_dbaname1, oc.license_dbaname2, 
                            oc.license_dbaname3, oc.license_dbaname4
     FROM         emdbuser.org_chart AS oc INNER JOIN
                            nmls AS n ON oc.oid = n.oid INNER JOIN
                            mersmin AS m ON oc.oid = m.oid INNER JOIN
                            info AS i ON oc.oid = i.oid
GO
GRANT SELECT ON  [dbo].[org_chart_full] TO [GRCORP\Marketing SQL SEC]
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
         Begin Table = "oc"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "n"
            Begin Extent = 
               Top = 6
               Left = 298
               Bottom = 110
               Right = 458
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 6
               Left = 496
               Bottom = 110
               Right = 656
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 114
               Left = 298
               Bottom = 233
               Right = 462
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
', 'SCHEMA', N'dbo', 'VIEW', N'org_chart_full', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'org_chart_full', NULL, NULL
GO
