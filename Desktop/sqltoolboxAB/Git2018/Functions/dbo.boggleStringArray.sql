SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[boggleStringArray](@seqNbr TINYINT, @itemIndex TINYINT)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  seqNbr    = @seqNbr, 
  array     = item.array, 
  string    = f.item, 
  item      = SUBSTRING(f.item,@itemIndex,1),
  itemIndex = @itemIndex
FROM dbo.O(1,4,@seqNbr) AS O
CROSS JOIN 
(
  SELECT STRING_AGG(mb.seq,'.') WITHIN GROUP (ORDER BY mb.RN) 
	FROM dbo.boggle mb
) AS item(array)
CROSS APPLY (VALUES(PARSENAME(item.array,O.Op))) f(item);
GO
