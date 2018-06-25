SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[weeksApart] (@startDate DATETIME, @endDate DATETIME) 
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT weeks =
  CASE WHEN SIGN(DATEDIFF(dd,@startDate,@endDate)) > -1
       THEN DATEDIFF(dd,@startDate,@endDate) -
         CASE WHEN DATEPART(dd,@startDate) > DATEPART(dd,@endDate) THEN 1 ELSE 0 END
  END / 7;
GO
