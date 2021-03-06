SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[patExtractN4K]
(
  @string  NVARCHAR(4000),
  @pattern NVARCHAR(50)
)
/****************************************************************************************
Description:
 This can be considered a NVARCHAR(4000) T-SQL inline table valued function (iTVF) 
 equivalent of Microsoft's mdq.RegexExtract: https://goo.gl/HpAvKZ except:

 1. It includes each matching substring's position in the string
  
 2. The mask parameter is not required and therefore does not exist.

 3. You have specify what text we're searching for as an exclusion; e.g. for numeric 
    characters you should search for '[^0-9]' instead of '[0-9]'. 

 4. There is is no parameter for naming a "capture group". Using the variable below, both 
    the following queries will return the same result:

	 DECLARE @string nvarchar(4000) = N'123 Main Street';
	 
   SELECT item FROM samd.patExtractN4K(@string, '[^0-9]');
   SELECT clr.RegexExtract(@string, N'(?<number>(\d+))(?<street>(.*))', N'number', 1);

 Alternatively, you can think of patExtractN4K as Chris Morris' PatternSplitCM (found here:
 http://www.sqlservercentral.com/articles/String+Manipulation/94365/) but only returns the
 rows where [matched]=0. The key benefit of is that it performs substantially better 
 because you are only returning the number of rows required instead of returning twice as
 many rows then filtering out half of them.  Furthermore, because we're 

 The following two sets of queries return the same result:

 DECLARE @string varchar(100) = 'xx123xx555xx999';
 BEGIN
 -- QUERY #1
   -- patExtractN4K
   SELECT ps.itemNumber, ps.item 
   FROM samd.patExtractN4K(@string, '[^0-9]') ps;

   -- patternSplitCM   
   SELECT itemNumber = row_number() over (order by ps.itemNumber), ps.item 
   FROM dbo.patternSplitCM(@string, '[^0-9]') ps
   WHERE [matched] = 0;

 -- QUERY #2
   SELECT ps.itemNumber, ps.item 
   FROM samd.patExtractN4K(@string, '[0-9]') ps;
   
   SELECT itemNumber = row_number() over (order by itemNumber), item 
   FROM dbo.patternSplitCM(@string, '[0-9]')
   WHERE [matched] = 0;
 END;

Compatibility:
 SQL Server 2008+

Syntax:
 --===== Autonomous
 SELECT pe.ItemNumber, pe.ItemIndex, pe.ItemLength, pe.Item
 FROM samd.patExtractN4K(@string,@pattern) pe;

 --===== Against a table using APPLY
 SELECT t.someString, pe.ItemIndex, pe.ItemLength, pe.Item
 FROM dbo.SomeTable t
 CROSS APPLY samd.patExtractN4K(t.someString, @pattern) pe;

Parameters:
 @string        = NVARCHAR(4000); the input string
 @searchString  = NVARCHAR(50); pattern to search for

Inline table valued function returns:
 itemNumber = bigint; the instance or ordinal position of the matched substring
 itemIndex  = bigint; the location of the matched substring inside the input string
 itemLength = int; the length of the matched substring
 item       = NVARCHAR(4000); the returned text

Developer Notes:
 1. Requires NGrams8k which can be found here: https://goo.gl/cXF9Gi

 2. patExtractN4K does not return any rows on NULL or empty strings. Consider using 
    OUTER APPLY or append the function with the code below to force the function to return 
    a row on emply or NULL inputs:

    UNION ALL SELECT 1, 0, NULL, @string WHERE nullif(@string,'') IS NULL;

 3. patExtractN4K is not case sensitive; use a case sensitive collation for 
    case-sensitive comparisons

 4. patExtractN4K is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

 5. samd.patExtractN4K performs substantially better with a parallel execution plan, often
    2-3 times faster. For queries that leverage patExtractN4K that are not getting a 
    parallel exeution plan you should consider performance testing using Traceflag 8649 
    in Development environments and Adam Machanic's make_parallel in production. 

Examples:
 --===== (1) Basic extact all groups of numbers:
    with temp(id, txt) as
   (
     SELECT * FROM (values
     (1, 'hello 123 fff 1234567 and today;""o999999999 tester 44444444444444 done'),
     (2, 'syat 123 ff tyui( 1234567 and today 999999999 tester 777777 done'),
     (3, '&**OOOOO=+ + + // ==?76543// and today !!222222\\\tester{}))22222444 done'))t(x,xx)
   )
   SELECT
     [temp.id] = t.id,
     pe.itemNumber,
     pe.itemIndex,
     pe.itemLength,
     pe.item
   FROM temp t
   CROSS APPLY samd.patExtractN4K(t.txt, '[^0-9]') pe;
---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20170801 - Initial Development - Alan Burstein
 Rev 01 - 20180619 - Complete re-write   - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
 itemNumber = ROW_NUMBER() OVER (ORDER BY f.position),
 itemIndex  = f.position,
 itemLength = itemLen.l,
 item       = SUBSTRING(f.token, 1, itemLen.l)
FROM
(
 SELECT ng.position, SUBSTRING(@string, ng.position, DATALENGTH(@string))
 FROM dbo.NGramsN4k(@string, 1) ng
 WHERE
   PATINDEX(@pattern, ng.token) <  --<< this token does NOT match the pattern
   ABS(SIGN(ng.position-1)-1) +    --<< are you the first row?  OR
   PATINDEX(@pattern,SUBSTRING(@string,ng.position-1,1)) --<< always 0 for 1st row
) f(position, token)
CROSS APPLY (VALUES(ISNULL(NULLIF(PATINDEX('%'+@pattern+'%',f.token),0),
  DATALENGTH(@string)/2+2-f.position)-1)) itemLen(l);
GO
