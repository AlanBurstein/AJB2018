SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[TopN](@rows int, @n int)  -- n is the number of rows
RETURNS TABLE AS RETURN
SELECT TOP(@rows) n = @n
FROM dbo.tally T1;
GO
