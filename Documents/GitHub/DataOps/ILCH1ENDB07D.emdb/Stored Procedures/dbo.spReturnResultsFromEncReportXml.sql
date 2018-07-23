SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[spReturnResultsFromEncReportXml]
	@EncReportFile xml,
	@User varchar( 100 ),
	@ReportName varchar( 100 )
as
/* who				when			what
petervandivier		2015-11-10		proc for Cisco to return a table set from xml input
*/
begin
	set nocount on;
	set tran isolation level read uncommitted;

	declare @SqlTable table
	(
		ErrMsg varchar( max ),
		ErrCount int,
		SqlQuery varchar( max )
	);

	declare 
		@ErrMsg varchar( max ),
		@ErrCount int,
		@SqlQuery nvarchar( max );

	insert @SqlTable
	exec dbo.spGetSelectFromEncXml @EncReportFile, @User, @ReportName;

	select 
		@ErrMsg = Errmsg,
		@ErrCount = ErrCount,
		@SqlQuery = SqlQuery
	from @SqlTable;

	exec sp_executesql @SqlQuery;

	return 0;
end;

/*
exec dbo.spReturnResultsFromEncReportXml 
	@EncReportFile = '';
*/

GO
GRANT EXECUTE ON  [dbo].[spReturnResultsFromEncReportXml] TO [GRCORP\BHarrison]
GO
GRANT EXECUTE ON  [dbo].[spReturnResultsFromEncReportXml] TO [GRCORP\jpugh]
GO
