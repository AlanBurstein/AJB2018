SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [emdbuser].[RebuildGroupAccessibleLoanOwners]
	@groupId int
as
	-- Clear the table
	DELETE FROM AccessibleLoanOwners where UserID in
		(select UserID from AclGroupMembers where GroupID = @groupId)
	-- Rebuild its contents
   	INSERT INTO AccessibleLoanOwners
		-- Add records so each user can access their own loans
		select UserID, UserID from AclGroupMembers where GroupID = @groupId
		union
		-- Add records so users can access subordinates loans
		select cu.userid, u.userid from users cu 
			inner join org_descendents od on cu.org_id = od.oid
			inner join users u on u.org_id = od.descendent
			inner join AclGroupMembers agm on cu.userid = agm.userid
		where agm.GroupID = @groupId
		union
		-- Add users at the same level of the hierarchy, if appropriate
		select cu.userid, u.userid from users cu
			inner join users u on u.org_id = cu.org_id
			inner join AclGroupMembers agm on cu.userid = agm.userid
		where agm.GroupID = @groupId
			and cu.peerView > 0
		union
		-- Now we use AclGroup membership to see who we have access to. Start with the
		-- folks directly assigned to an org which the user has access to.
		select cu.userid, u.userid from users cu
			inner join AclGroupMembers cuagm on cu.userid = cuagm.userid
			inner join AclGroupMembers agm on cu.userid = agm.userid
			inner join AclGroupLoanOrgRef aglor on aglor.groupid = agm.groupid
			inner join users u on u.org_id = aglor.orgID
		where cuagm.GroupID = @groupId
		union
		-- Next, find people who are assigned to sub-organization of orgs that are added
		-- recursively to the acl group's access list
		select cu.userid, u.userid from users cu
			inner join AclGroupMembers cuagm on cu.userid = cuagm.userid
			inner join AclGroupMembers agm on cu.userid = agm.userid
			inner join AclGroupLoanOrgRef aglor on aglor.groupid = agm.groupid
			inner join org_descendents od on od.oid = aglor.orgID
			inner join users u on u.org_id = od.descendent
		where cuagm.GroupID = @groupId
			and aglor.recursive = 1
		union
		-- Finally, add any users to whom the user gains access thru direct assignment
		select cu.userid, aglur.UserID from users cu
			inner join AclGroupMembers cuagm on cu.userid = cuagm.userid
			inner join AclGroupMembers agm on cu.userid = agm.userid
			inner join AclGroupLoanUserRef aglur on aglur.groupID = agm.GroupID
		where cuagm.GroupID = @groupId

GO
