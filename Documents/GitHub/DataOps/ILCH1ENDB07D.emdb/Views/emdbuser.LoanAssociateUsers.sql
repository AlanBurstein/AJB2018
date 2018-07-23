SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- LoanAssociates provides a list of the associates for each loan milestone
-- and role
create view [emdbuser].[LoanAssociateUsers]
as
	select la.Guid, la.AssociateGuid, la.MilestoneID, la.RoleID,
			la.AssociateType, IsNull(gm.UserID, la.UserID) as UserID, la.GroupID, la.Name,
			la.Email, la.Phone, la.Fax, la.AllowWrites
	from	LoanAssociates la
		left outer join AclGroupMembers gm on la.GroupID = gm.GroupID

GO
