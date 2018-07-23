CREATE TABLE [emdbuser].[LOANXDB_X_04]
(
[XRefId] [int] NOT NULL,
[InsertBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_loanxdb_x_04_InsertBy] DEFAULT (replace(suser_sname(),'GRCORP\','')),
[InsertDT] [datetime] NOT NULL CONSTRAINT [df_loanxdb_x_04_InsertDT] DEFAULT (getdate()),
[LastUpdateBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_loanxdb_x_04_LastUpdateBy] DEFAULT (replace(suser_sname(),'GRCORP\','')),
[LastUpdateDT] [datetime] NOT NULL CONSTRAINT [df_loanxdb_x_04_LastUpdateDT] DEFAULT (getdate()),
[Revision] [int] NOT NULL CONSTRAINT [df_loanxdb_x_04_Revision] DEFAULT ((0)),
[_CX_GFEDCOMMENT_7] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_CX_GFEDCOMMENT_8] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_CX_GFEDCOMMENT_9] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LOANXDB_X_04] ADD CONSTRAINT [pk_LOANXDB_X_04] PRIMARY KEY CLUSTERED  ([XRefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
