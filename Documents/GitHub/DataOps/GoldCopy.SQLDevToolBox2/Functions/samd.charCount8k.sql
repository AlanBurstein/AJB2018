SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[charCount8k]
(
    @string     VARCHAR(8000),
    @searchChar CHAR(1)
)
/****************************************************************************************
[Purpose]:
 Scans the input string (@string) and counts how many times the search character
 (@searchChar) appears. This function is Based on Itzik Ben-Gans logic found here: 
 https://goo.gl/EPRarB

[Author]:
  Alan Burstein

[Compatibility]:
 SQL Server 2005+

[Syntax]:
--===== Autonomous
 SELECT f.charCount
 FROM   samd.charCount8k(@string,@searchChar) AS f;

--===== Against a table using APPLY
 SELECT      f.charCount
 FROM        dbo.someTable                       AS t
 CROSS APPLY samd.charCount8k(t.col, @seachChar) AS f;

[Parameters]:
  @string     = varchar(8000); input string to analyze
  @searchChar = char(1); character to search for

[Returns]:
 inline table valued function returns -
 charCount = int; Number of times that @searchChar appears in @string

[Dependencies]:
 N/A

[Developer Notes]:
 1. A computed column will outperform this function and can be indexed. For cases 
    where this operation needs to be performed regularly consider a persisted computed 
    column with a covering index or an indexed view. The logic is simple:

    LEN(<input string>) - LEN(REPLACE(<input string>, <search character>, ''))

 2. charCount8k is what is referred to as an "inline" scalar UDF." Technically it's an
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

 3. charCount8k returns NULL when either input parameter is NULL and returns 0 when either 
    input parameter is blank.

 4. charCount8k does not treat parameters as case senstitive

 5. charCount8k is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:
--==== 1. Basic use
  SELECT  f.charCount 
  FROM    samd.charCount8k('abc123aaa', 'a') AS f; -- count the number of a's

--==== 2. against a table
  DECLARE @table TABLE (txt varchar(8));
  INSERT  @table SELECT TOP (10) LEFT(newid(),8) FROM sys.all_columns;

  SELECT      t.txt, f.charCount
  FROM        @table                       AS t
  CROSS APPLY samd.charCount8k(t.txt, 'A') AS f;
  GO

--==== 3. against a table searching for multiple characters (A-F for this example):
  DECLARE @table TABLE (txt varchar(8) UNIQUE);
  INSERT  @table 
  SELECT TOP (10) LEFT(newid(),8) 
	FROM    sys.all_columns UNION ALL SELECT '0000000';

  SELECT       t.txt, totalChars = SUM(f.charCount)
  FROM         @table                                      AS t
  CROSS JOIN  (VALUES ('A'),('B'),('C'),('D'),('E'),('F')) AS x(l)
  CROSS APPLY  samd.charCount8k(t.txt, x.l) f
  GROUP BY     t.txt;
----------------------------------------------------------------------------------------
[Revision History]:
 Rev 00 - 20180625 - Initial Creation - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
SELECT charCount = LEN(@string) - LEN(REPLACE(@string, @searchChar, ''));
GO
