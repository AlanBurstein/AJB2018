SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[xyAxis](@axis SMALLINT)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  y    = y.rn, 
  x    = x.rn, 
  axis = axis.xy
FROM       dbo.rangeAB(1,4,1,1) AS x
CROSS JOIN dbo.rangeAB(1,4,1,1) AS y
CROSS APPLY (VALUES(x.rn-y.rn)) AS axis(xy)
WHERE axis.xy = @axis;
GO
