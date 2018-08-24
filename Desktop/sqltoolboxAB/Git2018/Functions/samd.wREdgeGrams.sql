SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[wREdgeGrams](@string VARCHAR(8000))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  itemIndex  = split.pos+1, 
  itemLength = LEN(@string)-split.pos, 
  item       = SUBSTRING(@string, split.pos+1, LEN(@string)-split.pos)
FROM
(
  SELECT 0 UNION ALL 
  SELECT ng.position
  FROM dbo.NGrams8K(@string,1) ng 
  WHERE ng.token = ' '
) split(pos);
GO
