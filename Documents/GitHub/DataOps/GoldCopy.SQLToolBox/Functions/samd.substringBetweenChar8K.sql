SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[substringBetweenChar8K]
(
  @string    varchar(8000),
  @first     int,
  @last      int,
  @delimiter varchar(100)
)
/*****************************************************************************************
Purpose:
 Takes in input string (@string) and returns the text between two instances of a delimiter
 (@delimiter); the location of the delimiters is defined by @first and @last.
 For example: if @string = 'xx.yy.zz.abc', @first=1, @last=3, and @delimiter = '.' the
 function will return the text: yy.zz; this is the text between the first and third
 instance of "." in the string "xx.yy.zz.abc".

Compatibility:
 SQL Server 2008+

Syntax:
--===== Autonomous use
 SELECT sb.item, sb.itemIndex, sb.itemLength
 FROM samd.substringBetweenChar8K(@string, @first, @last, @delimiter); sb;

--===== Use against a table
 SELECT sb.item, sb.itemIndex, sb.itemLength
 FROM SomeTable st
 CROSS APPLY samd.substringBetweenChar8K(st.SomeColumn1, 1, 2, '.') sb;

Parameters:
 @string    = varchar(8000); Input string to parse
 @first     = int; the instance of @delimiter to search for; this is where the output 
              should start. When @first is 0 then the function will return everything from
              the beginning of @string until @end.
 @last      = int; the last instance of @delimiter to search for; this is where the output 
              should end. When @end is 0 then the function will return everything from 
              @first until the end of the string.
 @delimiter = varchar(100); The delimiter use to determine where the output starts/ends

Return Types:
 Inline Table Valued Function returns:
   item     = varchar(8000); the substring between the two instances of @delimiter 
              defined by @first and @last
 itemIndex  = smallint; the location of where the substring begins
 itemLength = int; size of the returned substring

------------------------------------------------------------------------------------------
Developer Notes:
 1. Requires NGrams8K. The code for NGrams8K can be found here:
    http://www.sqlservercentral.com/articles/Tally+Table/142316/

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

 3. samd.substringBetweenChar8K generally performs better with a parallel execution plan 
    but the optimizer is sometimes stingy about assigning one. Consider performance 
    testing using Traceflag 8649 in Development environments and Adam Machanic's 
    make_parallel in production environments. 

 4. samd.substringBetweenChar8K returns NULL when supplied with a NULL input strings and/or
    NULL pattern;

 5. samd.substringBetweenChar8K is deterministic; for more about deterministic and
    nondeterministic functions see https://msdn.microsoft.com/en-us/library/ms178091.aspx

Examples:
--====== 1. Basic Examples
 DECLARE @string varchar(100) = 'abc.defg.hi.jk.lmnop.qrs.tuv';
 BEGIN
  -- beginning of string to 2nd delimiter, 2nd delimiter to end of the string
    SELECT string=@string, sb.item, sb.itemIndex, sb.itemLength 
    FROM samd.substringBetweenChar8K(@string,0,2, '.') sb;
  
    SELECT string=@string, sb.item, sb.itemIndex, sb.itemLength 
    FROM samd.substringBetweenChar8K(@string,2,0, '.') sb;
  
  -- Between the 1st & 2nd, then 2nd & 5th delimiters
    SELECT string=@string, sb.item, sb.itemIndex, sb.itemLength 
    FROM samd.substringBetweenChar8K(@string,1,2, '.') sb;

    SELECT string=@string, sb.item, sb.itemIndex, sb.itemLength 
    FROM samd.substringBetweenChar8K(@string,2,5, '.') sb;
  
  -- dealing with NULLS, delimiters that don't exist and when @first = @last
    SELECT string=@string, sb.item, sb.itemIndex, sb.itemLength 
    FROM samd.substringBetweenChar8K(@string,2,10,'.') sb;
       
    SELECT string=@string, sb.item, sb.itemIndex, sb.itemLength 
    FROM samd.substringBetweenChar8K(@string,1,NULL,'.') sb;
       
    SELECT string=@string, sb.item, sb.itemIndex, sb.itemLength 
    FROM samd.substringBetweenChar8K(@string,NULL,1,'.') sb;
 END

--====== 2. Every iteration (requires rangeAB)
  DECLARE @string varchar(8000) = 'https://www.xyz.com/folder1/sub1';
  
  WITH base AS 
  ( SELECT r.rn
    FROM dbo.rangeAB(0,LEN(@string)-LEN(REPLACE(@string,'/','')),1,0) r)
  SELECT [@first] = a.rn, [@last] = b.rn, sb.item, sb.itemIndex, sb.itemLength
  FROM base a
  CROSS JOIN base b
  CROSS APPLY samd.substringBetweenChar8K(@string,a.rn,b.rn,'/') sb
  WHERE b.rn=0 OR a.rn<b.rn;

---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20160720 - Initial Creation - Alan Burstein
 Rev 01 - 20180613 - Complete re-design, includeing multi-char delimiters
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  item = 
    CASE WHEN @first >= 0 AND @last >=0 THEN
     CASE WHEN @first+@last=0 THEN @string
          WHEN @last=0        THEN SUBSTRING(@string, p.mn+LEN(@delimiter), 8000)
          WHEN @first<@last   THEN SUBSTRING(@string, p.mn+LEN(@delimiter), 
                                     NULLIF(p.mx,p.mn)-p.mn-LEN(@delimiter)) END END,
  itemIndex = 
    CASE WHEN @first >= 0 AND @last >=0 THEN
     CASE WHEN @first+@last=0 THEN 1
          WHEN @last=0        THEN (p.mn+LEN(@delimiter))
          WHEN @first<@last   THEN (p.mn+LEN(@delimiter))*SIGN(NULLIF(p.mx,p.mn)) END END,
  itemLength = 
    CASE WHEN @first >= 0 AND @last >=0 THEN
     CASE WHEN @first+@last=0 THEN LEN(@string)
          WHEN @last=0        THEN LEN(@string)-p.mn+LEN(@delimiter)
          WHEN @first<@last   THEN NULLIF(p.mx,p.mn)-p.mn-LEN(@delimiter) END END
FROM
(
  SELECT MIN(d.de), MAX(d.de)
  FROM
  (
    SELECT CHECKSUM(0),0 WHERE @first = 0 UNION ALL
    SELECT CHECKSUM(ROW_NUMBER() OVER (ORDER BY ng.position)), ng.position
    FROM dbo.NGrams8k(@string, LEN(@delimiter)) ng
    WHERE ng.token = @delimiter
  ) d(ds,de)
  WHERE ds IN (@first,@last)
) p(mn,mx);
GO
