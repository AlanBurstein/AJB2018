CREATE TABLE [emdbuser].[LOANXDB_X_03]
(
[XRefID] [int] NOT NULL,
[_CX_ISECLOSING] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_loanxdb_x_03_InsertBy] DEFAULT (replace(suser_sname(),'GRCORP\','')),
[InsertDT] [datetime] NOT NULL CONSTRAINT [df_loanxdb_x_03_InsertDT] DEFAULT (getdate()),
[LastUpdateBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_loanxdb_x_03_LastUpdateBy] DEFAULT (replace(suser_sname(),'GRCORP\','')),
[LastUpdateDT] [datetime] NOT NULL CONSTRAINT [df_loanxdb_x_03_LastUpdateDT] DEFAULT (getdate()),
[Revision] [int] NOT NULL CONSTRAINT [df_loanxdb_x_03_Revision] DEFAULT ((0)),
[_CX_GFEDCOMMENT_4] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_CX_GFEDCOMMENT_5] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_CX_GFEDCOMMENT_6] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LOANXDB_X_03] ADD CONSTRAINT [PK_LOANXDB_X_03] PRIMARY KEY CLUSTERED  ([XRefID]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
