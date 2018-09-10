SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dates].[castAsXMLDate](@date DATE)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
-- RETURNS: YYYY-MM-DDThh:mm:dd
SELECT xmlDate = 
  CASE WHEN ISDATE(LTRIM(@date))=1 -- To force a NULL output on NULL Input
       THEN CONCAT(dt.y,'-',                                -->> YYYY-
              REPLICATE('0',2-LEN(dt.m)), dt.m,'-',         -->> MM-
              REPLICATE('0',2-LEN(dt.d)), dt.d,'T00:00:00') -->> DDThh:mm:ss
  END
FROM (VALUES (YEAR(@date), MONTH(@date), DAY(@date))) dt(y,m,d);
-- NOTE #2: The CASE statement only returns a value when @date is a valid date, otherwise 
-- it returns a NULL. This is required because CONCAT treats NULLs as a blank string --
-- which means that, on a NULL input, without the CASE statment the function would 
-- return: "--T00:00:00"

-- NOTE #1: The function uses AB forumula to return 0 & 1 as finite opposites:
-- WHEN LEN(dt.m)=2 we want 0, LEN(dt.m)=1 We want 1
-- N=LEN(dt.?)=(1 or 2), H=1, L=0: H+L-N = (2-1)+1-N = 2-N
GO
