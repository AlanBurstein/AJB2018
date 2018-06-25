SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[assemble_tiles](@tiles tinyint, @rows int)
RETURNS TABLE AS RETURN
(
  SELECT tile = t.n
  FROM dbo.calculate_tiles(@tiles, @rows) ct
  CROSS APPLY dbo.topn(ct.tile, ct.n) t
);
GO
