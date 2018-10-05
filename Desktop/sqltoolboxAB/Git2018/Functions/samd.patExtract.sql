SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[patExtract]
(
  @string  VARCHAR(MAX),
  @pattern VARCHAR(50)
)
/****************************************************************************************
[Purpose]:
 This can be considered a varchar(max) T-SQL inline table valued function equivalent of 
 Microsoft's mdq.RegexExtract: https://goo.gl/HpAvKZ except:

 1. It includes each matching substring's position in the string
 
 2. It accepts varchar(max) instead of nvarchar(4000) for the input string, nvarchar(50)
    instead of nvarchar(4000) for the pattern
 
 3. The mask parameter is not required and therefore does not exist.

 4. You have specify what text we're searching for as an exclusion; e.g. for numeric 
    characters you should search for '[^0-9]' instead of '[0-9]'. 

 5. There is is no parameter for naming a "capture group". Using the variable below, both 
    the following queries will return the same result:

	 DECLARE @string VARCHAR(MAX) = N'123 Main Street';
	 
   SELECT item FROM samd.patExtract(@string, '[^0-9]');
   SELECT clr.RegexExtract(@string, N'(?<number>(\d+))(?<street>(.*))', N'number', 1);

[Author]: 
  Alan Burstein

[Compatibility]:
 SQL Server 2008+, Azure SQL Database

[Syntax]:
 --===== Autonomous
 SELECT pe.ItemNumber, pe.ItemIndex, pe.ItemLength, pe.Item
 FROM   samd.patExtract(@string,@pattern) AS pe;

 --===== Against a table using APPLY
 SELECT      t.someString, pe.ItemIndex, pe.ItemLength, pe.Item
 FROM        samd.SomeTable AS t
 CROSS APPLY samd.patExtract(t.someString, @pattern) AS pe;

[Parameters]:
 @string        = VARCHAR(MAX); the input string
 @searchString  = VARCHAR(50); pattern to search for

[Returns]:
 itemNumber = BIGINT; the instance or ordinal position of the matched substring
 itemIndex  = BIGINT; the location of the matched substring inside the input string
 itemLength = INT; the length of the matched substring
 item       = VARCHAR(MAX); the returned text

[Dependencies]:
 1. dbo.NGrams  (iTVF) >> https://goo.gl/cXF9Gi 
 2. dbo.rangeAB (iTVF, required for dbo.NGrams) 

[Developer Notes]:
 1. patExtract does not return any rows on NULL or empty strings. Consider using 
    OUTER APPLY or append the function with the code below to force the function to return 
    a row on emply or NULL inputs:

    UNION ALL SELECT 1, 0, NULL, @string WHERE nullif(@string,'') IS NULL;

 2. patExtract is not case sensitive; use a case sensitive collation for 
    case-sensitive comparisons

 3. patExtract is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

 4. patExtract performs substantially better with a parallel execution plan, often
    2-3 times faster. For queries that leverage patextract that are not getting a 
    parallel exeution plan you should consider performance testing using Traceflag 8649 
    in Development environments and Adam Machanic's make_parallel in production. 

[Examples]:
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
   CROSS APPLY samd.patExtract(t.txt, '[^0-9]') pe;
---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20180704 - Initial Development - Alan Burstein
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
 FROM dbo.NGrams(@string, 1) ng
 WHERE 
   PATINDEX(@pattern, ng.token) <  --<< this token does NOT match the pattern
   ABS(SIGN(ng.position-1)-1) +    --<< are you the first row?  OR
   PATINDEX(@pattern,SUBSTRING(@string,ng.position-1,1)) --<< always 0 for 1st row
) f(position, token)
CROSS APPLY (VALUES(ISNULL(NULLIF(PATINDEX('%'+@pattern+'%',f.token),0),
  DATALENGTH(@string)+2-f.position)-1)) itemLen(l);
GO
