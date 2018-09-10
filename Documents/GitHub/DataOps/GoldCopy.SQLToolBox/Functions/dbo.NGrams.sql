SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NGrams]
(
  @string varchar(max), 
  @N      int
)
/****************************************************************************************
Purpose:
 A character-level N-Grams function that outputs a stream of tokens based on an input
 string (@string) up to 2^31-1 bytes (2 GB). For more 
 information about N-Grams see: http://en.wikipedia.org/wiki/N-gram. 

Compatibility: 
 SQL Server 2008+, Azure SQL Database

Syntax:
--===== Autonomous
 SELECT position, token FROM dbo.NGrams(@string,@N);

--===== Against a table using APPLY
 SELECT s.SomeID, ng.position, ng.token
 FROM dbo.SomeTable s
 CROSS APPLY dbo.NGrams(s.SomeValue,@N) ng;

Parameters:
 @string = varchar(max); the input string to split into tokens 
 @N      = bigint; the size of each token returned

Returns:
 Position = bigint; the position of the token in the input string
 token    = varchar(max); a @N-sized character-level N-Gram token

Developer Notes:
 1. Based on NGrams8k but modified to accept varchar(max)

 2. Note that this funciton was previously named NGrams2B for "N-Grams 2 billion" as it
    supports varchar(max). On June 15, 2018 I changed the name to NGrams.

 3. NGrams is not case sensitive

 4. Many functions that use NGrams will see a huge performance gain when the optimizer
    creates a parallel execution plan. One way to get a parallel query plan (if the 
    optimizer does not chose one) is to use make_parallel by Adam Machanic which can be 
    found here:
 sqlblog.com/blogs/adam_machanic/archive/2013/07/11/next-level-parallel-plan-porcing.aspx

 5. Performs about 2-3 times slower than NGrams8k. Only use when you'resure that NGrams8k 
    will not suffice. 

 6. When @N is less than 1 or greater than the datalength of the input string then no 
    tokens (rows) are returned. If either @string or @N are NULL no rows are returned.
    This is a debatable topic but the thinking behind this decision is that: because you
    can't split 'xxx' into 4-grams, you can't split a NULL value into unigrams and you 
    can't turn anything into NULL-grams, no rows should be returned.

    For people who would prefer that a NULL input forces the function to return a single
    NULL output you could add this code to the end of the function:

    UNION ALL 
    SELECT 1, NULL
    WHERE NOT(@N > 0 AND @N <= DATALENGTH(@string)) OR (@N IS NULL OR @string IS NULL)

 7. Note that there is no ORDER BY that corresponds with the TOP clause in my iTally CTE.
    This normally be considered bad SQL because, without an ORDER BY, the order in which
    the rows are returned is not guaranteed. This is fine because order does not matter
    here. To guarantee that the results are returned in the order they appear you can sort
    position without any performance penalty. There will be a performance penalty for a
    Descending sort by position.  

 8. NGrams8k is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

Usage Examples:
--===== Turn the string, 'abcd' into unigrams, bigrams and trigrams
 SELECT position, token FROM dbo.NGrams('abcd',1); -- bigrams  (@N=1)
 SELECT position, token FROM dbo.NGrams('abcd',2); -- bigrams  (@N=2)
 SELECT position, token FROM dbo.NGrams('abcd',3); -- trigrams (@N=3)

---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20150909 - Initial Developement - Alan Burstein 
 Rev 01 - 20151029 - Added ISNULL logic to the TOP clause for both parameters: @string 
                     and @N. This will prevent a NULL string or NULL @N from causing an 
                     "improper value" to be passed to the TOP clause. - Alan Burstein
 Rev 02 - 20180618 - Changed the name to NGrams from NGrams. 
                   - Removed Conversions of @string to varchar(max). This was intended
                     to circumvent implicit conversions but, after some testing, doesn't.
                   - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH L1(N) AS 
(
  SELECT N 
  FROM (VALUES 
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),
   (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) t(N)
), --216 values
iTally(N) AS 
(
  SELECT TOP (ABS(CONVERT(BIGINT,(DATALENGTH(ISNULL(@string,''))-(ISNULL(@N,1)-1)),0)))
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
  FROM L1 a CROSS JOIN L1 b CROSS JOIN L1 c CROSS JOIN L1 d
  --2,176,782,336 rows: enough to handle varchar(max) -> 2^31-1 bytes
)
SELECT
  position = i.N,
  token    = SUBSTRING(@string,i.N,@N)
FROM iTally i
WHERE @N > 0 AND @N <= DATALENGTH(@string);
GO
