CREATE TABLE [emdbuser].[LoanSummaryDAT_4848]
(
[Guid] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoanNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[XRefID] [int] NOT NULL,
[LoanOfficerName] [varchar] (101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanProcessorName] [varchar] (101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanFolder] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BorrowerFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isFalseLoanOverride] [bit] NULL,
[isFalseLoan] AS (CONVERT([bit],case  when [LoanFolder] like '%samples%' then (1) when [LoanFolder] like '%test%' then (1) when [LoanFolder] like '%train%' then (1) when [LoanFolder] like '%trash%' then (1) when [isFalseLoanOverride]=(1) then (1) else (0) end,(0))) PERSISTED
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LoanSummaryDAT_4848] ADD CONSTRAINT [PK_LoanSummaryDAT_4848_LoanSummaryDAT_4848Id] PRIMARY KEY CLUSTERED  ([Guid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_LoanSummaryDAT_4848_isFalseLoan] ON [emdbuser].[LoanSummaryDAT_4848] ([isFalseLoan]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
