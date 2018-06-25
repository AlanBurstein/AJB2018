SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[PatExclude8K_NXP]
(
    @String VARCHAR(8000),
	@Pattern VARCHAR(50)
) 
/*******************************************************************************
 Purpose:
 Given a string (@String) and a pattern (@Pattern) of characters to remove, 
 remove the patterned characters from the string.

Usage:
--===== Basic Syntax Example
 SELECT CleanedString 
 FROM dbo.PatExclude8K_NXP(@String,@Pattern);

--===== Remove all but Alpha characters
 SELECT CleanedString 
 FROM dbo.SomeTable st
 CROSS APPLY dbo.PatExclude8K(st.SomeString,'%[^A-Za-z]%');

--===== Remove all but Numeric digits
 SELECT CleanedString
 FROM dbo.SomeTable st
 CROSS APPLY dbo.PatExclude8K(st.SomeString,'%[^0-9]%');

 Programmer Notes:
 1. @Pattern is case sensitive (the function can be easily modified to make it so)
 2. There is no need to include the "%" before and/or after your pattern since since we 
	are evaluating each character individually

 Revision History:
 Rev 00 - 20180508 Initial Development - Alan Burstein

*******************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS
RETURN
WITH
E1(N) AS (SELECT N FROM (VALUES (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL)) AS X(N)),
itally(N) AS 
(
  SELECT TOP(CONVERT(INT,LEN(@String),0)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
  FROM E1 T1 CROSS JOIN E1 T2 CROSS JOIN E1 T3 CROSS JOIN E1 T4
) 
SELECT NewString =
(
  SELECT SUBSTRING(@String,N,1)
  FROM iTally
  WHERE 0 = PATINDEX(@Pattern,SUBSTRING(@String COLLATE Latin1_General_BIN,N,1))
  FOR XML PATH('')
)
GO
