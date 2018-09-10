SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--====== 2. function to dbo.nview.id into a random number between 
CREATE FUNCTION [dbo].[randomNumbers](@rows INT, @low INT, @high INT)
/*****************************************************************************************
--====== Exeamples
;
--== 1. get 10 rows of random numbers between 1 and 5
SELECT random.rn, random.rnbr FROM dbo.randomNumbers(10,1,5) random;

--== 2. get 100 rows of random numbers between -3 and 3
SELECT random.rn, random.rnbr FROM dbo.randomNumbers(100,-3,3) random;

--==  3. get 10 rows of distinct increasing random numbers 
SELECT random.rn, random.rnbr, distinctN = SUM(random.rnbr) OVER (ORDER BY random.rn)
FROM dbo.randomNumbers(10,1,20) random

--== 4. get 25 rows of random numbers:
-- 1st column bewteen 1,000,000 and 9,999,999, 2nd column between 500.00 and 2,400.99
SELECT
  r1.rn,
  random1 = r1.rnbr,
  random2 = CAST(CONCAT(r2.rnbr,'.',r3.rnbr) AS DECIMAL(6,2))
FROM       dbo.randomNumbers(25,1000000,9999999)r1
CROSS JOIN dbo.randomNumbers(1,500,2499) r2
CROSS JOIN dbo.randomNumbers(1,0,99) r3
--OPTION (QUERYTRACEON 8649) -- Note highly parallelizable
;

--== 5. Generate a random 6-letter sequence where each value can be between 0 to 9 or A to Z
SELECT CONCAT(CHAR(l1.rnbr), CHAR(l2.rnbr),CHAR(l3.rnbr),
              CHAR(l4.rnbr), CHAR(l5.rnbr),CHAR(l6.rnbr))
FROM        dbo.randomNumbers(1,1,3) r1 -- 1 in 3 chance that r1.rnbr = 1
CROSS JOIN  dbo.randomNumbers(1,1,3) r2
CROSS JOIN  dbo.randomNumbers(1,1,3) r3
CROSS JOIN  dbo.randomNumbers(1,1,3) r4
CROSS JOIN  dbo.randomNumbers(1,1,3) r5
CROSS JOIN  dbo.randomNumbers(1,1,3) r6
CROSS APPLY (VALUES(
  IIF(r1.rnbr=1,1,2), IIF(r2.rnbr=1,1,2), IIF(r3.rnbr=1,1,2), 
	IIF(r4.rnbr=1,1,2), IIF(r5.rnbr=1,1,2), IIF(r6.rnbr=1,1,2))) r(r1,r2,r3,r4,r5,r6)
CROSS APPLY (VALUES (IIF(r.r1=1,48,65), IIF(r.r1=1,10,26))) v1(s,r) -- value.(start|rows)
CROSS APPLY (VALUES (IIF(r.r2=1,48,65), IIF(r.r2=1,10,26))) v2(s,r)
CROSS APPLY (VALUES (IIF(r.r3=1,48,65), IIF(r.r3=1,10,26))) v3(s,r)
CROSS APPLY (VALUES (IIF(r.r4=1,48,65), IIF(r.r4=1,10,26))) v4(s,r)
CROSS APPLY (VALUES (IIF(r.r5=1,48,65), IIF(r.r5=1,10,26))) v5(s,r)
CROSS APPLY (VALUES (IIF(r.r6=1,48,65), IIF(r.r6=1,10,26))) v6(s,r)
CROSS APPLY dbo.randomNumbers(1,v1.s, v1.s+v1.r-1) l1
CROSS APPLY dbo.randomNumbers(1,v2.s, v1.s+v2.r-1) l2
CROSS APPLY dbo.randomNumbers(1,v3.s, v1.s+v3.r-1) l3
CROSS APPLY dbo.randomNumbers(1,v4.s, v1.s+v4.r-1) l4
CROSS APPLY dbo.randomNumbers(1,v5.s, v1.s+v5.r-1) l5
CROSS APPLY dbo.randomNumbers(1,v6.s, v1.s+v6.r-1) l6;
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT rn = r.rn, rnbr = ABS(CHECKSUM(new.id)%ABS(@high-@low)+1)+@low
FROM dbo.vnewid new
CROSS JOIN dbo.rangeAB(1,@rows,1,1) r
WHERE @rows > 0;
GO
