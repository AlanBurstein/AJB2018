SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [reports].[spGetTitleCompanyReportTopTitleCompaniesByState]

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
	sethm	02/13/13	added bcarrara to report
	sethm	02/22/13	added dmoran to report and now joining on aba number and account number

*/

begin

	set nocount on
	set transaction isolation level read uncommitted
	
	-- used for storing title company info
	create table #TitleCompanyInfo (
		ResultSetID int identity( 1,1 ) not null,
		State varchar( 10 ) not null,
		TitleCompanyName varchar( 100 ) not null,
		LoanUnits int not null,
		TotalLoanUnits int not null,
		ReturnResultFlag char( 1 ) not null
	)
	
	-- used for storing employees
	create table #EmployeeInfo ( 
		EmployeeID int not null 
	)
	
	-- used for storing loan purpose options
	create table #LoanPurpose (
		LoanPurposeName varchar( 100 ) null
	)

	-- create temp indexes
	create index idx_1 on #EmployeeInfo ( EmployeeID )	
	create index idx_1 on #LoanPurpose ( LoanPurposeName )

	-- declare misc variables
	declare @TotalLoanUnits int
	declare @TotalTitleTurnaroundTime int
	declare @TotalTitleTurnaroundLoans money
	
	-- determine whether user can view this report
	if @UserName not in ('kwoodruff', 'smueller', 'bhawley', 'nejohnson', 'hgordon', 'dgorman', 'nathanasiou', 'johne', 'bcarrara', 'dmoran' )
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
	
	-- get the results of the query
	insert	#TitleCompanyInfo ( State, TitleCompanyName, LoanUnits, TotalLoanUnits, ReturnResultFlag )
	select	_14 as State,
		T.TitleCompanyName, 
		count( * ) as LoanUnits,
		0 as TotalLoanUnits,
		'N' as ReturnResultFlag
	from	emdbuser.LoanSummary LS
		inner join emdbuser.LOANXDB_D_01 D01 on LS.XRefID = D01.XRefID
		inner join emdbuser.LOANXDB_S_01 S01 on LS.XRefID = S01.XRefID
		inner join emdbuser.LOANXDB_S_02 S02 on LS.XRefID = S02.XRefID
		inner join emdbuser.LOANXDB_S_03 S03 on LS.XRefID = S03.XRefID
		inner join #EmployeeInfo E on E.EmployeeID = S03._CX_FINALOCODE_4
		inner join #LoanPurpose LP on LP.LoanPurposeName = S01._19
		left outer join loanwarehouse..TitleCompanyMapping T on S02._VEND_X398 = T.ABANumber and S01._VEND_X399 = T.AccountNumber
	where	LS.LoanFolder not in ( 'Samples', '(Trash)', 'Archive' ) and 
		( 
			( @FundedStartDate is not null and _CX_FUNDDATE_1 is not null and _CX_FUNDDATE_1 between @FundedStartDate and @FundedEndDate ) or
			( @FundedStartDate is null )
		) and
		( T.TitleCompanyName is not null and T.TitleCompanyName = case when @TitleCompanyName = 'All' then T.TitleCompanyName else @TitleCompanyName end ) and 
		_VEND_X200 = case when @WarehouseName = 'All' then _VEND_X200 else @WarehouseName end and
		_2626 = case when @ChannelName = 'All' then _2626 else @ChannelName end and
		_14 = case when @StateName = 'All' then _14 else @StateName end and
		LoanNumber = case when @LoanNumber is not null then @LoanNumber else LoanNumber end and
		( 
			( @TitleOrderedStartDate is not null and _CX_TITLEORDER_1 is not null and _CX_TITLEORDER_1 between @TitleOrderedStartDate and @TitleOrderedEndDate ) or
			( @TitleOrderedStartDate is null )
		) 
	group	by _14, T.TitleCompanyName
	order	by _14, LoanUnits desc

	-- get the median number of loan units to return to user by state	
	select	State, sum( LoanUnits ) as TotalLoanUnits, round( ( sum( LoanUnits ) * .5 ), 0 ) as MedianLoanUnits
	into	#StateInfo
	from	#TitleCompanyInfo
	group	by State

	-- update the loan unit count for each result set id
	update	#TitleCompanyInfo
	set	TotalLoanUnits = ( select sum( LoanUnits ) from #TitleCompanyInfo T2 where T1.State = T2.State and T1.ResultSetID >= T2.ResultSetID )
	from	#TitleCompanyInfo T1

	-- determine which results to return	
	update	#TitleCompanyInfo
	set	ReturnResultFlag = 'Y'
	from	#TitleCompanyInfo T1, (
			select	S.State, min( ResultSetID ) as ResultSetID
			from	#TitleCompanyInfo T, #StateInfo S
			where	T.State = S.State and
				T.TotalLoanUnits >= S.MedianLoanUnits
			group	by S.State
		) T2
	where	T1.State = T2.State and
		T1.ResultSetID <= T2.ResultSetID


	select * from #TitleCompanyInfo order by resultsetid
	select * from #StateInfo order by State

/*
	-- get the total units
	select @TotalLoanUnits = sum( LoanUnits ) from #TitleCompanyInfo
	
	-- get the total title turnaround times and loan units
	select	@TotalTitleTurnaroundTime = sum( TitleTurnaroundTime ),
		@TotalTitleTurnaroundLoans = sum( TitleTurnaroundLoans )
	from	#TitleCompanyInfo
	
	-- and return the results
	select	TitleCompanyName, LoanVolume, LoanUnits, ( LoanUnits + 0.0 ) / ( @TotalLoanUnits + 0.0 ) as PercentageOfTotal,
		case when TitleTurnaroundLoans > 0 then ( TitleTurnaroundTime + 0.0 ) / ( TitleTurnaroundLoans + 0.0 ) else 0 end as AverageTitleTurnaroundTime,
		case when @TotalTitleTurnaroundLoans > 0 then ( @TotalTitleTurnaroundTime + 0.0 ) / ( @TotalTitleTurnaroundLoans + 0.0 ) else 0 end as TotalAverageTitleTurnaroundTime
	from	#TitleCompanyInfo
	order	by 3 desc, 1
*/
	
end

GO
