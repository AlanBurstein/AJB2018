SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[getAllSubstrings](@string varchar(8000))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  itemSort  = L.rn,
  itemLen   = L.op,
  item      = ng.token
FROM dbo.rangeAB(1,LEN(@string),1,1) L
CROSS APPLY dbo.rangeAB(1,L.rn,1,1) P
CROSS APPLY (VALUES (SUBSTRING(@string,P.rn,L.op))) ng(token)
GO
