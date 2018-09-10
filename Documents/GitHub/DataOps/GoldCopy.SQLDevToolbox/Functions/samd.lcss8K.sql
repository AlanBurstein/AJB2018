SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[lcss8K] (@s1 VARCHAR(8000), @s2 VARCHAR(8000))
/*****************************************************************************************
[Purpose]:
 A highly optimized function for identifying the longest common substring between two 
 strings (@s1 and @s2) in substantially less than O(N*M) time. For more about the Longest
 Common Substring see: https://www.geeksforgeeks.org/longest-common-substring-dp-29L. 
 
[Author]: 
  Alan Burstein

[Compatibility]:
 SQL Server 2008+

[Syntax]:
--===== Autonomous
 SELECT f.S1, f.S2, f.L1, f.L2, f.low, f.high, f.itemLength, f.itemIndex, f.item, f.minSim
 FROM   samd.lcss8K(@s1,@s2) AS f;

--===== Against a table using APPLY
 SELECT      t.*, f.*
 FROM        dbo.someTable           AS t
 CROSS APPLY samd.lcss8K(@s1, t.col) AS f;

[Parameters]:
  @s1 = VARCHAR(8000); string to compare to @s2
  @s2 = VARCHAR(8000); string to compare to @s1

[Returns]:
 <function type,,inline table valued function> returns:
 S1         varchar(8000); The shorter of @s1 & @s2 OR @s1 when @s1 & @s2 are equal length
 S2         varchar(8000); The longer  of @s1 & @s2 OR @s2 when @s1 & @s2 are equal length
 L1         int; The length of S1
 L2         int; The length of S2
 low        int; low and high represent the upper and lower lengths of the window
 high       int; low and high represent the upper and lower lengths of the window
 itemLength int; length of the longest common substring
 itemIndex  int;
 item       varchar(8000);
 minSim     numeric;


 <name,,> = <datatype,,> <description,,>

[Dependencies]:
 <Dependencies,,N/A>

[Developer Notes]:
 1. Optimizations

    This function is special in that it's optimized to be much faster than linear.
    Included in the return values are the lengths of both input strings: L1 represents the 
    length of the shorter of @s1 and @s2, L2 represents the longer of the two strings. The 
    Longest Common Substring problem can be solved in O(m*n) time via a brute force -- 
    that is, splitting both strings into every possible substring then looking for matching
    substrings. Functions can solve this problem in O(m*n) time using a suffix tree but, 
    in SQL Server, this cannot be accomplished using an iTVF and is therefore not a viable
    option. lcss8K has been optimized with mathmatically sound, set-based, deterministic 
    logic which lives inside an iTVF that identifies the longest common substring without
    a brute force approach. This makes lcss8K the first of it's kind.
 
 --==== 1.1. Faster than linear 
   The first major optimization is the use of the bernie8K iTVF to identify which of the 
   twoinput strings (@s1 and @s2) is shorter and which is longer. bernie8K returns the 
   shorter string as S1 and the longer as S2. Then *only S1 is split into substrings*; S1
   is then scanned for a match between it and substrings from S1. The dramtically reduces 
   the number of characters that are evaluated; often by 99.999% in longer strings.   

   Consider two strings, the first (S1) is 100 characters long, the second (S2) has 120 
   characters. A brute force solution would create 5050 substrings for S1 and 7260 for 
   S2. This means that 36,663,000 comparisons would be required to identify all matching
   substrings then a sort is required to identify the longest common substring. Using 
   bernie8K the 5,050 substrings of S1 are compared to S2. THIS MEANS ONLY WE REDUCE THE 
   NUMBER OF EVALUATIONS DOWN TO 5050 FROM 36,663,000. With strings 200 characters+ the
   number of operations expands into the billions. For two strings, 8000 characters each, 
   the number of operations eplodes to 1,024,000,000,000,000. Using the bernie8K appoach
   requires 32,000,000 operations. 

 --==== 1.2. No sorting required to idenitfy the longest substring
   Use of Finite Opposite Numbers to eliminate the need for a descending sort
 
 --==== 1.3. S1 Multi-Tiling to dramatically reduce the number of substrings compared
   This further reduces the number of evaluations required by as much as 99.9999999999%.

 --==== 1.4. Parallelism
   Parallelizes quite nicely. Use traceflag 8649 in development environments and 
   make_parallel in production. 

 2. Similarity
    Can be used for optimizing string simliarity comparisons (fuzzy matching) using
    algorithms such as Levenshtein and the Longest Common Subsequence

 --==== 2.1. Similarity Example
   Excellent perofrmance optimization by quickly identifying similarity when the 
   differences are at the beginning and end of the string.

    DECLARE @s1 VARCHAR(8000) = '$$ABC123XYZ&&', --'$$$ABC123XYZ&&&',
            @s2 VARCHAR(8000) = '??ABC123XYZ??'; --'ABC123XYZ??????';
    
    SELECT L.* FROM samd.lcss8K(@s1,@s2) AS L;
    
    SELECT sqlDevToolbox.clr.Similarity(@s1,@s2,0,0,0)
    SELECT sqlDevToolbox.clr.Similarity(@s1,@s2,3,0,0)

 3. Returns <return value on NULL input,,a single NULL>, 
    <return value on blank input,,No rows>. To return a single row containing a a NULL or 
    Blank row on NULL inputparameters conider using OUTER APPLY or append the function 
    with a UNION ALL "dummy row." Noe the following examples:

    <OUTER APPLY example,,>

    <UNION ALL example,,>
    <UNION ALL LOGIC,,UNION ALL SELECT NULL, WHERE NULLIF(@parameter,'') IS NULL;>
 4. Case sensitivity and collation

 5. <function name,,> is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx


[Examples]:

--===== 1. <tile 1.,,>
 -- (1.1) <subtitle 1.1,,>
 <example code,,s>;

 -- (1.2) <subtitle 1.2.,,>
 <example code 12..,,s>;

--===== 2. <tile 2.,,>
 -- (1.1) <subtitle,,>
 <example code,,>;

-----------------------------------------------------------------------------------------
[Revision History]: 
 Rev 00 - 20180907 - Initial Development - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH
wmx AS
(
  SELECT TOP (1) ws.winMax, ws.winSize, b.L1, b.L2, b.S1, b.S2, ng.position
  FROM           samd.bernie8K(@s1,@s2)        AS b
  CROSS JOIN     dbo.rangeAB(0,3,1,1)          AS r
  CROSS APPLY   (VALUES(POWER(10,LEN(b.L1)-1),
                        POWER(10,r.op-1)))     AS ws(winSize,winMax)
  CROSS APPLY    dbo.NGrams8k(b.S1, ws.winMax) AS ng
  WHERE          ws.winSize >= ws.winMax
  AND            CHARINDEX(ng.token,b.S2) > 0
  ORDER BY r.RN
),
wmx2(tokenSize,high,position,winMax,winSize,L1,L2,S1,S2) AS
(
  SELECT TOP (1) 
    ws.winSize,
    IIF(wmx.L1<wmx.winSize+ws.winsize, wmx.L1, wmx.winSize+ws.winsize-1),
    wmx.position, wmx.winMax, wmx.winSize, wmx.L1, wmx.L2, wmx.S1, wmx.S2
  FROM wmx
  CROSS APPLY  dbo.rangeAB(0,wmx.L1/wmx.winSize,1,1)                 AS r2
  CROSS APPLY  (VALUES(COALESCE(NULLIF(wmx.winSize*(r2.OP-1),0),1))) AS ws(winSize)
  CROSS APPLY  dbo.NGrams8k(wmx.S1,ws.winSize)                       AS ng2
  WHERE        CHARINDEX(ng2.token,wmx.S2) > 0
  ORDER BY r2.RN
)
SELECT TOP (1) WITH TIES
  S1         = wmx2.S1,
  S2         = wmx2.S2,
  L1         = wmx2.L1,
  L2         = wmx2.L2,
  low        = CHECKSUM(wmx2.tokenSize),
  high       = CHECKSUM(wmx2.high),
  itemLength = CHECKSUM(wmx2.tokenSize+r3.OP-1),
  itemIndex  = CHECKSUM(ng3.position),
  item       = ng3.token,
  minSim     = 1.00*(wmx2.tokenSize+r3.OP-1)/wmx2.L2
FROM wmx2
CROSS JOIN   samd.bernie8K(@s1,@s2)                               AS b2
CROSS APPLY  (VALUES(CHOOSE(
                     LEN(wmx2.high-wmx2.tokenSize),1,5,100,500))) AS ws(winsize)
CROSS APPLY  dbo.rangeAB(wmx2.tokenSize,wmx2.high,1,1)            AS r3
CROSS APPLY  dbo.NGrams8k(wmx2.S1, wmx2.tokenSize+r3.OP-1)        AS ng3
WHERE        CHARINDEX(ng3.token, b2.S2) > 0
ORDER BY     r3.RN;
GO
