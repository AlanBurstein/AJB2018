SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [emdbuser].[ResetMilestoneOrder]
	@milestoneName varchar(128),
	@newOrder nvarchar(2)
AS
Begin
	declare @newMilestoneID varchar(128)
	declare @sql nvarchar(2000)
	select @newMilestoneID = "Guid" from CustomMilestones where "Name" = @milestoneName
	if exists (select 1 from CustomMilestones where "Name" = @milestoneName)
	begin
		select @newMilestoneID = "Guid" from CustomMilestones where "Name" = @milestoneName
	end
	else
	begin
		select @newMilestoneID = "MilestoneId" from Milestone where "Milestone" = @milestoneName
	end
	set @sql = 'Update MilestoneTemplate set [order] = ' + @newOrder + ' where milestoneID = ''' + @newMilestoneID + ''''
	exec sp_executesql @sql	
End

GO
