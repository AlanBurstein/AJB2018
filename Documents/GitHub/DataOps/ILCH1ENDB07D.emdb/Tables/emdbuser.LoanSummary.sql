CREATE TABLE [emdbuser].[LoanSummary]
(
[Guid] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoanNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoanFolder] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoanName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrowerFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrowerLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanOfficerId] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanProcessorId] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanOfficerName] [varchar] (101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanProcessorName] [varchar] (101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanPurpose] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondMortgage] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentMilestoneName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentMilestoneDate] [smalldatetime] NULL,
[NextMilestoneName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextMilestoneDate] [datetime] NULL,
[PrevMilestoneGroupDate] [datetime] NULL,
[CurrentCoreMilestoneName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextCoreMilestoneName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessorReviewed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LockExpirationDate] [smalldatetime] NULL,
[Lender] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnderwriterVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AppraisalVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EscrowVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FloodVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocPrepVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HazardInsuranceVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MortgageInsuranceVendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferralSource] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateFileOpened] [smalldatetime] NULL,
[DateSentToProcessing] [datetime] NULL,
[DateSubmittedToLender] [datetime] NULL,
[DateApprovalReceived] [datetime] NULL,
[DateDocsSigned] [datetime] NULL,
[DateFunded] [smalldatetime] NULL,
[DateOfEstimatedCompletion] [datetime] NULL,
[DateCompleted] [smalldatetime] NULL,
[LastModified] [datetime] NULL,
[ActionTaken] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionTakenDate] [smalldatetime] NULL,
[CensusTract] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSA] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerSex] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrowerSex] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerRace] [varchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrowerRace] [varchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerEthnicity] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoBorrowerEthnicity] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanCloserId] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanCloserName] [varchar] (101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkGuid] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loanStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[loanDocTypeCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LockRequestDate] [smalldatetime] NULL,
[RateLockStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RateIsLocked] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Investor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Broker] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoanProgram] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupancyStatus] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EscrowWaived] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PropertyType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvestorStatus] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvestorStatusDate] [datetime] NULL,
[TradeGuid] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TradeNumber] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amortization] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateShipped] [datetime] NULL,
[DatePurchased] [datetime] NULL,
[ISStatementDue] [datetime] NULL,
[ISPaymentDue] [datetime] NULL,
[ISEscrowDue] [datetime] NULL,
[RegistrationExpiredDate] [datetime] NULL,
[InvestorDeliveryDate] [datetime] NULL,
[CurrentMilestoneID] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextMilestoneID] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loanChannel] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LockRequested] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LockRequestPending] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BorrowerName] AS (case  when [BorrowerLastName]='' AND [BorrowerFirstName]='' then '' else ([BorrowerLastName]+', ')+[BorrowerFirstName] end),
[CoBorrowerName] AS (case  when [CoBorrowerLastName]='' AND [CoBorrowerFirstName]='' then '' else ([CoBorrowerLastName]+', ')+[CoBorrowerFirstName] end),
[AppraisedValue] [money] NULL,
[DownPayment] [money] NULL,
[LoanSource] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[BuySideCommitted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellSideCommitted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Adverse] AS (case  when [LoanStatus]=(6) OR [LoanStatus]=(1) OR [LoanStatus]=(0) then 'N' else 'Y' end),
[Completed] AS (case  when [DateCompleted] IS NULL then 'N' else 'Y' end),
[DateOfFinalAction] AS (case  when [LoanStatus]=(6) OR [LoanStatus]=(1) OR [LoanStatus]=(0) then [DateCompleted] else [ActionTakenDate] end),
[LienPosition] AS (case  when [SecondMortgage]='Y' then 'SecondLien' else 'FirstLien' end),
[ARMAdjustmentDate] [smalldatetime] NULL,
[ISStatus] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoanAmount] [money] NULL,
[LoanRate] [decimal] (18, 5) NULL,
[Term] [int] NULL,
[LockDays] [int] NULL,
[LoanOfficerProfit] [money] NULL,
[LoanBrokerProfit] [money] NULL,
[LoanProcessorProfit] [money] NULL,
[ManagerProfit] [money] NULL,
[OtherProfit] [money] NULL,
[TotalCommissionByLoan] [money] NULL,
[TotalCommissionByProfit] [money] NULL,
[TotalAdditionalCommission] [money] NULL,
[LOCommissionByLoan] [money] NULL,
[LOCommissionByProfit] [money] NULL,
[LOAdditionalCommission] [money] NULL,
[TotalLoanAmount] [money] NULL,
[CreditScore] [int] NULL,
[LTV] [decimal] (18, 5) NULL,
[CLTV] [decimal] (18, 5) NULL,
[NetBuyPrice] [decimal] (18, 5) NULL,
[NetSellPrice] [decimal] (18, 5) NULL,
[TotalBuyPrice] [decimal] (18, 5) NULL,
[TotalSellPrice] [decimal] (18, 5) NULL,
[NetProfit] [money] NULL,
[DTITop] [decimal] (18, 5) NULL,
[DTIBottom] [decimal] (18, 5) NULL,
[ARMMargin] [decimal] (18, 5) NULL,
[ARMLifeCap] [decimal] (18, 5) NULL,
[ARMFloorRate] [decimal] (18, 5) NULL,
[ARMFirstRateAdjCap] [decimal] (18, 5) NULL,
[ISLatePaymentDate] [datetime] NULL,
[XRefID] [int] NOT NULL,
[TotalMonthlyIncome] [money] NULL,
[EstimatedValue] [money] NULL,
[LockExtensionRequestPending] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LockCancellationRequestPending] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LockIsCancelled] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelockRequestPending] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOLOID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOLPID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOCompanyID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOBranchID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPORegisterDate] [datetime] NULL,
[TPOSubmitDate] [datetime] NULL,
[UnderWriterApprovalDate] [datetime] NULL,
[UnderWriterSuspendedDate] [datetime] NULL,
[UnderWriterDeniedDate] [datetime] NULL,
[UnderWriterDifferentApprovedDate] [datetime] NULL,
[TPOSiteID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOArchived] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOLOName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOLPName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOCompanyName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TPOBranchName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] AS (case  when [NextMilestoneID] IS NULL OR NOT ([LoanStatus]=(6) OR [LoanStatus]=(1) OR [LoanStatus]=(0)) then 'N' else 'Y' end),
[LockCommitment] AS (case  when [NextMilestoneID] IS NULL then '' when [BuySideCommitted]='Y' AND [SellSideCommitted]='Y' then 'Locked' when [BuySideCommitted]='Y' AND [SellSideCommitted]='N' then 'Long' else 'Floating' end),
[LockStatusSortKey] AS (case  when [LockExpirationDate] IS NULL then (0) when datediff(day,getdate(),[LockExpirationDate])<(0) then (2) else (1) end),
[LockAndRequestStatus] AS ([emdbuser].[FN_CalcLockAndRequestStatus]([LockRequestPending],[LockExpirationDate],[LockExtensionRequestPending],[LockCancellationRequestPending],[LockIsCancelled],[RelockRequestPending])),
[LockAndRequestSortKey] AS ([emdbuser].[FN_CalcLockAndRequestSortKey]([LockRequestPending],[LockExpirationDate],[LockExtensionRequestPending],[LockCancellationRequestPending],[LockIsCancelled],[RelockRequestPending])),
[LockStatus] AS (case  when [LockIsCancelled]='Y' then 'Cancelled' when [LockExpirationDate] IS NULL then 'NotLocked' when datediff(day,getdate(),[LockExpirationDate])<(0) then 'Expired' else 'Locked' end),
[CorrespondentTradeGuid] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CorrespondentTradeNumber] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isFalseLoanOverride] [bit] NULL,
[isFalseLoan] AS (CONVERT([bit],case  when [LoanFolder] like '%samples%' then (1) when [LoanFolder] like '%test%' then (1) when [LoanFolder] like '%train%' then (1) when [LoanFolder] like '%trash%' then (1) when [isFalseLoanOverride]=(1) then (1) else (0) end,(0))) PERSISTED
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[LoanSummary] ADD CONSTRAINT [PK_LoanSummary_LoanSummaryId] PRIMARY KEY CLUSTERED  ([Guid]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LoanSummary_Address1_LastModified_includes] ON [emdbuser].[LoanSummary] ([Address1], [LastModified]) INCLUDE ([XRefID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LoanSummary_CurrentMilestoneID] ON [emdbuser].[LoanSummary] ([CurrentMilestoneID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LoanSummary_DateCompleted_Guid_LoanFolder] ON [emdbuser].[LoanSummary] ([DateCompleted], [Guid], [LoanFolder]) INCLUDE ([Address1], [Address2], [City], [DateCreated], [LoanAmount], [LoanOfficerId], [loanStatus], [LoanType], [State], [Zip]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_4] ON [emdbuser].[LoanSummary] ([Guid], [DateFunded]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_1] ON [emdbuser].[LoanSummary] ([Guid], [LoanFolder], [LoanNumber]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_3] ON [emdbuser].[LoanSummary] ([Guid], [LockExpirationDate], [Active]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LoanSummary_Guid_XrefId] ON [emdbuser].[LoanSummary] ([Guid], [XRefID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_LoanSummary_isFalseLoan] ON [emdbuser].[LoanSummary] ([isFalseLoan]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LoanSummary_LastModified_includes] ON [emdbuser].[LoanSummary] ([LastModified]) INCLUDE ([XRefID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LoanSummary_LoanFolder_02] ON [emdbuser].[LoanSummary] ([LoanFolder]) INCLUDE ([Address1], [BorrowerName], [Guid], [LoanNumber], [LoanOfficerName], [LockCancellationRequestPending], [LockExpirationDate], [LockExtensionRequestPending], [LockIsCancelled], [LockRequestDate], [LockRequestPending], [RelockRequestPending]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LoanSummary_LoanFolder_Guid_LoanNumber_BorrowerName_XRefID] ON [emdbuser].[LoanSummary] ([LoanFolder]) INCLUDE ([BorrowerName], [Guid], [LoanNumber], [XRefID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LoanSummary_LoanFolder_Guid] ON [emdbuser].[LoanSummary] ([LoanFolder], [Guid]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LoanSummary_LoanFolder_XRefID] ON [emdbuser].[LoanSummary] ([LoanFolder], [XRefID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LoanSummary_LoanNumber] ON [emdbuser].[LoanSummary] ([LoanNumber]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LoanSummary_OfficerId] ON [emdbuser].[LoanSummary] ([LoanOfficerId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_2] ON [emdbuser].[LoanSummary] ([LoanOfficerName]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LoanSummary_ProcessorId] ON [emdbuser].[LoanSummary] ([LoanProcessorId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LoanSummary_NextMilestoneID] ON [emdbuser].[LoanSummary] ([NextMilestoneID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LoanSummary_XrefId] ON [emdbuser].[LoanSummary] ([XRefID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_LoanSummary_LoanService_17] ON [emdbuser].[LoanSummary] ([XRefID]) INCLUDE ([DateCreated], [Guid], [LoanAmount], [LoanFolder], [LoanNumber], [LoanOfficerId]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LoanSummary_XrefId_MSID] ON [emdbuser].[LoanSummary] ([XRefID], [CurrentMilestoneID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LoanSummary_XrefId_Guid_MSID] ON [emdbuser].[LoanSummary] ([XRefID], [Guid], [CurrentMilestoneID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
