SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [metadata].[getRoutineDefinition]
(
  @routine VARCHAR(300)
)
/*
--==== 1. Filter on routine name
-- either works (schema or no schema):
DECLARE @routine VARCHAR(200) = 'delimitedSplitAB8K'; --'samd.delimitedSplitAB8K'

SELECT fd.routineName, fd.routineType, fd.objDef 
FROM metadata.getRoutineDefinition(@routine) AS fd;

--==== 2. Get all the definitions
SELECT fd.routineName, fd.routineType, fd.objDef 
FROM metadata.getRoutineDefinition('ALL') AS fd;
*/
RETURNS TABLE AS RETURN
SELECT TOP (1+IIF(@routine='ALL',10000000,0))
  routineName = routineName.txt,
  routineType = routine.ROUTINE_TYPE,
  objDef      = OBJECT_DEFINITION(OBJECT_ID(routineName.txt))
FROM INFORMATION_SCHEMA.ROUTINES                     AS routine
CROSS APPLY (VALUES(CONCAT(
  routine.ROUTINE_SCHEMA,'.',routine.ROUTINE_NAME))) AS routineName(txt)
WHERE        @routine IN (routine.ROUTINE_NAME, routineName.txt, 'ALL') 
ORDER BY     routine.ROUTINE_TYPE, routine.ROUTINE_SCHEMA, routine.ROUTINE_NAME;
GO
