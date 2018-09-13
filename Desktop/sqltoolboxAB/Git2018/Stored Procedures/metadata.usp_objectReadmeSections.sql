SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [metadata].[usp_objectReadmeSections](@output BIT = 1) AS
/*****************************************************************************************
[Purpose]:
 <breif details about what the routine does,,>

[Author]:
 <Author,,> -- dditional credits can go here (e.g. "based on Joe Smith's code...")

[Compatibility]:
 <SQL Server Version,,SQL Server 2008+>
 <optional details about why it won't work with earlier versions,,>

[Syntax]:
--===== Autonomous
 SELECT f.returnValue
 FROM   dbo.yourfunction(@parameters) AS f;

--===== Against a table using APPLY
 SELECT      f.returnValue
 FROM        dbo.someTable                        AS t
 CROSS APPLY dbo.yourfunction(t.col, @parameters) AS f;

[Parameters]:
  @string = <datatype,,>; <parameter details,,>

[Returns]:
 <function type,,inline table valued function> returns:
 <name,,> = <datatype,,> <description,,>

[Dependencies]:
 <Dependencies,,N/A>

[Developer Notes]:
 1. Returns <return value on NULL input,,a single NULL>, 
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

--===== 1. <tile 1.,,>
 -- (1.1) <subtitle 1.1,,>
 <example code,,s>;

 -- (1.2) <subtitle 1.2.,,>
 <example code 12..,,s>;

--===== 2. <tile 2.,,>
 -- (1.1) <subtitle,,>
 <example code,,>;

-----------------------------------------------------------------------------------------
[Revision History]: 
 Rev 00 - <YYYYMMDD> - <details> - <developer>
*****************************************************************************************/
BEGIN
BEGIN TRAN buildTable
  IF OBJECT_ID('metadata.objectReadmeSections','U') IS NOT NULL
    DROP TABLE metadata.objectReadmeSections;

  CREATE TABLE metadata.objectReadmeSections
  (
   sortKey            TINYINT IDENTITY                NOT NULL,
   sectionName        VARCHAR(30)                     NOT NULL,
   sectionNameLength  AS (LEN(sectionName)) PERSISTED NOT NULL,
   sectionDescription VARCHAR(1000)                   NOT NULL DEFAULT(''),
   CONSTRAINT pk_cl__metadata_objectReadmeSections__section 
     UNIQUE CLUSTERED(sortKey),
   CONSTRAINT ck__metadata_objectReadmeSections 
     CHECK(sectionName = RTRIM(LTRIM(sectionName)) AND PATINDEX('%[^A-Z ]%',sectionName)=0)
  );

  -- !!! make this a table
  INSERT metadata.objectReadmeSections(sectionName) VALUES
  ('Purpose'),
  ('Author'),
  ('Compatibility'),
  ('Syntax'),
  ('Parameters'),
  ('Returns'),
  ('Dependencies'),
  ('Developer Notes'),
  ('Examples'),
  ('Revision History');

COMMIT TRAN buildTable;

-- Output
IF @output = 1
  SELECT m.sectionName 
  FROM   metadata.objectReadmeSections AS m;
END
GO
