SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SubstringBetweenChar8K2]
(
  @string    varchar(8000),
  @first     int,
  @last      int,
  @delimiter varchar(100)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN

SELECT 
  item = 
    CASE WHEN @first >= 0 AND @last >=0 THEN
      CASE WHEN @first+@last=0 THEN @string
           WHEN @last=0        THEN SUBSTRING(@string, p.mn+LEN(@delimiter), 8000)
           WHEN @first<@last   THEN SUBSTRING(@string, p.mn+LEN(@delimiter), NULLIF(p.mx,p.mn)-p.mn-LEN(@delimiter)) END
    END,
  itemIndex = 
    CASE WHEN @first >= 0 AND @last >=0 THEN
      CASE WHEN @first+@last=0 THEN 1
           WHEN @last=0        THEN (p.mn+LEN(@delimiter))
           WHEN @first<@last   THEN (p.mn+LEN(@delimiter))*SIGN(NULLIF(p.mx, p.mn)) END
    END
FROM --(VALUES (LEN(@delimiter))) f(l) CROSS APPLY
(
  SELECT MIN(d.de), MAX(d.de)
  FROM
  (
    SELECT CHECKSUM(0),0 WHERE @first = 0 UNION ALL
    SELECT CHECKSUM(ROW_NUMBER() OVER (ORDER BY ng.position)), ng.position
    FROM dbo.ngrams8k(@string, LEN(@delimiter)) ng
    WHERE ng.token = @delimiter
  ) d(ds,de)
  WHERE ds IN (@first,@last)
) p(mn,mx);
GO
