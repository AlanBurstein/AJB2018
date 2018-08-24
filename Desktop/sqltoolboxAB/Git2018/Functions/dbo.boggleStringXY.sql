SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[boggleStringXY]()
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  xy.axis, 
  seq = 
  (
    SELECT STRING_AGG(sa.item,'') WITHIN GROUP (ORDER BY xy.y)
		FROM dbo.boggleXY() AS ixy
    WHERE xy.axis = ixy.axis
    GROUP BY ixy.axis
  )
FROM dbo.boggleXY() AS xy
CROSS APPLY dbo.boggleStringArray(xy.y,xy.x) AS sa
GROUP BY xy.axis;
GO
