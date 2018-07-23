SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [emdbuser].[AddUserToAclGroup]
	@groupName varchar(50),
	@userId varchar(16)
AS
BEGIN
	declare @groupId int
	select @groupId = groupID from AclGroups where groupName = @groupName
	if @groupId is null return
	-- Prevent an attempt to insert a duplicate
	if not exists (select * from AclGroupUserRef where groupID = @groupId and userID = @userId)
	begin
		-- Create the group record
		insert into AclGroupUserRef (groupID, userID) values (@groupId, @userId)
	end
END

GO
