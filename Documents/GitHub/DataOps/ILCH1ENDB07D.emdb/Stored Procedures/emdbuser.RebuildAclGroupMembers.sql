SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [emdbuser].[RebuildAclGroupMembers]
as
BEGIN
	-- Clear the table
	DELETE FROM AclGroupMembers
	-- Rebuild its contents
   	INSERT INTO AclGroupMembers 
	    -- Get users directly assigned to group:      
		SELECT gu.groupID, gu.userid
	      	FROM AclGroupUserRef gu 
		UNION 
		-- Get users whose organization is directly assigned to group:
		SELECT go.groupID, u.userid
		FROM AclGroupOrgRef go
			INNER JOIN users u ON go.orgID = u.org_id
		UNION
		-- Get users whose organization is a decendent of organization directly assigned to group:
		SELECT go.groupID, u.userid
		FROM AclGroupOrgRef go
			INNER JOIN org_descendents od ON go.orgID = od.oid
			INNER JOIN users u ON od.descendent = u.org_id
		WHERE go.recursive = 1
		-- Now rebuild the UserLoans table entries that are tied to groups
		DELETE UserLoans
		FROM LoanAssociates la
			WHERE UserLoans.AssociateGuid = la.AssociateGuid
				and la.GroupID IS NOT NULL
		INSERT INTO UserLoans
		SELECT agm.UserID, xref.XRefID, la.AssociateGuid
		FROM LoanAssociates la
			INNER JOIN AclGroupMembers agm on la.GroupID = agm.GroupID
			INNER JOIN LoanXRef xref on xref.LoanGuid = la.Guid
END

GO
