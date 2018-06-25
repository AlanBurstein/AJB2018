SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[patReplace_2017]
(
  @string  varchar(max),
  @pattern varchar(50),
  @replace varchar(20)
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
FROM dbo.NGrams2B(@string, 1) ng;
GO
