SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [metadata].[getRoutineDefinition]
(
  @routine VARCHAR(300)
)
/*****************************************************************************************
[Purpose]:
 
[Author]:
 Alan Burstein

[Compatibility]:
 SQL Server 2008+

[Syntax]:
--===== Autonomous
 SELECT f.returnValue
 FROM   metadata.getRoutineDefinition(@parameters) AS r;

--===== Against a table using APPLY
 SELECT      f.returnValue
 FROM        dbo.someTable                        AS t
 CROSS APPLY dbo.yourfunction(t.col, @parameters) AS f;

[Parameters]:
  @routine = VARCHAR(300); the stored proc or function to look up

[Returns]:
 inline table valued function returns:
 metadata.getRoutineDefinition =  

[Dependencies]:
 N/A

[Developer Notes]:
 X. @routine can be the name of a stored proc or the text "ALL" (no quotes). All will
    return all routines in INFORMATION_SCHEMA.ROUTINES

 X. Does not return the definition for CLR objects because they are not available via 
   OBJECT_DEFINITION which is used to return the definition.

 1. Returns a single NULL, 
    No rows. To return a single row containing a a NULL or 
    Blank row on NULL inputparameters conider using OUTER APPLY or append the function 
    with a UNION ALL "dummy row." Noe the following examples:

    

    
    UNION ALL SELECT NULL, WHERE NULLIF(@parameter,'') IS NULL;
 2. Case sensitivity and collation
 4.  is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx
 5.  performs substantially|marginally|notably better with 
    a parallel execution plan, often 2-3 times faster. For queries that leverage 
    patextract8K that are not getting a parallel exeution plan you should consider 
    performance testing using Traceflag 8649 in Development environments and 
    Adam Machanic's make_parallel in Production. 

[Examples]:
--==== 1. Filter on routine name
 DECLARE @routine VARCHAR(200) = 'delimitedSplitAB8K'; --'samd.delimitedSplitAB8K'
 
 SELECT fd.routineName, fd.routineType, fd.objDef
 FROM   metadata.getRoutineDefinition(@routine) AS fd;

--==== 2. Get all the definitions
 SELECT fd.routineName, fd.routineType, fd.objDef 
 FROM   metadata.getRoutineDefinition('ALL') AS fd;
-----------------------------------------------------------------------------------------
[Revision History]: 
 Rev 00 - 20180911 - Initial Creation - Alan Burstein
*****************************************************************************************/
RETURNS TABLE AS RETURN
SELECT TOP (1+CASE WHEN @routine='ALL'THEN 10000000 ELSE 0 END)
  routineName = routineName.txt,
  routineType = routine.ROUTINE_TYPE,
  objDef      = OBJECT_DEFINITION(OBJECT_ID(routineName.txt))
FROM INFORMATION_SCHEMA.ROUTINES                     AS routine
CROSS APPLY (VALUES(CONCAT(
  routine.ROUTINE_SCHEMA,'.',routine.ROUTINE_NAME))) AS routineName(txt)
WHERE        @routine IN (routine.ROUTINE_NAME, routineName.txt, 'ALL') 
ORDER BY     routine.ROUTINE_TYPE, routine.ROUTINE_SCHEMA, routine.ROUTINE_NAME;
GO
