CREATE TABLE [metadata].[objectReadmeSections]
(
[sortKey] [tinyint] NOT NULL IDENTITY(1, 1),
[sectionName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sectionNameLength] AS (len([sectionName])) PERSISTED NOT NULL,
[sectionDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__objectRea__secti__5B0E7E4A] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [metadata].[objectReadmeSections] ADD CONSTRAINT [ck__metadata_objectReadmeSections] CHECK (([sectionName]=rtrim(ltrim([sectionName])) AND patindex('%[^A-Z ]%',[sectionName])=(0)))
GO
ALTER TABLE [metadata].[objectReadmeSections] ADD CONSTRAINT [pk_cl__metadata_objectReadmeSections__section] UNIQUE CLUSTERED  ([sortKey]) ON [PRIMARY]
GO
