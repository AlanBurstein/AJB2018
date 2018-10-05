SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[removeDupesExcept](@string varchar(max), @preserved varchar(50))
/*****************************************************************************************
Purpose:
 A purely set-based inline table valued function (iTVF) that accepts and input strings
 (@string) and a pattern (@preserved) and removes all duplicate characters in @string that
 do not match the @preserved pattern.

Compatibility:
 SQL Server 2008+

Syntax:
--===== Autonomous use
 SELECT rd.newString
 FROM samd.removeDupesExcept(@string, @preserved) rd;
--===== Against a table
 SELECT st.SomeColumn1, rd.newString
 FROM SomeTable st
 CROSS APPLY samd.removeDupesExcept(st.SomeColumn1, @preserved) rd;

Parameters:
 @string    = varchar(max); Input string to be "cleaned"
 @preserved = varchar(50); the pattern to preserve. For example, when @preserved='[0-9]'
 only non-numeric characters will be removed

Return Types:
 Inline Table Valued Function returns:
 newString = varchar(max); the string with duplicate characters removed
---------------------------------------------------------------------------------------
Developer Notes:
 1. Requires NGrams. The code for NGrams can be found here:
    http://www.sqlservercentral.com/articles/Tally+Table/142316/

 2. This function is what is referred to as an "inline" scalar UDF." Technically it's an
    inline table valued function (iTVF) but performs the same task as a scalar valued user
    defined function (UDF); the difference is that it requires the APPLY table operator
    to accept column values as a parameter. For more about "inline" scalar UDFs see this
    article by SQL MVP Jeff Moden: http://www.sqlservercentral.com/articles/T-SQL/91724/
    and for more about how to use APPLY see the this article by SQL MVP Paul White:
    http://www.sqlservercentral.com/articles/APPLY/69953/.

    Note the above syntax example and usage examples below to better understand how to
    use the function. Although the function is slightly more complicated to use than a
    scalar UDF it will yield notably better performance for many reasons. For example,
    unlike a scalar UDFs or multi-line table valued functions, the inline scalar UDF does
    not restrict the query optimizer's ability generate a parallel query execution plan.

 3. removeDupesExcept is deterministic; for more about deterministic and nondeterministic
    functions see https://msdn.microsoft.com/en-us/library/ms178091.aspx

---------------------------------------------------------------------------------------
Examples:

DECLARE @string varchar(8000) = '!!!aa###bb!!!';
BEGIN
  --===== Remove all duplicate characters
    SELECT f.newString 
    FROM samd.removeDupesExcept(@string,'') f; -- Returns: !a#b!
  
  --===== Remove all non-alphabetical duplicates
    SELECT f.newString 
    FROM samd.removeDupesExcept(@string,'[a-z]') f; -- Returns: !aa#bb!
  
  --===== Remove only alphabetical duplicates
    SELECT f.newString 
    FROM samd.removeDupesExcept(@string,'[^a-z]') f; -- Returns: !!!a###b!!!
END
---------------------------------------------------------------------------------------
Revision History:
 Rev 00 - 20170930 - Initial Creation - Alan Burstein
 Rev 02 - 20180615 - Updated to use NGrams (previously NGrams2B) - Alan Burstein
****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT newString =
( SELECT ng.token+''
  FROM dbo.NGrams(@string,1) ng
  WHERE ng.token <> SUBSTRING(@string,ng.position+1,1) -- exclude chars equal to the next
  OR ng.token LIKE @preserved -- preserve characters that match the @preserved pattern
  ORDER BY ng.position        -- spoon
  FOR XML PATH(''),TYPE       -- XML safe concatination
).value('(text())[1]','varchar(max)'); -- using Wayne Sheffield’s concatenation logic
GO
