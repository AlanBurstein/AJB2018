SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[NTallyV1](@tiles tinyint, @rows int)
RETURNS TABLE AS RETURN
SELECT rn = ROW_NUMBER() OVER (ORDER BY tile), -- This does not affect the query plan
       tile
FROM dbo.assemble_tiles(@tiles, @rows);
GO
