SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [secmktg].[spGetDiscrepanciesAuditTrailLockRateCurrentStatus]
	 
/*
exec secmktg.spGetDiscrepanciesAuditTrailLockRateCurrentStatus  = ;
*/
as
/* who				when			what
petervandivier		2016-01-11	what doesn't match from 02 to 03
*/
begin
	set nocount on;
	set tran isolation level read uncommitted;
	
	if object_id( N'tempdb..#AuditTarget' ) is not null drop table #AuditTarget;
	if object_id( N'tempdb..#AuditSource' ) is not null drop table #AuditSource;

	select top 10000 
		*
	into #AuditSource
	from [GRCHILHQ-SQ-02].emdb.emdbuser.AuditTrail
	where FieldXref = 454
	order by RecordId desc;


	select top 10000 
		*
	into #AuditTarget
	from secmktg.AuditTrailLockRateCurrentStatus 
	order by RecordId desc;

	--select RecordId, LoanXref, UserId, Data, PreviousData, ModifiedDateTime, IsCurrent from #AuditTarget
	--except
	--select RecordId, LoanXref, UserId, Data, PreviousData, ModifiedDTTM, IsCurrent from #AuditSource;

	select RecordId, LoanXref, UserId, Data, PreviousData, ModifiedDTTM, IsCurrent from #AuditSource
	except
	select RecordId, LoanXref, UserId, Data, PreviousData, ModifiedDateTime, IsCurrent from #AuditTarget;

	return 0;
end;

GO
