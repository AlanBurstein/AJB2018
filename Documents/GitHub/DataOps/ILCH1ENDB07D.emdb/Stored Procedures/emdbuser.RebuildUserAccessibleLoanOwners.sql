SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [emdbuser].[RebuildUserAccessibleLoanOwners]
	@userId varchar(16)
as
	-- Clear the table
	DELETE FROM AccessibleLoanOwners where UserID = @userId
	IF EXISTS (SELECT 1 FROM Users WHERE UserID = @userId)
	begin
		-- Rebuild its contents
   		INSERT INTO AccessibleLoanOwners
			-- A user can always see their own loans
			select @userId, @userId
			union
			-- Get all users subordinate to the current user
			select @userId, u.userid from users u
				inner join org_descendents od on u.org_id = od.descendent
				inner join users cu on cu.org_id = od.oid
			where cu.userid = @userId
			union
			-- Add users at the same level of the hierarchy, if appropriate
			select @userId, u.userid from users u
				inner join users cu on u.org_id = cu.org_id
			where cu.userid = @userId
			  and cu.peerView > 0
			union
			-- Now we use AclGroup membership to see who we have access to. Start with the
			-- folks directly assigned to an org which the user has access to.
			select @userId, u.userid from users u
				inner join AclGroupLoanOrgRef aglor on u.org_id = aglor.orgID
				inner join AclGroupMembers agm on aglor.groupID = agm.GroupID
			where agm.UserID = @userId
			union
			-- Next, find people who are assigned to sub-organization of orgs that are added
			-- recursively to the acl group's access list
			select @userId, u.userid from users u
				inner join org_descendents od on u.org_id = od.descendent
				inner join AclGroupLoanOrgRef aglor on od.oid = aglor.orgID
				inner join AclGroupMembers agm on aglor.groupID = agm.GroupID
			where agm.UserID = @userId
				and aglor.recursive = 1
			union
			-- Finally, add any users to whom the user gains access thru direct assignment
			select @userId, aglur.UserID from AclGroupLoanUserRef aglur
				inner join AclGroupMembers agm on aglur.groupID = agm.GroupID
			where agm.UserID = @userId
	end

GO
