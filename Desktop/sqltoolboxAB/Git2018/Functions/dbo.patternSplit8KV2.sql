SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[patternSplit8KV2] (@string varchar(8000), @pattern varchar(50))
/****************************************************************************************
Description:
 Accepts an input string (@string) and pattern (@pattern) then splits a string returning 
 tokens aliased as "item" that match and don't match the input pattern. There is a column 
 called "isMatch" used to determine if the token matches the pattern. For matching items 
 a 1 is returned, for items that do not match a 0 is returned. Note this example: 

	SELECT ps.* FROM dbo.patternSplit8K('abc12345xyz', '[0-9]') ps;

	Results:

   itemNumber  itemIndex  itemLength  item    isMatch
   ----------- ---------- ----------- ------- ---------
   1           1          3           abc     0
   2           4          5           12345   1
   3           7          3           xyz     0
	 
  The functionality is identical to patternSplitCM found here: https://goo.gl/PxLdsk
	except that it also returns each matched and unmatched item's position within the input
  string, and each item's length.
 
Compatibility:
 SQL Server 2008+

Parameters:
 @string        = varchar(8000); the input string
 @searchString  = varchar(50);   pattern to search for

Returns:
 itemNumber = bigint; the instance or ordinal position of the matched substring
 itemIndex  = bigint; the location of the matched substring inside the input string
 itemLength = bigint; the length of the matched substring
 item       = varchar(8000); the returned text
 isMatch    = boolean true/false value indicating is the item matches @pattern

Syntax:
 --===== Autonomous
  SELECT ps.itemNumber,
         ps.itemIndex,
         ps.itemLength,
         ps.item,
         ps.isMatch 
  FROM dbo.patternSplit8K(<@string, varchar(8000),>,'<@string, varchar(50),>') ps;

 --===== Against a table using APPLY
  SELECT st.someColumn,
         ps.itemNumber,
         ps.itemIndex,
         ps.itemLength,
         ps.item,
         ps.isMatch 
  FROM dbo.sometable st
  CROSS APPLY dbo.patternSplit8K(<@string, varchar(8000),>,'<@pattern, varchar(50),>') ps;

Programmer Notes:
 1. Requires rangeAB which can be found here: https://goo.gl/Cb3S3y

 2. patternSplit8K does not return any rows on NULL or empty strings. Consider using 
    OUTER APPLY or append the function with the code below to force the function to return 
    a row on emply or NULL inputs:

    UNION ALL SELECT 1, 0, NULL, @string WHERE nullif(@string,'') IS NULL;

 3. patternSplit8K is not case sensitive; use a case sensitive collation for 
    case-sensitive comparisons

 4. patternSplit8K is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

 5. patternSplit8K performs substantially better with a parallel execution plan, often
    2-3 times faster. For queries that leverage patextract8K that are not getting a 
    parallel exeution plan you should consider performance testing using Traceflag 8649 
    in Development environments and Adam Machanic's make_parallel in production. 

Example:
 --===== (1) Replace phone numbers with the text, "<removed>":
   WITH temp(id, txt) as
   (
     SELECT * FROM (values
     (1, 'hello my phone number is 555-888-9999.'),
     (2, 'I can be reached at (312) 224-9900'),
     (3, 'My old cell # is 555-6677, my new one is 888-999-7777.'))t(x,xx)
   )
   SELECT
     t1.id, oldText = t1.txt, newText = 
     (
       SELECT 
         CASE WHEN pe.isMatch=1 AND 
               (   pe.item LIKE '%([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]%'
                OR pe.item LIKE '%[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]%'
                OR pe.item LIKE '%[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]%') THEN ' <removed>'
         ELSE pe.item END+''
       FROM temp t2
       CROSS APPLY dbo.patternSplit8K(t1.txt, '[() 0-9-]') pe
       WHERE t1.id = t2.id
       ORDER BY pe.itemNumber
       FOR XML PATH(''), TYPE).value('text()[1]', 'varchar(8000)')
   FROM temp t1;
;
---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20170801 - Initial Development - Alan Burstein
 Rev 01 - 20180619 - Complete re-write   - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  itemNumber = ROW_NUMBER() OVER (ORDER BY patSplit.itemIndex), 
  patSplit.itemIndex,
  patSplit.itemLength,
  patSplit.item,
  patsplit.isMatch
FROM
(
  SELECT 
    itemIndex  = r.rn,
    itemLength = LEAD(r.rn,1,DATALENGTH(@string)+1) OVER (ORDER BY r.rn)-r.rn,
    item = 
      SUBSTRING(@string,r.rn,LEAD(r.rn,1,DATALENGTH(@string)+1) OVER (ORDER BY r.rn)-r.rn),
    isMatch   = ABS(t.p-2+1)
  FROM dbo.rangeAB(1,DATALENGTH(@string),1,1) r
  CROSS APPLY (VALUES (
    CAST(PATINDEX(@pattern,SUBSTRING(@string,r.rn,1))   AS BIT),
    CAST(PATINDEX(@pattern,SUBSTRING(@string,r.rn-1,1)) AS BIT),
    SUBSTRING(@string,r.rn,r.op+1))
  ) t(c,p,s)
  WHERE t.c^t.p|ABS(SIGN(r.rn-1)-1) = 1
) patSplit;
-- PREVIOUS VERSION (TEST A LITTLE MORE)
;
--SELECT
--  itemNumber = ROW_NUMBER() OVER (ORDER BY split.position),
--  itemIndex  = split.position,
--  itemLength = split.itemLen,
--  item       = SUBSTRING(@string, split.position, split.itemLen),
--  isMatch    = CAST(ISNULL(NULLIF(ABS(ab-2),2),0) AS BIT)
--FROM
--(
--  SELECT f.p, LEAD(f.p,1,DATALENGTH(@string)+1) OVER (ORDER BY f.p)-f.p, f.a&f.b
--  FROM dbo.NGrams8K(@string, 1) ng
--  CROSS APPLY (VALUES(
--    PATINDEX(@pattern, SUBSTRING(@string, ng.position-1, 1))+1,
--    ABS(PATINDEX(@pattern, ng.token)-2),  
--    ng.position)) f(a,b,p)
--  WHERE (f.a&f.b > 0 OR ng.position = 1)
--) split(position, itemLen, ab);
GO
