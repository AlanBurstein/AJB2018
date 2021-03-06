SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[yearsApart](@startDate DATETIME, @endDate DATETIME) 
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
SELECT years = 
  CASE WHEN SIGN(DATEDIFF(dd,@startDate,@endDate)) > -1
       THEN DATEDIFF(month,@startDate,@endDate) -
         CASE WHEN DATEPART(day,@startDate) > DATEPART(day,@endDate) THEN 1 ELSE 0 END
  END / 12;
GO
