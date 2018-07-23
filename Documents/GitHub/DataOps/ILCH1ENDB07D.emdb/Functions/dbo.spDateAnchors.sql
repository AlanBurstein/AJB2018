SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[spDateAnchors]
(
	@Anchor varchar( 100 ),
	@Today date
)
returns date
as
/* who				when			what
petervandivier		
*/
begin

	declare @ResultDate date ;

	select @Today = isnull( @Today, getdate() ) ;

	declare 
		@LastYearStartDate date ,
		@ThisYearStartDate date ,
		@NextYearStartDate date ,
		@LastMonthStartDate date ,
		@ThisMonthStartDate date ,
		@NextMonthStartDate date ,
		@LastWeekStartDate date ,
		@ThisWeekStartDate date ,
		@NextWeekStartDate date ,
		@LastYearEndDate date,
		@ThisYearEndDate date,
		@NextYearEndDate date,
		@LastMonthEndDate date,
		@ThisMonthEndDate date,
		@NextMonthEndDate date,
		@LastWeekEndDate date,
		@ThisWeekEndDate date,
		@NextWeekEndDate date ;

	select 
		@LastYearStartDate = min( LastYear.[DateName] ),
		@LastYearEndDate = max( LastYear.[DateName] )
	from LoanWarehouse.dbo.dimDate Today
	left outer join LoanWarehouse.dbo.dimDate LastYear on ( LastYear.YearKey + 1 ) = Today.YearKey
	where Today.DateName = @Today ;

	select
		@LastMonthStartDate = min( LastMonth.[DateName] ), 
		@LastMonthEndDate = max( LastMonth.[DateName] )
	from LoanWarehouse.dbo.dimDate today
	left outer join LoanWarehouse.dbo.dimDate LastMonth on ( LastMonth.MonthKey + 1 ) = today.MonthKey
	where today.[DateName] = @Today ;

	select
		@LastWeekStartDate = min( LastWeek.[DateName] ), 
		@LastWeekEndDate = max( LastWeek.[DateName] )
	from LoanWarehouse.dbo.dimDate today
	left outer join LoanWarehouse.dbo.dimDate LastWeek on ( LastWeek.WeekKey + 1 ) = today.WeekKey
	where today.[DateName] = @Today


	select 
		@ThisYearStartDate = min( ThisYear.[DateName] ),
		@ThisYearEndDate = max( ThisYear.[DateName] )
	from LoanWarehouse.dbo.dimDate Today
	left outer join LoanWarehouse.dbo.dimDate ThisYear on ( ThisYear.YearKey ) = Today.YearKey
	where Today.DateName = @Today ;

	select
		@ThisMonthStartDate = min( ThisMonth.[DateName] ), 
		@ThisMonthEndDate = max( ThisMonth.[DateName] )
	from LoanWarehouse.dbo.dimDate today
	left outer join LoanWarehouse.dbo.dimDate ThisMonth on ( ThisMonth.MonthKey ) = today.MonthKey
	where today.[DateName] = @Today ;

	select
		@ThisWeekStartDate = min( ThisWeek.[DateName] ), 
		@ThisWeekEndDate = max( ThisWeek.[DateName] )
	from LoanWarehouse.dbo.dimDate today
	left outer join LoanWarehouse.dbo.dimDate ThisWeek on ( ThisWeek.WeekKey ) = today.WeekKey
	where today.[DateName] = @Today

	select 
		@NextYearStartDate = min( NextYear.[DateName] ),
		@NextYearEndDate = max( NextYear.[DateName] )
	from LoanWarehouse.dbo.dimDate Today
	left outer join LoanWarehouse.dbo.dimDate NextYear on ( NextYear.YearKey - 1 ) = Today.YearKey
	where Today.DateName = @Today ;

	select
		@NextMonthStartDate = min( NextMonth.[DateName] ), 
		@NextMonthEndDate = max( NextMonth.[DateName] )
	from LoanWarehouse.dbo.dimDate today
	left outer join LoanWarehouse.dbo.dimDate NextMonth on ( NextMonth.MonthKey - 1 ) = today.MonthKey
	where today.[DateName] = @Today ;

	select
		@NextWeekStartDate = min( NextWeek.[DateName] ), 
		@NextWeekEndDate = max( NextWeek.[DateName] )
	from LoanWarehouse.dbo.dimDate today
	left outer join LoanWarehouse.dbo.dimDate NextWeek on ( NextWeek.WeekKey - 1 ) = today.WeekKey
	where today.[DateName] = @Today ;

	select @ResultDate =
		case @Anchor
			when 'LastYearStartDate' then @LastYearStartDate
			when 'ThisYearStartDate' then @ThisYearStartDate
			when 'NextYearStartDate' then @NextYearStartDate
			when 'LastMonthStartDate' then @LastMonthStartDate
			when 'ThisMonthStartDate' then @ThisMonthStartDate
			when 'NextMonthStartDate' then @NextMonthStartDate
			when 'LastWeekStartDate' then @LastWeekStartDate
			when 'ThisWeekStartDate' then @ThisWeekStartDate
			when 'NextWeekStartDate' then @NextWeekStartDate
			when 'LastYearEndDate' then @LastYearEndDate
			when 'ThisYearEndDate' then @ThisYearEndDate
			when 'NextYearEndDate' then @NextYearEndDate
			when 'LastMonthEndDate' then @LastMonthEndDate
			when 'ThisMonthEndDate' then @ThisMonthEndDate
			when 'NextMonthEndDate' then @NextMonthEndDate
			when 'LastWeekEndDate' then @LastWeekEndDate
			when 'ThisWeekEndDate' then @ThisWeekEndDate
			when 'NextWeekEndDate' then @NextWeekEndDate 
			end;

	return @ResultDate ;
end ;

/*
declare 
	@Anchor varchar( 100 ) = 'LastYearStartDate',
	@Today date = null;

select dbo.spDateAnchors( @Anchor, @Today ) ;
*/

GO
