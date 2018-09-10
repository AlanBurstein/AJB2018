SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[addCommasToNumber](@N VARCHAR(100))
/*****************************************************************************************
Purpose:
 Formats a number to include commmas. For example: 12345678 becomes 1,234,678. Decimal 
 data types and leading +/- symbols are also handled; e.g. -1234.99 becomes -1,234.99.

Compatibility: 
 SQL Server 2008+

Syntax:
--===== Autonomous
 SELECT f.formattedNumber, f.wholeNumber
 FROM addCommasToNumber(@N) f;

--===== Against a table using APPLY
 SELECT f.formattedNumber, f.wholeNumber
 FROM dbo.someTable t
 CROSS APPLY addCommasToNumber(t.col) f;

Parameters:
  @N = VARCHAR(100); The number to format

Returns:
 Inline table valued function returns -
  formattedNumber = varchar(39); new formatted number including +/- prefix and numbers 
                    after the decimal when required.
  wholeNumber     = varchar(39); the formatted number without the decimal and following 
                    numbers

Developer Notes:
 1. Requires NGrams8K
 2. Returns NULL on NULL on non-numeric inputs.
 3. addCommasToNumber performs substantially better with a parallel execution plan, often 
    2-3 times faster. For queries that leverage addCommasToNumber that are not getting a 
    parallel exeution plan you should consider performance testing using Traceflag 8649 in 
    Development environments and Adam Machanic's make_parallel in Production. 
 4. addCommasToNumber is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

Usage Examples:

--===== 1. Basic Usage
 SELECT f.formattedNumber, f.wholeNumber
 FROM samd.addCommasToNumber(1999123.554433) f;

---------------------------------------------------------------------------------------
Revision History: 
 Rev 00 - 20180629 - initial development - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT 
  formattedNumber = 
    CAST(ISNULL(CASE WHEN a.isclean&a.itfloats = 1 AND a.prefix < 2 
         THEN string.front+nbr.formatted+string.rght END,0) AS VARCHAR(100)),
  wholeNumber    = CAST(string.front+nbr.formatted AS VARCHAR(100))
FROM (VALUES(
  PATINDEX('%[-+]%',SUBSTRING(@N,1,100)),         -- position of the + or - if one exists
  ABS(CAST(PATINDEX('[^+0-9.-]%', @N) AS BIT)-1), -- check the string for bad characters
  ISNULL(NULLIF(CHARINDEX('.',@N),0),LEN(@N)+1),  -- decimal place if there's a decimal
  CAST(TRY_CAST(@N AS FLOAT) AS BIT))) a(prefix,isclean,dot,itfloats) -- is a valid number?
CROSS APPLY (VALUES(
  SUBSTRING(@N, 1, a.prefix),
  SUBSTRING(@N, 1+a.prefix, a.dot-a.prefix-1),
  SUBSTRING(@N, a.dot, LEN(@N))
)) string(front,lft,rght) -- front of string, left of decimal, right of decimal
CROSS APPLY
(
  SELECT REVERSE(SUBSTRING(REVERSE(string.lft),r.op*3+1,3)) + REPLICATE(',',SIGN(r.op))
  FROM dbo.rangeAB(1, ((LEN(string.lft)-1)/3)+1, 1, 0) r
  ORDER BY r.rn
  FOR XML PATH('')
) nbr(formatted);
GO
