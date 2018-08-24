SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[lcssRange](@s1 VARCHAR(8000), @s2 VARCHAR(8000), @u BIT)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP (1) WITH TIES
  item        = item.item,
  itemIndexS1 = p.RN,
  itemIndexS2 = item.itemIndex,
  itemLenS1   = item.itemLen,
  itemLenS2   = b.L2,
  minSim      = similarity.mn
FROM samd.bernie8K(@s1,@s2)                         AS b
CROSS APPLY dbo.rangeAB(1-@u,IIF(b.B>0,1,b.L1),1,1) AS L
CROSS APPLY dbo.rangeAB(1,L.rn,1,1)                 AS p
CROSS APPLY (VALUES(SUBSTRING(b.S1,P.rn,L.op)))     AS ng(item)
CROSS APPLY (VALUES(IIF(b.B>0,@s1,ng.item),
                    IIF(b.B>0.0,b.L1,L.Op),
                    CHARINDEX(ng.item,b.S2)))        AS item(item,itemLen,itemIndex)
CROSS APPLY (VALUES(1.*item.itemLen/b.L2))           AS similarity(mn)
WHERE item.itemIndex > 0
ORDER BY L.rn;
GO
