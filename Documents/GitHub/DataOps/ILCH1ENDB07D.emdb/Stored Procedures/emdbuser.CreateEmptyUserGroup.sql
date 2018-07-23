SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [emdbuser].[CreateEmptyUserGroup]
	@groupName varchar(50),
	@groupId int output
AS
BEGIN
	-- Prevent an attempt to insert a duplicate
	if exists (select * from AclGroups where groupName = @groupName)
	begin
		select @groupId = groupID from AclGroups where groupName = @groupName
		return
	end
	-- Create the group record
	insert into AclGroups (groupName, viewSubordContacts, displayOrder, contactAccess) 
		values (@groupName, 0, 1, 0)
	select @groupId = @@identity
	-- Set the Role View settings so no users are visible
	insert into AclGroupRoleAccessLevel (groupID, roleID, access, hideDisabled)
		select @groupId, Roles.roleID, 2, 1
		from Roles
END

GO
