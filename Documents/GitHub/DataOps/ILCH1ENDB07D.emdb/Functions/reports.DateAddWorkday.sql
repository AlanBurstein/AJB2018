SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Hawley
-- Create date: 2012-10-26
-- Description:	Add or subtract days from a datetime, skipping weekends
-- =============================================
CREATE FUNCTION [reports].[DateAddWorkday] 
(
	@number int,    -- Number of days to add, not including weekends
	@date datetime  -- Base date (datetime to be compatible with Encompass date fields)
)
RETURNS datetime
WITH RETURNS NULL ON NULL INPUT
/*
Explanation of expressions here:
- Work weeks translated to real weeks:  (@number / 5) * 7
- Remainder of days to add/subtract:    @number % 5
- Day of week, normalized:  (datepart(weekday,@date) + (@@datefirst % 7)) % 7
  Sun=1, Mon=2, Tue=3, Wed=4, Thu=5, Fri=6, Sat=0
*/
AS BEGIN
	-- Saturday and Sunday skip forwards to Monday before we add @number
	return case when @number > 0 then
		-- Add the 5-day weeks translated to 7-day weeks, and the remainder
		dateadd(day, ((@number / 5) * 7) + (@number % 5) + (
			-- Friday skips past the weekend; Saturday and Sunday count from the next Monday
			case (datepart(weekday,@date) + (@@datefirst % 7)) % 7 when 6 then 2 when 1 then 1 when 0 then 2 else 0 end
		), @date)
	when @number = 0 then
		-- Saturday and Sunday skip to the next Monday
		dateadd(day, case (datepart(weekday,@date) + (@@datefirst % 7)) % 7 when 1 then 1 when 0 then 2 else 0 end, @date)
	else
		-- Subtract the 5-day weeks translated to 7-day weeks, and the remainder
		dateadd(day, ((@number / 5) * 7) + (@number % 5) + (
			-- Monday skips back past the weekend; Saturday and Sunday count from the next Monday
			case (datepart(weekday,@date) + (@@datefirst % 7)) % 7 when 2 then -2 when 1 then -1 else 0 end
		), @date)
	end
END
GO
