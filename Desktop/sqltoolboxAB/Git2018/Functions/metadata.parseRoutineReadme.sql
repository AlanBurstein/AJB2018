SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [metadata].[parseRoutineReadme]
(
  @routine VARCHAR(200)
)
RETURNS TABLE AS RETURN
/*****************************************************************************************
[Purpose]:
 Parses the comment section of the SQLToolbox routines when they are formatted like this
 (e.g. with "Purpose", "Author", etc...)

[Author]:
 Alan Burstein

[Compatibility]:
 SQL Server 2008+

[Syntax]:
--===== Autonomous
 SELECT r.sortKey, r.sectionName, r.sectionText, r.sectionTextXML
 FROM   metadata.parseRoutineReadme(@routine) AS r;

--===== Against a table using APPLY
 SELECT      t.routine, r.sortKey, r.sectionName, r.sectionText, r.sectionTextXML
 FROM        dbo.someTable                          AS t
 CROSS APPLY metadata.parseRoutineReadme(t.routine) AS r;

[Parameters]:
  @routine = VARCHAR(200); Name of the routine (stored proc or function) to parse

[Returns]:
 Inline table valued function returns:
 <name,,> = <datatype,,> <description,,>

 sortKey        = TINYINT; Represents each section's ordinal position, also for sorting
 sectionName    = VARCHAR(30); Name of the section (e.g. "Purpose", "Author", etc.)
 sectionText    = VARCHAR(8000); The text for that section
 sectionTextXML = XML; sectionText as XML so we can click and open the text in a new window

[Dependencies]:
 1. metadata.getRoutineDefinition (function)
 2. metadata.objectReadmeSections (proc)
 3. samd.delimitedSplitAB8K_VLNO  (function)
    3.1. dbo.NGrams8k             (function)

[Developer Notes]:
 1. Returns <return value on NULL input,,a single NULL>, 
    <return value on blank input,,No rows>. To return a single row containing a a NULL or 
    Blank row on NULL inputparameters conider using OUTER APPLY or append the function 
    with a UNION ALL "dummy row." Noe the following examples:

    <OUTER APPLY example,,>

    <UNION ALL example,,>
    <UNION ALL LOGIC,,UNION ALL SELECT NULL, WHERE NULLIF(@parameter,'') IS NULL;>
 2. Case sensitivity and collation
 3. metadata.parseRoutineReadme is NOT deterministic due to the use of system tables. 
    For more deterministic functions see:
      https://msdn.microsoft.com/en-us/library/ms178091.aspx

[Examples]:
--===== 1. Basic use
 DECLARE @routine VARCHAR(200) = 'dates.firstOfYear';
 
 SELECT r.sortKey, r.sectionName, r.sectionText, r.sectionTextXML
 FROM metadata.parseRoutineReadme(@routine) AS r;

[Sample Results]:
--===== Query
 SELECT 
   r.sortKey, 
   r.sectionName, 
   sectionText    = LEFT(REPLACE(REPLACE(r.sectionText, CHAR(10),''),CHAR(13),''), 35)+'...  ',
   sectionTextXML = '<sectionText AS XML>'
 FROM metadata.parseRoutineReadme('dates.firstOfYear') AS r;

--===== Results:
 sortKey sectionName       sectionText                              sectionTextXML
 ------- ----------------- ---------------------------------------- --------------------
 1       Purpose            Accepts an input date (@date) firs...   <sectionText AS XML>
 2       Author             Alan Burstein Note: The idea for t...   <sectionText AS XML>
 3       Compatibility      SQL Server 2005+, Azure SQL Databa...   <sectionText AS XML>
 4       Syntax            --===== Autonomous use SELECT f.yea...   <sectionText AS XML>
 5       Parameters         @date  = datetime; Input date to e...   <sectionText AS XML>
 6       Returns            Inline Table Valued Function retur...   <sectionText AS XML>
 7       Dependencies       N/A...                                  <sectionText AS XML>
 8       Developer Notes    1. The idea for this function came...   <sectionText AS XML>
 9       Examples          --==== Basic use ->  DECLARE @date ...   <sectionText AS XML>
 10      Revision History   Rev 00 - 20180614 - Initial Creati...   <sectionText AS XML>

-----------------------------------------------------------------------------------------
[Revision History]: 
 Rev 00 - 20180911 - Initial Creation - Alan Burstein
*****************************************************************************************/
SELECT 
  sortKey        =  rm.sortKey,
  sectionName    =  rm.section,
  sectionText    =  section.txt,
  sectionTextXML = (SELECT section.txt+'' FOR XML PATH(''), TYPE)
FROM
(
  SELECT 
    sortKey         = m.sortKey,
    section         = m.sectionName,
    sectionTextRaw  = split.item,
    position        = CHARINDEX('['+m.sectionName+']:', split.item),
    nextPosition    = LEAD(CHARINDEX('['+m.sectionName+']:', split.item),1,LEN(obj.def))
  	                    OVER (ORDER BY CHARINDEX('['+m.sectionName+']:', split.item)),
    delimiterLength = m.sectionNameLength+3
  FROM
  (
    SELECT TOP (1) fd.objDef -- TOP (1) used to force a single (atomic) value
    FROM metadata.getRoutineDefinition(@routine) AS fd
  ) AS obj(def)
  CROSS APPLY samd.delimitedSplitAB8K_VLNO(obj.def,'**********') AS split
  CROSS JOIN  metadata.objectReadmeSections                      AS m
  WHERE split.itemNumber = 2
) AS rm
CROSS APPLY (VALUES(SUBSTRING(
  rm.sectionTextRaw,                               -- split.item from above
  rm.position+rm.delimiterLength,                  -- start position(sp)+delemiter len(dl)
  rm.nextPosition-rm.position-rm.delimiterLength)) -- next positition - (sp) - (dl)
) AS section(txt)
WHERE rm.position > 0;
GO
