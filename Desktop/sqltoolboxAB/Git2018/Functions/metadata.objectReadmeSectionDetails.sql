SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [metadata].[objectReadmeSectionDetails]
(
  @isGoodReadMe BIT -- note that NULL means "both"
)
/*****************************************************************************************
[Purpose]:
 <breif details about what the routine does,,>

[Author]:
 Alan Burstein

[Compatibility]:
 <SQL Server Version,,SQL Server 2008+>
 <optional details about why it won't work with earlier versions,,>

[Syntax]:
--===== Autonomous
 SELECT f.returnValue
 FROM   <schema.routine,,>(@parameters) AS f;

--===== Against a table using APPLY
 SELECT      f.returnValue
 FROM        dbo.someTable                        AS t
 CROSS APPLY <routine,,>(t.col, @parameters) AS f;

[Parameters]:
  @string = <datatype,,>; <parameter details,,>

[Returns]:
 <function type,,inline table valued function> returns:
 <name,,> = <datatype,,> <description,,>

[Dependencies]:
 1. metadata.getRoutineDefinition
 2. metadata.parseRoutineReadme

[Developer Notes]:
 1. CAN'T BE SCHEMABOUND (INFORMATION_SCHEMA)
 
 Returns <return value on NULL input,,a single NULL>, 
    <return value on blank input,,No rows>. To return a single row containing a a NULL or 
    Blank row on NULL inputparameters conider using OUTER APPLY or append the function 
    with a UNION ALL "dummy row." Noe the following examples:

    <OUTER APPLY example,,>

    <UNION ALL example,,>
    <UNION ALL LOGIC,,UNION ALL SELECT NULL, WHERE NULLIF(@parameter,'') IS NULL;>
 2. Case sensitivity and collation
 4. <function name,,> is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx
 5. <function name,,> performs <better,,substantially|marginally|notably> better with 
    a parallel execution plan, often 2-3 times faster. For queries that leverage 
    patextract8K that are not getting a parallel exeution plan you should consider 
    performance testing using Traceflag 8649 in Development environments and 
    Adam Machanic's make_parallel in Production. 

[Examples]:
--===== 1. Return good ReadMe's only
 SELECT 
  d.goodReadme,
  d.itemNumber,
  d.totalComments,
  d.routineName,
  d.routineType,
  d.sectionName,
  d.sectionTextXML
 FROM metadata.objectReadmeSectionDetails(1) AS d;

--===== 2. Return Bad ReadMe's only
 SELECT d.*
 FROM   metadata.objectReadmeSectionDetails(0) AS d;

--===== 3. Return Everything
 SELECT d.*
 FROM metadata.objectReadmeSectionDetails(NULL) AS d;

--===== 4. Return a DISTINCT list of good ReadMe's
 SELECT TOP (1) WITH TIES d.*
 FROM metadata.objectReadmeSectionDetails(1) AS d
 ORDER BY ROW_NUMBER() OVER (PARTITION BY d.routineName ORDER BY (SELECT NULL));

--===== 5. Return a DISTINCT list of *Complete* ReadMe's
 SELECT TOP (1) WITH TIES d.*
 FROM       metadata.objectReadmeSectionDetails(1) AS d
 CROSS JOIN metadata.objectReadmeSectionsCOUNT AS c
 WHERE      d.totalComments = c.total
 ORDER BY   ROW_NUMBER() OVER (PARTITION BY d.routineName ORDER BY (SELECT NULL));

--===== 6. Return a DISTINCT list of *Incomplete* ReadMe's
 SELECT TOP (1) WITH TIES d.routineName, d.routineType, d.totalComments
 FROM       metadata.objectReadmeSectionDetails(NULL) AS d
 CROSS JOIN metadata.objectReadmeSectionsCOUNT AS c
-- WHERE      c.total > d.totalComments OR d.totalComments IS NULL --COALESCE(d.totalComments,0)
 ORDER BY   ROW_NUMBER() OVER (PARTITIeON BY d.routineName ORDER BY (SELECT NULL));

-----------------------------------------------------------------------------------------
[Revision History]: 
 Rev 00 - 20180911 - Initial Creation - Alan Burstein
*****************************************************************************************/
RETURNS TABLE AS RETURN
WITH 
documented AS 
(
  SELECT   rd.routineName,
           rd.routineType
  FROM     INFORMATION_SCHEMA.ROUTINES                   AS r
  CROSS 
  APPLY    metadata.getRoutineDefinition(r.ROUTINE_NAME) AS rd
  CROSS 
  APPLY    metadata.parseRoutineReadme(rd.routineName)   AS s
  WHERE    CHARINDEX('['+s.sectionName+']:', rd.objDef) > 0
  GROUP BY rd.routineName, rd.routineType
),
readmeInfo AS
(
  SELECT  goodReadme = 1, d.routineName, d.routineType
  FROM    documented AS d
  UNION ALL
  (
    SELECT  goodReadme = 0, d.ROUTINE_SCHEMA+'.'+d.ROUTINE_NAME, d.ROUTINE_TYPE
    FROM INFORMATION_SCHEMA.ROUTINES AS d
    EXCEPT
    SELECT goodReadme = 0, d.routineName, d.routineType
    FROM documented AS d
  )
)
SELECT rm.goodReadme,
       itemNumber    = r.sortKey,
       totalComments = COUNT(*) OVER (PARTITION BY rm.routineName ORDER BY (SELECT 1)),
       rm.routineName,
       rm.routineType,
       r.sectionName, 
       r.sectionTextXML
FROM   readmeInfo AS rm
OUTER 
APPLY  metadata.parseRoutineReadme(rm.routineName) AS r
WHERE  rm.goodReadme = @isGoodReadMe OR @isGoodReadMe IS NULL;
GO
