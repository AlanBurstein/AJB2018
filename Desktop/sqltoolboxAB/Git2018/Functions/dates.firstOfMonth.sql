SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dates].[firstOfMonth] (@date datetime, @months smallint)
/*****************************************************************************************
[Purpose]:
 Accepts an input date (@date) firstOfMonth will return the beginning of the month in 
 datetime format. When @months is zero the function returns the beginning of the month, 
 when @months is a positive integer greater than zero it returns the beginning of the 
 month that many months ahead, when it's a negative value it returns the beginning of 
 the month that many months ago. 

[Author]:
 Alan Burstein

[Compatibility]:
 SQL Server 2005+, Azure SQL Database

[Syntax]:
--===== Autonomous use
 SELECT f.monthStart
 FROM   dates.firstOfMonth(@date, @months) AS f;

--===== Use against a table
 SELECT      st.someDateCol, f.monthStart
 FROM        SomeTable st
 CROSS APPLY dates.firstOfMonth(st.someDateCol, 5) AS f;

[Parameters]:
 @date   = datetime; Input date to evaluate. 
 @months = smallint; Number of months ahead (when positive) or months back (when negative)

[Returns]:
 Inline Table Valued Function returns:
   monthStart = datetime; the return value in the form of YYYY-MM-DD 00:00:00.000

[Dependencies]:
 N/A

[Developer Notes]:
 1. The idea for this function came from Lynn Pettis on SQLServerCentral.com. See:
    http://www.sqlservercentral.com/blogs/lynnpettis/2009/03/25/some-common-date-routines/

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
 
 3. When @date or @months is NULL the function will return a NULL value

 4. On SQL instances earlier than Version 2012, where eoMonth is not available, this 
    function can easily be used to retrieve the end of month by simply grabbing the
    next month and subtracting one day using: DATEADD(dd, -1, f.monthStart). Note that the
    the following two queries will return the end of the current month:

		-- using dates.firstOfMonth >>
    SELECT DATEADD(dd, -1, f.monthStart) FROM dates.firstOfMonth(getdate(),  1) f;
		-- using eomonth in SQL 2012+
    SELECT eomonth(getdate(), 0)

 5. firstOfMonth is deterministic; for more about deterministic and nondeterministic 
    functions see https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:
--==== Basic use
  DECLARE @date datetime = getdate();

  SELECT f.monthStart FROM dates.firstOfMonth(@date,  0) AS f; -- first of this month
  SELECT f.monthStart FROM dates.firstOfMonth(@date,  1) AS f; -- first of next month
  SELECT f.monthStart FROM dates.firstOfMonth(@date, -1) AS f; -- first of last month

--==== against a table
  DECLARE @table TABLE (someDate date NULL);
  INSERT @table VALUES ('20180106'),(NULL),('20170511');
  
  SELECT      t.someDate, f.monthStart
  FROM        @table AS t
  CROSS APPLY dates.firstOfMonth(t.someDate, -10) AS f;

--==== Returns:
  someDate   monthStart
  ---------- -----------------------
  2018-01-06 2017-03-01 00:00:00.000
  NULL       NULL
  2017-05-11 2016-07-01 00:00:00.000

---------------------------------------------------------------------------------------
[Revision History]:
 Rev 00 - 20180614 - Initial Creation - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT monthStart = dateadd(mm,datediff(mm,0,@date)+@months,0);
GO
