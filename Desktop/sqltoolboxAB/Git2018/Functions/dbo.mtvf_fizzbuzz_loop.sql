SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[mtvf_fizzbuzz_loop](@rows int)
RETURNS @table TABLE (N int, fizzbuzz char(10)) WITH SCHEMABINDING AS 
BEGIN
  DECLARE @i int = 0;
  WHILE @i < @rows
  BEGIN
    SET @i+=1;
    INSERT @table VALUES (@i,
      CASE WHEN @i%3=0 THEN 'fizz' ELSE '' END + CASE WHEN @i%5=0 THEN 'buzz' ELSE '' END)
  END
  RETURN;
END
GO
