SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[boggleAxisXY]()
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  axis = 'xy', 
  RN   = xy.axis, 
  xy.seq, 
  ss.itemLen, 
  ss.itemIndex, 
  ss.item
FROM dbo.boggleStringXY() AS xy
CROSS APPLY samd.getAllSubstrings(xy.seq,NULL,0) ss
WHERE ss.itemLen > 1;
GO
