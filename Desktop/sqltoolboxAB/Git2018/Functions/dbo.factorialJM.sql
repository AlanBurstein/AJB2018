SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[factorialJM](@N BIGINT)
RETURNS BIGINT WITH SCHEMABINDING AS 
BEGIN
 DECLARE @Factorial BIGINT = 1;

 SELECT TOP (@N) @Factorial = @Factorial * t.N 
 FROM dbo.tally t
 ORDER BY t.N;

 RETURN @Factorial;
END
GO
