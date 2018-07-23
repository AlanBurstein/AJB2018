SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [reports].[spGetSecSummaryClassicView]

/* who				when			what
petervandivier		2016-01-09	create proc to port http://grchilhq-sq-04n/reports/daily/restricted/sec_summary.aspx
*/
--declare
	@StartDate datetime,
	@Users varchar( max )
as
--select
/* TESTING FRAMEWORK
exec reports.spGetSecSummaryClassicView
	@StartDate = dateadd( day, -2, convert( date, getdate() ) ),
	@Users = 'arodela,bjewell,bpalin,cmottel,creynolds,dhemy,dratcliff,ebrown,ecritendon,edamdinsuren,gbirdsong,iousley,jamieg,jGebhardt,jsellers,jshewski,kj,kleung,kmcilwee,mdobrovic,merwin,mmcpherson,mtomb,pScott,rfielding,rvaudelle,tschuster,UHart,vjimenez,wdaley,dkan,nmilano';
*/
begin
	set nocount on;
	set tran isolation level read uncommitted;

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
	select 
		UserId,
		[Date] = ModifiedDate,
		Denied,
		[Active Request],
		Locked
	from PvtData
	pivot ( count( One ) for Data in ( [Denied],[Active Request],[Locked] ) ) as pvt;

	return 0;
end;


GO
