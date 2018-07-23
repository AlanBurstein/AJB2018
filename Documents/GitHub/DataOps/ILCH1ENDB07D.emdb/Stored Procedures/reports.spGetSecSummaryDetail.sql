SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [reports].[spGetSecSummaryDetail]
	@StartDate datetime,
	@Users varchar( max )
/*

declare @StartDate datetime = dateadd( d, -3, convert( date, getdate() ) );

exec reports.spGetSecSummaryDetail 
	@StartDate,
	@UserId = 'dkan';
*/
as
/* who				when			what
petervandivier		2016-01-10	create drill trhough proc for port of http://grchilhq-sq-04n/reports/daily/restricted/sec_summary.aspx
*/
begin
	set nocount on;
	set tran isolation level read uncommitted;

	with Loans as
	(
		select distinct 
			UserId,
			LoanXref
		from secmktg.AuditTrailLockRateCurrentStatus
		where ModifiedDateTime >= @StartDate and 
			UserId in ( select distinct
							ColumnValue
						from fnSplitDelimitedList( @Users, ',' ) )
	)
	select
		SecDeskName = e.displayName,
		SecDeskId = e.employeeId,
		ls.LoanNumber,
		ls.BorrowerLastName,
		ls.LoanAmount,
		s01.Lockrate_CurrentStatus,
		ls.LoanOfficerName,
		VpId = vp.employeeId,
		VpName = vp.displayName,
		LockDate = convert( date, d03.LOCKRATE_2149 ),
		EstimatedClosing = convert( date, d01._763 )
	from Loans L
	join emdbuser.LoanSummary ls on ls.XrefId = L.LoanXref
	left join emdb.emdbuser.LOANXDB_S_01 s01 on s01.XRefID = ls.XRefId 
	left join emdb.emdbuser.LOANXDB_S_03 s03 on s03.XRefID = ls.XRefId 
	left join emdb.emdbuser.LOANXDB_D_01 d01 on d01.XRefID = ls.XRefId 
	left join emdb.emdbuser.LOANXDB_D_03 d03 on d03.XRefID = ls.XRefId 
	left join [Admin].corp.Employee vp on vp.LOCode = s03._CX_FINALOCODE_4
	left join [Admin].corp.Employee e on e.EncompassLogin = L.UserId;

	return 0;
end;

GO
