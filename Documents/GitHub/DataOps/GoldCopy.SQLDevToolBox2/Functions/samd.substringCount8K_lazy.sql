SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[substringCount8K_lazy]
(
  @string       varchar(8000),
  @searchstring varchar(1000)
)
/*****************************************************************************************
Purpose:
 Scans the input string (@string) and counts how many times the search character
 (@searchChar) appears. This function is Based on Itzik Ben-Gans logic found here: 
 https://goo.gl/EPRarB

Compatibility: 
 SQL Server 2008+
 Uses TABLE VALUES constructor (not available pre-2008)

Syntax:
--===== Autonomous
 SELECT f.substringCount
 FROM samd.substringCount8K_lazy(@string,@searchString) f;

--===== Against a table using APPLY
 SELECT f.substringCount
 FROM dbo.someTable t
 CROSS APPLY samd.substringCount8K_lazy(t.col, @searchString) f;

Parameters:
  @string       = varchar(8000); input string to analyze
  @searchString = varchar(1000); substring to search for

Returns:
 inline table valued function returns -
 substringCount = int; Number of times that @searchChar appears in @string

Developer Notes:
 1. substringCount8K_lazy does NOT take overlapping values into consideration. For 
    example, this query will return a 1 but the correct result is 2:

      SELECT substringCount FROM samd.substringCount8K_lazy('xxx','xx')

    When overlapping values are a possibility or concern then use substringCountAdvanced8k

 2. substringCount8K_lazy is what is referred to as an "inline" scalar UDF." Technically 
    it's aninline table valued function (iTVF) but performs the same task as a scalar 
    valued user defined function (UDF); the difference is that it requires the APPLY table 
    operator to accept column values as a parameter. For more about "inline" scalar UDFs 
    see thisarticle by SQL MVP Jeff Moden: 
      http://www.sqlservercentral.com/articles/T-SQL/91724/
    and for more about how to use APPLY see the this article by SQL MVP Paul White:
      http://www.sqlservercentral.com/articles/APPLY/69953/.
 
    Note the above syntax example and usage examples below to better understand how to
    use the function. Although the function is slightly more complicated to use than a
    scalar UDF it will yield notably better performance for many reasons. For example,
    unlike a scalar UDFs or multi-line table valued functions, the inline scalar UDF does
    not restrict the query optimizer's ability generate a parallel query execution plan.

 3. substringCount8K_lazy returns NULL when either input parameter is NULL and returns 0 
    when either input parameter is blank.

 4. substringCount8K_lazy does not treat parameters as cases senstitive

 5. substringCount8K_lazy is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

Usage Examples:
--===== 1. How many times does the substring "abc" appear?
 DECLARE @string varchar(8000) = 'abc123xxxabc';

 SELECT f.* FROM samd.substringCount8k_lazy(@string,'abc') f;

--===== 2. Return records from a table where the substring "ab" appears more than once
 DECLARE @table TABLE (string varchar(8000));
 DECLARE @searchString varchar(1000) = 'ab';
 INSERT @table VALUES ('abcabc'),('abcd'),('bababab'),('baba'),(NULL);

 SELECT searchString = @searchString, t.string, f.substringCount
 FROM @table t
 CROSS APPLY samd.substringCount8k_lazy(string,'ab') f
 WHERE f.substringCount > 1;

---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20180625 - Initial Development - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
SELECT substringCount = (LEN(v.s) - LEN(REPLACE(v.s, v.st, ''))) / LEN(v.st)
FROM (VALUES (@string, NULLIF(@searchstring, ''))) v (s, st);
GO
