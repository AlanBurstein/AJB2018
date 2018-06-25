SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Calculate Working Days: https://www.sqlservercentral.com/Forums/Topic153606.aspx?PageIndex=16
CREATE FUNCTION [dbo].[countWorkDays] (@startDate DATETIME, @endDate DATETIME) 
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT workDays =
    -- If @startDate or @endDate are NULL then rerturn a NULL
  CASE WHEN SIGN(DATEDIFF(dd, @startDate, @endDate)) > -1 THEN
     (DATEDIFF(dd, @startDate, @endDate) + 1) --Start with total days including weekends
    -(DATEDIFF(wk, @startDate, @endDate) * 2) --Subtact 2 days for each full weekend

    -- Subtract 1 when startDate is Sunday and Substract 1 when endDate is Sunday: 
    -(CASE WHEN DATENAME(dw, @startDate) = 'Sunday'   THEN 1 ELSE 0 END)
    -(CASE WHEN DATENAME(dw, @endDate)   = 'Saturday' THEN 1 ELSE 0 END)
  END
GO
