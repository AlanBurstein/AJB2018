SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[bernieUL] (@string1 VARCHAR(8000), @string2 VARCHAR(8000))
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT BD = 
      ABS(a.l1-a.l2) * -- the difference in the length of the two strings
       SIGN( -- if any of these 3 values are > 0 return 1, otherwise return a NULL
         CHARINDEX(a.s1,a.s2)|  -- is s1 a substring of s2?
         CHARINDEX(a.s2,a.s1)|  -- is s2 a substring of s1?
         ABS(SIGN(a.l1*a.l2)-1)) -- when sl or s2 is blank return 1, otherwise return 0       
FROM (VALUES(@string1,@string2,DATALENGTH(@string1),DATALENGTH(@string2))) a(s1,s2,l1,l2);
GO
