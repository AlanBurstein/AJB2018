SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [reports].[spGetSecSummary]
--declare
	@StartDate datetime,
	@Users varchar( max )

as
/* who				when			what
petervandivier		2016-01-10	create proc to port http://grchilhq-sq-04n/reports/daily/restricted/sec_summary.aspx

-- TESING FRAMEWORK 
exec reports.spGetSecSummary 
	@StartDate = dateadd( day, -2, convert( date, getdate() ) ),
	@Users = 'arodela,bjewell,bpalin,cmottel,creynolds,dhemy,dratcliff,ebrown,ecritendon,edamdinsuren,gbirdsong,iousley,jamieg,jGebhardt,jsellers,jshewski,kj,kleung,kmcilwee,mdobrovic,merwin,mmcpherson,mtomb,pScott,rfielding,rvaudelle,tschuster,UHart,vjimenez,wdaley,dkan,nmilano';

*/
begin
	set nocount on;
	set tran isolation level read uncommitted;

	if object_id( N'tempdb..#Metrics' ) is not null drop table #Metrics;

	declare
		@Sql nvarchar( max );

	with PvtData as
	(
		select 
			UserId,
			Data = isnull( nullif( Data, '' ), 'Blank' ),
			One = 1,
			ModifiedDate = convert( date, ModifiedDateTime )

		from secmktg.AuditTrailLockRateCurrentStatus
		where ModifiedDateTime >= @StartDate and 
			UserId in ( select distinct
							ColumnValue
						from fnSplitDelimitedList( @Users, ',' ) )
	)
	,Metrics as
	(
		select 
			UserId,
			ModifiedDate,
			pvt.[Blank],
			pvt.[Purchased],
			pvt.[Lock Expired],
			pvt.[Denied],
			pvt.[Shipped],
			pvt.[Locked],
			pvt.[Active Request]
		from PvtData
		pivot ( count( One ) for Data in ( [Blank],[Purchased],[Lock Expired],[Denied],[Shipped],[Locked],[Active Request] ) ) as pvt
	)
	,dCount as
	(
	select 
		UserId,
		dCount = count( distinct LoanXref ),
		ModifiedDate = convert( date, ModifiedDateTime )
	from secmktg.AuditTrailLockRateCurrentStatus
	where ModifiedDateTime >= @StartDate and 
		UserId in ( select distinct
						ColumnValue
					from fnSplitDelimitedList( @Users, ',' ) )
	group by 
			UserId,
			convert( date, ModifiedDateTime )
	)
	select 
		m.UserId,
		e.EmployeeId,
		e.titleId,
		m.ModifiedDate,
		dc.dCount,
		m.Blank,
		m.Purchased,
		LockExpired = m.[Lock Expired],
		m.Denied,
		m.Shipped,
		m.Locked,
		ActiveRequest = m.[Active Request] 
	into #Metrics
	from Metrics m 
	left join dCount dc on 
		dc.UserId = m.UserId and
		dc.ModifiedDate = m.ModifiedDate
	left join [Admin].corp.Employee e on e.EncompassLogin = m.UserId;

-- validate Return grain
	set @Sql = 'create index idx_A on #Metrics ( UserId, ModifiedDate );';

	exec sp_executesql @Sql;

	with TitleStart as
	(
		select 
			TitleStart = min( RowStartDate ),
			employeeId,
			titleId
		from LoanWarehouse.dbo.dimEmployeeHierarchy dei
		group by 
			employeeId,
			titleId
	)
	select 
		m.UserId,
		m.EmployeeId,
		e.displayName,

		m.titleId,
		TitleTenureMonths = datediff( month, ts.TitleStart, getdate() ),
		ts.TitleStart,
		m.ModifiedDate,
		m.dCount,
		m.Blank,
		m.Purchased,
		m.LockExpired,
		m.Denied,
		m.Shipped,
		m.Locked,
		m.ActiveRequest 
	from #Metrics m
	left join TitleStart ts on 
		ts.EmployeeId = m.EmployeeId and
		ts.TitleId = m.TitleId
	left join [Admin].corp.Employee e on e.EncompassLogin = m.UserId;

	return 0;

end;

GO
