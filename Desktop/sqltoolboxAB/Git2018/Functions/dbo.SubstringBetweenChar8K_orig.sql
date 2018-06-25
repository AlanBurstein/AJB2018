SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SubstringBetweenChar8K_orig]
(
  @string    varchar(8000),
  @start     tinyint,
  @stop      tinyint,
  @delimiter char(1)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH
chars AS
(
 SELECT instance = 0, position = 0 WHERE @start = 0
 UNION ALL
 SELECT ROW_NUMBER() OVER (ORDER BY position), position
 FROM dbo.NGrams8k(@string,1)
 WHERE token = @delimiter
 UNION ALL
 SELECT -1, DATALENGTH(@string)+1 WHERE @stop = 0
)
SELECT 
  token = SUBSTRING
          (
            @string,
            MIN(position)+1,
            NULLIF(MAX(position),MIN(position)) - MIN(position)-1
          ),
  position = CAST
      		(
            CASE WHEN NULLIF(MAX(position),MIN(position)) - MIN(position)-1 > 0
            THEN MIN(position)+1 END AS smallint
          )
FROM chars
WHERE instance IN (@start, NULLIF(@stop,0), -1);
GO
