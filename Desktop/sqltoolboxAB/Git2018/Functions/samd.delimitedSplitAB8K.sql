SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[delimitedSplitAB8K]
(
  @string    VARCHAR(8000), -- input string
  @delimiter CHAR(1)        -- delimiter
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
/*****************************************************************************************
[Purpose]:
 Splits (tokenizes) an input string (@string) into rows based on a user-supplied delimiter
 (@delimiter). The functionality is identical to Jeff Moden's DelimitedSplit8K but with 
 added functionality: It returns the item's position in the string as well as it's length.

[Author]:
 Alan Burstein 
 (Based on Jeff Moden's DelimitedSplit8K)

[Compatibility]:
 SQL Server 2008+

[Syntax]:
--===== Autonomous
 SELECT ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM   samd.delimitedSplitAB8K(@string, @delimiter) AS ds;

--===== Against a table using APPLY
 SELECT t.someId, ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM        dbo.someTable AS t
 CROSS APPLY samd.delimitedSplitAB8K(t.someString, @delimiter) AS ds;

[Parameters]:
  @string    = VARCHAR(8000); input string to split
  @delimiter = CHAR(1); item delimiter

[Returns]:
 Inline table valued function returns:
  itemNumber = BIGINT; ordinal position of the item in the string
  itemIndex  = INT; position (charindex) of the item in the string
  itemLength = INT; length of the item
  item       = VARCHAR(8000); the item (token)

[Dependencies]:
 Requires samd.NGrams8K which is available here: https://goo.gl/ZHzVcw

[Developer Notes]:
 1. Returns a NULL item on NULL @string input 
 2. delimitedSplitAB8K is not case sensitive
 3. delimitedSplitAB8K is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx
 4. Opposite numbers can be used to circumvent a descending sort but my initial testing 
    showed that a descending sort performed better. 

[Examples]:
--===== 1. Against a variable
 DECLARE @string varchar(8000) = ',,abc,12345,z,,,', @delimiter char(1) = ',';

 SELECT ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM   samd.delimitedSplitAB8K(@string, @delimiter) AS ds;

--===== 2. Against a table
 DECLARE @table TABLE (someId INT IDENTITY, someString VARCHAR(8000));
 INSERT  @table(someString) VALUES ('abc,123'), ('xxx,yyy'), ('50,60,70');

 SELECT      t.someId, ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM        @table AS t
 CROSS APPLY samd.delimitedSplitAB8K(t.someString, ',') AS ds;

-----------------------------------------------------------------------------------------
[Revision History]: 
 Rev 00 - 20180704 - Created - Alan Burstein
*****************************************************************************************/
SELECT
  itemNumber   = ROW_NUMBER() OVER (ORDER BY d.p),
  itemIndex    = CHECKSUM(ISNULL(NULLIF(d.p+1, 0),1)),
  itemLength   = CHECKSUM(item.ln),
  item         = SUBSTRING(@string, d.p+1, item.ln)
FROM (VALUES (DATALENGTH(@string))) AS l(s) -- length of the string
CROSS APPLY
(
  SELECT 0 UNION ALL -- for handling leading delimiters
  SELECT ng.position
  FROM   samd.NGrams8K(@string, 1) AS ng
  WHERE  token = @delimiter
) AS d(p) -- delimiter.position
CROSS APPLY (VALUES(  --LEAD(d.p, 1, l.s+l.d) OVER (ORDER BY d.p) - (d.p+l.d)
  ISNULL(NULLIF(CHARINDEX(@delimiter,@string,d.p+1),0)-(d.p+1), l.s-d.p))) AS item(ln);
GO
