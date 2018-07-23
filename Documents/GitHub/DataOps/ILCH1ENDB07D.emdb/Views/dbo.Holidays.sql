SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view  [dbo].[Holidays] 
	
	as 
select distinct
	DATE as Holidaydate,
	description,
	HolidayType
	 
from emdbuser.LegalHolidays
 
where HolidayType = 2

GO
