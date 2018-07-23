SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- LoanAssociates provides a list of the associates for each loan milestone
-- and role
create view [emdbuser].[LoanAssociateDetails]
as
	select la.Guid, la.AssociateGuid, la.MilestoneID, lm.MilestoneName, lm."order", 
			la.RoleID, r.RoleName, r.RoleAbbr, 
			la.AssociateType, la.GroupID, la.UserID, 
			IsNull(u.FirstLastName, IsNull(gp.GroupName, la.name)) as FullName, 
			IsNull(la.UserID, IsNull(gp.GroupName, '')) as DisplayName,
			u.first_name, u.last_name, la.Email, la.Phone, la.Fax, la.AllowWrites, la.IsCurrent
	from	LoanAssociates la
			inner join AllRoles r on la.RoleID = r.RoleID
			left outer join users u on la.UserID = u.userid
			left outer join AclGroups gp on la.GroupID = gp.GroupID
			left outer join LoanMilestones lm on la.Guid = lm.Guid and la.MilestoneID = lm.MilestoneID

GO
