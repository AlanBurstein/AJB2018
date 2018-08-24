SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[bernie8K](@s1 VARCHAR(8000), @s2 VARCHAR(8000))
/*
SELECT b.S1, b.S2, b.L1, b.L2, b.D, b.I, b.BD
FROM samd.bernieDistance8K('abc123','bc1') b;
*/
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
SELECT 
  S1 = base.S1,    -- short string
  S2 = base.S2,	   -- long string
  L1 = base.L1,	   -- short string length
  L2 = base.L2,	   -- long string length
  D  = base.D,		 -- distance >> number of characters required to add to S1 to make L1=L2
  I  = iMatch.idx, -- index    >> position of S1 within S2
  B  = bernie.D,	 -- bernie distance
  S  = sim.D			 -- bernie similarity
FROM
(
  SELECT
    S1 = CASE WHEN f.LL=1 THEN @S2  ELSE @S1  END,
    S2 = CASE WHEN f.LL=1 THEN @S1  ELSE @S2  END,
    L1 = CASE WHEN f.LL=1 THEN l.S2 ELSE l.S1 END,
    L2 = CASE WHEN f.LL=1 THEN l.S1 ELSE l.S2 END,
    D  = ABS(l.S1-l.S2)
  FROM (VALUES(LEN(@s1), LEN(@s2)))     AS l(S1, S2) -- Datalength of S1 & S2
	CROSS APPLY (VALUES(SIGN(l.S1-l.S2))) AS f(LL)     -- LeftLength
) AS base
CROSS APPLY (VALUES(ABS(SIGN(base.L1)-1),ABS(SIGN(base.L2)-1)))             AS blank(S1,S2)
CROSS APPLY (VALUES(CHARINDEX(base.S1,base.S2)))                            AS iMatch(idx)
CROSS APPLY (VALUES(CASE WHEN SIGN(iMatch.idx|blank.S1)=1 THEN base.D END)) AS bernie(D)
CROSS APPLY (VALUES(CASE blank.S1 WHEN 1 THEN blank.S2 ELSE 
                      1.*NULLIF(SIGN(iMatch.idx),0)*base.L1/base.L2 END))   AS sim(D)
-- Note about NULL inputs
-- Note how, when one S1 is blank, sim.S = 0, BD = L2;
GO
