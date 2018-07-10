SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[addCommasToNumber3](@string VARCHAR(39))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  upperBoundry    = IIF(it.floats=1 AND d.p<32, s9.d, NULL),
  wholeNumber     = IIF(it.floats=1 AND d.p<32, s9.s, NULL),
  formattedNumber = IIF(it.floats=1 AND d.p<32, CONCAT(s9.s,it.b), NULL)
FROM (VALUES (ISNULL(NULLIF(CHARINDEX('.', @string),0),LEN(@string)+1), @string)) d(p,s)
CROSS APPLY (VALUES (
  IIF(TRY_CAST(@string AS FLOAT) IS NOT NULL AND CHARINDEX('-',@string) < 2,1,0),
  SUBSTRING(d.s,1,d.p-1), SUBSTRING(d.s,d.p,8000),
  CHARINDEX('-',@string))) it(floats,a,b,c)
CROSS APPLY (VALUES (
  IIF(d.p-it.c < 5, it.a,  STUFF(it.a,d.p-3,0,',')),
  CONCAT('thousand', IIF(d.p-it.c < 5,'-','+')))) s1(s,d)
CROSS APPLY (VALUES (
  IIF(d.p-it.c < 8, s1.s, STUFF(s1.s,d.p-6,0,',')),
  IIF(d.p-it.c < 8, s1.d, 'million+'))) s2(s,d)
CROSS APPLY (VALUES (
  IIF(d.p<11, s2.s, STUFF(s2.s,d.p-9,0,',')),
  IIF(d.p<11, s2.d, 'billion+'))) s3(s,d)
CROSS APPLY (VALUES (
  IIF(d.p<14, s3.s, STUFF(s3.s,d.p-12,0,',')),
  IIF(d.p<14, s3.d, 'trillion+'))) s4(s,d)
CROSS APPLY (VALUES (
  IIF(d.p<17, s4.s, STUFF(s4.s,d.p-15,0,',')),
  IIF(d.p<17, s4.d, 'Quadrillion+'))) s5(s,d)
CROSS APPLY (VALUES (
  IIF(d.p<20, s5.s, STUFF(s5.s,d.p-18,0,',')),
  IIF(d.p<20, s5.d, 'Quintillion+'))) s6(s,d)
CROSS APPLY (VALUES (
  IIF(d.p<23, s6.s, STUFF(s6.s,d.p-21,0,',')),
  IIF(d.p<23, s6.d, 'Sextillion+'))) s7(s,d)
CROSS APPLY (VALUES (
  IIF(d.p<26, s7.s, STUFF(s7.s,d.p-24,0,',')),
  IIF(d.p<26, s7.d, 'Septillion+'))) s8(s,d)
CROSS APPLY (VALUES (
  IIF(d.p<29, s8.s, STUFF(s8.s,d.p-27,0,',')),
  IIF(d.p<29, s8.d, 'Octillion+'))) s9(s,d);
GO
