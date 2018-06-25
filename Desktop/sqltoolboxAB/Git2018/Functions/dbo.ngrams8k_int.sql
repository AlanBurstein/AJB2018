SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ngrams8k_int]
(
  @string varchar(8000), -- Input string
  @N      int            -- requested token size
)
/****************************************************************************************
Purpose:
 A character-level N-Grams function that outputs a contiguous stream of @N-sized tokens
 based on an input string (@string). Accepts strings up to 8000 varchar characters long.
 For more information about N-Grams see: http://en.wikipedia.org/wiki/N-gram.

 Based on ngrams8k but uses CHECKSUM over the iTally table ROW_NUMBER function to force 
 it to return a an int instead of a bigint. 

Compatibility:
 SQL Server 2008+, Azure SQL Database

Syntax:
--===== Autonomous
 SELECT position, token FROM dbo.ngrams8k_int(@string,@N);

--===== Against a table using APPLY
 SELECT s.SomeID, ng.position, ng.token
 FROM dbo.SomeTable s
 CROSS APPLY dbo.ngrams8k_int(s.SomeValue,@N) ng;

Parameters:
 @string  = The input string to split into tokens.
 @N       = The size of each token returned.

Returns:
 Position = bigint; the position of the token in the input string
 token    = varchar(8000); a @N-sized character-level N-Gram token

Developer Notes: 
 1. ngrams8k_int is not case sensitive
 2. Many functions that use ngrams8k_int will see a huge performance gain when the optimizer
    creates a parallel execution plan. One way to get a parallel query plan (if the
    optimizer does not choose one) is to use make_parallel by Adam Machanic which can be
    found here:
 sqlblog.com/blogs/adam_machanic/archive/2013/07/11/next-level-parallel-plan-porcing.aspx
3. When @N is less than 1 or greater than the datalength of the input string then no
    tokens (rows) are returned. If either @string or @N are NULL no rows are returned.
    This is a debatable topic but the thinking behind this decision is that: because you
    can't split 'xxx' into 4-grams, you can't split a NULL value into unigrams and you
    can't turn anything into NULL-grams, no rows should be returned.
    For people who would prefer that a NULL input forces the function to return a single
    NULL output you could add this code to the end of the function:
    UNION ALL
    SELECT 1, NULL
    WHERE NOT(@N > 0 AND @N <= DATALENGTH(@string)) OR (@N IS NULL OR @string IS NULL)
 4. ngrams8k_int can also be used as a Tally Table with the position column being your "N"
    row. To do so use REPLICATE to create an imaginary string, then use NGrams8k to split
    it into unigrams then only return the position column. NGrams8k will get you up to
    8000 numbers. There will be no performance penalty for sorting by position in
    ascending order but there is for sorting in descending order. To get the numbers in
    descending order without forcing a sort in the query plan use the following formula:
    N = <highest number>-position+1.
 5. ngrams8k_int is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx
 6. Becuase ngrams8k_int uses CHECKSUM over the ROW_NUMBER to return and int (instead of
    bigint) but will force a sort in the execution plan sorting by position. With this in
    mind, this function should only be used when you an ORDER BY clause is not necessary

Usage Examples:
--===== Turn the string, 'abcd' into unigrams, bigrams and trigrams
 SELECT position, token FROM dbo.ngrams8k_int('abcd',1); -- unigrams (@N=1)
 SELECT position, token FROM dbo.ngrams8k_int('abcd',2); -- bigrams  (@N=2)
 SELECT position, token FROM dbo.ngrams8k_int('abcd',3); -- trigrams (@N=3)

--===== How many times the substring "AB" appears in each record
 DECLARE @table TABLE(stringID int identity primary key, string varchar(100));
 INSERT @table(string) VALUES ('AB123AB'),('123ABABAB'),('!AB!AB!'),('AB-AB-AB-AB-AB');
 SELECT string, occurances = COUNT(*)
 FROM @table t
 CROSS APPLY dbo.ngrams8k_int(t.string,2) ng
 WHERE ng.token = 'AB'
 GROUP BY string;
----------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20180518 - Initial Development - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH
L1(N) AS
(
  SELECT 1
  FROM (VALUES    -- 90 NULL values used to create the CTE Tally Table
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),
        (NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL),(NULL)
       ) t(N)
),
iTally(N) AS                                          -- CTE Tally Table
(
  SELECT TOP (ABS(DATALENGTH(ISNULL(@string,''))+1-ISNULL(@N,1)))
    CHECKSUM(ROW_NUMBER() OVER (ORDER BY (SELECT 1))) -- ORDER BY a constant avoids a sort
  FROM L1 a CROSS JOIN L1 b                           -- Cartesian for 8100 rows (90^2)
)
SELECT
  position = N,                             -- position of the token in the string(s)
  token    = SUBSTRING(@string,N,@N)        -- the @N-Sized token
FROM iTally
WHERE @N > 0 AND @N <= DATALENGTH(@string); -- Protection against bad parameter values
GO
