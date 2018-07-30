CREATE TABLE [emdbuser].[LOANXDB_D_02]
(
[XrefId] [int] NOT NULL,
[_CX_SHIPSERVSHIP_4] [datetime] NULL,
[_REQUEST_X21] [datetime] NULL,
[_DENIAL_X11] [datetime] NULL,
[_CX_LNGDATE_4] [datetime] NULL,
[_2360] [datetime] NULL,
[_CX_MORTGAGERECVD_4] [datetime] NULL,
[_2359] [datetime] NULL,
[_1403] [datetime] NULL,
[_CX_ACCCARDSTAMP_5] [datetime] NULL,
[_CX_BROKERCLOSE_5] [datetime] NULL,
[_CX_BROKERFUND_5] [datetime] NULL,
[_CX_PROBLOANDT_5] [datetime] NULL,
[_1998] [datetime] NULL,
[_CX_BRKSUBMIT_12] [datetime] NULL,
[_CX_BRKAPPROVE_12] [datetime] NULL,
[_2397] [datetime] NULL,
[Log_MS_Date_AssigntoClose] [datetime] NULL,
[Log_MS_Date_ConditionsSubmittedtoUW] [datetime] NULL,
[Log_MS_Date_UWDecisionExpected] [datetime] NULL,
[_CX_PROBLOANSUBDT_14] [datetime] NULL,
[_CX_PROBLOANCLSDT_14] [datetime] NULL,
[_CX_PCREVIEWCLEAR_16] [datetime] NULL,
[_CX_PCDATEREVIEW_16] [datetime] NULL,
[_CX_SECORIGLOCK2_16] [datetime] NULL,
[_CX_SECORIGLOCK3_16] [datetime] NULL,
[_CX_LOCKCANCEL2_16] [datetime] NULL,
[_CX_LOCKCANCEL_16] [datetime] NULL,
[_CX_SECORIGLOCK_16] [datetime] NULL,
[_CX_LOCKCANCEL3_16] [datetime] NULL,
[_CX_SECORIGLOCK4_10] [datetime] NULL,
[_CX_SECORIGLOCK5_10] [datetime] NULL,
[_CX_DATE_10] [datetime] NULL,
[_CX_LOCKCANCEL4_10] [datetime] NULL,
[_CX_LOCKCANCEL5_10] [datetime] NULL,
[_CX_ACCTVERIFY_10] [datetime] NULL,
[_2365] [datetime] NULL,
[_MS_APP] [datetime] NULL,
[_MS_PROC] [datetime] NULL,
[_MS_DOC] [datetime] NULL,
[_MS_CLO] [datetime] NULL,
[_MS_START] [datetime] NULL,
[_MS_FUN] [datetime] NULL,
[_CX_APPRRECTRANS_10] [datetime] NULL,
[_CX_SUBORDRECVD_10] [datetime] NULL,
[_CX_INSURRECVD_10] [datetime] NULL,
[_CX_CONDORECV_10] [datetime] NULL,
[_CX_CONDODOCS_10] [datetime] NULL,
[_CX_APPRORDERTRANS_10] [datetime] NULL,
[_CX_SUBORD_10] [datetime] NULL,
[_CX_PAYOFFRECV_10] [datetime] NULL,
[_NEWHUD_X332] [datetime] NULL,
[_NEWHUD_X1] [datetime] NULL,
[_NEWHUD_X2] [datetime] NULL,
[_CX_CLSREC] [datetime] NULL,
[_CX_SECDELV] [datetime] NULL,
[_CX_SECDELV5] [datetime] NULL,
[_CX_SECEXP] [datetime] NULL,
[_CX_CLSESTFUND] [datetime] NULL,
[_CX_SECDELV2] [datetime] NULL,
[_CX_SECEXP2] [datetime] NULL,
[_CX_SECEXP3] [datetime] NULL,
[_CX_SECEXP4] [datetime] NULL,
[_CX_SECDELV4] [datetime] NULL,
[_CX_CLSASSTOCLS] [datetime] NULL,
[_CX_SECDELV3] [datetime] NULL,
[_CX_CLSTOPOD] [datetime] NULL,
[_CX_SECEXP5] [datetime] NULL,
[_3140] [datetime] NULL,
[_3143] [datetime] NULL,
[_3142] [datetime] NULL,
[_3144] [datetime] NULL,
[_3147] [datetime] NULL,
[_3149] [datetime] NULL,
[_3148] [datetime] NULL,
[_3165] [datetime] NULL,
[_3167] [datetime] NULL,
[_CX_MERSTRANS] [datetime] NULL,
[_3137] [datetime] NULL,
[_3150] [datetime] NULL,
[_3153] [datetime] NULL,
[_3152] [datetime] NULL,
[_3155] [datetime] NULL,
[_3154] [datetime] NULL,
[_3151] [datetime] NULL,
[_3170] [datetime] NULL,
[_3544] [datetime] NULL,
[_3545] [datetime] NULL,
[_3546] [datetime] NULL,
[_3547] [datetime] NULL,
[_CX_POA_CTRCLEARDATE] [datetime] NULL,
[_2966] [datetime] NULL,
[_CX_CDSIGNEDALL] [datetime] NULL,
[_3197] [datetime] NULL,
[_CX_APPROVALCLEANUPSUBDATE] [datetime] NULL,
[_CX_APPRAISALONLYSUBDATE] [datetime] NULL,
[_CX_ESIGNCONSENTRECEIVEDDATE1] [datetime] NULL,
[_3979] [datetime] NULL,
[_3977] [datetime] NULL,
[_CX_MOSTRECENTLEAPPROVEDDATE] [datetime] NULL,
[_CX_ESIGNCONSENTRECEIVEDDATE2] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LOANXDB_D_02] ADD CONSTRAINT [PK_LOANXDB_D_02_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LOANXDB_D_02_MS_START] ON [emdbuser].[LOANXDB_D_02] ([_MS_START]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_02__MS_START_Includes] ON [emdbuser].[LOANXDB_D_02] ([_MS_START]) INCLUDE ([_3142], [_3143], [_3148], [_3152], [_REQUEST_X21], [Log_MS_Date_ConditionsSubmittedtoUW], [XrefId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_D_02_LoanService_08] ON [emdbuser].[LOANXDB_D_02] ([XrefId]) INCLUDE ([_CX_APPRORDERTRANS_10], [_CX_APPRRECTRANS_10], [_MS_START], [Log_MS_Date_UWDecisionExpected]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO