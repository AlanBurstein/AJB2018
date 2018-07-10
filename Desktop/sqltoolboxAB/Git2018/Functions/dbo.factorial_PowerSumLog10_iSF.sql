SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[factorial_PowerSumLog10_iSF](@N smallint)
RETURNS TABLE WITH SCHEMABINDING AS RETURN -- blows up slightly at 18+ 
  SELECT factorial = 
    CAST(ISNULL(POWER(10.0, SUM(LOG10(N))), CASE WHEN @N < 1 THEN 1 END) AS bigint)
  FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),
             (12),(13),(14),(15),(16),(17),(18),(19),(20))t(N)
  WHERE @N <= 20 AND N <= @N;
GO
