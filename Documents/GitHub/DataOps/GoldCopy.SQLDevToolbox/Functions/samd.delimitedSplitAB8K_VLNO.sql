SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[delimitedSplitAB8K_VLNO]
(
  @string       VARCHAR(8000),
  @delimiter    VARCHAR(100)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
/*
DECLARE @string VARCHAR(1000) = -- 4 > 3 
'>>Then he said "hi" >>the answer is: 4 &gt; 3 
>> another line of text
>>> even more text';

SELECT *
FROM samd.delimitedSplitAB8K_VLNO(@string,'>>')

SELECT *
FROM samd.delimitedSplitAB8K(@string,'>>') ds
WHERE ds.item > ''

DECLARE
  @string VARCHAR(1000)  = 'xxxxx123xABCxxxPPPPPxxxxxxxr', 
  @delimiter VARCHAR(30) = 'xxxx';

SELECT * FROM samd.delimitedSplitAB8K_VL(@string,@delimiter) 

SELECT * FROM samd.delimitedSplitAB8K(@string,@delimiter)
*/
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
WHERE items.itemIndex <= DATALENGTH(@string)
GO
