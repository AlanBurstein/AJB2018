SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[wLEdgeGrams](@string VARCHAR(8000))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  itemNumber = ROW_NUMBER() OVER (ORDER BY split.pos),
  itemLength = split.pos, 
  item       = SUBSTRING(@string, 1, split.pos-1)
FROM
(
  SELECT ng.position
  FROM dbo.NGrams8K(@string,1) ng 
  WHERE ng.token = ' '
  UNION ALL
  SELECT LEN(@string)+1
) split(pos);
GO
