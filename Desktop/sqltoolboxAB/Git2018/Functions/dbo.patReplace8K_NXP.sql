SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[patReplace8K_NXP]
(
  @string  varchar(8000),
  @pattern varchar(50),
  @replace varchar(20)
) 
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  newString = 
    CASE WHEN @string = '' THEN ''
         WHEN @pattern+@replace+@string IS NOT NULL THEN 
    (
      SELECT
        CASE WHEN PATINDEX(@pattern, token COLLATE Latin1_General_BIN) = 0
             THEN ng.token ELSE @replace END
      FROM dbo.NGrams8K(@string, 1) ng
      ORDER BY ng.position  -- spoon
      FOR XML PATH('')
    ) END;
GO
