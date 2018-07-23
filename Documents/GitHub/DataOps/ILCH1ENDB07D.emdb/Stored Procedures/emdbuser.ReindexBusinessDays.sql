SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [emdbuser].[ReindexBusinessDays]
(
	@calendarId int
)
as
begin
	-- First ensure that work days and weekends are marked appropriately 
	declare @workDays int
	select @workDays = WorkDays from BusinessCalendar where CalendarID = @calendarId
	declare @dayOfWeek int
	declare @dayOfWeekMask int
	select @dayOfWeek = 1, @dayOfWeekMask = 1
	while @dayOfWeek <= 7
	begin
		-- We need to correct any weekend days that have the incorrect day type based on
		-- the current weekend settings. A DayType = 2 indicates a weekend (non-work) day
		-- while a DayType = 1 indicates a work day.
		if (@workDays & @dayOfWeekMask) > 0
			update BusinessDays set DayType = 1, DayIndex = -1 
				where CalendarID = @calendarId and DayType = 2 and DayOfWeek = @dayOfWeek
		else
			update BusinessDays set DayType = 2, DayIndex = -1 
				where CalendarID = @calendarId and DayType = 1 and DayOfWeek = @dayOfWeek
		-- Move to the next day of the week
		select @dayOfWeek = @dayOfWeek + 1, @dayOfWeekMask = @dayOfWeekMask * 2
	end
	-- Look for the last date with a non-negative index -- that's where we'll start
	declare @date datetime
	declare @dayIndex int
	select @date = max("Date"), @dayIndex = max(DayIndex) 
	from BusinessDays 
	where CalendarID = @calendarId
		and DayIndex >= 0
		and "Date" < (select min("Date") from BusinessDays where CalendarID = @calendarId and DayIndex < 0)
	-- If no date is present which is already set, start with the first date
	if @date is NULL
	begin
		select @date = min("Date") from BusinessDays where CalendarID = @calendarId
		select @dayIndex = 0
	end
	-- Increment the date until we reach the last date in the calendar
	while exists (select 1 from BusinessDays where CalendarID = @calendarId and "Date" = @date)
	begin
		-- Set the day index for the current date
		update BusinessDays set DayIndex = @dayIndex where CalendarID = @calendarId and "Date" = @date
		-- Move to the next date
		select @date = DateAdd(d, 1, @date)
		declare @dayType int
		select @dayType = DayType from BusinessDays where CalendarID = @calendarId and "Date" = @date
		if @dayType = 1
			select @dayIndex = @dayIndex + 1
	end
end

GO
