SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[hammingDistance8K] (@s1 VARCHAR(8000), @s2 VARCHAR(8000))
/*****************************************************************************************
Purpose:
 <breif details about what the routine does,,>

Compatibility: 
 <SQL Server Version,,SQL Server 2008+>
 <optional details about why it won't work with earlier versions,,>

Syntax:
--===== Autonomous
 SELECT f.returnValue
 FROM dbo.yourfunction(@parameters) f;

--===== Against a table using APPLY
 SELECT f.returnValue
 FROM dbo.someTable t
 CROSS APPLY dbo.yourfunction(t.col, @parameters) f;

Parameters:
  @string = <datatype,,>; <parameter details,,>

Returns:
 <function type,,inline table valued function> returns:
 <name> = <datatype> <description>

Developer Notes:
 1. Requires <required objects,,dbo.>
 2. Returns <return value on NULL input,,a single NULL>, 
    <return value on blank input,,No rows>. To return a single row containing a a NULL or 
    Blank row on NULL inputparameters conider using OUTER APPLY or append the function 
    with a UNION ALL "dummy row." Noe the following examples:

    <OUTER APPLY example,,>

    <UNION ALL example,,>
    <UNION ALL LOGIC,,UNION ALL SELECT NULL, WHERE NULLIF(@parameter,'') IS NULL;>
 3. Case sensitivity
 4. <function name,,dbo.> is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx
 5. <function name,,dbo.> performs <better,,substantially|marginally|notably> better with 
    a parallel execution plan, often 2-3 times faster. For queries that leverage 
    patextract8K that are not getting a parallel exeution plan you should consider 
    performance testing using Traceflag 8649 in Development environments and 
    Adam Machanic's make_parallel in Production. 


Usage Examples:

--===== 1. <tile 1.,,>
 -- (1.1) <subtitle 1.1,,>
 <example code 1.1.,,s>;

 -- (1.2) <subtitle 1.2.,,>
 <example code 12..,,s>;

--===== 1. <tile 2.,,>
 -- (1.1) <subtitle,,>
 <example code 1,,s>;

---------------------------------------------------------------------------------------
Revision History: 
 Rev 00 - <YYYYMMDD> - <details> - <developer>
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT hammingDistance.hd
FROM
(
  SELECT CASE LEN(@s1) WHEN LEN(@s2)
         THEN LEN(@s1)-SUM(CHARINDEX(ng.token,SUBSTRING(@s2,ng.position,1))) END
  FROM dbo.NGrams8k(@s1,1) ng
) hammingDistance(hd);
/*
  dld = CASE WHEN hammingDistance.hd < 2 THEN hammingDistance.hd END,
  lcs = CASE WHEN hammingDistance.hd < 2 THEN DATALENGTH(@s1)-hammingDistance.hd END
*/;
GO
