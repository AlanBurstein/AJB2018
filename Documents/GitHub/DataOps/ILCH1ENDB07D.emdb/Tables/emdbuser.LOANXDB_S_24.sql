CREATE TABLE [emdbuser].[LOANXDB_S_24]
(
[XrefId] [int] NOT NULL,
[_CX_UW_LS_ASSETS] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UW_LS_ASSETS] DEFAULT (N''),
[_CX_UWXRA_12] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UWXRA_12] DEFAULT (N''),
[_CX_ONLINETRANSACTIONID] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_ONLINETRANSACTIONID] DEFAULT (N''),
[_CX_UWXRA_1] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UWXRA_1] DEFAULT (N''),
[_CX_UWXRA_3] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UWXRA_3] DEFAULT (N''),
[_CX_UWXRA_2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UWXRA_2] DEFAULT (N''),
[_CX_ECOA_10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_ECOA_10] DEFAULT (N''),
[_CX_APPRLXORDERID3_4] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_APPRLXORDERID3_4] DEFAULT (N''),
[_CX_POA_TRACKING_INFO] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_POA_TRACKING_INFO] DEFAULT (N''),
[_CX_APPRLXORDERID5_4] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_APPRLXORDERID5_4] DEFAULT (N''),
[_CX_APPRLXORDERID2_4] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_APPRLXORDERID2_4] DEFAULT (N''),
[_CX_APPRLXORDERID4_4] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_APPRLXORDERID4_4] DEFAULT (N'')
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LOANXDB_S_24] ADD CONSTRAINT [PK_LOANXDB_S_24_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
