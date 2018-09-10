SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[translate8K_2017]
(
  @inputString  VARCHAR(8000), 
  @characters   VARCHAR(8000), 
  @translations VARCHAR(8000)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
/*
-- Masking possible PII
DECLARE @inputstring VARCHAR(8000) = 
  'I don''t know if you got my SSN but it''s 555-90-5511. Call me at 312.800.5555';

SELECT t.newstring
FROM samd.translate8K(@inputString, '0123456789', REPLICATE('#',10)) t;

Created: 20180725
*/
SELECT newstring = STRING_AGG(IIF(c.chr>c.tx,'',IIF(c.chr>0,t.chr, ng.token)),'')
                     WITHIN GROUP (ORDER BY ng.position)
FROM dbo.NGrams8k(@inputString,1) ng   -- c = cursor, chr = character, tx = translation:
CROSS APPLY (VALUES(CHARINDEX(ng.token, @characters), LEN(@translations))) c(chr,tx)
CROSS APPLY (VALUES(SUBSTRING(@translations,c.chr,1))) t(chr);
GO
