CREATE TABLE [emdbuser].[LoanXDBFieldList]
(
[LoanXDBFieldListId] [int] NOT NULL IDENTITY(1, 1),
[FieldID] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableType] [int] NOT NULL,
[FieldSize] [int] NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UseIndex] [bit] NULL CONSTRAINT [DF__LoanXDBFi__UseIn__50DC3785] DEFAULT ((0)),
[Auditable] [bit] NULL CONSTRAINT [DF__LoanXDBFi__Audit__51D05BBE] DEFAULT ((0)),
[Pair] [int] NOT NULL CONSTRAINT [DF__LoanXDBFie__Pair__52C47FF7] DEFAULT ((0)),
[Status] [int] NOT NULL CONSTRAINT [DF__LoanXDBFi__Statu__53B8A430] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LoanXDBFieldList] ADD CONSTRAINT [Chk_LOANXDBFieldList_ValidateFieldExists] CHECK (([dbo].[fnLoanXDBFieldListColumnExistsInEMDB]([FieldID],[TableName],[Pair])=(1)))
GO
ALTER TABLE [emdbuser].[LoanXDBFieldList] ADD CONSTRAINT [PK_LoanXDBFieldList] PRIMARY KEY CLUSTERED  ([LoanXDBFieldListId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
