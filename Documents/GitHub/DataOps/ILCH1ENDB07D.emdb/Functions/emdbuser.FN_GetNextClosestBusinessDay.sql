SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [emdbuser].[FN_GetNextClosestBusinessDay]
(
	@calendarId int,
	@date datetime
)
RETURNS TABLE
AS
RETURN
(
	select top 1 [Date], DayIndex
	from BusinessDays
	where CalendarID = @calendarId 
		and [Date] >= convert(datetime, floor(convert(float, @date)))
		and DayType = 1
	order by Date
)

GO
