SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [reports].[spGetFundedLoanTotalsByDate] 

	@StartDate datetime,
	@EndDate datetime

as

begin

	set transaction isolation level read uncommitted

	-- get the loan amounts group by mc, lc, and vp
	select	datename( month, _CX_FUNDDATE_1 ) as MonthName, datepart( month, _CX_FUNDDATE_1 ) as MonthNumber, datepart( year, _CX_FUNDDATE_1 ) as YearName,
		LS03._CX_FINALOCODE_4, LS03._CX_MCNAME_1, LS01._CX_LCNAME_1, sum( LN02._2 ) as LoanAmount, count( * ) as LoanCount
	into	#FundedLoans
	from	emdbuser.LOANXDB_S_01 LS01
		inner join emdbuser.LoanSummary LS on LS01.XRefID = LS.XRefID 
		inner join emdbuser.LOANXDB_S_03 LS03 on LS01.XRefID = LS03.XRefID
		inner join emdbuser.LOANXDB_D_01 LD01 on LS01.XRefID = LD01.XRefID
		inner join emdbuser.LOANXDB_N_02 LN02 on LS01.XRefID = LN02.XRefID
	where	_CX_FUNDDATE_1 between @StartDate and @EndDate and
		LoanFolder not in ( '(Archive)', '(Trash)', 'Samples' ) 
	group	by datename( month, _CX_FUNDDATE_1 ), datepart( month, _CX_FUNDDATE_1 ), datepart( year, _CX_FUNDDATE_1 ), 
		LS03._CX_FINALOCODE_4, LS03._CX_MCNAME_1, LS01._CX_LCNAME_1

	-- group totals by vp
	select	'VP' as Title, E.DisplayName, E.EmployeeID, D.DivisionID, D.Division, R.RegionID, R.Region, CC.CostCenter, CC.CostCenterName,
		F.YearName, F.MonthNumber, F.MonthName, sum( LoanAmount ) as LoanAmount, sum( LoanCount ) as LoanCount
	from	#FundedLoans F
		left join admin.corp.LOCode LO on F._CX_FINALOCODE_4 = LO.LOCode
		left join admin.corp.Employee E on LO.EmployeeID = E.EmployeeID
		left join admin.corp.CostCenter CC on E.CostCenterID = CC.CostCenterID
		left join admin.corp.Region R on R.RegionID = CC.RegionID
		left join admin.corp.Division D on D.DivisionID = R.DivisionID
--	where	isnull( E.DisplayName, '' ) <> '' 
	group	by E.DisplayName, E.EmployeeID, D.DivisionID, D.Division, R.RegionID, R.Region, CC.CostCenter, CC.CostCenterName,
		F.YearName, F.MonthNumber, F.MonthName

/*		
	union all
	
	-- group totals by mc
	select	'MC' as Title, E.DisplayName, E.EmployeeID, D.DivisionID, D.Division, R.RegionID, R.Region, CC.CostCenter, CC.CostCenterName,
		F.YearName, F.MonthNumber, F.MonthName, sum( LoanAmount ) as LoanAmount, sum( LoanCount ) as LoanCount
	from	#FundedLoans F
		left join admin.corp.Employee E on F._CX_MCNAME_1 = E.DisplayName
		left join admin.corp.CostCenter CC on E.CostCenterID = CC.CostCenterID
		left join admin.corp.Region R on R.RegionID = CC.RegionID
		left join admin.corp.Division D on D.DivisionID = R.DivisionID
	where	isnull( E.DisplayName, '' ) <> '' 
	group	by E.DisplayName, E.EmployeeID, D.DivisionID, D.Division, R.RegionID, R.Region, CC.CostCenter, CC.CostCenterName,
		F.YearName, F.MonthNumber, F.MonthName

	union all
	
	select	'LC' as Title, E.DisplayName, E.EmployeeID, D.DivisionID, D.Division, R.RegionID, R.Region, CC.CostCenter, CC.CostCenterName,
		F.YearName, F.MonthNumber, F.MonthName, sum( LoanAmount ) as LoanAmount, sum( LoanCount ) as LoanCount
	from	#FundedLoans F
		left join admin.corp.Employee E on F._CX_LCNAME_1 = E.DisplayName
		left join admin.corp.CostCenter CC on E.CostCenterID = CC.CostCenterID
		left join admin.corp.Region R on R.RegionID = CC.RegionID
		left join admin.corp.Division D on D.DivisionID = R.DivisionID
	where	isnull( E.DisplayName, '' ) <> '' 
	group	by E.DisplayName, E.EmployeeID, D.DivisionID, D.Division, R.RegionID, R.Region, CC.CostCenter, CC.CostCenterName,
		F.YearName, F.MonthNumber, F.MonthName
	
*/
end
GO
