SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--====== 2. function to dbo.nview.id into a random number between 
CREATE FUNCTION [dbo].[randomNumbers](@rows INT, @low INT, @high INT)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT rn = r.rn, rnbr = ABS(CHECKSUM(new.id)%ABS(@high-@low)+1)+@low
FROM dbo.vnewid new
CROSS JOIN dbo.rangeAB(1,@rows,1,1) r
WHERE @rows > 0;
GO
