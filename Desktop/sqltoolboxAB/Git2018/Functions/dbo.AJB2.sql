SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[AJB2] (@string varchar(30))
RETURNS TABLE /*WITH SCHEMABINDING*/ AS RETURN 
SELECT FINAL_STR = 
  REPLACE((
  SELECT substring(@string,n1,1) + replicate('|', sign(len(@string)-n1))+''
  FROM dbo.getnumsAB(1,len(@string),4,1)
  WHERE substring(@string,n1,1) <> substring(@string,n2,1)
  ORDER BY rn
  FOR XML PATH('')),'|',' > ')
GO
