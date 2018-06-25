SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ngrams8k_v2](@string varchar(8000), @k int)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  position = r.rn,
  token    = SUBSTRING(@string, CHECKSUM(r.rn), @k)
FROM dbo.rangeAB(1, DATALENGTH(@string)+1-@k,1,1) r
WHERE @k > 0 AND @k <= DATALENGTH(@string);
GO
