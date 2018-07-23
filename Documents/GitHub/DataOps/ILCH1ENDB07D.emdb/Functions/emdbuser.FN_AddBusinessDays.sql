SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [emdbuser].[FN_AddBusinessDays]
(
	@calendarId int,
	@date datetime,
	@daysToAdd int,
	@startAtClosestBusinessDay bit
)
RETURNS @dateTable TABLE
(
	[Date] datetime,
	DayIndex int
)
AS
BEGIN
	-- Advance the date if required to the closest business day
	if @startAtClosestBusinessDay = 1
		select @date = [Date] from FN_GetNextClosestBusinessDay(@calendarId, @date)
	-- Determine the date index for the business day
	declare @dayIndex int
	select @dayIndex = DayIndex from FN_GetBusinessDay(@calendarId, @date)
	-- Select the specified date N days after the start date
	insert into @dateTable
	select [Date], [DayIndex]
	from BusinessDays
	where CalendarID = @calendarId 
		and DayIndex = @dayIndex + @daysToAdd
		and DayType = 1
RETURN
END

GO
