SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[NGramsN4K]
(
  @string NVARCHAR(4000), -- Input string
  @N      INT             -- requested token size
)
/*****************************************************************************************
[Purpose]:
 A character-level N-Grams function that outputs a contiguous stream of @N-sized tokens 
 based on an input string (@string). Accepts strings up to 4000 nvarchar characters long.
 For more information about N-Grams see: http://en.wikipedia.org/wiki/N-gram. 

[Author]:
  Alan Burstein

[Compatibility]:
 SQL Server 2008+, Azure SQL Database

[Syntax]:
--===== Autonomous
 SELECT ng.position, ng.token
 FROM   samd.NGramsN4K(@string,@N) AS ng;

--===== Against a table using APPLY
 SELECT      s.SomeID, ng.position, ng.token
 FROM        dbo.SomeTable                 AS s
 CROSS APPLY samd.NGramsN4K(s.SomeValue,@N) AS ng;

[Parameters]:
 @string  = The input string to split into tokens.
 @N       = The size of each token returned.

[Returns]:
 Position = bigint; the position of the token in the input string
 token    = nvarchar(4000); a @N-sized character-level N-Gram token

[Dependencies]:
 N/A

[Developer Notes]:
 1. NGramsN4K is not case sensitive

 2. Many functions that use NGramsN4K will see a huge performance gain when the optimizer
    creates a parallel execution plan. One way to get a parallel query plan (if the 
    optimizer does not chose one) is to use make_parallel by Adam Machanic which can be 
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
    WHERE NOT(@N > 0 AND @N <= DATALENGTH(@string)) OR (@N IS NULL OR @string IS NULL);

 4. NGramsN4K is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:
--===== 1. Turn the string, 'abcd' into unigrams, bigrams and trigrams
 SELECT position, token FROM samd.NGramsN4K('abcd',1); -- unigrams (@N=1)
 SELECT position, token FROM samd.NGramsN4K('abcd',2); -- bigrams  (@N=2)
 SELECT position, token FROM samd.NGramsN4K('abcd',3); -- trigrams (@N=3)
 SELECT position, token FROM samd.NGramsN4K('abcd',4); -- 4-grams  (@N=4)

--===== 2. Scenarios where the function would not return rows
 SELECT position, token FROM samd.NGramsN4K('abcd',5); -- 5-grams  (@N=5)
 SELECT position, token FROM samd.NGramsN4K(N'x',-1);
 SELECT position, token FROM samd.NGramsN4K(N'x', 0);
 SELECT position, token FROM samd.NGramsN4K(N'x', NULL);

--===== 3. How many times the substring "AB" appears in each record
 BEGIN
   DECLARE @table TABLE(stringID int identity primary key, string nvarchar(100));
   INSERT @table(string) VALUES ('AB123AB'),('123ABABAB'),('!AB!AB!'),('AB-AB-AB-AB-AB');
  
   SELECT string, occurances = COUNT(*) 
   FROM @table t
   CROSS APPLY samd.NGramsN4K(t.string,2) ng
   WHERE ng.token = 'AB'
   GROUP BY string;
 END;
-----------------------------------------------------------------------------------------
[Revision History]:
 Rev 00 - 20170324 - Initial Development - Alan Burstein
 Rev 01 - 20180829 - Changed TOP logic and startup-predicate logic in the WHERE clause
                   - Alan Burstein
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
WITH
L1(N) AS
(
  SELECT 1 FROM (VALUES -- 64 dummy values to CROSS join for 4096 rows
        ($),($),($),($),($),($),($),($),($),($),($),($),($),($),($),($),
        ($),($),($),($),($),($),($),($),($),($),($),($),($),($),($),($),
        ($),($),($),($),($),($),($),($),($),($),($),($),($),($),($),($),
        ($),($),($),($),($),($),($),($),($),($),($),($),($),($),($),($)) t(N)
),
iTally(N) AS 
(
  SELECT TOP (ABS((DATALENGTH(ISNULL(NULLIF(@string,''),'X'))/2)-(ISNULL(@N,1)-1)))
    ROW_NUMBER() OVER (ORDER BY (SELECT 1)) -- Order by a constant to avoid a sort
  FROM       L1 AS a                        -- 64 rows
	CROSS JOIN L1 AS b                        -- cartesian product for 4096 rows (64^2)
)
SELECT position =  i.N,                                -- position of the token in the string(s)
       token    =  SUBSTRING(@string,CHECKSUM(i.N),@N) -- the @N-Sized token
FROM   iTally AS i
WHERE  @N BETWEEN 1 AND DATALENGTH(ISNULL(NULLIF(@string,''),'X'))/2; 
GO
