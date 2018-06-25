SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ngrams8k_v3](@string varchar(8000), @k int)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  position = r.N,
  token    = SUBSTRING(@string, CHECKSUM(r.N), @k)
FROM dbo.fnTally(1, DATALENGTH(@string)+1-@k) r
WHERE @k > 0 AND @k <= DATALENGTH(@string);
GO
