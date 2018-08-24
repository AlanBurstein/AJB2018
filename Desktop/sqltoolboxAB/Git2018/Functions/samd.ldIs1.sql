SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[ldIs1] (@string1 VARCHAR(8000), @string2 VARCHAR(8000))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT LD = 1
WHERE EXISTS (
  SELECT 1
  FROM (VALUES(IIF(LEN(@string1)>LEN(@string2),1,2))) longer(s)
  CROSS APPLY (VALUES(IIF(longer.s=1,@string1,@string2),
                      IIF(longer.s=1,@string2,@string1))) s(s1,s2)
  CROSS APPLY dbo.ngrams8K(s.s1,1) ng
  WHERE s.s2 = STUFF(s.s1,ng.position,1,''));
GO
