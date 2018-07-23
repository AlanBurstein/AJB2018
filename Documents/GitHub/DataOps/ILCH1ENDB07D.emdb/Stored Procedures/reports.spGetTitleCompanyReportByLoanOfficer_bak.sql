SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [reports].[spGetTitleCompanyReportByLoanOfficer_bak]

	@UserName varchar( 100 ),
	@TitleCompanyName varchar( 100 ),
	@DivisionName varchar( 100 ),
	@CostCenter int,
	@LoanOfficerID int,
	@WarehouseName varchar( 100 ),
	@ChannelName varchar( 100 ),
	@StateName varchar( 10 ),
	@LoanNumber varchar( 100 ),
	@FundedStartDate datetime,
	@FundedEndDate datetime,
	@TitleOrderedStartDate datetime,
	@TitleOrderedEndDate datetime,
	@LoanPurposeName varchar( 100 )

as

/*

----------------------------------------------------------------------------------------------------------------------------------
	who	when		what
----------------------------------------------------------------------------------------------------------------------------------
	sethm	01/15/13	initial rev of proc
	sethm	01/29/13	added loan purpose to filters

*/

begin

	set nocount on
	set transaction isolation level read uncommitted

	-- used for storing employee ids
	create table #EmployeeInfo (
		EmployeeID int not null,
		DisplayName varchar( 100 ) not null
	)

	-- used for storing loan purpose options
	create table #LoanPurpose (
		LoanPurposeName varchar( 100 ) null
	)
	
	-- declare misc variables
	declare @TotalLoanUnits int

	-- determine whether user can view this report
	if @UserName not in ( 'kwoodruff', 'smueller', 'bhawley', 'nejohnson', 'hgordon', 'dgorman', 'nathanasiou', 'johne' )
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
		insert	#EmployeeInfo ( EmployeeID, DisplayName )
		select	@LoanOfficerID, DisplayName
		from	admin.corp.Employee
		where	EmployeeID = @LoanOfficerID
	end
	else if @CostCenter <> 0
	begin
		insert	#EmployeeInfo ( EmployeeID, DisplayName )
		select	E.EmployeeID, E.DisplayName
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	C.CostCenter = @CostCenter and
			E.CostCenterID = C.CostCenterID and
			E.Active = 1
	end
	else if @DivisionName = 'Retail'
	begin
		insert	#EmployeeInfo ( EmployeeID, DisplayName )
		select	E.EmployeeID, E.DisplayName
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	E.CostCenterID = C.CostCenterID and
			( C.CostCenterName not like '%direct%' or CostCenter <> 3003 ) and
			E.Active = 1
	end
	else if @DivisionName = 'Direct'
	begin
		insert	#EmployeeInfo ( EmployeeID, DisplayName )
		select	E.EmployeeID, E.DisplayName
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	E.CostCenterID = C.CostCenterID and
			C.CostCenterName like '%direct%' and
			E.Active = 1
	end
	else if @DivisionName = 'Online'
	begin
		insert	#EmployeeInfo ( EmployeeID, DisplayName )
		select	E.EmployeeID, E.DisplayName
		from	admin.corp.Employee E, admin.corp.CostCenter C
		where	E.CostCenterID = C.CostCenterID and
			C.CostCenter = 3003 and
			E.Active = 1
	end
	else
	begin
		insert	#EmployeeInfo ( EmployeeID, DisplayName )
		select	E.EmployeeID, E.DisplayName
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

	-- and return results
	select	E.DisplayName as EmployeeName,
		sum( _2 ) as LoanVolume,
		count( * ) as LoanUnits
	into	#LoanOfficerInfo
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
		left outer join loanwarehouse.dbo.TitleCompanyMapping T on S02._VEND_X398 = T.ABANumber
		inner join #EmployeeInfo E on E.EmployeeID = S03._CX_FINALOCODE_4
		inner join #LoanPurpose LP on LP.LoanPurposeName = S01._19
	where	LS.LoanFolder not in ( 'Samples', '(Trash)', 'Archive' ) and 
		( 
			( @FundedStartDate is not null and _CX_FUNDDATE_1 is not null and _CX_FUNDDATE_1 between @FundedStartDate and @FundedEndDate ) or
			( @FundedStartDate is null )
		) and
		isnull( T.TitleCompanyName, '(blank)' ) = case when @TitleCompanyName = 'All' then isnull( T.TitleCompanyName, '(blank)' ) else @TitleCompanyName end and
		_VEND_X200 = case when @WarehouseName = 'All' then _VEND_X200 else @WarehouseName end and
		_2626 = case when @ChannelName = 'All' then _2626 else @ChannelName end and
		_14 = case when @StateName = 'All' then _14 else @StateName end and
		LoanNumber = case when @LoanNumber is not null then @LoanNumber else LoanNumber end and
		( 
			( @TitleOrderedStartDate is not null and _CX_TITLEORDER_1 is not null and _CX_TITLEORDER_1 between @TitleOrderedStartDate and @TitleOrderedEndDate ) or
			( @TitleOrderedStartDate is null )
		) 
	group	by E.DisplayName

	-- get the total units
	select @TotalLoanUnits = sum( LoanUnits ) from #LoanOfficerInfo
	
	-- and return the results
	select	EmployeeName, LoanVolume, LoanUnits, ( LoanUnits + 0.0 ) / ( @TotalLoanUnits + 0.0 ) as PercentageOfTotal
	from	#LoanOfficerInfo
	order	by 3 desc, 1

end

GO
