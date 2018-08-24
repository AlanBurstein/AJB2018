SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[getshortstring8k](@s1 VARCHAR(8000), @s2 VARCHAR(8000))
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
SELECT
  L1 = CASE WHEN l.s1 < l.s2 THEN l.s1 ELSE l.s2 END, -- datalength of the shortest string
  L2 = CASE WHEN l.s1 < l.s2 THEN l.s2 ELSE l.s1 END, -- datalength of the longest string
  S1 = CASE WHEN l.s1 < l.s2 THEN @s1 ELSE @s2 END,   -- shortest
  S2 = CASE WHEN l.s1 < l.s2 THEN @s2 ELSE @s1 END,   -- longest
  D  = ABS(LEN(@s1)-LEN(@s2))
FROM (VALUES (DATALENGTH(@s1), DATALENGTH(@s2))) l(s1,s2);
GO
