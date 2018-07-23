SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
create function [emdbuser].[FN_ActiveMilestoneTemplate]
(
)
returns @msTable table
(
	milestoneID varchar(38) PRIMARY KEY,
	days int,
	[order] int identity(1, 1)
)
as
begin
	declare looper cursor for 
		select milestoneID, days from MilestoneTemplate mt
		left outer join CustomMilestones cm on mt.MilestoneID = cm.Guid
		where IsNull(cm.Status, 0) = 0 order by mt.[Order]
	declare @milestoneID varchar(38), @days int
	open looper
	fetch next from looper into @milestoneID, @days
	while @@fetch_status = 0
	begin
		insert into @msTable(milestoneID, days) values(@milestoneID, @days) 
		fetch next from looper into @milestoneID, @days
	end
	close looper
	deallocate looper
return
end

GO
