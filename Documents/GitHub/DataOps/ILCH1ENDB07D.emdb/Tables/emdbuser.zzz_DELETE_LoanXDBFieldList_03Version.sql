CREATE TABLE [emdbuser].[zzz_DELETE_LoanXDBFieldList_03Version]
(
[LoanXDBFieldListId] [int] NOT NULL,
[FieldID] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableType] [int] NOT NULL,
[FieldSize] [int] NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UseIndex] [bit] NULL,
[Auditable] [bit] NULL,
[Pair] [int] NOT NULL,
[Status] [int] NOT NULL
) ON [PRIMARY]
GO
