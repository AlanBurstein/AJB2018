SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[substringExtract]
(
  @string       varchar(max),
  @searchstring varchar(100),
  @pad          varchar(50)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT itemindex = ng.position, item = @searchstring
FROM (VALUES (len(@searchstring))) ss(ln)
CROSS APPLY dbo.ngramsN2b(@string, ss.ln) ng
WHERE ng.token = @searchstring AND (@pad = '' OR (
  substring(@string,position-1,1)     NOT LIKE @pad AND
  substring(@string,position+ss.ln,1) NOT LIKE @pad))
UNION ALL SELECT null,null WHERE @pad IS NULL OR @searchstring IS NULL OR @string IS NULL;
GO
