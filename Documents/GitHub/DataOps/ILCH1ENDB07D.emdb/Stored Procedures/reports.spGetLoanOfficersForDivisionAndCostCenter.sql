SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [reports].[spGetLoanOfficersForDivisionAndCostCenter]

	@DivisionName varchar( 100 ),
	@CostCenter int
	
as

/*

----------------------------------------------------------------------------------------------------------------------------------
	who	when		what
----------------------------------------------------------------------------------------------------------------------------------
	sethm	01/15/13	initial rev of proc


*/

begin

	set nocount on
	set transaction isolation level read uncommitted

	declare @IncludeBranch table (
		CostCenter int not null 
	)

	-- get cost center
	if @CostCenter <> 0
	begin
		insert	@IncludeBranch ( CostCenter )
		values	( @CostCenter )
	end
	else if @DivisionName = 'All'
	begin
		insert	@IncludeBranch ( CostCenter )
		select	distinct CostCenter
		from	admin.corp.CostCenter
		where	Active = 1
	end
	else if @DivisionName = 'Retail'
	begin
		insert	@IncludeBranch ( CostCenter )
		select	distinct CostCenter
		from	admin.corp.CostCenter
		where	Active = 1 and
			( CostCenterName not like '%direct%' or CostCenter <> 3003 )
	end
	else if @DivisionName = 'Direct'
	begin
		insert	@IncludeBranch ( CostCenter )
		select	distinct CostCenter
		from	admin.corp.CostCenter
		where	Active = 1 and
			CostCenterName like '%direct%'
	end
	else -- online
	begin
		insert	@IncludeBranch ( CostCenter )
		values	( 3003 )
	end
	
	-- return results
	select	0 as SortOrder, 0 as EmployeeID, 'All' as EmployeeName

	union

	select	1 as SortOrder, EmployeeID, DisplayName
	from	emdbuser.LoanSummary LS
		inner join emdbuser.LOANXDB_D_01 D01 on LS.XRefID = D01.XRefID
		inner join emdbuser.LOANXDB_S_03 S03 on LS.XRefID = S03.XRefID
		inner join admin.corp.Employee E on S03._CX_FINALOCODE_4 = E.EmployeeID
	where	LS.Loanfolder not in ( 'Samples', '(Trash)', 'Archive' ) and 
		_CX_FUNDDATE_1 is not null and
		E.Active = 1
		and CostCenterID in ( 
			select	CC.CostCenterID
			from	admin.corp.CostCenter CC, @IncludeBranch I
			where	CC.CostCenter = I.CostCenter
		)
	order	by 1, 3

end
GO
