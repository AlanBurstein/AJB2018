SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnLevDist](@a VARCHAR(255), @b VARCHAR(255), @minScoreHint FLOAT=0) 
RETURNS INT AS 
BEGIN
    DECLARE @scaler REAL = CASE WHEN LEN(@a)>LEN(@b) THEN LEN(@a) ELSE LEN(@b) END
    RETURN ROUND((1.0 - clr.Similarity(@a, @b, 0, 0, @minScoreHint)) * @scaler, 0)
END
GO
