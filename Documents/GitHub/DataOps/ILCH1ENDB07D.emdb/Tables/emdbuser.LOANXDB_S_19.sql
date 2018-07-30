CREATE TABLE [emdbuser].[LOANXDB_S_19]
(
[XrefId] [int] NOT NULL,
[_CX_LM_PROGRESS_NOTES] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_LM_PROGRESS_NOTES] DEFAULT (N''),
[_BE0110] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0110] DEFAULT (N''),
[_BE0105] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0105] DEFAULT (N''),
[_BE0104] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0104] DEFAULT (N''),
[_BE0115] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0115] DEFAULT (N''),
[_BE0102] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0102] DEFAULT (N''),
[_BE0109] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0109] DEFAULT (N''),
[_FL0110] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0110] DEFAULT (N''),
[_FL0103] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0103] DEFAULT (N''),
[_FL0104] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0104] DEFAULT (N''),
[_FL0105] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0105] DEFAULT (N''),
[_CX_OVERWIRE_DESC] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_OVERWIRE_DESC] DEFAULT (N''),
[_CX_SEVERITY_RATING] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SEVERITY_RATING] DEFAULT (N''),
[_CE0102] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0102] DEFAULT (N''),
[_CE0104] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0104] DEFAULT (N''),
[_DD0102] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0102] DEFAULT (N''),
[_DD0104] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0104] DEFAULT (N''),
[_DD0105] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0105] DEFAULT (N''),
[_CE0115] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0115] DEFAULT (N''),
[_DD0202] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0202] DEFAULT (N''),
[_DD0224] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0224] DEFAULT (N''),
[_DD0207] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0207] DEFAULT (N''),
[_DD0205] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0205] DEFAULT (N''),
[_DD0204] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0204] DEFAULT (N''),
[_CE0137] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0137] DEFAULT (N''),
[_DD0208] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0208] DEFAULT (N''),
[_DD0210] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0210] DEFAULT (N''),
[_FL0203] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0203] DEFAULT (N''),
[_FL0210] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0210] DEFAULT (N''),
[_CE0110] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0110] DEFAULT (N''),
[_BE0202] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0202] DEFAULT (N''),
[_CE0105] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0105] DEFAULT (N''),
[_CE0107] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0107] DEFAULT (N''),
[_CE0109] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0109] DEFAULT (N''),
[_BE0205] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0205] DEFAULT (N''),
[_FL0207] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0207] DEFAULT (N''),
[_FL0206] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0206] DEFAULT (N''),
[_FL0205] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0205] DEFAULT (N''),
[_FL0204] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0204] DEFAULT (N''),
[_BE0206] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0206] DEFAULT (N''),
[_BE0207] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0207] DEFAULT (N''),
[_BE0204] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_BE0204] DEFAULT (N''),
[_CX_CHECK_INCLUDED] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_CHECK_INCLUDED] DEFAULT (N''),
[_CX_SUSPENSEFORMI] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SUSPENSEFORMI] DEFAULT (N''),
[_CX_DIRECT_BILLING_ELIGIBLE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_DIRECT_BILLING_ELIGIBLE] DEFAULT (N''),
[_DD0310] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_DD0310] DEFAULT (N''),
[_FL0306] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0306] DEFAULT (N''),
[_FL0304] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_FL0304] DEFAULT (N''),
[_CE0217] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0217] DEFAULT (N''),
[_CE0206] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CE0206] DEFAULT (N'')
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LOANXDB_S_19] ADD CONSTRAINT [PK_LOANXDB_S_19_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_S_19_LicensingLoanDetails_04] ON [emdbuser].[LOANXDB_S_19] ([XrefId]) INCLUDE ([_BE0102], [_BE0104], [_BE0105], [_CE0102], [_CE0104], [_CE0105], [_CE0107]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO