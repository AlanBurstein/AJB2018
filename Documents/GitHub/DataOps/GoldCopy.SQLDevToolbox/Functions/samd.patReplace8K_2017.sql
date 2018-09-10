SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[patReplace8K_2017]
(
  @string  VARCHAR(8000),
  @pattern VARCHAR(50),
  @replace VARCHAR(20)
) 
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  newString = 
    CASE WHEN @string = '' THEN ''
         WHEN @pattern+@replace+@string IS NOT NULL
         THEN STRING_AGG(
            CASE WHEN PATINDEX(@pattern, token COLLATE Latin1_General_BIN) = 0
                 THEN ng.token 
                 ELSE @replace END,'') WITHIN GROUP (ORDER BY ng.position) END
FROM dbo.NGrams8K(@string, 1) ng;
GO
