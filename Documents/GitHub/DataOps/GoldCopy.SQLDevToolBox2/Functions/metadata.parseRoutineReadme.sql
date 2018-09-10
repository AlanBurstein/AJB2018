SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [metadata].[parseRoutineReadme]
(
  @routine VARCHAR(200)
)
RETURNS TABLE AS RETURN
/*
DECLARE @routine VARCHAR(200) = 'dates.firstOfYear';

SELECT r.sectionName, r.sectionText, r.sectionTextXML
FROM metadata.parseRoutineReadme(@routine) AS r;
*/
SELECT 
  sectionName    =  rm.section,
  sectionText    =  section.txt,
  sectionTextXML = (SELECT section.txt+'' FOR XML PATH(''), TYPE)
FROM
(
  SELECT 
    section         = m.sectionName,
    sectionTextRaw  = split.item,
    position        = CHARINDEX('['+m.sectionName+']:', split.item),
    nextPosition    = LEAD(CHARINDEX('['+m.sectionName+']:', split.item),1,LEN(obj.def))
  	                    OVER (ORDER BY CHARINDEX('['+m.sectionName+']:', split.item)),
    delimiterLength = m.sectionNameLength+3
  FROM
  (
    SELECT TOP (1) fd.objDef -- TOP (1) to force a single (atomic) value
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
