SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[rangeAB8K]
(
  @low  bigint, 
  @high bigint, 
  @gap  bigint,
  @row1 bit
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH L1(N) AS 
(
  SELECT 1
  FROM (VALUES
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0)) T(N) -- 90 values 
),
L2(N)  AS (SELECT 1 FROM L1 a CROSS JOIN L1 b),
iTally AS (SELECT rn = ROW_NUMBER() OVER (ORDER BY (SELECT 1)) FROM L2 a CROSS JOIN L2 b)
SELECT 
  rn = 0 ,
  op = (@high-@low)/@gap,
  n1 = @low,
  n2 = @gap+@low
WHERE @row1 = 0 AND @high+@low+@gap IS NOT NULL AND @high >= @low AND @gap > 0
UNION ALL -- ISNULL required in the TOP statement for error handling purposes
SELECT TOP (ABS((ISNULL(@high,0)-ISNULL(@low,0))/ISNULL(@gap,0)+ISNULL(@row1,1)))
  rn,
  op = (@high-@low)/@gap+(2*@row1)-rn,
  n1 = (rn-@row1)*@gap+@low,
  n2 = (rn-(@row1-1))*@gap+@low
FROM iTally i
WHERE @high+@low+@gap+@row1 IS NOT NULL AND @high >= @low AND @gap > 0 -- AND rn <= (@high-@low)/@gap+@row1
ORDER BY rn; -- now our TOP clause is legit
--UNION ALL 
--SELECT NULL, NULL, NULL, NULL  -- Error handling and assurance of a single row return
--WHERE NOT (@high+@low+@gap+@row1 IS NOT NULL AND @high >= @low AND @gap > 0);
GO
