SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnTally]
/**********************************************************************************************************************
 Purpose:
 Return a column of BIGINTs from @ZeroOrOne up to and including @MaxN with a max value of 1 Trillion.

 As a performance note, it takes about 00:02:10 (hh:mm:ss) to generate 1 Billion numbers to a throw-away variable.

 Usage:
--===== Syntax example (Returns BIGINT)
 SELECT t.N
   FROM dbo.fnTally(@ZeroOrOne,@MaxN) t
;

 Notes:
 1. Based on Itzik Ben-Gan's cascading CTE (cCTE) method for creating a "readless" Tally Table source of BIGINTs.
    Refer to the following URLs for how it works and introduction for how it replaces certain loops. 
    http://www.sqlservercentral.com/articles/T-SQL/62867/
    http://sqlmag.com/sql-server/virtual-auxiliary-table-numbers
 2. To start a sequence at 0, @ZeroOrOne must be 0 or NULL. Any other value that's convertable to the BIT data-type
    will cause the sequence to start at 1.
 3. If @ZeroOrOne = 1 and @MaxN = 0, no rows will be returned.
 5. If @MaxN is negative or NULL, a "TOP" error will be returned.
 6. @MaxN must be a positive number from >= the value of @ZeroOrOne up to and including 1 Billion. If a larger
    number is used, the function will silently truncate after 1 Billion. If you actually need a sequence with
    that many values, you should consider using a different tool. ;-)
 7. There will be a substantial reduction in performance if "N" is sorted in descending order.  If a descending 
    sort is required, use code similar to the following. Performance will decrease by about 27% but it's still
    very fast especially compared with just doing a simple descending sort on "N", which is about 20 times slower.
    If @ZeroOrOne is a 0, in this case, remove the "+1" from the code.

    DECLARE @MaxN BIGINT; 
     SELECT @MaxN = 1000;
     SELECT DescendingN = @MaxN-N+1 
       FROM dbo.fnTally(1,@MaxN);

 8. There is no performance penalty for sorting "N" in ascending order because the output is explicity sorted by
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL))

 Revision History:
 Rev 00 - Unknown     - Jeff Moden 
        - Initial creation with error handling for @MaxN.
 Rev 01 - 09 Feb 2013 - Jeff Moden 
        - Modified to start at 0 or 1.
 Rev 02 - 16 May 2013 - Jeff Moden 
        - Removed error handling for @MaxN because of exceptional cases.
 Rev 03 - 22 Apr 2015 - Jeff Moden
        - Modify to handle 1 Trillion rows for experimental purposes.
**********************************************************************************************************************/
        (@ZeroOrOne BIT, @MaxN BIGINT)
RETURNS TABLE WITH SCHEMABINDING AS 
 RETURN WITH
  E1(N) AS (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
            SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
            SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
            SELECT 1)                                  --10E1 or 10 rows
, E4(N) AS (SELECT 1 FROM E1 a, E1 b, E1 c, E1 d)      --10E4 or 10 Thousand rows
,E12(N) AS (SELECT 1 FROM E4 a, E4 b, E4 c)            --10E12 or 1 Trillion rows                 
            SELECT N = 0 WHERE ISNULL(@ZeroOrOne,0)= 0 --Conditionally start at 0.
             UNION ALL 
            SELECT TOP(@MaxN) N = ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E12 -- Values from 1 to @MaxN
;
GO
