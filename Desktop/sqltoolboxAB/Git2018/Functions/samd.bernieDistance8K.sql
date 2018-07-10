SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[bernieDistance8K](@string1 VARCHAR(8000), @string2 VARCHAR(8000))
/*****************************************************************************************
Purpose:
 Returns the "Bernie Distance" between two input strings (@string1 and @string2). The 
 Bernie Distance is the difference in length between two substrings when one is a 
 substring of the other. For example, the Bernie Distance between "ABCD" and "BC" is 2:
 "BC" is a 
 Can be used to speed up queries that leverage complex string leverage algorithms such as 
 the Levenshtein Distance, Damerau–Levenshtein Distance and Longest Common Subsequence.

 When the Bernie 

Compatibility: 
 <SQL Server Version,,SQL Server 2008+>
 <optional details about why it won't work with earlier versions,,>

Syntax:
--===== Autonomous
 SELECT f.returnValue
 FROM dbo.yourfunction(@parameters) f;

--===== Against a table using APPLY
 SELECT f.returnValue
 FROM dbo.someTable t
 CROSS APPLY dbo.yourfunction(t.col, @parameters) f;

Parameters:
  @string = <datatype,,>; <parameter details,,>

Returns:
 <function type,,inline table valued function> returns:
 <name> = <datatype> <description>

Developer Notes:
 1. Requires <required objects,,dbo.>
 2. Returns <return value on NULL input,,a single NULL>, 
    <return value on blank input,,No rows>. To return a single row containing a a NULL or 
    Blank row on NULL inputparameters conider using OUTER APPLY or append the function 
    with a UNION ALL "dummy row." Noe the following examples:

    <OUTER APPLY example,,>

    <UNION ALL example,,>
    <UNION ALL LOGIC,,UNION ALL SELECT NULL, WHERE NULLIF(@parameter,'') IS NULL;>
 3. Case sensitivity
 4. <function name,,dbo.> is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx
 5. <function name,,dbo.> performs <better,,substantially|marginally|notably> better with 
    a parallel execution plan, often 2-3 times faster. For queries that leverage 
    patextract8K that are not getting a parallel exeution plan you should consider 
    performance testing using Traceflag 8649 in Development environments and 
    Adam Machanic's make_parallel in Production. 


Usage Examples:

--===== 1. <tile 1.,,>
 -- (1.1) <subtitle 1.1,,>
 <example code,,s>;

 -- (1.2) <subtitle 1.2.,,>
 <example code 12..,,s>;

--===== 2. <tile 2.,,>
 -- (1.1) <subtitle,,>
 <example code,,s>;

---------------------------------------------------------------------------------------
Revision History: 
 Rev 00 - <YYYYMMDD> - <details> - <developer>
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT BD =
  CASE
    WHEN a.l1=a.l2 THEN SIGN(CHARINDEX(SUBSTRING(a.s1,0,a.l1),a.s2))|
                        SIGN(CHARINDEX(SUBSTRING(a.s1,2,a.l1),a.s2))
    ELSE 
      ABS(a.l1-a.l2) * -- the difference in the length of the two strings
       SIGN(NULLIF( -- if any of these 3 values are > 0 return 1, otherwise return a NULL
         CHARINDEX(a.s1,a.s2)|  -- is s1 a substring of s2?
         CHARINDEX(a.s2,a.s1)|  -- is s2 a substring of s1?
         ABS(SIGN(a.l1*a.l2)-1) -- when sl or s2 is blank return 1, otherwise return 0
       ,0)) 
  END
FROM (VALUES(@string1,@string2,DATALENGTH(@string1),DATALENGTH(@string2))) a(s1,s2,l1,l2);
GO
