SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[patExtract8KCM]
(
  @string  varchar(8000),
  @pattern varchar(50)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  itemNumber = ROW_NUMBER() OVER (ORDER BY MIN(p)),
  itemIndex  = MIN(p),
  itemLength = 1+MAX(p)-MIN(p),
  item       = SUBSTRING(@string, MIN(p), 1+MAX(p)-MIN(p))
FROM
(
	SELECT ng.position, grouper = ng.position - ROW_NUMBER() OVER (ORDER BY ng.position)
	FROM dbo.NGrams8k(@string, 1) ng
	WHERE ng.token LIKE @pattern
) d(p, g) -- delimiter(position, grouper)
GROUP BY d.g;
GO
