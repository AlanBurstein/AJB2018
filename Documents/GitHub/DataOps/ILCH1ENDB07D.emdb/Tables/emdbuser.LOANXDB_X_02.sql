CREATE TABLE [emdbuser].[LOANXDB_X_02]
(
[XRefId] [int] NOT NULL,
[InsertBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_loanxdb_x_02_InsertBy] DEFAULT (replace(suser_sname(),'GRCORP\','')),
[InsertDT] [datetime] NOT NULL CONSTRAINT [df_loanxdb_x_02_InsertDT] DEFAULT (getdate()),
[LastUpdateBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_loanxdb_x_02_LastUpdateBy] DEFAULT (replace(suser_sname(),'GRCORP\','')),
[LastUpdateDT] [datetime] NOT NULL CONSTRAINT [df_loanxdb_x_02_LastUpdateDT] DEFAULT (getdate()),
[Revision] [int] NOT NULL CONSTRAINT [df_loanxdb_x_02_Revision] DEFAULT ((0)),
[_CX_GFEDCOMMENT] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_CX_GFEDCOMMENT_2] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[_CX_GFEDCOMMENT_3] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LOANXDB_X_02] ADD CONSTRAINT [pk_LOANXDB_X_02] PRIMARY KEY CLUSTERED  ([XRefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
