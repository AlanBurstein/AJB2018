SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [emdbuser].[FN_GetBusinessDay]
(
	@calendarId int,
	@date datetime
)
RETURNS TABLE
AS
RETURN
(
	select *
	from BusinessDays
	where CalendarID = @calendarId 
		and [Date] = convert(datetime, floor(convert(float, @date)))
)

GO
