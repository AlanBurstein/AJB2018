SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[boggleAxisX]()
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT axis='x', mb.RN, mb.seq, ss.itemLen, ss.itemIndex, ss.item
FROM dbo.boggle mb
CROSS APPLY samd.getAllSubstrings(mb.seq,4,0) ss;
GO
