SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[PatternSplitCM]
(
       @List                VARCHAR(8000) = NULL
       ,@Pattern            VARCHAR(50)
) RETURNS TABLE WITH SCHEMABINDING 
AS 

RETURN
    WITH numbers AS (
      SELECT TOP(ISNULL(DATALENGTH(@List), 0))
       n = ROW_NUMBER() OVER(ORDER BY (SELECT NULL))
      FROM
      (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) d (n),
      (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) e (n),
      (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) f (n),
      (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) g (n))

    SELECT
      ItemNumber = ROW_NUMBER() OVER(ORDER BY MIN(n)),
      Item = SUBSTRING(@List,MIN(n),1+MAX(n)-MIN(n)),
      [Matched]
     FROM (
      SELECT n, y.[Matched], Grouper = n - ROW_NUMBER() OVER(ORDER BY y.[Matched],n)
      FROM numbers
      CROSS APPLY (
          SELECT [Matched] = CASE WHEN SUBSTRING(@List,n,1) LIKE @Pattern THEN 1 ELSE 0 END
      ) y
     ) d
     GROUP BY [Matched], Grouper
GO
