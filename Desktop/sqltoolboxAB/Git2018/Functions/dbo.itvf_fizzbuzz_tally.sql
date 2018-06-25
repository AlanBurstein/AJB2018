SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[itvf_fizzbuzz_tally](@rows int)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT N, fizzbuzz =
  CASE 0 WHEN N%15 THEN 'fizzbuzz' WHEN N%5 THEN 'buzz' WHEN N%3 THEN 'fizz' ELSE '' END
FROM dbo.tally
ORDER BY N
OFFSET 0 ROWS -- NOTE: remove the ROWS reference on this line for postgreSQL compatabiliy
FETCH FIRST @rows ROWS ONLY;
GO
