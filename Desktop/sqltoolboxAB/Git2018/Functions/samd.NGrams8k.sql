SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[NGrams8k]
(
  @string VARCHAR(8000), -- Input string
  @N      INT            -- requested token size
)
/*****************************************************************************************
[Purpose]:
 A character-level N-Grams function that outputs a contiguous stream of @N-sized tokens
 based on an input string (@string). Accepts strings up to 8000 varchar characters long.
 For more information about N-Grams see: http://en.wikipedia.org/wiki/N-gram.

 Updated 20180912 to enable developers to return tokens in descending order without a
 performance penalty. 

[Author]: 
  Alan Burstein

[Compatibility]:
 SQL Server 2008+, Azure SQL Database

[Syntax]:
--===== Autonomous
 SELECT ng.position, ng.token 
 FROM   samd.NGrams8k(@string,@N) AS ng;

--===== Against a table using APPLY
 SELECT      s.SomeID, ng.position, ng.token
 FROM        dbo.SomeTable AS s
 CROSS APPLY samd.NGrams8K(s.SomeValue,@N) AS ng;

[Parameters]:
 @string  = The input string to split into tokens.
 @N       = The size of each token returned.

[Returns]:
 Position = BIGINT; the position of the token in the input string
 token    = VARCHAR(8000); a @N-sized character-level N-Gram token

[Dependencies]:
 1. dbo.rangeAB (iTVF)

[Developer Notes]:
 1. NGrams8k is not case sensitive;

 2. Many functions that use NGrams8k will see a huge performance gain when the optimizer
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

 4. NGrams8k is deterministic. For more about deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:
--===== 1. Split the string, "abcd" into unigrams, bigrams and trigrams

 --===== 1.1. Ascending order by position (no sort)
 SELECT ng.position, ng.token FROM samd.NGrams8k('abcd',1) AS ng; -- unigrams (@N=1)
 SELECT ng.position, ng.token FROM samd.NGrams8k('abcd',2) AS ng; -- bigrams  (@N=2)
 SELECT ng.position, ng.token FROM samd.NGrams8k('abcd',3) AS ng; -- trigrams (@N=3)

 --===== 1.2. Descending order by position (no sort)
 SELECT ng.positionOP, ng.tokenOP FROM samd.NGrams8k('abcd',1) AS ng; -- unigrams (@N=1)
 SELECT ng.positionOP, ng.tokenOP FROM samd.NGrams8k('abcd',2) AS ng; -- bigrams  (@N=2)
 SELECT ng.positionOP, ng.tokenOP FROM samd.NGrams8k('abcd',3) AS ng; -- trigrams (@N=3)


--===== How many times the substring "AB" appears in each record
 DECLARE @table TABLE(stringID int identity primary key, string varchar(100));
 INSERT @table(string) VALUES ('AB123AB'),('123ABABAB'),('!AB!AB!'),('AB-AB-AB-AB-AB');

 SELECT      string, occurances = COUNT(*)
 FROM        @table t
 CROSS APPLY samd.NGrams8k(t.string,2) AS ng
 WHERE       ng.token = 'AB'
 GROUP BY    string;

[Revision History]:
------------------------------------------------------------------------------------------
 Rev 00 - 20140310 - Initial Development - Alan Burstein
 Rev 01 - 20150522 - Removed DQS N-Grams functionality, improved iTally logic. Also Added
                     conversion to bigint in the TOP logic to remove implicit conversion
                     to bigint - Alan Burstein
 Rev 03 - 20150909 - Added logic to only return values if @N is greater than 0 and less
                     than the length of @string. Updated comment section. - Alan Burstein
 Rev 04 - 20151029 - Added ISNULL logic to the TOP clause for the @string and @N
                     parameters to prevent a NULL string or NULL @N from causing "an
                     improper value" being passed to the TOP clause. - Alan Burstein
 Rev 05 - 20171228 - Small simplification; changed: 
                (ABS(CONVERT(BIGINT,(DATALENGTH(ISNULL(@string,''))-(ISNULL(@N,1)-1)),0)))
                                           to:
                (ABS(CONVERT(BIGINT,(DATALENGTH(ISNULL(@string,''))+1-ISNULL(@N,1)),0)))
 Rev 06 - 20180612 - Using CHECKSUM(N) in the to convert N in the token output instead of
                     using (CAST N as int). CHECKSUM removes the need to convert to int.
 Rev 07 - 20180612 - re-designed to: (1) use dbo.rangeAB, (2) accomidate descending sorts
                     without a performance penalty. 
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT
  position   = r.RN,
  token      = SUBSTRING(@string, CHECKSUM(r.RN), @N),
  positionOP = r.OP,
  tokenOP    = SUBSTRING(@string, CHECKSUM(r.OP), @N)
FROM  dbo.rangeAB(1, LEN(@string)+1-@N,1,1) AS r
WHERE @N > 0 AND @N <= LEN(@string);
GO
