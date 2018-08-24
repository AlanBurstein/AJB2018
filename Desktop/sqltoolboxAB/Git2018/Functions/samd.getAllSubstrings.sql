SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[getAllSubstrings](@string VARCHAR(8000), @top INT, @asc BIT)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP(8000)
  itemNumber = ROW_NUMBER() OVER (ORDER BY itemLen.RN),
  sortKey    = itemLen.RN,
  itemIndex  = position.RN,
  itemLen    = IIF(@asc=1,itemLen.RN,itemLenOP.Op),
  item       = SUBSTRING(@string,position.RN,IIF(@asc=1,itemLen.RN,itemLenOP.Op))
FROM (VALUES(COALESCE(@top,LEN(@string))))                         AS f(low)
CROSS APPLY (VALUES(LEN(@string)-f.low+1, LEN(@string)))           AS tile(low,high)
CROSS APPLY dbo.rangeAB(tile.low,tile.high,1,1)                    AS itemLen
CROSS APPLY dbo.O(@asc*(LEN(@string)-f.low)+1, tile.high,
                        IIF(@asc=1,itemLen.N1,itemLen.RN))         AS itemLenOP
CROSS APPLY dbo.rangeAB(1,IIF(@asc=1,itemLenOP.Op,itemLen.RN),1,1) AS position
WHERE f.low <= tile.high
ORDER BY sortKey;
GO
