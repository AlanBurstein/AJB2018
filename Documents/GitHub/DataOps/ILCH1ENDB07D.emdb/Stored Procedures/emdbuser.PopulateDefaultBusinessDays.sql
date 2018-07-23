SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [emdbuser].[PopulateDefaultBusinessDays]
(
	@calendarId int,
	@startDate datetime,
	@endDate datetime,
	@holidayType int
)
as
begin
	declare @date datetime
	select @date = @startDate
	while DateDiff(d, @date, @endDate) >= 0
	begin
		-- Populate the missing days, marking every day as a work day
		if not exists (select * from BusinessDays where CalendarID = @calendarId and "Date" = @date)
		begin
			declare @dayType int
			select @dayType = 1
			if exists (select * from LegalHolidays where "Date" = @date and HolidayType = @holidayType)
				select @dayType = 3
			insert into BusinessDays (CalendarID, "Date", DayOfWeek, DayType, DayIndex) 
				values (@calendarId, @date, DatePart(dw, @date), @dayType, -1)
		end
		select @date = DateAdd(d, 1, @date)
	end
	-- Reindex the days
	exec ReindexBusinessDays @calendarId
end

GO
