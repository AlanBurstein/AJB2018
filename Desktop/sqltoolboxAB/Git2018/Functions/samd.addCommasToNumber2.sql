SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[addCommasToNumber2](@string VARCHAR(39))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH it AS 
(
  SELECT d.p, it.floats, it.a, it.b, it.c
  FROM (VALUES (ISNULL(NULLIF(CHARINDEX('.', @string),0),LEN(@string)+1), @string)) d(p,s)
  CROSS APPLY (VALUES (
    IIF(TRY_CAST(@string AS FLOAT) IS NOT NULL AND CHARINDEX('-',@string) < 2 , 1, 0),
		SUBSTRING(d.s,1,d.p-1), SUBSTRING(d.s,d.p,80), CHARINDEX('-',@string))) it(floats,a,b,c)
), s1(s,d) AS
( SELECT IIF(it.p-it.c < 5,  it.a, STUFF(it.a,it.p-3,0,',')),
         IIF(it.p-it.c < 5, 'single digits','thousand+')
  FROM it
), s2(s,d) AS
( SELECT IIF(it.p-it.c < 8, s1.s, STUFF(s1.s,it.p-6, 0,',')), 
         IIF(it.p-it.c < 8, s1.d, 'million+')
  FROM it CROSS JOIN s1		 						 
), s3(s,d) AS							 						 
( SELECT IIF(it.p-it.c < 11, s2.s, STUFF(s2.s, it.p-9, 0,',')), 
         IIF(it.p-it.c < 11, s2.d, 'billion+') 
  FROM it CROSS JOIN s2		 	 					 
), s4(s,d) AS 						 	 
( SELECT IIF(it.p-it.c < 14, s3.s, STUFF(s3.s, it.p-12,0,',')), 
         IIF(it.p-it.c < 14, s3.d, 'trillion+') 
  FROM it CROSS JOIN s3		 						 
), s5(s,d) AS							 						 
( SELECT IIF(it.p-it.c < 17,s4.s, STUFF(s4.s, it.p-15,0,',')), 
         IIF(it.p-it.c < 17,s4.d, 'quadrillion+')
  FROM it CROSS JOIN s4		 						 
), s6(s,d) AS							 						 
( SELECT IIF(it.p-it.c < 20,s5.s, STUFF(s5.s, it.p-18,0,',')), 
         IIF(it.p-it.c < 20,s5.d, 'quintillion+') 
  FROM it CROSS JOIN s5		 						 
), s7(s,d) AS
( SELECT IIF(it.p-it.c < 23, s6.s, STUFF(s6.s, it.p-21,0,',')), 
         IIF(it.p-it.c < 23, s6.d,'sextillion+') 
  FROM it CROSS JOIN s6		 						 
), s8(s,d) AS							 						 
( SELECT IIF(it.p-it.c < 26,s7.s, STUFF(s7.s, it.p-24,0,',')), 
         IIF(it.p-it.c < 26,s7.d, 'septillion+') 
  FROM it CROSS JOIN s7		 						 
), s9(s,d) AS							 						 
( SELECT IIF(it.p-it.c < 29,s8.s, STUFF(s8.s, it.p-27,0,',')), 
         IIF(it.p-it.c < 29,s8.d, 'octillion+') 
  FROM it CROSS JOIN s8		 						 
)
SELECT
  upperBoundry    = IIF(it.floats=1 AND it.p<32, s9.d, NULL), 
  wholeNumber     = IIF(it.floats=1 AND it.p<32, s9.s, NULL), 
  formattedNumber = IIF(it.floats=1 AND it.p<32, CONCAT(s9.s,it.b), NULL)
FROM it CROSS JOIN s9;
GO
