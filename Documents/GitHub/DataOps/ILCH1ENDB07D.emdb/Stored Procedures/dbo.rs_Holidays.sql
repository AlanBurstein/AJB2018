SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure  [dbo].[rs_Holidays] 
	 @StartDate date,
	 @EndDate date
	as 
select distinct
	DATE as Holidaydate,
	description,
	HolidayType
	 
from emdbuser.LegalHolidays
 
where HolidayType = 2 and date between @StartDate and @EndDate

GO
