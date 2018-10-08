SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[patReplace]
(
  @string  VARCHAR(MAX),
  @pattern VARCHAR(50),
  @replace VARCHAR(20)
) 
/*****************************************************************************************
[Purpose]:
 Given a string (@string), a pattern (@pattern), and a replacement character (@replace)
 patReplace will replace any character in @string that matches the @Pattern parameter 
 with the character, @replace. This version is limited to varchar(max). 

[Author]:
 Alan Burstein

[Compatibility]:
  SQL Server 2008+

[syntax]:
--===== Basic Syntax Example
 SELECT pr.NewString
 FROM   samd.patReplace(@String,@Pattern,@Replace) AS pr;

[Developer Notes]:
 1. Required SQL Server 2008+
 2. @Pattern IS case sensitive but can be easily modified to make it case insensitive
 3. There is no need to include the "%" before and/or after your pattern since since we 
    are evaluating each character individually
 4. Certain special characters, such as "$" and "%" need to be escaped with a "/"
    like so: [/$/%]

-----------------------------------------------------------------------------------------
[Revision History]:
 Rev 00 - 20171116 - Initial Development - Alan Burstein. Based on the 8k version 
                     in teh SSC comments below. The history below is for the 8k version.
 Rev 01 - 10/29/2014 Mar 2007 - Alan Burstein
        - Redesigned based on the dbo.STRIP_NUM_EE by Eirikur Eiriksson
          (see: http://www.sqlservercentral.com/Forums/Topic1585850-391-2.aspx)
        - change how the cte tally table is created 
        - put the include/exclude logic in a CASE statement instead of a WHERE clause
        - Added Latin1_General_BIN Colation
        - Add code to use the pattern as a parameter.

 Rev 02 - 20141106
        - Added final performane enhancement (more cudo's to Eirikur Eiriksson)
        - Put 0 = PATINDEX filter logic into the WHERE clause

Rev 03  - 20150516
        - Updated to deal with special XML characters

Rev 04  - 20170320
        - changed @replace from char(1) to varchar(1) to address how spaces are handled
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT newString = 
  (
    SELECT   CASE WHEN @string = CAST('' AS VARCHAR(MAX)) THEN CAST('' AS VARCHAR(MAX))
                  WHEN @pattern+@replace+@string IS NOT NULL THEN 
                    CASE WHEN PATINDEX(@pattern,token COLLATE Latin1_General_BIN)=0
                         THEN ng.token ELSE @replace END END
    FROM     samd.NGrams(@string, 1) AS ng
    ORDER BY ng.position
    FOR XML PATH(''), TYPE
  ).value('text()[1]', 'VARCHAR(MAX)');
GO
