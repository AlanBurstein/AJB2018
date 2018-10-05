SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [metadata].[objectReadmeSectionAnalysis]
(
  @orphinMode BIT = 0
)
/*
SELECT r.* FROM metadata.objectReadmeSectionAnalysis(0) AS r;
SELECT r.* FROM metadata.objectReadmeSectionAnalysis(1) AS r;



Note: will be slow due to XML Output
*/
RETURNS TABLE AS RETURN
SELECT details.goodReadme,
       details.itemNumber,
       details.totalComments,
       details.routineName,
       details.routineType,
       details.section,
       details.details 
FROM 
(
  SELECT  RN = ROW_NUMBER() OVER (PARTITION BY d.routineName ORDER BY d.itemNumber),
          d.goodReadme,
          d.itemNumber,
          d.totalComments,
          d.routineName,
          d.routineType,
          section = CASE @orphinMode WHEN 1 THEN '<definition>' ELSE d.sectionName END,
          details = CASE @orphinMode WHEN 1 THEN f.f ELSE d.sectionTextXML END 
  FROM    metadata.objectReadmeSectionDetails(1)              AS d
  CROSS 
  APPLY   metadata.getRoutineDefinition(d.routineName)        AS df
  CROSS 
  APPLY  (SELECT df.objDef+'' FOR XML PATH(''), TYPE)         AS f(f)
  CROSS 
  APPLY  (SELECT COUNT(*) FROM metadata.objectReadmeSections) AS section(total)
  WHERE  @orphinMode = 0 OR (@orphinMode = 1 AND d.totalComments < section.total)
) AS details
WHERE details.RN = 1 OR @orphinMode = 0;
--ORDER BY    ROW_NUMBER() OVER (PARTITION BY d.routineName ORDER BY d.itemNumber), d.itemNumber
GO
