SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [secmktg].[spUpdateAuditTrailLockRateCurrentStatus]
	@OffsetInMinutes int = null
/* --  testing framework
exec secmktg.spUpdateAuditTrailLockRateCurrentStatus @OffsetInMinutes = 5;
*/
as
/* who				when			what
petervandivier		2016-01-09	Create Proc to port http://grchilhq-sq-04n/reports/daily/restricted/sec_summary.aspx
*/
begin
	set nocount on;
	set tran isolation level read uncommitted;

	if object_id( N'tempdb..#UpdateAuditTrailLockRateCurrentStatus' ) is not null drop table #UpdateAuditTrailLockRateCurrentStatus;

	declare
		@StartDate datetime,
		@ProcName sysname = 'secmktg.spUpdateAuditTrailLockRateCurrentStatus',
		@ProcTime datetime = getdate(),
		@OffRows varchar( 10 ),
		@NewRows varchar( 10 ),
		@RetMsg varchar( 4000 ) = '',
		@Lb char( 1 ) = char( 10 ),
		@Error int = 0;

	select
		@StartDate = max( ModifiedDateTime ),
		@OffsetInMinutes = -1 * abs( isnull( @OffsetInMinutes, 5 ) )
	from secmktg.AuditTrailLockRateCurrentStatus;

	-- set @StartDate = dateadd( minute, @OffsetInMinutes, @StartDate );

		/****************/
		/*	Stage Data	*/
		/****************/
	select 
		RecordId,
		LoanXref,
		UserId,
		Data = convert( varchar, Data ),
		PreviousData = convert( varchar, PreviousData ),
		ModifiedDTTM,
		IsCurrent
	into #UpdateAuditTrailLockRateCurrentStatus
	from [GRCHILHQ-SQ-02].emdb.emdbuser.AuditTrail
	where FieldXref = 454 and 
		ModifiedDTTM >= @StartDate;

	select 
		@Error += @@error;

		/****************************/
		/*	Turn Off Expired Rows	*/
		/****************************/
	update secmktg.AuditTrailLockRateCurrentStatus set
		IsCurrent = 0,
		LastUpdateBy = @ProcName,
		LastUpdateDatetime = @ProcTime,
		Revision += 1
	from secmktg.AuditTrailLockRateCurrentStatus a
	where exists( select 1
					from #UpdateAuditTrailLockRateCurrentStatus b
					where b.LoanXref = a.LoanXref and
						b.IsCurrent = 1 );

	select 
		@OffRows = convert( varchar( 10 ), @@rowcount ),
		@Error += @@error;

		/************************/
		/*	Insert New Records	*/
		/************************/
	insert secmktg.AuditTrailLockRateCurrentStatus
	(
		RecordId,
		LoanXref,
		UserId,
		Data,
		PreviousData,
		ModifiedDateTime,
		IsCurrent,
		InsertedBy,
		InsertDatetime,
		LastUpdateBy,
		LastUpdateDatetime
	)
	select 
		RecordId,
		LoanXref,
		UserId,
		convert( varchar, Data ),
		convert( varchar, PreviousData ),
		ModifiedDTTM,
		IsCurrent,
		@ProcName,
		@ProcTime,
		@ProcName,
		@ProcTime
	from #UpdateAuditTrailLockRateCurrentStatus a
	where not exists ( select 1 
						from secmktg.AuditTrailLockRateCurrentStatus b
						where b.RecordId = a.RecordId );

	select 
		@NewRows = convert( varchar( 10 ), @@rowcount ),
		@Error += @@error;

	select @RetMsg += 
		'secmktg.spUpdateAuditTrailLockRateCurrentStatus completed ' + 
		case @Error when 0 then 'SUCCESSFULLY! ' else 'WITH ERRORS! ' end + @Lb + 
		'Snapshot taken from offset time ' + convert( varchar, @StartDate, 126 ) + '. ' + @Lb + 
		@NewRows + ' row(s) added, ' + @OffRows + ' row(s) deleted. ';

	if @Error = 0 
		print @RetMsg
	else 
		raiserror( @RetMsg, 11, 1 );

	return @Error;
end;

GO
