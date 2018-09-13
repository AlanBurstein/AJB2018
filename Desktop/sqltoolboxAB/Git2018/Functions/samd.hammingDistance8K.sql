SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[hammingDistance8K] 
(
  @s1 VARCHAR(8000), -- first input string
  @s2 VARCHAR(8000)  -- second input string
)
/*****************************************************************************************
[Purpose]:
 Purely set-based iTVF that returns the Hamming Distance between two strings of equal 
 length. See: https://en.wikipedia.org/wiki/Hamming_distance

[Author]:
 Alan Burstein

[Compatibility]:
 SQL Server 2008+

[Syntax]:
--===== Autonomous
 SELECT h.HD
 FROM   samd.hammingDistance8K(@s1,@s2) AS h;

--===== Against a table using APPLY
 SELECT      t.string, S2 = @s2, h.HD
 FROM        dbo.someTable AS t
 CROSS APPLY samd.hammingDistance8K(t.string, @s2) AS h;

[Parameters]:
  @s1 = VARCHAR(8000); the first input string
  @s2 = VARCHAR(8000); the second input string

[Returns]:
 <function type,,inline table valued function> returns:
 <name> = <datatype> <description>

[Dependencies]:
 1. samd.NGrams8K

[Developer Notes]:
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

[Examples]:
--===== 1. Basic Use
DECLARE @s1 VARCHAR(8000) = 'abc1234',  
        @s2 VARCHAR(8000) = 'abc2234'; 

SELECT h.hd 
FROM   samd.hammingDistance8K(@s1,@s2) AS h;

---------------------------------------------------------------------------------------
Revision History: 
 Rev 00 - 20180800 - Initial re-design - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT hammingDistance.HD
FROM
(
  SELECT CASE LEN(@S1) 
         WHEN LEN(@S2) THEN LEN(@S1)-SUM(CHARINDEX(ng.token,SUBSTRING(@S2,ng.position,1)))
         END
  FROM   dbo.NGrams8k(@s1,1) AS ng
) AS hammingDistance(HD);
/*
dld = CASE WHEN hammingDistance.hd < 2 THEN hammingDistance.hd END,
lcs = CASE WHEN hammingDistance.hd < 2 THEN DATALENGTH(@s1)-hammingDistance.hd END

DECLARE -- THE UNIGRAM PROBLEM: Two solutions: (1) for short strings, use the other function (2) wrap results in subquery UNION ALL'd with 
  @s1 VARCHAR(8000) = 'abc1234',  
  @s2 VARCHAR(8000) = 'abc2234'; 

SELECT h.hd FROM samd.hammingDistance8K(@s1,@s2) AS h OPTION(RECOMPILE);

SELECT hd = CASE LEN(@S2)-LEN(@S2) WHEN 0 THEN LEN(@S1)-SUM(CHARINDEX(c.S1,c.S2)) END
FROM samd.bernie8K(@s1,@s2)                         AS b
CROSS APPLY dbo.NGrams8k(b.S1,1)                    AS ng
CROSS APPLY (VALUES(SUBSTRING(b.S1,ng.position,1),
                    SUBSTRING(b.S2,ng.position,1))) AS c(S1,S2)
OPTION(RECOMPILE);
*/;
GO
