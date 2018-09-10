SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[delimitedSplitABN4K]
(
  @string       NVARCHAR(4000),
  @delimiter    NCHAR(1)
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
/*****************************************************************************************
Purpose:
 Splits (tokenizes) an NVARCHAR(4000) input string (@string) into rows based on a 
 user-supplied NCHAR(1) delimiter (@delimiter). The functionality is identical to Jeff 
 Moden's DelimitedSplit8K but with added functionality: it returns the item's position 
 in the string as well as it's length.

Compatibility: 
 SQL Server 2008+

Syntax:
--===== Autonomous
 SELECT ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM samd.delimitedSplitABN4K(@string, @delimiter) ds;

--===== Against a table using APPLY
 SELECT t.someId, ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM dbo.someTable t
 CROSS APPLY samd.delimitedSplitABN4K(t.someString, @delimiter) ds;

Parameters:
  @string    = VARCHAR(4000); input string to split
  @delimiter = NCHAR(1); item delimiter

Returns:
 Inline table valued function returns:
 itemNumber = bigint; ordinal position of the item in the string
 itemIndex  = int; position (charindex) of the item in the string
 itemLength = int; length of the item
 item       = VARCHAR(4000); the item (token)

Developer Notes:
 1. Requires NGramsN4K which is available here: https://goo.gl/ZHzVcw
 2. Returns a NULL item on NULL @string input 
 3. delimitedSplitABN4K is not case sensitive
 4. delimitedSplitABN4K is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

Usage Examples:

--===== 1. Against a variable
 DECLARE @string VARCHAR(4000) = ',,abc,12345,z,,,', @delimiter NCHAR(1) = ',';

 SELECT ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM samd.delimitedSplitABN4K(@string, @delimiter) ds;

--===== 2. Against a table
 DECLARE @table TABLE (someId INT IDENTITY, someString VARCHAR(8000));
 INSERT @table(someString) VALUES ('abc,123'), ('xxx,yyy'), ('1,2,3');

 SELECT t.someId, ds.itemNumber, ds.itemIndex, ds.itemLength, ds.item
 FROM @table t
 CROSS APPLY samd.delimitedSplitABN4K(t.someString, ',') ds;

---------------------------------------------------------------------------------------
Revision History: 
 Rev 00 - 20180704 - Created - Alan Burstein
*****************************************************************************************/
SELECT
  itemNumber = ROW_NUMBER() OVER (ORDER BY d.p),
  itemIndex  = CHECKSUM(ISNULL(NULLIF(d.p+l.d, 0),1)),
  itemLength = CAST(item.ln AS INT),
  item       = SUBSTRING(@string, d.p+l.d, item.ln)
FROM (VALUES (DATALENGTH(@string), 1)) AS l(s,d) -- length of the string and delimiter
CROSS APPLY
(
  SELECT CAST(-l.d+1 AS BIGINT) UNION ALL -- for handling leading delimiters
  SELECT ng.position
  FROM dbo.NGramsN4K(@string, l.d) AS ng
  WHERE token = @delimiter
) AS d(p) -- delimiter.position
CROSS APPLY (VALUES(  --LEAD(d.p, 1, l.s+l.d) OVER (ORDER BY d.p) - (d.p+l.d)
  ISNULL(NULLIF(CHARINDEX(@delimiter,@string,d.p+l.d),0)-(d.p+l.d), l.s/2-d.p))) item(ln);
GO
