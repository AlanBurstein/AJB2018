SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[patMatchIndex]
(
  @string       VARCHAR(8000),
  @basepattern  VARCHAR(50),
  @patternFront VARCHAR(10),
  @patternBack  VARCHAR(10),
  @repLow       INT,
  @repHigh      INT
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  patternMatched = patcreate.pattern,
  patternIndex   = patcreate.idx
FROM (VALUES (@string)) t(string)
OUTER APPLY -- OUTER APPLY ADDS OVERHEAD
( 
  SELECT p.pattern, pat.idx, bpMatch = r.N1
  FROM dbo.rangeAB(ISNULL(@repLow,0), ISNULL(@repHigh,LEN(@string)), 1, 1) r
  CROSS APPLY (VALUES(
    CONCAT('%',@patternFront,REPLICATE(@basepattern,r.N1),@patternBack,'%'))) p(pattern)
  CROSS APPLY (VALUES(PATINDEX(p.pattern, @string))) pat(idx)
  WHERE pat.idx > 0
) patcreate;
GO
