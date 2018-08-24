SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[delimitedSplitAB8K_VLO]
(
  @string       VARCHAR(8000),
  @delimiter    VARCHAR(100)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
/*
DECLARE 
  @string    VARCHAR(8000) = 'blah blah...<br/>more yada yada...<br/>The end!',
  @delimiter VARCHAR(100)  = '<br/>'

SELECT * FROM samd.delimitedSplitAB8K_VLO(@string, @delimiter) split

Created: 20180725
*/
SELECT
  itemNumber = ROW_NUMBER() OVER (ORDER BY d.p),
  itemIndex  = ISNULL(NULLIF(d.p+l.d,0),1),
  itemLength = item.ln,
  item       = SUBSTRING(@string, d.p+l.d, item.ln)
FROM (VALUES (DATALENGTH(@string), DATALENGTH(@delimiter))) as l(s,d)
CROSS APPLY  -- string and delimiter length ^^^
(
  SELECT -(l.d) WHERE CHARINDEX(@delimiter, @string) <> 1 UNION ALL
  SELECT ng.position
  FROM dbo.NGrams8K(@string, l.d) as ng
  WHERE token = @delimiter
) as d(p) -- delimiter.position
CROSS APPLY (VALUES(
  ISNULL(NULLIF(CHARINDEX(@delimiter,@string,d.p+l.d),0)-(d.p+l.d),l.s+l.d))) item(ln)

GO
