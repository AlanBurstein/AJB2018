SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[DateAddWeekDay]
(
 @workdays int,
 @date datetime
)
RETURNS datetime
AS
BEGIN
 DECLARE
 @sat int,
 @sun int,
 @weeks int,
 @remain_days smallint,
 @day_o_week smallint,
 @current_day smallint

 -- no change
 IF @workdays = 0
 RETURN @date

 -- number of whole weeks
 SET @weeks = @workdays / 5
 -- days of partial week
 SET @remain_days = @workdays % 5
 -- starting day of the week
 SET @current_day = datepart(WEEKDAY, @date)
 -- day of the week for date plus the partial days; this may go beyond the
 -- bounds of 1 and 7, which is desirable if it happens.
 SET @day_o_week = @current_day + @remain_days

 -- are days being added?
 IF @workdays > 0
 BEGIN
 -- value of Saturday
 SET @sat = 7 - @@DATEFIRST

 -- working with days after the current day. Make sure the value of
 -- Saturday reflects this, even if it goes beyond 7.
 IF @sat < @current_day
 SET @sat = @sat + 7

 -- set Sunday accordingly
 SET @sun = @sat + 1

 -- the calculation for weekends will be that one business day after
 -- Sunday is equal to Tuesday instead of Monday. Possibly add a
 -- parameter for the caller to make that decision.
 IF @current_day = @sun
 OR @current_day + 7 = @sun
 RETURN @date + @weeks * 7 + @remain_days + 1

 -- If starting on a Saturday or crossing the weekend boundary, subtract
 -- two more days.
 IF @day_o_week >= @sat
 OR @current_day = @sat
 RETURN @date + @weeks * 7 + @remain_days + 2

 -- neither started on a weekend, nor crossed the weekend.
 RETURN @date + @weeks * 7 + @remain_days
 END
 -- ELSE days are being subtracted

 -- working with days before the current day. Make sure the value of
 -- Sunday reflects this, even if it goes below 1...
 SET @sun = 1 - @@DATEFIRST

 -- ... but no so far below that it's more than 6 than the current day.
 IF @current_day > @sun + 6
 SET @sun = @sun + 6

 -- set Saturday accordingly
 SET @sat = @sun - 1

 -- the calculation for weekends will be that one business day before
 -- Saturday is equal to Thursday instead of Friday. Possibly add a
 -- parameter for the caller to make that decision.
 IF @current_day = @sat
 OR @current_day - 7 = @sat
 RETURN @date + @weeks * 7 + @remain_days - 1

 -- If starting on a Sunday or crossing the weekend boundary, subtract two
 -- more days.
 IF @day_o_week <= @sun
 OR @current_day = @sun
 RETURN @date + @weeks * 7 + @remain_days - 2

 -- neither started on a weekend, nor crossed the weekend.
 RETURN @date + @weeks * 7 + @remain_days
END

GO
