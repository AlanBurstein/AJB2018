SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[delimitedSplitAB8K_VLNO]
(
  @string       VARCHAR(8000),
  @delimiter    VARCHAR(30)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  itemNumber = ROW_NUMBER() OVER (ORDER BY items.itemGroup),
  items.itemIndex,
  items.itemLength,
  item = SUBSTRING(@string, items.itemIndex, items.itemLength)
FROM
(
  SELECT 
    itemGroup  = d.g, 
    itemIndex  = MAX(d.p), 
    itemLength = CHECKSUM(ISNULL(NULLIF(CHARINDEX(@delimiter,@string,MAX(d.p)),0),
                   DATALENGTH(@string)+1)-MAX(d.p))
  FROM
  (
    SELECT -1, 1 WHERE CHARINDEX(@delimiter,@string) <> 1 UNION ALL
    SELECT CHECKSUM(ng.position - ROW_NUMBER() OVER (ORDER BY ng.position)), 
           CHECKSUM(ng.position + DATALENGTH(@delimiter))
    FROM dbo.ngrams8k(@string, DATALENGTH(@delimiter)) ng
    WHERE ng.token = @delimiter
  ) d(g,p) -- delimiter.grouper, delimiter.position
  GROUP BY d.g
) items
WHERE itemIndex <= DATALENGTH(@string)
GO
