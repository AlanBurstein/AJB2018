CREATE TABLE [emdbuser].[LOANXDB_S_05]
(
[XrefId] [int] NOT NULL,
[_CX_COMPAREMIDFICO_14] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_COMPAREMIDFICO_14] DEFAULT (N''),
[_SYS_X239] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X239] DEFAULT (N''),
[_SYS_X246] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X246] DEFAULT (N''),
[_SYS_X247] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X247] DEFAULT (N''),
[_SYS_X245] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X245] DEFAULT (N''),
[_SYS_X233] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X233] DEFAULT (N''),
[_SYS_X240] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X240] DEFAULT (N''),
[_CX_UWMATCHES_16] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UWMATCHES_16] DEFAULT (N''),
[_CX_PCAUDITCOMMENT_16] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PCAUDITCOMMENT_16] DEFAULT (N''),
[_CX_DOCMAGIC_PLANCODE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_DOCMAGIC_PLANCODE] DEFAULT (N''),
[_CX_PCAUDITOR_16] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PCAUDITOR_16] DEFAULT (N''),
[_CX_DOCMAGIC_TRANSFERTO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_DOCMAGIC_TRANSFERTO] DEFAULT (N''),
[_CX_PCDEPTREVIEW_16] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PCDEPTREVIEW_16] DEFAULT (N''),
[_CX_DOCMAGIC_ALTLENDER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_DOCMAGIC_ALTLENDER] DEFAULT (N''),
[_LINKGUID] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LINKGUID] DEFAULT (N''),
[_LIC_AZ] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_AZ] DEFAULT (N''),
[_LIC_MT] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_MT] DEFAULT (N''),
[_LIC_MO] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_MO] DEFAULT (N''),
[_LIC_MN] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_MN] DEFAULT (N''),
[_LIC_LA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_LA] DEFAULT (N''),
[_LIC_NV] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_NV] DEFAULT (N''),
[_LIC_WI] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_WI] DEFAULT (N''),
[_LIC_DE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_DE] DEFAULT (N''),
[_LIC_NY] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_NY] DEFAULT (N''),
[_LIC_PA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_PA] DEFAULT (N''),
[_LIC_OH] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_OH] DEFAULT (N''),
[_LIC_AL] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_AL] DEFAULT (N''),
[_LIC_TN] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_TN] DEFAULT (N''),
[_LIC_TX] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_TX] DEFAULT (N''),
[_LIC_PR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_PR] DEFAULT (N''),
[_LIC_NE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_NE] DEFAULT (N''),
[_LIC_OR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_OR] DEFAULT (N''),
[_LIC_SC] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_SC] DEFAULT (N''),
[_LIC_NJ] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_NJ] DEFAULT (N''),
[_LIC_IL] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_IL] DEFAULT (N''),
[_LIC_MI] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_MI] DEFAULT (N''),
[_LIC_AR] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_AR] DEFAULT (N''),
[_LIC_ND] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_ND] DEFAULT (N''),
[_LIC_UT] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_UT] DEFAULT (N''),
[_LIC_CA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_CA] DEFAULT (N''),
[_LIC_GA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_GA] DEFAULT (N''),
[_LIC_VA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_VA] DEFAULT (N''),
[_LIC_IN] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_IN] DEFAULT (N''),
[_LIC_KS] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_KS] DEFAULT (N''),
[_LIC_IA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_IA] DEFAULT (N''),
[_LIC_ID] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_ID] DEFAULT (N''),
[_LIC_DC] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_DC] DEFAULT (N''),
[_LIC_WY] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_WY] DEFAULT (N''),
[_LIC_MA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_MA] DEFAULT (N''),
[_LIC_MS] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_MS] DEFAULT (N''),
[_LIC_MD] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_MD] DEFAULT (N''),
[_LIC_NH] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_NH] DEFAULT (N''),
[_LIC_SD] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_SD] DEFAULT (N''),
[_LIC_NC] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_NC] DEFAULT (N''),
[_LIC_FL] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_FL] DEFAULT (N''),
[_LIC_WA] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_WA] DEFAULT (N''),
[_LIC_WV] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_WV] DEFAULT (N''),
[_LIC_HI] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_HI] DEFAULT (N''),
[_LIC_AK] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_AK] DEFAULT (N''),
[_LIC_ME] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_ME] DEFAULT (N''),
[_LIC_VT] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_VT] DEFAULT (N''),
[_LIC_RI] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_RI] DEFAULT (N''),
[_LIC_CT] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_CT] DEFAULT (N''),
[_LIC_CO] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_CO] DEFAULT (N''),
[_LIC_VI] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_VI] DEFAULT (N''),
[_LIC_OK] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_OK] DEFAULT (N''),
[_LIC_NM] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_NM] DEFAULT (N''),
[_LIC_KY] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LIC_KY] DEFAULT (N''),
[_SYS_X4] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X4] DEFAULT (N''),
[_SYS_X43] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X43] DEFAULT (N''),
[_SYS_X38] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X38] DEFAULT (N''),
[_SYS_X49] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X49] DEFAULT (N''),
[_1228] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_1228] DEFAULT (N''),
[_SYS_X16] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X16] DEFAULT (N''),
[_SYS_X117] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X117] DEFAULT (N''),
[_SYS_X40] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X40] DEFAULT (N''),
[_SYS_X19] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X19] DEFAULT (N''),
[_SYS_X116] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X116] DEFAULT (N''),
[_SYS_X21] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X21] DEFAULT (N''),
[_SYS_X29] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X29] DEFAULT (N''),
[_SYS_X20] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X20] DEFAULT (N''),
[_SYS_X201] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X201] DEFAULT (N''),
[_SYS_X48] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X48] DEFAULT (N''),
[_SYS_X28] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X28] DEFAULT (N''),
[_SYS_X50] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X50] DEFAULT (N''),
[_SYS_X45] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X45] DEFAULT (N''),
[_SYS_X22] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X22] DEFAULT (N''),
[_SYS_X23] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X23] DEFAULT (N''),
[_SYS_X15] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X15] DEFAULT (N''),
[_SYS_X203] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X203] DEFAULT (N''),
[_541] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_541] DEFAULT (N''),
[_CX_PCFININVNUMB_16] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PCFININVNUMB_16] DEFAULT (N''),
[_CX_SECONDUNITS_16] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECONDUNITS_16] DEFAULT (N''),
[_CX_HPMLTERM_16] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_HPMLTERM_16] DEFAULT (N''),
[_CX_SECMI_16] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECMI_16] DEFAULT (N''),
[_CX_PREVINVEST_16] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PREVINVEST_16] DEFAULT (N''),
[_CX_PREVINVEST3_16] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PREVINVEST3_16] DEFAULT (N''),
[_CX_HPMLSETRATEPR_16] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_HPMLSETRATEPR_16] DEFAULT (N''),
[_CX_HPMLSETRATE_16] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_HPMLSETRATE_16] DEFAULT (N''),
[_CX_PREVINVEST2_16] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PREVINVEST2_16] DEFAULT (N''),
[_CX_HPMLSTATEMENT_16] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_HPMLSTATEMENT_16] DEFAULT (N''),
[_L248] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_L248] DEFAULT (N''),
[_CX_SECCOMMIT2_10] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECCOMMIT2_10] DEFAULT (N''),
[_SYS_X56] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X56] DEFAULT (N''),
[_CX_SECNEGOTIATE3_10] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECNEGOTIATE3_10] DEFAULT (N''),
[_CX_SECNEGOTIATE2_10] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECNEGOTIATE2_10] DEFAULT (N''),
[_CX_SECNEGOTIATE5_10] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECNEGOTIATE5_10] DEFAULT (N''),
[_CX_SECNEGOTIATE4_10] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECNEGOTIATE4_10] DEFAULT (N''),
[_SYS_X57] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X57] DEFAULT (N''),
[_SYS_X58] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X58] DEFAULT (N''),
[_CX_SECNEGOTIATE_10] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_SECNEGOTIATE_10] DEFAULT (N''),
[_SYS_X6] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X6] DEFAULT (N''),
[_SYS_X55] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SYS_X55] DEFAULT (N''),
[_VEND_X136] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_VEND_X136] DEFAULT (N''),
[_VEND_X114] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_VEND_X114] DEFAULT (N''),
[_4000] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_4000] DEFAULT (N''),
[_4002] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_4002] DEFAULT (N''),
[_4004] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_4004] DEFAULT (N''),
[_4006] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_4006] DEFAULT (N''),
[_CX_FINALLONAME] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_FINALLONAME] DEFAULT (N''),
[_CX_TITENV] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITENV] DEFAULT (N''),
[_CX_TITCOMMENT] [varchar] (175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITCOMMENT] DEFAULT (N''),
[_CX_TRUST] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TRUST] DEFAULT (N''),
[_CX_TITEPA] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITEPA] DEFAULT (N''),
[_CX_TITLOCATION] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITLOCATION] DEFAULT (N''),
[_CX_TITCONDO] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITCONDO] DEFAULT (N''),
[_CX_TITPIN] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITPIN] DEFAULT (N''),
[_CX_TITOK] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITOK] DEFAULT (N''),
[_CX_TITMTGCLAUSE] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITMTGCLAUSE] DEFAULT (N''),
[_CX_TITCONFRIM] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITCONFRIM] DEFAULT (N''),
[_CX_TITLENDERNAME] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITLENDERNAME] DEFAULT (N''),
[LOCKRATE3_1401] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DFLOCKRATE3_1401] DEFAULT (N''),
[LOCKRATE3_1041] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DFLOCKRATE3_1041] DEFAULT (N''),
[LOCKRATE3_1172] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DFLOCKRATE3_1172] DEFAULT (N''),
[_CX_TITARM] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITARM] DEFAULT (N''),
[_CX_UWAUDFIND] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UWAUDFIND] DEFAULT (N''),
[_CX_UWAUDREVIEW] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_UWAUDREVIEW] DEFAULT (N''),
[_CX_TITPUD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_TITPUD] DEFAULT (N''),
[_996] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_996] DEFAULT (N''),
[_2853] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_2853] DEFAULT (N''),
[_2977] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_2977] DEFAULT (N''),
[_CX_PROPTAXBILLCODE_5] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXBILLCODE_5] DEFAULT (N''),
[_CX_PROPTAXBILLCODE_4] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXBILLCODE_4] DEFAULT (N''),
[_CX_PROPTAXBILLCODE_1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXBILLCODE_1] DEFAULT (N''),
[_CX_PROPTAXBILLCODE_3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXBILLCODE_3] DEFAULT (N''),
[_CX_INSFLDCOMPANY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDCOMPANY] DEFAULT (N''),
[_CX_INSWNDPOLICYNO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSWNDPOLICYNO] DEFAULT (N''),
[_CX_PROPTAXADDRESS_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXADDRESS_2] DEFAULT (N''),
[_CX_INSFLDCOMMUNITYNO] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDCOMMUNITYNO] DEFAULT (N''),
[_CX_PROPTAXAUTHORITY_2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXAUTHORITY_2] DEFAULT (N''),
[_CX_INSWNDCITY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSWNDCITY] DEFAULT (N''),
[_CX_INSFLDEQREQ] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDEQREQ] DEFAULT (N''),
[_CX_PROPTAXZIP_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXZIP_3] DEFAULT (N''),
[_CX_INSWNDAGENTNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSWNDAGENTNAME] DEFAULT (N''),
[_CX_INSEQSTATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQSTATE] DEFAULT (N''),
[_CX_PROPTAXSTATE_4] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXSTATE_4] DEFAULT (N''),
[_CX_INSFLDPANELNO] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDPANELNO] DEFAULT (N''),
[_CX_INSHAZPOLICYNO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHAZPOLICYNO] DEFAULT (N''),
[_CX_INSEQAGENTNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQAGENTNAME] DEFAULT (N''),
[_CX_INSFLDPROGRAM] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDPROGRAM] DEFAULT (N''),
[_CX_PROPTAXZIP_1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXZIP_1] DEFAULT (N''),
[_CX_PROPTAXCITY_5] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXCITY_5] DEFAULT (N''),
[_CX_PROPTAXAUTHORITY_3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXAUTHORITY_3] DEFAULT (N''),
[_CX_INSFLDSUFFIXNO] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDSUFFIXNO] DEFAULT (N''),
[_CX_PROPTAXADDRESS_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXADDRESS_3] DEFAULT (N''),
[_CX_INSFLDTYPE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDTYPE] DEFAULT (N''),
[_CX_INSHAZTYPE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHAZTYPE] DEFAULT (N''),
[_CX_INSEQTYPE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQTYPE] DEFAULT (N''),
[_CX_INSFLDCITY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDCITY] DEFAULT (N''),
[_CX_INSEQPOLICYNO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQPOLICYNO] DEFAULT (N''),
[_CX_INSFLDSTATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDSTATE] DEFAULT (N''),
[_CX_INSHURADDRESS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHURADDRESS] DEFAULT (N''),
[_CX_PROPTAXZIP_5] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXZIP_5] DEFAULT (N''),
[_CX_INSFLDZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDZIP] DEFAULT (N''),
[_CX_PROPTAXZIP_2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXZIP_2] DEFAULT (N''),
[_CX_INSHURAGENTNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHURAGENTNAME] DEFAULT (N''),
[_CX_INSFLDADDRESS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDADDRESS] DEFAULT (N''),
[_CX_INSHAZADDRESS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHAZADDRESS] DEFAULT (N''),
[_CX_PROPTAXSTATE_3] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXSTATE_3] DEFAULT (N''),
[_CX_PROPTAXADDRESS_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXADDRESS_5] DEFAULT (N''),
[_CX_INSHURZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHURZIP] DEFAULT (N''),
[_CX_PROPTAXAUTHORITY_4] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXAUTHORITY_4] DEFAULT (N''),
[_CX_PROPTAXBILLCODE_2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXBILLCODE_2] DEFAULT (N''),
[_CX_PROPTAXADDRESS_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXADDRESS_4] DEFAULT (N''),
[_CX_PROPTAXPARCELNO_3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXPARCELNO_3] DEFAULT (N''),
[_CX_PROPTAXPARCELNO_2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXPARCELNO_2] DEFAULT (N''),
[_CX_PROPTAXPARCELNO_5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXPARCELNO_5] DEFAULT (N''),
[_CX_PROPTAXPARCELNO_4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXPARCELNO_4] DEFAULT (N''),
[_CX_PROPTAXADDRESS_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXADDRESS_1] DEFAULT (N''),
[_CX_INSHURSTATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHURSTATE] DEFAULT (N''),
[_CX_INSWNDADDRESS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSWNDADDRESS] DEFAULT (N''),
[_CX_INSHAZCOMPANY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHAZCOMPANY] DEFAULT (N''),
[_CX_INSHAZCITY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHAZCITY] DEFAULT (N''),
[_CX_INSHURCOMPANY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHURCOMPANY] DEFAULT (N''),
[_CX_PROPTAXCITY_4] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXCITY_4] DEFAULT (N''),
[_CX_PROPTAXCITY_1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXCITY_1] DEFAULT (N''),
[_CX_PROPTAXCITY_3] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXCITY_3] DEFAULT (N''),
[_CX_INSWNDTYPE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSWNDTYPE] DEFAULT (N''),
[_CX_PROPTAXAUTHORITY_5] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXAUTHORITY_5] DEFAULT (N''),
[_CX_INSEQADDRESS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQADDRESS] DEFAULT (N''),
[_CX_INSEQCOMPANY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQCOMPANY] DEFAULT (N''),
[_CX_INSEQCITY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQCITY] DEFAULT (N''),
[_CX_INSHURTYPE] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHURTYPE] DEFAULT (N''),
[_CX_INSEQZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSEQZIP] DEFAULT (N''),
[_CX_INSFLDAGENTNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDAGENTNAME] DEFAULT (N''),
[_CX_INSFLDPOLICYNO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSFLDPOLICYNO] DEFAULT (N''),
[_CX_INSHAZAGENTNAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHAZAGENTNAME] DEFAULT (N''),
[_CX_INSHURPOLICYNO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHURPOLICYNO] DEFAULT (N''),
[_CX_PROPTAXCITY_2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_PROPTAXCITY_2] DEFAULT (N''),
[_CX_INSWNDZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSWNDZIP] DEFAULT (N''),
[_CX_INSHAZZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_INSHAZZIP] DEFAULT (N''),
[_2849] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_2849] DEFAULT (N''),
[_2850] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_2850] DEFAULT (N''),
[_CX_AGENCYDONOTSUBMIT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_AGENCYDONOTSUBMIT] DEFAULT (N''),
[_LE3_X2] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LE3_X2] DEFAULT (N''),
[_CD4_X2] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CD4_X2] DEFAULT (N''),
[_CD3_X19] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CD3_X19] DEFAULT (N''),
[_CX_CONDO_PAYMENT_REQUESTOR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CX_CONDO_PAYMENT_REQUESTOR] DEFAULT (N''),
[_NEWHUD2_X1415] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_NEWHUD2_X1415] DEFAULT (N''),
[_NEWHUD2_X2405] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_NEWHUD2_X2405] DEFAULT (N''),
[_NEWHUD2_X79] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_NEWHUD2_X79] DEFAULT (N''),
[_NEWHUD2_X3197] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_NEWHUD2_X3197] DEFAULT (N''),
[_NEWHUD2_X3527] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_NEWHUD2_X3527] DEFAULT (N''),
[_NEWHUD2_X1910] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_NEWHUD2_X1910] DEFAULT (N''),
[_NEWHUD2_X1052] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_NEWHUD2_X1052] DEFAULT (N'')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[ti_LOANXDB_S_05_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_S_05]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF NOT EXISTS( SELECT 1 FROM emdbuser.LoanSummary ls JOIN inserted i ON i.XRefID = ls.XRefID)
	BEGIN

		INSERT INTO emdbuser.LoanSummary([Guid]
										,[LoanNumber]
										,[LoanFolder] 
										,[LoanName]
										,[Status]
										,[loanStatus]
										,[RateLockStatus]
										,[RateIsLocked]
										,[Investor]
										,[Broker]
										,[XRefID]
										,LastModified
										,MortgageInsuranceVendor
										,LinkGuid)
		SELECT NEWID()
			  ,''
			  ,''
			  ,NEWID()
			  ,'A'
			  ,''
			  ,''
			  ,''
			  ,''
			  ,''
			  ,XRefID
			  ,GETDATE()
			  ,_L248
			  ,_LINKGUID
		FROM inserted i
	END
	ELSE

		UPDATE ls
		SET  MortgageInsuranceVendor = i._L248
			,LinkGuid = i._LINKGUID
			,LastModified = GETDATE()
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [emdbuser].[tu_LOANXDB_S_05_Forklift_LoanSummary]
   ON  [emdbuser].[LOANXDB_S_05]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF (UPDATE(_L248) OR UPDATE(_LINKGUID))

		UPDATE ls
		SET  MortgageInsuranceVendor = i._L248
			,LinkGuid = i._LINKGUID
			,LastModified = GETDATE()
		FROM emdbuser.LoanSummary ls
		JOIN inserted i ON i.XRefID = ls.XRefID

	



END
GO
ALTER TABLE [emdbuser].[LOANXDB_S_05] ADD CONSTRAINT [PK_LOANXDB_S_05_XrefId] PRIMARY KEY CLUSTERED  ([XrefId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LOANXDB_S_05_CHILHQSQLDB_rs_BasicData_adalparams1_02] ON [emdbuser].[LOANXDB_S_05] ([XrefId]) INCLUDE ([_4002], [_CX_FINALLONAME]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
