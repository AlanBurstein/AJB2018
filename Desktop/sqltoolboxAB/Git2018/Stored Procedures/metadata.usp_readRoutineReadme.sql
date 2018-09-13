SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [metadata].[usp_readRoutineReadme](@routine VARCHAR(200)) AS
BEGIN
  -- Output
  SELECT r.sectionName, r.sectionText, r.sectionTextXML
  FROM metadata.parseRoutineReadme(@routine) AS r;
  
  -- Missing Columns
  SELECT
    routine     =  df.routineName, 
    routineType =  df.routineType, 
    section     =  s.sectionName,
    objectDef   = (SELECT df.objDef+'' FOR XML PATH(''), TYPE)
  FROM        metadata.getRoutineDefinition(@routine) AS df
  CROSS JOIN  metadata.objectReadmeSections           AS s
  WHERE       CHARINDEX(s.sectionName,df.objDef) = 0;
END
GO
