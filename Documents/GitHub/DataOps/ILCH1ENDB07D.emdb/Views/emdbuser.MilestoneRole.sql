SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- MilestoneRole view provides mapping of Milestone ID to Role ID to account for 
-- one-off offset in the MilestoneWorksheets table
create view [emdbuser].[MilestoneRole]
as
	-- Start by selecting the first milestone, which never has an associated Role
	SELECT MilestoneID, 0 as RoleID, 'File Starter' as RoleName, 'FS' as RoleAbbr FROM MilestoneTemplate WHERE "Order" = 1
	UNION
	-- Now select the other milestones and use the role ID offset by one from the MilestoneWorksheets
	SELECT  mt.MilestoneID, r.RoleID, r.RoleName, r.RoleAbbr
	FROM    	FN_ActiveMilestoneTemplate() as mt 
		INNER JOIN FN_ActiveMilestoneTemplate() mtr ON mt."order" = mtr."order" + 1
		INNER JOIN MilestoneWorksheets msr ON mtr.milestoneID = msr.MilestoneID 
		INNER JOIN Roles r on msr.RoleID = r.RoleID

GO
