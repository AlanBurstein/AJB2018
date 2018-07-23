SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [reports].[spGetAttorneyReportDetails]

	@UserName varchar( 100 ),
	@TitleCompanyName varchar( 100 ),
	@DivisionName varchar( 100 ),
	@CostCenter int,
	@LoanOfficerID int,
	@WarehouseName varchar( 100 ),
	@ChannelName varchar( 100 ),
	@StateName varchar( 1000 ),
	@LoanNumber varchar( 100 ),
	@FundedStartDate datetime,
	@FundedEndDate datetime,
	@TitleOrderedStartDate datetime,
	@TitleOrderedEndDate datetime,
	@LoanPurposeName varchar( 100 ),
	@AttorneyPhoneNumber varchar( 250 ),
	@AttorneyCompanyName varchar( 250 )

as

/*

----------------------------------------------------------------------------------------------------------------------------------
	who	when		what
----------------------------------------------------------------------------------------------------------------------------------
	sethm	10/08/13	initial rev of proc
*/

begin

	set nocount on
	set transaction isolation level read uncommitted

	-- used for storing employee ids
	create table #EmployeeInfo (
		EmployeeID int not null 
	)

	-- used for storing loan purpose options
	create table #LoanPurpose (
		LoanPurposeName varchar( 100 ) null
	)
	
	-- used for storing states
	create table #States (
		StateName varchar( 100 ) null
	)
	
	-- create temp indexes
	create index idx_1 on #EmployeeInfo ( EmployeeID )	
	create index idx_1 on #LoanPurpose ( LoanPurposeName )

	-- determine whether user can view this report
	if @UserName not in ( 'smueller', 'nejohnson', 'hgordon', 'dgorman', 'nathanasiou', 'johne', 'bcarrara', 'dmoran' )
	begin
		return 0
	end

	-- fix loan number field
	if ltrim( rtrim( isnull( @LoanNumber, '' ))) = ''
	begin
		set @LoanNumber = null
	end

	-- validate funded start and end dates
	if @FundedStartDate is null or @FundedEndDate is null
	begin
		set @FundedStartDate = null
		set @FundedEndDate = null
	end
		
	-- validate title ordered start and end dates
	if @TitleOrderedStartDate is null or @TitleOrderedEndDate is null
	begin
		set @TitleOrderedStartDate = null
		set @TitleOrderedEndDate = null
	end
	
	-- determine employee info to include
	if @LoanOfficerID <> 0
	begin
		insert	#EmployeeInfo ( EmployeeID )
		values	( @LoanOfficerID )
	end
	else if @CostCenter <> 0
	begin
		insert	#EmployeeInfo ( EmployeeID )
		select	E.EmployeeID
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	C.CostCenter = @CostCenter and
			E.CostCenterID = C.CostCenterID and
			E.Active = 1
	end
	else if @DivisionName = 'Retail'
	begin
		insert	#EmployeeInfo ( EmployeeID )
		select	E.EmployeeID
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	E.CostCenterID = C.CostCenterID and
			( C.CostCenterName not like '%direct%' or CostCenter <> 3003 ) and
			E.Active = 1
	end
	else if @DivisionName = 'Direct'
	begin
		insert	#EmployeeInfo ( EmployeeID )
		select	E.EmployeeID
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	E.CostCenterID = C.CostCenterID and
			C.CostCenterName like '%direct%' and
			E.Active = 1
	end
	else if @DivisionName = 'Online'
	begin
		insert	#EmployeeInfo ( EmployeeID )
		select	E.EmployeeID
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	E.CostCenterID = C.CostCenterID and
			C.CostCenter = 3003 and
			E.Active = 1
	end
	else
	begin
		insert	#EmployeeInfo ( EmployeeID )
		select	E.EmployeeID
		from	admin.corp.Employee E
	end

	-- add loan purpose options
	if @LoanPurposeName = 'All'
	begin
		insert	#LoanPurpose ( LoanPurposeName ) values ( '' ), ( 'Cash-Out Refinance' ), ( 'ConstructionOnly' ), ( 'ConstructionToPerman' ), 
			( 'NoCash-Out Refinance' ), ( 'Other' ), ( 'Purchase' )
	end
	else if @LoanPurposeName = 'Purchase'
	begin
		insert	#LoanPurpose ( LoanPurposeName ) values ( 'Purchase' )
	end
	else if @LoanPurposeName = 'Refinance'
	begin
		insert	#LoanPurpose ( LoanPurposeName ) values ( 'Cash-Out Refinance' ), ( 'NoCash-Out Refinance' )
	end
	else
	begin
		insert	#LoanPurpose ( LoanPurposeName ) values ( '' ), ( 'ConstructionOnly' ), ( 'ConstructionToPerman' ), ( 'Other' )
	end	

	-- determine which states to view
	if @StateName = 'ALL'
	begin
		insert	#States ( StateName )
		select	distinct _14 as StateName 
		from	emdbuser.LOANXDB_S_01 
		where	_14 <> ''
	end
	else
	begin
		insert	#States ( StateName )
		select	distinct ColumnValue
		from	dbo.fnSplitDelimitedList ( @StateName, ',' )
	end		
	
	-- and return results
	select	LS.LoanNumber, 
		LS.BorrowerLastName,
		_14 as SubjectPropertyState,
		_2 as TotalLoanAmount, 
		_19 as LoanPurposeName,
		_56 as AttorneyCompanyName,
		_VEND_X112 as AttorneyAddress,
		_VEND_X113 as AttorneyCity,
		_VEND_X114 as AttorneyState,
		_VEND_X115 as AttorneyPostalCode,
		_VEND_X117 as AttorneyContact,
		_VEND_X118 as AttorneyPhone,
		_VEND_X119 as AttorneyEmail,
		T.TitleCompanyName,
		_1174 as TitleCompanyState,
		_187 as TitleCompanyTitleNumber,
		_385 as TitleCompanyBorrowerFees,
		_412 as TitleCompanyAddress,
		_414 as TitleCompanyPostalCode,
		_416 as TitleCompanyContact,
		_417 as TitleCompanyPhone,
		_88 as TitleCompanyEmail,
		_CX_CLSPKGTITLE as ClosingPackageSenttoTitleDate,
		_CX_TITLEORDER_1 as TitleOrderedDate,
		_CX_TITLERCVD_1 as TitleReceivedDate,
		case when _CX_TITLEORDER_1 is not null and _CX_TITLERCVD_1 is not null 
			then cast( datediff( day, _CX_TITLEORDER_1, _CX_TITLERCVD_1 ) as varchar( 10 )) else '-' end as TitleTurnaroundTime,
		_CX_TITLEREF_1 as TitleReferenceNumber,
		_CX_TITLESHIP_3 as FinalTitlePolicyShipDate,
		_NEWHUD_X202 as TitleServicesAndLendersTitleInsuranceProvider,
		_NEWHUD_X38 as TitleServicesAndLendersTitleInsuranceAmount,
		_NEWHUD_X639 as TitleInsuranceLenderFees,
		_SYS_X50 as TitleCompanyAPRFees,
		_VEND_X156 as TitleCompanyLineItemNumber,
		_VEND_X398 as TitleCompanyABANumber,
		_vend_x200 as Warehouse,
		_2626 as Channel,
		_VEND_X399 as TitleCompanyAccountNumber,
		_CX_FINALLONAME as LOCredit
		
	from	emdbuser.LoanSummary LS
		inner join emdbuser.LOANXDB_D_01 D01 on LS.XRefID = D01.XRefID
		inner join emdbuser.LOANXDB_D_03 D03 on LS.XRefID = D03.XRefID
		inner join emdbuser.LOANXDB_S_01 S01 on LS.XRefID = S01.XRefID
		inner join emdbuser.LOANXDB_S_02 S02 on LS.XRefID = S02.XRefID
		inner join emdbuser.LOANXDB_S_03 S03 on LS.XRefID = S03.XRefID
		inner join emdbuser.LOANXDB_S_04 S04 on LS.XRefID = S04.XRefID
		inner join emdbuser.LOANXDB_S_05 S05 on LS.XRefID = S05.XRefID
		inner join emdbuser.LOANXDB_S_06 S06 on LS.XRefID = S06.XRefID
		inner join emdbuser.LOANXDB_S_07 S07 on LS.XRefID = S07.XRefID
		inner join emdbuser.LOANXDB_N_02 N02 on LS.XRefID = N02.XRefID
		inner join emdbuser.LOANXDB_N_05 N05 on LS.XRefID = N05.XRefID
		inner join emdbuser.LOANXDB_N_06 N06 on LS.XRefID = N06.XRefID
		left outer join loanwarehouse.dbo.TitleCompanyMapping T on S02._VEND_X398 = T.ABANumber and S01._VEND_X399 = T.AccountNumber
		inner join #EmployeeInfo E on E.EmployeeID = S03._CX_FINALOCODE_4
		inner join #LoanPurpose LP on LP.LoanPurposeName = S01._19
		inner join #States S on _14 = S.StateName
	where	LS.LoanFolder not in ( 'Samples', '(Trash)', 'Archive' ) and 
		( 
			( @FundedStartDate is not null and _CX_FUNDDATE_1 is not null and _CX_FUNDDATE_1 between @FundedStartDate and @FundedEndDate ) or
			( @FundedStartDate is null )
		) and
		isnull( T.TitleCompanyName, '(blank)' ) = case when @TitleCompanyName = 'All' then isnull( T.TitleCompanyName, '(blank)' ) else @TitleCompanyName end and
		_VEND_X200 = case when @WarehouseName = 'All' then _VEND_X200 else @WarehouseName end and
		_2626 = case when @ChannelName = 'All' then _2626 else @ChannelName end and
		LoanNumber = case when @LoanNumber is not null then @LoanNumber else LoanNumber end and
		( 
			( @TitleOrderedStartDate is not null and _CX_TITLEORDER_1 is not null and _CX_TITLEORDER_1 between @TitleOrderedStartDate and @TitleOrderedEndDate ) or
			( @TitleOrderedStartDate is null )
		) and
		_VEND_X118 = isnull( @AttorneyPhoneNumber, _VEND_X118 ) and
		_56 = isnull( @AttorneyCompanyName, _56 ) 
	order	by LS.LoanNumber

end
GO
