SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[NTally](@tiles bigint, @rows bigint)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH
calculate_tiles AS	-- 1. dbo.caclulate tiles
(
  SELECT t.N, tile = (@rows/@tiles) + CASE WHEN t.N <= (@rows%@tiles) THEN 1 ELSE 0 END
  FROM dbo.tally t
  WHERE t.N <= @tiles
),
assemble_tiles AS -- 3. dbo.assemble_tiles
(
  SELECT tile = topn.N
  FROM calculate_tiles ct -- dbo.calculate_tiles results fed to dbo.topn
  CROSS APPLY
  (
    SELECT TOP(ct.tile) N = ct.N
    FROM dbo.tally t1 CROSS JOIN dbo.tally t2 -- Up to 1 trillion rows per tile group
  ) topn        -- 2. dbo.topn
)
SELECT TOP 100 PERCENT
  rn = ROW_NUMBER() OVER (ORDER BY a.tile), -- Your Anchor
  a.tile
FROM assemble_tiles a  -- Your “NTally” Table
ORDER BY a.tile;       -- Your spoon

GO
