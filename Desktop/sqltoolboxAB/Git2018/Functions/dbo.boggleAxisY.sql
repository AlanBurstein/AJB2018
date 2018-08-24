SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[boggleAxisY]()
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT axis='y', y.RN, y.seq, ss.itemLen, ss.itemIndex, ss.item
FROM dbo.boggleStringY() AS y
CROSS APPLY samd.getAllSubstrings(y.seq,3,0) ss;
GO
