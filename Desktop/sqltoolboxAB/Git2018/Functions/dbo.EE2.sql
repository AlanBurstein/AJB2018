SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[EE2] (@string varchar(30))
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
WITH T(N) AS (SELECT X.N FROM (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) X(N))
,SAMPLE_DATA AS 
(
  SELECT 
    ROW_NUMBER() OVER (ORDER BY @@VERSION) AS STR_RID
   ,S.str_raw
  FROM (VALUES (@string)) S(str_raw)
),
GROUPED_SET AS
(
SELECT 
  SS.STR_RID
 ,SS.str_raw + ' >' AS INP_STR
 ,NUMS.N
 ,SUBSTRING(SS.str_raw + ' > ',(NUMS.N * 4) -3, 4) AS GRP_STR
FROM SAMPLE_DATA SS
CROSS APPLY 
(
  SELECT TOP((LEN(SS.str_raw) + 3) / 4 )
    ROW_NUMBER() OVER (ORDER BY @@VERSION) AS N 
  FROM T T1,T T2,T T3,T T4
) 
NUMS(N)
)
,COMP_SET AS 
(
SELECT
 GS.STR_RID
  ,GS.GRP_STR
  ,LEAD(GS.GRP_STR,1,NULL) OVER 
    (
    PARTITION BY GS.STR_RID
    ORDER BY   GS.N 
    ) AS CMP_STR
  ,GS.N
FROM GROUPED_SET  GS
)
,OUTPUT_SET AS
(
  SELECT  
  CS.STR_RID
  ,(
    SELECT 
    CONCAT
      (
        ''
        ,CASE 
        WHEN CSS.GRP_STR = CSS.CMP_STR THEN ''
        ELSE CSS.GRP_STR
        END 
      )
    FROM  COMP_SET    CSS
    WHERE CSS.STR_RID = CS.STR_RID
    FOR XML PATH ('')
  ) AS OUT_STR_RAW
  FROM  COMP_SET  CS
  GROUP BY CS.STR_RID
)
SELECT
 REPLACE(STUFF(OS.OUT_STR_RAW, LEN(OS.OUT_STR_RAW) - 3,5,''), '&gt;','>') AS FINAL_STR
FROM OUTPUT_SET OS;
GO
