SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[bernie8K](@s1 VARCHAR(8000), @s2 VARCHAR(8000))
/*****************************************************************************************
[Purpose]:
 This function allows developers to optimize and simplify how they fuzzy comparisons 
 between two strings (@s1 and @s2). 
 
 bernie8K returns:
  S1  = short string - LEN(S1) will always be <= LEN(S2); The formula to calculate S1 is:
          S1 = CASE WHEN LEN(@s1) > LEN(@s2) THEN @s2, ELSE @s1 END;
  S2  = long string  - LEN(S1) will always be <= LEN(S2); The formula to calculate S1 is:
          S2 = CASE WHEN LEN(@s1) > LEN(@s2) THEN @s1, ELSE @s2;
  L1  = short string length = LEN(S1)
  L2  = long string length  = LEN(S2)
  D   = distance            = L2-L1; how many characters needed to make L1=L2; D tells us:
          1. D    is the *minimum* Levenshtein distance between S1 and S2
          2. L2/D is the *maximum* similarity between S1 and S2
  I   = index               = CHARINDEX(S1,S2);
  B   = bernie distance     = When B is not NULL then:
          1. B = The Levenshtein Distance between S1 and S2
          2. B = The Damarau-Levenshtein Distance bewteen S1 and S2
          3. B = The Longest Common Substring & Longest Common Subsequence of S1 and S2
          4. KEY! = The similarity between L1 and L2 is L1/l2
  S   = Bernie Similarity   = When B isn't null S is the same Similarity value returned by
        mdq.Similarity: https://msdn.microsoft.com/en-us/library/ee633878(v=sql.105).aspx

[Author]:
  Alan Burstein

[Compatibility]: 
 SQL Server 2005+, Azure SQL Database, Azure SQL Data Warehouse & Parallel Data Warehouse

[Parameters]:
 @s1 = varchar(8000); First of two input strings to be compared
 @s2 = varchar(8000); Second of two input strings to be compared

[Returns]:
 S1 = VARCHAR(8000); The shorter of @s1 and @s2; returns @s1 when LEN(@s1)=LEN(@s2)
 S2 = VARCHAR(8000); The longer  of @s1 and @s2; returns @s2 when LEN(@s1)=LEN(@s2)
 L1 = INT; The length of the shorter of @s1 and @s2 (or both when they're of equal length) 
 L2 = INT; The length of the longer  of @s1 and @s2 (or both when they're of equal length) 
 D  = INT; L2-L1; The "distance" between L1 and L2
 I  = INT; The location (position) of S1 inside S2; Note that when 1>0 then S1 is both:
       1.  a substring   of S2
       2.  a subsequence of S2
 B  = INT; The Bernie Distance between @s1 and @s1; When B is not null then:
       1. B = The Levenshtein Distance between S1 and S2
       2. B = The Damarau-Levenshtein Distance bewteen S1 and S2
       3. B = The Longest Common Substring & Longest Common Subsequence of S1 and S2
       4. KEY! = The similarity between L1 and L2 is L1/l2
 S  = NUMERIC; When B isn't null then S is the same Similarity value returned by
        mdq.Similarity: https://msdn.microsoft.com/en-us/library/ee633878(v=sql.105).aspx

[Syntax]:
--===== Autonomous
 SELECT b.S1, b.S2, b.L1, b.L2, b.I, b.B, b.S
 FROM   samd.bernie8K('abc123','abc12') AS b;

--===== CROSS APPLY example
 SELECT b.S1, b.S2, b.L1, b.L2, b.I, b.B, b.S
 FROM        dbo.SomeTable            AS t
 CROSS APPLY samd.bernie8K(t.S1,t.S2) AS b;

[Dependencies]:
 N/A

[Developer Notes]:
 1. When @s1 is NULL then S2 = @s2, L2 = LEN(@s2); 
    When @s2 is NULL then S1 = @s1, L1 = LEN(@s1)
 2. bernie8K ignores leading and trailing whitespace on both input strings (@s1 and @s2). 
    In other words LEN(@s1)=DATALENGTH(@s1), LEN(@s2)=DATALENGTH(@s2)
 3. bernie8K is deterministic; for more about deterministic and nondeterministic
    functions see https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:

--==== 1. BASIC USE:
SELECT b.S1, b.S2, b.L1, b.L2, b.D, b.I, b.B, b.S
FROM samd.bernie8K('abc123','bc1') b;

--==== 2. bernie8K behaivior
-- 2.1. Equality 
  SELECT b.* FROM samd.bernie8K('abc','abc') b; -- equal strings
  SELECT b.* FROM samd.bernie8K('','') b;       -- blank S1 & S2
-- 2.2. Empty strings
  SELECT b.* FROM samd.bernie8K('','abc') b;    -- blank S1
  SELECT b.* FROM samd.bernie8K('abc','') b;    -- blank S2
-- 2.3. NULL values: Note the behavior difference vs blank (explain real-world example)
  SELECT b.* FROM samd.bernie8K('abc',NULL) b;
  SELECT b.* FROM samd.bernie8K(NULL,'abc') b;
-- 2.4. Note what happens when an Inner Match occures 
    -- (when one string is blank or S1 is a substring of S2)
  SELECT b.* FROM samd.bernie8K('abc123','abc12') b;
  SELECT b.* FROM samd.bernie8K('abc123','bc123') b;
  SELECT b.* FROM samd.bernie8K('abc123','bc') b;
-- 2.5 No inner match
  SELECT b.* FROM samd.bernie8K('abc123','abcd') b;

--==== 3. Understanding Similarity
-- 3.1. Using mdq.similarity:
SELECT l.* FROM SQLDevToolbox.samd.levenshteinAB('Maine','Mai',.01) l -- 3/5 = 0.6
SELECT l.* FROM SQLDevToolbox.samd.levenshteinAB('Mississippi','Mississipp',0) AS l

-- 3.2. Using bernie8k:
SELECT b.* FROM samd.bernie8K('Maine','mai') AS b -- 4/5 = 0.8
SELECT b.* FROM samd.bernie8K('Mississippi','Mississipp') b

--==== 4. Understanding the Lazy evaluation
  -- Run each with "show actual execution plan" ON then examine the Constant Scan operator

  SELECT b.D 
  FROM samd.bernie8K('abc123','abc12') AS b;
  
  SELECT b.S1, b.S2, b.L1, b.L2, b.D
  FROM samd.bernie8K('abc123','abc12') AS b;
  
  SELECT b.S1, b.S2, b.L1, b.L2, b.D,
         b.I, b.B, b.S 
  FROM samd.bernie8K('abc123','abc12') AS b;
-----------------------------------------------------------------------------------------
[Revision History]:
 Rev 00 - 20180708 - Inital Creation - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
SELECT 
  S1 = base.S1,     -- short string
  S2 = base.S2,	    -- long string
  L1 = base.L1,	    -- short string length
  L2 = base.L2,	    -- long string length
  D  = base.D,		  -- distance >> number of characters needed to make L1=L2
  I  = iMatch.idx,  -- index    >> position of S1 within S2
  B  = bernie.D,	  -- bernie distance
  S  = similarity.D -- bernie similarity
FROM
(
  SELECT
    S1 = CASE WHEN ls.L=1 THEN s.S2 ELSE s.S1 END,
    S2 = CASE WHEN ls.L=1 THEN s.S1 ELSE s.S2 END,
    L1 = CASE WHEN ls.L=1 THEN l.S2 ELSE l.S1 END,
    L2 = CASE WHEN ls.L=1 THEN l.S1 ELSE l.S2 END,
    D  = ABS(l.S1-l.S2)
  FROM        (VALUES(LEN(@s1),LEN(@s2)))                   AS l(S1,S2) -- LEN(S1,S2)
  CROSS APPLY (VALUES(RTRIM(LTRIM(@S1)),RTRIM(LTRIM(@S2)))) AS s(S1,S2) -- S1 and S2 trimmed
	CROSS APPLY (VALUES(SIGN(l.S1-l.S2)))                     AS ls(L)    -- LeftLength
) AS base
CROSS APPLY (VALUES(ABS(SIGN(base.L1)-1),ABS(SIGN(base.L2)-1)))             AS blank(S1,S2)
CROSS APPLY (VALUES(CHARINDEX(base.S1,base.S2)))                            AS iMatch(idx)
CROSS APPLY (VALUES(CASE WHEN SIGN(iMatch.idx|blank.S1)=1 THEN base.D END)) AS bernie(D)
CROSS APPLY (VALUES(CASE blank.S1 WHEN 1 THEN blank.S2 ELSE 
                      1.*NULLIF(SIGN(iMatch.idx),0)*base.L1/base.L2 END))   AS similarity(D);
GO
