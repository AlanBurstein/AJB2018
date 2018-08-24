SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[patMatch]
(
  @string       VARCHAR(8000),
  @basepattern  VARCHAR(50),
  @patternFront VARCHAR(10),
  @patternBack  VARCHAR(10),
  @repLow       INT,
  @repHigh      INT
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT patternMatch = IIF(EXISTS( 
             SELECT 1
             FROM dbo.rangeAB(ISNULL(@repLow,0), ISNULL(@repHigh,LEN(@string)), 1, 1) r
             WHERE PATINDEX(CONCAT('%',@patternFront,REPLICATE(@basepattern,r.N1),
                            @patternBack,'%'), @string) > 0),1,0);
GO
