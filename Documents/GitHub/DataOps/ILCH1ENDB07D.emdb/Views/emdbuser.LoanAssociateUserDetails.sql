SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- LoanAssociates provides a list of the associates for each loan milestone
-- and role
create view [emdbuser].[LoanAssociateUserDetails]
as
	select la.Guid, la.AssociateGuid, la.MilestoneID, lm.MilestoneName, lm."order", 
			la.RoleID, r.RoleName, r.RoleAbbr, 
			la.AssociateType, la.GroupID, la.UserID, 
			u.UserName as FullName, u.FirstLastName as FirstLastName,
			u.first_name, u.last_name, la.Email, la.Phone, la.Fax, la.AllowWrites
	from	LoanAssociateUsers la
			inner join AllRoles r on la.RoleID = r.RoleID
			inner join users u on la.UserID = u.userid
			left outer join LoanMilestones lm on la.Guid = lm.Guid and la.MilestoneID = lm.MilestoneID

GO
