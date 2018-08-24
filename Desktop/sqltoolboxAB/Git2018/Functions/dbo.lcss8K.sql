SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[lcss8K](@s1 VARCHAR(8000), @s2 VARCHAR(8000), @min INT)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP (1) WITH TIES
  lcss.item,
  itemLength = lcss.itemLength,
  lcss.s1Index,
  lcss.s2Index
FROM
( -- I.Check for NULLs, BLANKS and Bernie
------------------------------------------------------------------------------------------
 SELECT
   item       = string.S1+REPLICATE('',SIGN(string.L2)),
   itemLength = string.L1*SIGN(string.L2),
   s1Index    = SIGN(string.L2)*SIGN(string.L1),
   s2Index    = CHARINDEX(string.S1,string.S2)
 FROM samd.bernie8k(@s1,@s2) AS string
 WHERE string.S2 IS NULL
 OR string.L1*COALESCE(string.L2,0) = 0 
 OR CHARINDEX(string.s1, string.S2) > 0  
 UNION ALL 
 -- II. Handle Unigrams When Required
------------------------------------------------------------------------------------------
 SELECT
   item       = ng.token,
   itemLength = 1,
   s1Index    = ng.position,
   s2Index    = CHARINDEX(ng.token,string.S2)
 FROM samd.bernie8k(@s1,@s2) AS string
 CROSS APPLY dbo.ngrams8k(string.s1,1) ng
 WHERE @min = 1 
 AND NOT
 (
  string.S2 IS NULL
   OR string.L1*COALESCE(string.L2,0) = 0
   OR CHARINDEX(string.s1, string.S2) > 0
 )
 UNION ALL  
 -- III. LCSS (bi-grams+)
------------------------------------------------------------------------------------------
 SELECT item, itemLength, s1Index ,s2Index
 FROM
 (
   SELECT TOP (1) WITH TIES
     item       = SUBSTRING(groups.S1,MIN(groups.s1Index),@min+COUNT(*)-SIGN(@min-1)),
     itemLength = @min+COUNT(*)-SIGN(@min-1), --@min+COUNT(*)-1,
     s1Index    = MIN(groups.s1Index),
     s2Index    = MIN(groups.s2Index)
   FROM
   (
     SELECT 
       grouper = ng.position - ROW_NUMBER() OVER (ORDER BY ng.position),
       s1Index = ng.position,
       s2Index = CHARINDEX(ng.token,string.S2),
       S1      = string.S1
     FROM samd.bernie8k(@s1,@s2)          AS string
     CROSS APPLY dbo.ngrams8K(string.S1, ISNULL(NULLIF(@min,1),2)) AS ng
     WHERE @min BETWEEN 1 AND string.L1  -- Startup Predicate: When @min > string.L1 a wrong answer is possible
    AND NOT
    (
     string.S2 IS NULL
      OR string.L1*COALESCE(string.L2,0) = 0
      OR CHARINDEX(string.s1, string.S2) > 0
    )
    AND CHARINDEX(ng.token,string.S2) > 0 -- @mingh-gram exists in s.S2
   ) groups
   GROUP BY groups.S1, groups.grouper
   ORDER BY COUNT(*) DESC
 ) big
) lcss
ORDER BY -lcss.itemLength;
GO
