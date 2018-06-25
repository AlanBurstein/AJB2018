SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[lcssWindowAB](@s1 varchar(8000), @s2 varchar(8000), @window int)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP (1) WITH TIES itemIndex, itemLen , item
FROM
(
  SELECT
    itemIndex = MIN(grouper.position), 
    itemLen   = grouper.ws+COUNT(*)-1,
    item      = SUBSTRING((SELECT s1 FROM dbo.getshortstring8k(@s1,@s2)), 
                  MIN(grouper.position), grouper.ws+COUNT(*)-1)
  FROM
  (
    SELECT TOP 1 WITH TIES
      tokens.position,
      ws = x.x,
      grouper = tokens.position - ROW_NUMBER() OVER (ORDER BY itally.position)
    FROM dbo.getshortstring8k(@s1,@s2) xs
    CROSS APPLY (VALUES (DATALENGTH(xs.s1), @window)) v(ls,w) -- datalength of short string, @window
    CROSS APPLY dbo.ngrams8k(REPLICATE(0,v.ls/v.w),1) iTally
    CROSS APPLY (VALUES (v.ls+(v.w-(v.ls%v.w))-(iTally.position*v.w))) x(x)
    CROSS APPLY dbo.ngrams8k(xs.s1, x.x) tokens
    WHERE CHARINDEX(tokens.token, xs.s2) > 0
    ORDER BY iTally.position
  ) grouper
  GROUP BY grouper.ws, grouper.grouper
  UNION ALL
  SELECT ng.position, 1, ng.token
  FROM dbo.getshortstring8k(@s1,@s2) xs
  CROSS APPLY dbo.ngrams8k(xs.s1,1) ng
  WHERE CHARINDEX(ng.token, xs.s2) > 0
) lcss
ORDER BY itemLen DESC;
GO
