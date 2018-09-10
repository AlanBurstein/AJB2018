SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dates].[countWorkDays] (@startDate DATETIME, @endDate DATETIME) 
/*****************************************************************************************
[Purpose]:
 Calculates the number of business days between two dates (Mon-Fri) and excluded weekends.
 dates.countWorkDays does not take holidays into considerations; for this you would need a 
 seperate "holiday table" to perform an antijoin against.

 The idea is based on the solution in this article:
   https://www.sqlservercentral.com/Forums/Topic153606.aspx?PageIndex=16

[Compatibility]:
 SQL Server 2005+

[Syntax]:
--===== Autonomous
 SELECT f.workDays
 FROM dates.countWorkDays(@startdate, @enddate) AS f;

--===== Against a table using APPLY
 SELECT t.col1, t.col2, f.workDays
 FROM dbo.someTable t
 CROSS APPLY dates.countWorkDays(t.col1, t.col2) AS f;

[Parameters]:
  @startDate = datetime; first date to compare
  @endDate   = datetime; date to compare @startDate to

[Returns]:
 Inline Table Valued Function returns:
 workDays = int; number of work days between @startdate and @enddate

[Developer Notes]:
 1. NULL when either input parameter is NULL, 

 2. This function is what is referred to as an "inline" scalar UDF." Technically it's an
    inline table valued function (iTVF) but performs the same task as a scalar valued user
    defined function (UDF); the difference is that it requires the APPLY table operator
    to accept column values as a parameter. For more about "inline" scalar UDFs see this
    article by SQL MVP Jeff Moden: http://www.sqlservercentral.com/articles/T-SQL/91724/
    and for more about how to use APPLY see the this article by SQL MVP Paul White:
    http://www.sqlservercentral.com/articles/APPLY/69953/.

    Note the above syntax example and usage examples below to better understand how to
    use the function. Although the function is slightly more complicated to use than a
    scalar UDF it will yield notably better performance for many reasons. For example,
    unlike a scalar UDFs or multi-line table valued functions, the inline scalar UDF does
    not restrict the query optimizer's ability generate a parallel query execution plan.

 3. dates.countWorkDays requires that @enddate be equal to or later than @startDate. Otherwise
    a NULL is returned.

 4. dates.countWorkDays is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:
 --===== 1. Basic Use
 SELECT f.workDays 
 FROM dates.countWorkDays('20180608', '20180611') AS f;

---------------------------------------------------------------------------------------
[Revision History]: 
 Rev 00 - 20180625 - Initial Creation - Alan Burstein
*****************************************************************************************/
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
