SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[itvf_fizzbuzz_rcte](@rows int)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH cte(N) AS 
(
  SELECT 1 UNION ALL
  SELECT N+1
  FROM cte 
  WHERE N < @rows
)
SELECT N, fizzbuzz =
  CASE WHEN N%3=0 THEN 'fizz' ELSE '' END + CASE WHEN N%5=0 THEN 'buzz' ELSE '' END
FROM cte;
GO
