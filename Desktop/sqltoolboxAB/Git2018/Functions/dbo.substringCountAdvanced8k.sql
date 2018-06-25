SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[substringCountAdvanced8k]
(
  @string       varchar(8000),
  @searchString varchar(1000)
)
/****************************************************************************************
Purpose:
 Given an input string (@string) and substring to search for (@searchString) 
 stringCountAdvanced8K returns the number of times the the search string appears.

Compatibility: 
 SQL Server 2008+ and Azure SQL Database

Parameters:
 @string       = varchar(8000); input string to analyze 
 @searchString = varchar(1000); substring to count inside of the input string (@string)

Returns:
 matches = smallint; the number of times @searchString is found inside of @string

Developer Notes: 
 1. A more efficient way to count individual characters would be to use this formula:
    len(@string) - len(replace(@string, @searchString,''))

    For substrings with one or more characters you could use
    select (len(@string) - len(replace(@string, @searchString,''))) / len(@searchString)

    The problem with this approach is that it fails when overlapping values exist    
    The benefit of dbo.stringCountAdvanced8K is that it takes overlapping values into
    consideration. Note both queries below: the first query returns the correct answer 
    while second query does get's it wrong while dbo.stringCountAdvanced8K get's it right:

    declare @string varchar(20) = 'abc-abc-abc', @searchString varchar(5) = 'ab';
    select (len(@string) - len(replace(@string, @searchString,''))) / len(@searchString);
    -- returns 3, correct.    
    go

    declare @string varchar(20) = 'xxx', @searchString varchar(5) = 'xx';
    select (len(@string) - len(replace(@string, @searchString,''))) / len(@searchString);
    -- returns 1. Wrong. There are two instances of "xx".    

    select * from dbo.stringCountdvanced8K(@string, @searchString)
    -- returns 2. This is correct.   

 2. stringCountAdvanced8K is what is referred to as an "inline" scalar UDF" (iSF.) 
    Technically it's an inline table valued function (iTVF) but performs the same task as 
    a scalar valued user defined function (UDF). The difference is that it requires the 
    APPLY table operator to accept column values as a parameter.
		
		For more about "inline" scalar UDFs see this article by SQL MVP Jeff Moden: 
    https://goo.gl/1834wa. For more about how to use APPLY see the this article by SQL MVP 
    Paul White:http://www.sqlservercentral.com/articles/APPLY/69953/.
    
    Note the above syntax example and usage examples below to better understand how to
    use the function. Although the function is slightly more complicated to use than a
    scalar UDF it will yeild notably better performance for many reasons. For example, 
    unlike a scalar UDFs or multi-line table valued functions, the inline scalar UDF does
    not restrict the query optimizer's ability generate a parallel query execution plan.

 3. Requires NGrams8k which is available here: https://goo.gl/T3DDiY

 4. StringCount8K is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

Usage Examples:
--===== Sample string variable for both examples
 DECLARE @string varchar(8000) = 'xy123xy123xyxyxyz';

 --===== 1. How many times does the substring "xy" appear?
 SELECT * FROM dbo.StringCountAdvanced8K(@string,'xy');

 --===== 2. Return records from a table where the substring "ab" appears more than once
 DECLARE @table TABLE (string varchar(8000));
 DECLARE @searchString varchar(1000) = 'ab';
 INSERT @table VALUES ('abcabc'),('abcd'),('bababab'),('baba'),(NULL);

 SELECT searchString = @searchString, string, matches 
 FROM @table
 CROSS APPLY dbo.StringCountAdvanced8K(string,'ab')
 WHERE matches > 1;

---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20150600 - Initial Development - Alan Burstein
 Rev 01 - 20170929 - renamed to substringCountAdvanced8k - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT matches = CAST(COUNT(token) AS SMALLINT)
FROM dbo.NGrams8k(@string, DATALENGTH(@searchString))
WHERE token = @searchString;
GO
