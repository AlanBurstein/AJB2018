SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[boggleStringY]()
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT r.RN, seq = vertical.string
FROM dbo.rangeAB(1,4,1,1) r
CROSS APPLY
(
  SELECT STRING_AGG(ng.token,'') WITHIN GROUP (ORDER BY mb.RN)
  FROM dbo.boggle AS mb
  CROSS APPLY dbo.ngrams8k(mb.seq,1) AS ng
  WHERE ng.position = r.RN --@pos (replace parameter value with r.RN)
) vertical(string);
GO
