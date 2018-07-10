SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[delimitedSplitPattern8K]
(
  @string       VARCHAR(8000),
  @delimiter    VARCHAR(20)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  itemNumber = ROW_NUMBER() OVER (ORDER BY d.p),
	itemDelim  = SUBSTRING(@string, d.p, 1), --preceding delimiter
  itemIndex  = ISNULL(NULLIF(d.p+l.d, 0),1),
  itemLength = item.ln,
  item       = SUBSTRING(@string, d.p+l.d, item.ln)
FROM (VALUES(DATALENGTH(@string), 1)) as l(s,d) -- length.(string|delimiter)
CROSS APPLY
(
  SELECT CAST(-l.d+1 AS BIGINT) UNION ALL
  SELECT ng.position
  FROM dbo.NGrams8k(@string, l.d) as ng
  WHERE token LIKE @delimiter
) AS d(p) -- Delimiter.Position
CROSS APPLY (VALUES(ISNULL(NULLIF(PATINDEX('%'+@delimiter+'%', 
                    SUBSTRING(@string, d.p+l.d, l.s)),0)-1, l.s-d.p))) item(ln)
GO
