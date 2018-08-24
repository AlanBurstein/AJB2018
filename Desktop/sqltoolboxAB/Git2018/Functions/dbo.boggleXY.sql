SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[boggleXY]()
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT xy.axis, xy.y, xy.x
FROM dbo.rangeAB(-2,2,1,1) AS r
CROSS APPLY
(
  SELECT 
    y    = y.rn, 
    x    = x.rn, 
    axis = axis.xy
  FROM       dbo.rangeAB(1,4,1,1) AS x
  CROSS JOIN dbo.rangeAB(1,4,1,1) AS y
  CROSS APPLY (VALUES(x.rn-y.rn)) AS axis(xy)
  WHERE axis.xy = r.N1
) xy
GO
