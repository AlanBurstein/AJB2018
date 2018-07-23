SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [emdbuser].[FN_GetAlertMilestoneSetup]
(	
	@currentDate datetime
)
RETURNS TABLE 
AS
RETURN 
(
	-- Get the alerts with the "Days before" setting
	select ac.AlertID, amc.Guid as MilestoneID, DateAdd(d, ac.DaysBefore, @currentDate) as ActivationTime
	from AlertConfig ac
		inner join AlertMilestoneConfig amc on amc.alertID = ac.AlertID
	where ac.DaysBefore >= 0
		and ac.DisplayOnPipeline = 1
	union
	-- Get the alerts without "Days Before"
	select ac.AlertID, amc.Guid as MilestoneID, NULL as ActivationTime
	from AlertConfig ac
		inner join AlertMilestoneConfig amc on amc.alertID = ac.AlertID
	where ac.DaysBefore < 0
		and ac.DisplayOnPipeline = 1
)

GO
