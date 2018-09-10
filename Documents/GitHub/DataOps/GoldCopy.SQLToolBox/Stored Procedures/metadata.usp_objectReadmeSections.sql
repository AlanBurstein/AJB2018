SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [metadata].[usp_objectReadmeSections](@output BIT = 1) AS
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

  -- make this a table
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

  --('[Purpose]:'),
  --('[Compatibility]:'),
  --('[Syntax]:'),
  --('[Parameters]:'),
  --('[Returns]:'),
  --('[Developer Notes]:'),
  --('[Examples]:'),
  --('[Revision History]:');

COMMIT TRAN buildTable;

-- Output
IF @output = 1
  SELECT m.sectionName 
  FROM   metadata.objectReadmeSections AS m;
END
GO
