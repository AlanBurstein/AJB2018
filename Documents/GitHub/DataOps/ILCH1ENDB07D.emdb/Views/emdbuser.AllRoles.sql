SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- AllRoles provides a list of the Roles, including the File Starter role
create view [emdbuser].[AllRoles] as
	SELECT 0 as RoleID, 'File Starter' as RoleName, 'FS' as RoleAbbr, 0 as Protected
	UNION
	SELECT roleID, roleName, roleAbbr, protected FROM Roles

GO
