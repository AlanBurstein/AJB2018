SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create FUNCTION [dbo].[DateDiffWeekDay] (@start_date datetime, @end_date datetime)
  RETURNS INT
  AS
  BEGIN
      
      -- If the start date is a weekend, move it foward to the next weekday
      WHILE datepart(weekday, @start_date) in (1,7) -- Sunday, Saturday
      BEGIN
          SET @start_date = dateadd(d,1,@start_date)
      END
      
      -- If the end date is a weekend, move it back to the last weekday
      WHILE datepart(weekday, @end_date) in (1,7) -- Sunday, Saturday
      BEGIN
          SET @end_date = dateadd(d,-1,@end_date)
      END
      
      -- Weekdays are total days in perion minus weekends. (2 days per weekend)
      -- Extra weekend days were trimmed off the period above.
      -- I am adding an extra day to the total to make it inclusive. 
      --     i.e. 1/1/2008 to 1/1/2008 is one day because it includes the 1st
      RETURN (datediff(d,@start_date,@end_date) + 1) - (datediff(ww,@start_date,@end_date) * 2)
  
  END
  
  --test
  --select dbo.weekdays('2011-01-01','2011-01-30')
  --select DATEDIFF(day,'2011-01-01','2011-01-30')
GO
