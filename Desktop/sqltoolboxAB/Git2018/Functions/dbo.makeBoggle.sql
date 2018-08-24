SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[makeBoggle]()
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH letter(seq) AS
(
  SELECT CHAR(r1.rnbr)+CHAR(r2.rnbr)+CHAR(r3.rnbr)+CHAR(r4.rnbr)
  FROM       dbo.randomNumbers(1,65,90) r1
  CROSS JOIN dbo.randomNumbers(1,65,90) r2
  CROSS JOIN dbo.randomNumbers(1,65,90) r3
  CROSS JOIN dbo.randomNumbers(1,65,90) r4
)
SELECT RN = 1,  l.seq FROM letter l UNION ALL
SELECT RN = 2,  l.seq FROM letter l UNION ALL
SELECT RN = 3,  l.seq FROM letter l UNION ALL
SELECT RN = 4,  l.seq FROM letter l;
GO
