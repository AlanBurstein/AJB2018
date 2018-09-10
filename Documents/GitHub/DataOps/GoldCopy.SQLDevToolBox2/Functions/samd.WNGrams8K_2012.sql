SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[WNGrams8K_2012](@string varchar(8000), @N int)
/*****************************************************************************************
Purpose:
 WNGrams2012_8K accepts a varchar(8000) input string (@string) and splits 
 it into a contiguous sequence of @N-sized, word-level tokens.

 Per Wikipedia (http://en.wikipedia.org/wiki/N-gram) an "n-gram" is defined as: 
 "a contiguous sequence of n items from a given sequence of text or speech. The items can
  be phonemes, syllables, letters, words or base pairs according to the application. "
-----------------------------------------------------------------------------------------
Compatibility:
 SQL Server 2012+, Azure SQL Database
 2012+ because the function uses LEAD (see: https://goo.gl/6VK142)

Parameters:
 @string = varchar(8000); input string to spit into n-sized items
 @N      = int; number of items per row

Returns:
 itemNumber = bigint; the item's ordinal position inside the input string
 itemIndex  = int; the items location inside the input string
 item       = The @N-sized word-level token

-----------------------------------------------------------------------------------------
Syntax:
--===== Autonomous
 SELECT 
   ng.tokenNumber,
   ng.token
 FROM samd.WNGrams8K_2012(@string,@N) ng;

--===== Against another table using APPLY
 SELECT 
   t.SomeID
   ng.tokenNumber,
   ng.token
 FROM dbo.SomeTable t
 CROSS APPLY samd.WNGrams8K_2012(@string,@N) ng;
-----------------------------------------------------------------------------------------
Usage Examples:

--===== Example #1: Word-level Unigrams:
  SELECT 
    ng.itemNumber,
    ng.itemIndex,
    ng.itemLength,
    ng.item
  FROM samd.WNGrams8K_2012('One two three four words', 1) ng;

 --Results:
  itemNumber  itemIndex itemLength item
  1           1         3          One 
  2           4         3          two
  3           8         5          three
  4           14        4          four
  5           19        5          words

--===== Example #2: Word-level Bi-grams:
  SELECT 
    ng.itemNumber,
    ng.itemIndex,
    ng.itemLength,
    ng.item
  FROM samd.WNGrams8K_2012('One two three four words', 2) ng;

 --Results:
  itemNumber  itemIndex itemLength item
  1           1        7           One two 
  2           4        9           two three 
  3           8        10          three four
  4           14       10          four words 

--===== Example #3: Only the first two Word-level Bi-grams:
  -- Key: TOP(2) does NOT guarantee the correct result without an order by, which will
  -- degrade performance; see programmer note #5 below for details about sorting. 

  SELECT 
    ng.itemNumber,
    ng.itemIndex,
    ng.itemLength,
    ng.item
  FROM samd.WNGrams8K_2012('One two three four words',2) ng
  WHERE ng.itemNumber < 3;

 --Results:
  itemNumber  itemIndex itemLength item
  1           1         7          One two 
  2           4         9          two three 
-----------------------------------------------------------------------------------------
Programmer Notes:
 1. Function requires NGrams8K which can be found here:
      http://www.sqlservercentral.com/articles/Tally+Table/142316/

 2. Kudo's to Eirikur Eiriksson; this function could not have been developed without 
    what I learned reading "Reaping the benefits of the Window functions in T-SQL" 
    https://goo.gl/Gtru6A. The code may look substantially different but, WNGrams2012_8K
    is a hacked mutation of Eiriksson's DelimitedSplit8K_LEAD (see: https://goo.gl/f58x9t)

 3. Is faster than WNGrams2012_8K, the pre-2012 version, WNGrams_8K, which cannot leverage
    LEAD and which means a less efficient self-join against a derived set is required.

 4. WNGrams2012_8K uses spaces (char(32)) as the delimiter; the text must be pre-formatted
    to address line breaks, carriage returns multiple spaces, etc.

 5. Result set order does not matter and therefore no ORDER BY clause is required. The 
    *observed* default sort order is ItemNumber which means position is also sequential.
    That said, *any* ORDER BY clause will cause a sort in the execution plan. If you need
    to sort by position (ASC) or itemNumber (ASC), follow these steps to avoid a sort:

      A. In the function DDL, replace COALESCE/NULLIF for N1.N with the N. e.g. Replace
         "COALESCE(NULLIF(N1.N,0),1)" with "N" (no quotes)

      B. Add an ORDER BY position (which is logically identical to ORDER BY itemnumber).

      C. This will cause the position of the 1st token to be 0 instead of 1 when position
         is included in the final result-set. To correct this, simply use this formula:
         "COALESCE(NULLIF(position,0),1)" for "position". Note this example:

         SELECT
           ng.itemNumber,
           itemIndex = COALESCE(NULLIF(ng.itemIndex,0),1),
           ng.item
         FROM samd.WNGrams8K_2012('One two three four words',2) ng
         ORDER BY ng.itemIndex;

-----------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20170320 - Initial creation
        - Created using LEAD to eliminate the self join in the 2005/2008 version.
        - Alan Burstein
 Rev 01 - 20170908 - Made the following changes: 
            A. Added the Position element (as it is free)
            B. Removed ISNULL, utilizing LEAD's built-in default parameter instead
            C. Added table alias and updated comments
            D. Included comments on how to circumvent a sort when using ORDER BY
            E. Changed column names to itemNumber, itemIndex, item and itemCount
          - Alan Burstein
 Rev 02 - 20180625 - Added itemLength; minor bug fixes - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH
delim(RN,N) AS -- locate all of the spaces in the string
(
  SELECT 0,0 UNION ALL
  SELECT ROW_NUMBER() OVER (ORDER BY ng.position), ng.position
  FROM dbo.NGrams8k(@string,1) ng
  WHERE ng.token = CHAR(32)
),
tokens(itemNumber, itemIndex, item, itemLength) AS -- Create the tokens
(
  SELECT 
    itemNumber = N1.RN+1,
    itemIndex  = N1.N+1,
    item       = LTRIM(RTRIM(SUBSTRING(@string, N1.N+1,
                   LEAD(N1.N,@N, LEN(@string)+1) OVER (ORDER BY N1.N)-N1.N))),
    itemLength = LEAD(N1.N,@N, LEN(@string)+1) OVER (ORDER BY N1.N)-N1.N-1
     -- count number of spaces in the string then apply the N-GRAM rows-(@N-1) formula
     -- Note: using (@N-2 to compinsate for the extra row in the delim cte).
  FROM delim N1
)
SELECT 
  t.itemNumber,
	t.itemIndex,
  t.itemLength,
  t.item
FROM tokens t
WHERE @N > 0 AND t.itemNumber <= (LEN(@string)-LEN(REPLACE(@string,' ','')))-(@N-2); 
GO
