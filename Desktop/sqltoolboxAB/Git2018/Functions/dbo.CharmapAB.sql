SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CharmapAB](@asciiOnly BIT) 
/****************************************************************************************
Purpose:
 Generates a table containing the numbers 1 through 65535 along with the
 corrsponding CHAR(N) value (e.g. CHAR(65) = "A") and/or UNICODE value (e.g. 
 NCHAR(324) = "ń", aka the Latin minuscule: ń. 

 The ascii_xml_special and unicode_xml_special columns at bits that indicate if 
 the character is an ASCII or UNICODE Reserved XML character. The ascii_xml and 
 unicode_xml colummns show what will be displayed when the character is output as
 in XML format (e.g. SELECT CAST('>' AS XML) will return "&gt;". 

 is_ascii_whitespace indicates if the character is a "whitespace character" (such
 as CHAR(9), CHAR(32) and CHAR(160)). abin is the character's ascii binary value 
 and ubin is the characters unicode binary value. 

Developer Notes:
 1. Have not determined UNICODE whitespace characters. 

Examples:
--===== Get a list of ASCII whitespace characters
  SELECT * -- WhiteSpaceCharacters = 'CHAR('+CAST(n AS varchar(3))+')'
  FROM dbo.CharmapAB()
  WHERE is_ascii_whitespace = 1;

---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - May 2015 - Initial Development - Alan Burstein
 Rev 01 - 20150819 changed whitespace val, column names, added quoted_val
        - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH


E1(n) AS (SELECT n FROM (VALUES (1),(9),(10),(13),(32),(160)) x(n)),  -- WhiteSpace Characters
iTally(N) AS 
(
  SELECT TOP(CASE @asciiOnly WHEN 0 THEN 255 ELSE 65535 END) 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
  FROM E1 T1, E1 T2, E1 T3, E1 T4, E1 T5, E1 T6, E1 T7
), 
chars AS
(
  SELECT
	n, 
	ascii_val = char(n),
	unicode_val = nchar(n),
	ascii_xml_val = (SELECT char(n) FOR XML PATH('')),
	unicode_xml_val = (SELECT nchar(n) FOR XML PATH('')),
	is_unicode_only = CASE WHEN n < 256 THEN 0 ELSE 1 END
  FROM iTally
)
SELECT	
  char_nbr = c.n, 
  ascii_val, 
  quoted_val = '"'+CASE WHEN c.n <= 255 THEN ascii_val ELSE unicode_val END+'"', 
  unicode_val, 
  ascii_xml_val,
  unicode_xml_val,
  ascii_xml_special = charindex('&',ascii_xml_val),			
  unicode_xml_special = charindex('&',unicode_xml_val),
  is_unicode_only,
  is_ascii_whitespace = abs(isnull(x.n - x.n - 1,0)),
  abin = CAST(ascii_val AS varbinary),
  ubin = CAST(unicode_val AS varbinary)
FROM chars c
LEFT JOIN E1 x
ON c.n = x.n;
GO
