SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[lcssWindowGroup8K](@s1 varchar(8000), @s2 varchar(8000), @window int)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT itemIndex, itemLen, itemGroup
FROM dbo.getshortstring8k(@s1,@s2) xs
OUTER APPLY
(
  SELECT TOP (1) WITH TIES 
    itemIndex = items.position,
    itemLen   = itemlen.itemlen,
    itemGroup = items.position - ROW_NUMBER() OVER (ORDER BY itally.position)
  FROM (VALUES (DATALENGTH(xs.s1), @window)) v(ls,w) -- short string len & @window
  CROSS APPLY dbo.ngrams8k(REPLICATE(0,v.ls/v.w),1) iTally
  CROSS APPLY (VALUES (v.ls+(v.w-(v.ls%v.w))-(iTally.position*v.w))) itemlen(itemlen)
  CROSS APPLY dbo.ngrams8k(xs.s1, itemlen.itemlen) items
  WHERE @window >= 5 AND @window%5 = 0 -- must be greater than 5 and divisible by 5
  AND CHARINDEX(items.token, xs.s2) > 0
  ORDER BY iTally.position
) lcssWindowGroup;
GO
