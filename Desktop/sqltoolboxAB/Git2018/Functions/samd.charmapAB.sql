SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[charmapAB]
(
  @asciiOnly BIT,
  @xmlCheck  BIT
) 
/*****************************************************************************************
[Purpose]:
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

[Developer Notes]:
 1. Have not determined UNICODE whitespace characters. 

[Examples]:
--===== Get a list of ASCII whitespace characters
  SELECT cm.* -- WhiteSpaceCharacters = 'CHAR('+CAST(n AS varchar(3))+')'
  FROM samd.CharmapAB(0,0) AS cm;

  SELECT cm.* -- WhiteSpaceCharacters = 'CHAR('+CAST(n AS varchar(3))+')'
  FROM samd.CharmapAB(1,1) AS cm;
 
-----------------------------------------------------------------------------------------
[Revision History]:
 Rev 00 - May 2015 - Initial Development - Alan Burstein
 Rev 01 - 20150819 changed whitespace val, column names, added quoted_val
        - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH rowz(N) AS (SELECT CASE @asciiOnly WHEN 0 THEN 255 ELSE 65535 END)
SELECT
char_nbr        = i.RN, 
ascii_val       = CHAR(cs.RN),
unicode_val     = u.unicode_val,
quoted_val      = uq.quoted_val,
is_unicode_only = SIGN(i.RN&256),
is_acsii_ws     = CASE WHEN cs.RN IN ((2),(9),(10),(13),(32),(160)) THEN 1 ELSE 0 END,
is_ascii_blank  = CASE WHEN cs.RN BETWEEN 28  AND 31 
                         OR cs.RN BETWEEN 129 AND 159 THEN 1 ELSE 0 END,
unicode_xml_val = x.unicode_xml_val,
bin             = CAST(NCHAR(cs.RN) AS varbinary)
FROM rowz
CROSS APPLY dbo.rangeAB(1,rowz.N,1,1)       AS i
CROSS APPLY (VALUES(CHECKSUM(i.RN)))        AS cs(RN)
CROSS APPLY (SELECT TOP (@xmlCheck*1) NCHAR(cs.RN) 
             WHERE @xmlCheck = 1 
             FOR XML PATH(''))              AS x(unicode_xml_val)
CROSS APPLY (VALUES(NCHAR(cs.RN)))          AS u(unicode_val)  
CROSS APPLY (VALUES('"'+u.unicode_val+'"')) AS uq(quoted_val);
GO
