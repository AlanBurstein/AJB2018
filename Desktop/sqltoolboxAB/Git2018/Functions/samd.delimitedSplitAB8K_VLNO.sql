SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[delimitedSplitAB8K_VLNO]
(
  @string       VARCHAR(8000), -- input string
  @delimiter    VARCHAR(100)   -- row delimiter
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
/*****************************************************************************************
[Examples]:
--==== 1. Split the string on any sequence of four or more instances of "x"
 DECLARE
   @string    VARCHAR(1000) = 'xxxxxxx123xxABCxxxPPPPPxxxxxxx$2,255.77xxxx$1,000.000',
   @delimiter VARCHAR(30)   = 'xxxx';
 
 SELECT s.itemNumber, s.itemIndex, s.itemLength, s.item
 FROM   samd.delimitedSplitAB8K_VLNO(@string,@delimiter) AS s; 

--==== 2. Parse forumn contents based on two or more of: ">"
 DECLARE @string VARCHAR(1000) = -- 4 > 3 
 '>>>Then he said "hi" >>the answer is: 4 &gt; 3 
 >> another line of text
 >>>> even more text';
 
 SELECT s.itemNumber, s.itemIndex, s.itemLength, s.item
 FROM   samd.delimitedSplitAB8K_VLNO(@string,'>>') AS s;

--==== 3. Using REPLICATE for easier pattern creation
 -- Treat 20 or more hyphens as a delimiter, note the alias functions

 DECLARE @string VARCHAR(1000)  = 
  'Notes: blah, blah, blah....
   ---------------------------
   Details: yada, yada.....
   -------------------------
   Credits: John Smith, Pete Rose, Peter Beefeater';

 SELECT       s.itemNumber, s.itemIndex, s.itemLength, item = LTRIM(REPLACE(s.item,L.br,''))
 FROM         samd.delimitedSplitAB8K_VLNO(@string,REPLICATE('-',20)) AS s
 CROSS APPLY (VALUES(CHAR(13)+CHAR(10))) AS L(br);

--===== Results:
 itemNumber  itemIndex   itemLength  item
 ----------- ----------- ----------- -----------------------------------------------
 1           1           31          Notes: blah, blah, blah....  
 2           59          32          Details: yada, yada.....  
 3           116         51          Credits: John Smith, Pete Rose, Peter Beefeater
*****************************************************************************************/
SELECT
  itemNumber = ROW_NUMBER() OVER (ORDER BY items.itemGroup),
  items.itemIndex,
  items.itemLength,
  item = SUBSTRING(@string, items.itemIndex, items.itemLength)
FROM
(
  SELECT 
    itemGroup  = d.g, 
    itemIndex  = MAX(d.p), 
    itemLength = CHECKSUM(ISNULL(NULLIF(CHARINDEX(@delimiter,@string,MAX(d.p)),0),
                   DATALENGTH(@string)+1)-MAX(d.p))
  FROM
  (
    SELECT -1, 1 WHERE CHARINDEX(@delimiter,@string) <> 1 UNION ALL
    SELECT CHECKSUM(ng.position - ROW_NUMBER() OVER (ORDER BY ng.position)), 
           CHECKSUM(ng.position + DATALENGTH(@delimiter))
    FROM   dbo.NGrams8k(@string, DATALENGTH(@delimiter)) AS ng
    WHERE  ng.token = @delimiter
  ) d(g,p) -- delimiter.grouper, delimiter.position
  GROUP BY d.g
) AS items
WHERE items.itemIndex <= DATALENGTH(@string);
GO
