SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [emdbuser].[RebuildOrgAccessibleLoanOwners]
	@orgId int,
	@recursive bit
as
	-- Build the list of users to be processed
	declare @orgUsers table (UserID varchar(16) PRIMARY KEY, org_id int NOT NULL, peerView int NOT NULL)
	insert into @orgUsers
		select userid, org_id, peerView from users where org_id = @orgId
		union
		select u.userid, u.org_id, u.peerView from users u 
			inner join org_descendents od on u.org_id = od.descendent 
		where od.oid = @orgId
			and @recursive = 1
	-- Clear the table
	DELETE FROM AccessibleLoanOwners where UserID in
		(select UserID from @orgUsers)
	-- Rebuild its contents
   	INSERT INTO AccessibleLoanOwners
		-- Add records so each user can access their own loans
		select UserID, UserID from @orgUsers
		union
		-- Add records so users can access subordinates loans
		select cu.userid, u.userid from @orgUsers cu 
			inner join org_descendents od on cu.org_id = od.oid
			inner join users u on u.org_id = od.descendent
		union
		-- Add users at the same level of the hierarchy, if appropriate
		select cu.userid, u.userid from @orgUsers cu
			inner join users u on u.org_id = cu.org_id
		where cu.peerView > 0
		union
		-- Now we use AclGroup membership to see who we have access to. Start with the
		-- folks directly assigned to an org which the user has access to.
		select cu.userid, u.userid from @orgUsers cu
			inner join AclGroupMembers agm on cu.userid = agm.userid
			inner join AclGroupLoanOrgRef aglor on aglor.groupid = agm.groupid
			inner join users u on u.org_id = aglor.orgID
		union
		-- Next, find people who are assigned to sub-organization of orgs that are added
		-- recursively to the acl group's access list
		select cu.userid, u.userid from @orgUsers cu
			inner join AclGroupMembers agm on cu.userid = agm.userid
			inner join AclGroupLoanOrgRef aglor on aglor.groupid = agm.groupid
			inner join org_descendents od on od.oid = aglor.orgID
			inner join users u on u.org_id = od.descendent
		where aglor.recursive = 1
		union
		-- Finally, add any users to whom the user gains access thru direct assignment
		select cu.userid, aglur.UserID from @orgUsers cu
			inner join AclGroupMembers agm on cu.userid = agm.userid
			inner join AclGroupLoanUserRef aglur on aglur.groupID = agm.GroupID

GO
