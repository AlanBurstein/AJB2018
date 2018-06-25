SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ngrams_demo](@string varchar(8000), @k int)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT TOP (len(@string)+1-@k)
  position = N,
  token    = substring(@string,N,@k)
FROM dbo.tally;
GO
