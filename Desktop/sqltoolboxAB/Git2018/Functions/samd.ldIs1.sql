SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[ldIs1] (@s1 VARCHAR(8000), @s2 VARCHAR(8000))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP (1) 
  S1       = b.S1, 
  S2       = b.S2, 
  L1       = b.L1, 
  L2       = b.L2, 
  dropped  = ng.token, 
  position = ng.position, 
  maxSim   = (1.00*b.L1-b.D)/b.L2
FROM        samd.bernie8K(@s1,@s2) AS b
CROSS APPLY dbo.NGrams8k(b.S2,1)   AS ng
WHERE       b.D = 1 AND b.S1 = STUFF(b.S2,CHECKSUM(ng.position),1,'')
ORDER BY    ng.position;
GO
