SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ngrams8k_tally]
(
  @string varchar(8000), -- Input string
  @N      int            -- requested token size
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP (ABS(CONVERT(BIGINT,(DATALENGTH(ISNULL(@string,''))+1-ISNULL(@N,1)),0)))
  position = N,                                   -- position of the token in the string(s)
  token    = SUBSTRING(@string,CAST(N AS int),@N) -- the @N-Sized token
FROM dbo.tally
WHERE @N > 0 AND @N <= DATALENGTH(@string) AND N <= DATALENGTH(@string); -- Protection against bad parameter values
GO
