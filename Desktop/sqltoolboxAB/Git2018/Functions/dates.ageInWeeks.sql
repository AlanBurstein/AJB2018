SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dates].[ageInWeeks](@startDate DATETIME, @endDate DATETIME) 
/*****************************************************************************************
[Purpose]:
 Calculates the number of weeks between @startDate and @endDate. 

 This is something that cannot be done using DATEDIFF. Note how the following query 
 returns a "1". 

 SELECT DATEDIFF(MM,'Dec 30 2001', 'Jan 3 2002'); -- Returns 1

[Author]:
 Alan Burstein

[Compatibility]:
 SQL Server 2005+
 
[Syntax]:
--===== Autonomous
 SELECT f.weeks
 FROM dates.ageInWeeks(@startDate, @endDate) f;

--===== Against a table using APPLY
 SELECT t.*, f.weeks
 FROM dbo.someTable t
 FROM dates.ageInWeeks(t.col1, t.col2) f;

[Parameters]:
  @startDate = datetime; first date to compare
  @endDate   = datetime; date to compare @startDate to

[Returns]:
 Inline Table Valued Function returns:
 weeks = int; number of weeks between @startdate and @enddate

[Dependencies]:
 N/A

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

 3. ageInWeeks requires that @enddate be equal to or later than @startDate. Otherwise
    a NULL is returned.

 4. ageInWeeks is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:

--===== 1. Basic Use
  SELECT a.weeks 
  FROM dates.ageInWeeks('20120109', '20120113') AS a

--===== 2. Against a table
  DECLARE @sometable TABLE (date1 date, date2 date);
  BEGIN 
    INSERT @sometable 
    VALUES ('20111114','20111209'),('20190401','20190506'),('20091101','20091211');
  
    SELECT t.date1, t.date2, a.weeks 
    FROM @sometable t
    CROSS APPLY dates.ageInWeeks(t.date1, t.date2) AS a;
  END
---------------------------------------------------------------------------------------
[Revision History]:
 Rev 00 - 20180624 - Initial Creation - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
SELECT weeks =
  CASE WHEN SIGN(DATEDIFF(dd,@startDate,@endDate)) > -1
       THEN DATEDIFF(dd,@startDate,@endDate) -
         CASE WHEN DATEPART(dd,@startDate) > DATEPART(dd,@endDate) THEN 1 ELSE 0 END
  END / 7;
GO
