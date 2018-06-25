SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[calculate_tiles](@tiles tinyint, @rows int)
RETURNS TABLE AS RETURN
SELECT TOP(@tiles) N, tile = (@rows/@tiles)+CASE WHEN N<=(@rows%@tiles) THEN 1 ELSE 0 END
FROM dbo.tally;


GO
