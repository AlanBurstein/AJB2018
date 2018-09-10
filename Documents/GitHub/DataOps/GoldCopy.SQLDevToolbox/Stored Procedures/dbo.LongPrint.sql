SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LongPrint] @string nvarchar(MAX)
AS
/* 
Source:
https://ask.sqlservercentral.com/questions/3102/any-way-around-the-print-limit-of-nvarcharmax-in-s.html

Example:
exec LongPrint @string = 'This String Exists to test the system.'

This procedure is designed to overcome the limitation in the SQL print command that causes 
it to truncate strings longer than 8000 characters (4000 for nvarchar).

It will print the text passed to it in substrings smaller than 4000 characters. If there 
are carriage returns (CRs) or new lines (NLs in the text), it will break up the substrings
at the carriage returns and the printed version will exactly reflect the string passed.

If there are insufficient line breaks in the text, it will print it out in blocks of 4000 
characters with an extra carriage return at that point.
If it is passed a null value, it will do virtually nothing.

NOTE: This is substantially slower than a simple print, so should only be used when actually needed. */

DECLARE 
  @CurrentEnd bigint, /* track the length of the next substring */
  @offset tinyint     /*tracks the amount of offset needed */

set @string = replace(replace(@string, char(13)+char(10), char(10)), char(13), char(10));

WHILE LEN(@String) > 1 BEGIN
  IF CHARINDEX(char(10), @string) BETWEEN 1 AND 4000
  BEGIN 
    SET @CurrentEnd = CHARINDEX(char(10), @String) -1;
    SET @offset     = 2;
  END
  ELSE
  BEGIN
    SET @CurrentEnd = 4000;
    SET @offset     = 1;
  END;
   
  PRINT SUBSTRING(@String, 1, @CurrentEnd);
  
  SET @string = SUBSTRING(@String, @CurrentEnd+@offset, 1073741822);
 
END /*End While loop*/
GO
