SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		peter vandivier
-- Create date: 2015-10-28
-- Description:	return single line of where clause from encompass xml filter element in FilterList node
-- =============================================
-- MODIFICATIONS
/* who			when			what
petervandivier	2015-11-02		modify GetStartsWithWhereClause and GetDoesNotStartWithWhereClause to compare 'match%' rather than 'match''%'
								Fixed IsYesNo ( apparently I overwrote some changes from the weekend... dammit... )
petervandivier	2015-11-10		added "Is" operator to IsString. fixed "isnull( " prefix on IsCheckBox and IsYesNo
*/
create function [dbo].[fnGetWhereClauseLineFromFilterElement] 
(
	@FieldType varchar(255),
	@LeftParentheses varchar(255),
	@TblAbrv varchar( 255 ),
	@ColumnName sysname,
	@Operator varchar( 255 ),
	@ValueFrom varchar( 255 ),
	@ValueTo varchar( 255 ),
	@RightParentheses varchar(255),
	@JointToken varchar( 255 )
)
returns varchar( max )
as
begin

		/****************/
		/*	Misc vars	*/
		/****************/
	declare 
		@Result varchar( max ) = '',
		@SqlOperation varchar( 1000 ) = '',
		@sq nchar( 1 ) = char( 39 ), -- single quote
		@dq nchar( 2 ) = char( 39 ) + char( 39 ),
		@pct nchar( 1 ) = char( 37 ),
		@UnknownOperatorAlert varchar( 100 ) = '; -- unknown ' + @FieldType + ' type operator', -- 2x single quote 
		@DateAddVal varchar( 10 ),
		@DateAddDir varchar( 10 );

		/********************/
		/*	DateString vars	*/
		/********************/
	declare
		@TodayStr varchar( 100 ) = '(convert(date,getdate()))',
		@LastYearStartStr varchar( 1000 ) = '(convert(date,convert(varchar,datepart(year,getdate())-1)+''-01-01''))' ,
		@ThisYearStartStr varchar( 1000 ) = '(convert(date,convert(varchar,datepart(year,getdate())-0)+''-01-01''))' ,
		@NextYearStartStr varchar( 1000 ) = '(convert(date,convert(varchar,datepart(year,getdate())+1)+''-01-01''))' ,
		@LastMonthStartStr varchar( 1000 ) = '(convert(date,(convert(varchar,datepart(year,getdate()))+''/''+convert(varchar,month(getdate())-1)+''/1'')))' ,
		@ThisMonthStartStr varchar( 1000 ) = '(convert(date,(convert(varchar,datepart(year,getdate()))+''/''+convert(varchar,month(getdate())-0)+''/1'')))' ,
		@NextMonthStartStr varchar( 1000 ) = '(convert(date,(convert(varchar,datepart(year,getdate()))+''/''+convert(varchar,month(getdate())+1)+''/1'')))' ,
		@LastWeekStartStr varchar( 1000 ) = '(select min(w.[DateName])from LoanWarehouse.dbo.dimDate d, LoanWarehouse.dbo.dimDate w where convert(date,getdate())=d.[DateName] and (d.WeekKey-1)=w.WeekKey)' ,
		@ThisWeekStartStr varchar( 1000 ) = '(select min(w.[DateName])from LoanWarehouse.dbo.dimDate d, LoanWarehouse.dbo.dimDate w where convert(date,getdate())=d.[DateName] and (d.WeekKey-0)=w.WeekKey)' ,
		@NextWeekStartStr varchar( 1000 ) = '(select min(w.[DateName])from LoanWarehouse.dbo.dimDate d, LoanWarehouse.dbo.dimDate w where convert(date,getdate())=d.[DateName] and (d.WeekKey+1)=w.WeekKey)' ,
		@LastYearEndStr varchar( 1000 ) = '(convert(date,convert(varchar,datepart(year,getdate())-1)+''-12-31''))' ,
		@ThisYearEndStr varchar( 1000 ) = '(convert(date,convert(varchar,datepart(year,getdate())-0)+''-12-31''))' ,
		@NextYearEndStr varchar( 1000 ) = '(convert(date,convert(varchar,datepart(year,getdate())+1)+''-12-31''))' ,
		@LastMonthEndStr varchar( 1000 ) = '(dateadd(day,-1,(convert(date,(convert(varchar,datepart(year,getdate()))+''/''+convert(varchar,month(getdate())+0)+''/1'')))))' ,
		@ThisMonthEndStr varchar( 1000 ) = '(dateadd(day,-1,(convert(date,(convert(varchar,datepart(year,getdate()))+''/''+convert(varchar,month(getdate())+1)+''/1'')))))' ,
		@NextMonthEndStr varchar( 1000 ) = '(dateadd(day,-1,(convert(date,(convert(varchar,datepart(year,getdate()))+''/''+convert(varchar,month(getdate())+2)+''/1'')))))' ,
		@LastWeekEndStr varchar( 1000 ) = '(select dateadd(day,6,min(w.[DateName]))from LoanWarehouse.dbo.dimDate d, LoanWarehouse.dbo.dimDate w where convert(date,getdate())=d.[DateName] and (d.WeekKey-1)=w.WeekKey)' ,
		@ThisWeekEndStr varchar( 1000 ) = '(select dateadd(day,6,min(w.[DateName]))from LoanWarehouse.dbo.dimDate d, LoanWarehouse.dbo.dimDate w where convert(date,getdate())=d.[DateName] and (d.WeekKey-0)=w.WeekKey)' ,
		@NextWeekEndStr varchar( 1000 ) = '(select dateadd(day,6,min(w.[DateName]))from LoanWarehouse.dbo.dimDate d, LoanWarehouse.dbo.dimDate w where convert(date,getdate())=d.[DateName] and (d.WeekKey+1)=w.WeekKey)';

	select
		@JointToken = replace( @JointToken, 'Nothing', '' ),
		@LeftParentheses = replicate( '(', convert( int, @LeftParentheses ) ),
		@RightParentheses = replicate( ')', convert( int, @RightParentheses ) ),
		@ValueFrom = quotename( @ValueFrom, @sq ),
		@ValueTo = quotename( @ValueTo, @sq );

	if @FieldType = 'IsCheckbox' goto IsCheckbox;
	else if @FieldType = 'IsDate' goto IsDate;
	else if @FieldType = 'IsDateTime' goto IsDateTime;
	else if @FieldType = 'IsMonthDay' goto IsMonthDay;
	else if @FieldType = 'IsNumeric' goto IsNumeric;
	else if @FieldType = 'IsOptionList' goto IsOptionList;
	else if @FieldType = 'IsPhone' goto IsPhone;
	else if @FieldType = 'IsString' goto IsString;
	else if @FieldType = 'IsYesNo' goto IsYesNo;
	else
	begin
		set @JointToken += ' -- unknown FieldType declaration';
		goto Result;
	end;

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Type
-----------------------------------------------------------------------------------------------------------------------------------------------------

IsCheckbox:
	select 
		@SqlOperation =
			case @Operator 
				when 'Is Checked' then '= ''X'''
				when 'Is not checked' then 'in ( ''N'', '+@dq+' )'
				else @UnknownOperatorAlert
			end,
		@TblAbrv = 
			'isnull( ' + @TblAbrv,
		@ColumnName =
			@ColumnName + ', '+@dq+' )'; 
	goto Result;

IsDate: 
	if @Operator in 
		(
			'Last 7 days',
			'Last 15 days',
			'Last 30 days',
			'Last 60 days',
			'Last 90 days',
			'Last 180 days',
			'Last 365 days',
			'Next 7 days',
			'Next 15 days',
			'Next 30 days',
			'Next 60 days',
			'Next 90 days',
			'Next 180 days',
			'Next 365 days'
		)
	begin
		select 
			@DateAddVal =
				case @Operator
					when 'Last 7 days' then '-7'
					when 'Last 15 days' then '-15'
					when 'Last 30 days' then '-30'
					when 'Last 60 days' then '-60'
					when 'Last 90 days' then '-90'
					when 'Last 180 days' then '-180'
					when 'Last 365 days' then '-365'
					when 'Next 7 days' then '7'
					when 'Next 15 days' then '15'
					when 'Next 30 days' then '30'
					when 'Next 60 days' then '60'
					when 'Next 90 days' then '90'
					when 'Next 180 days' then '180'
					when 'Next 365 days' then '365'
				end,
			@DateAddDir = left( @Operator, 4 );
		
		if @DateAddDir = 'Next' 
		begin 
			select 
				@ValueFrom = 'getdate()',
				@ValueTo = 'dateadd( day, ' + @DateAddVal + ', getdate() )';
		end;
		else if @DateAddDir = 'Last' 
		begin 
			select 
				@ValueFrom = 'dateadd( day, ' + @DateAddVal + ', getdate() )',
				@ValueTo = 'getdate()';
		end;

		goto GetBetweenWhereClause;
	end;
	else if @Operator in 
		( 
			'Date between',
			'Previous year',
			'Previous month',
			'Previous week',
			'Current week',
			'Current month',
			'Year-to-date',
			'Next week',
			'Next month',
			'Next year'
		)
	begin
		select 
			@ValueFrom = 
				case @Operator
					when 'Date between' then @ValueFrom
					when 'Previous year' then @LastYearStartStr
					when 'Previous month' then @LastMonthStartStr
					when 'Previous week' then @LastWeekStartStr
					when 'Current week' then @ThisWeekStartStr
					when 'Current month' then @ThisMonthStartStr
					when 'Year-to-date' then @ThisYearStartStr
					when 'Next week' then @NextWeekStartStr
					when 'Next month' then @NextMonthStartStr
					when 'Next year' then @NextYearStartStr
					else @UnknownOperatorAlert
				end,
			@ValueTo = 
				case @Operator
					when 'Date between' then @ValueTo
					when 'Previous year' then @LastYearEndStr
					when 'Previous month' then @LastMonthEndStr
					when 'Previous week' then @LastWeekEndStr
					when 'Current week' then @ThisWeekEndStr
					when 'Current month' then @ThisMonthEndStr
					when 'Year-to-date' then @TodayStr
					when 'Next week' then @NextWeekEndStr
					when 'Next month' then @NextMonthEndStr
					when 'Next year' then @NextYearEndStr
					else @UnknownOperatorAlert
				end; 
		goto GetBetweenWhereClause;
	end;
	else if @Operator in
		(
			'Today',
			'Is',
			'Is not',
			'Before',
			'On or before',
			'After',
			'On or after'
		)
	begin
		select @ValueFrom =
			case @Operator 
				when 'Today' then 'getdate()'
				else @ValueFrom
				end;
		if @Operator in ( 'Today', 'Is' ) goto GetIsExactWhereClause;
		else if @Operator = 'Is not' goto GetNotIsExactWhereClause;
		else if @Operator = 'Before' goto GetLessThanWhereClause;
		else if @Operator = 'On or before' goto GetNotGreaterThanWhereClause;
		else if @Operator = 'After' goto GetGreaterThanWhereClause;
		else if @Operator = 'On or after' goto GetNotLessThanWhereClause;
	end;
	else if @Operator = 'Date not between' goto GetNotBetweenWhereClause;
	else if @Operator = 'Empty date field' goto GetIsNullWhereClause;
	else if @Operator = 'Non-empty date field' goto GetNotIsNullWhereClause;

	goto Result;

IsDateTime:
	set @SqlOperation = '; -- IsDateTime type operator not implemented';
	goto Result;

IsMonthDay:
	set @SqlOperation = '; -- MonthDay type operator not implemented ( "Recurring Date" filter selected in Encompass GUI )';
	goto Result;

IsNumeric:
	if @Operator = 'Greater than' goto GetGreaterThanWhereClause;
	else if @Operator = 'Is not' goto GetNotIsExactWhereClause;
	else if @Operator = 'Between' goto GetBetweenWhereClause;
	else if @Operator = 'Is' goto GetIsExactWhereClause;
	else if @Operator = 'Not less than' goto GetNotLessThanWhereClause;
	else if @Operator = 'Less than' goto GetLessThanWhereClause;
	else if @Operator = 'Not greater than' goto GetNotGreaterThanWhereClause;
	else 
	begin
		set @SqlOperation = @UnknownOperatorAlert;
	end;
	goto Result;

IsOptionList:
	select
		@SqlOperation = 
			case @Operator
				when 'Is any of' then 'in '
				when 'Is not any of' then 'not in '
				else @UnknownOperatorAlert
			end,
		@ValueFrom = 
			'(' + replace( @ValueFrom, ';', @sq+','+@sq ) + ')'; -- convert to SQL array ('1','2','3')
	set @SqlOperation = @SqlOperation + @ValueFrom;
	goto Result;

IsPhone:
	goto IsString; -- is phone logic appears to be the same as IsString
	goto Result;

IsString:
	if @Operator = 'Contains' goto GetContainsWhereClause;
	else if @Operator = 'Is not' goto GetNotIsExactWhereClause;
	else if @Operator = 'Is (Exact)' goto GetIsExactWhereClause;
	else if @Operator = 'Is' goto GetIsExactWhereClause;
	else if @Operator = 'Doesn''t contain' goto GetDoesNotContainWhereClause;
	else if @Operator = 'Starts with' goto GetStartsWithWhereClause;
	else if @Operator = 'Doesn''t start with' goto GetDoesNotStartWithWhereClause;
	else 
	begin
		set @SqlOperation = @UnknownOperatorAlert;
	end;
	goto Result;

IsYesNo:
	select 
		@SqlOperation =
			case @Operator 
				when 'Is Yes' then 'in (''Y'',''Yes'')'
				when 'Is No' then 'in ( ''N'', ''No'' )'
				else @UnknownOperatorAlert
			end,
		@TblAbrv = 
			'isnull( ' + @TblAbrv,
		@ColumnName =
			@ColumnName + ', ''No'' )'; 
	goto Result;

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Operators
-----------------------------------------------------------------------------------------------------------------------------------------------------

GetIsExactWhereClause: 
	select @SqlOperation =
		'= ' + @ValueFrom;
	goto Result;

GetNotIsExactWhereClause: 
	select @SqlOperation =
		'!= ' + @ValueFrom;
	goto Result;

GetNotBetweenWhereClause:
	select @SqlOperation = 
		'not between ' + @ValueFrom + ' and ' + @ValueTo; 
	goto Result;

GetBetweenWhereClause:
	select @SqlOperation = 
		'between ' + @ValueFrom + ' and ' + @ValueTo; 
	goto Result;

GetGreaterThanWhereClause:
	select @SqlOperation =
		'> ' + @ValueFrom;
	goto Result;

GetNotLessThanWhereClause:
	select @SqlOperation =
		'>= ' + @ValueFrom;
	goto Result;

GetLessThanWhereClause:
	select @SqlOperation =
		'< ' + @ValueFrom;
	goto Result;

GetNotGreaterThanWhereClause:
	select @SqlOperation =
		'<= ' + @ValueFrom;
	goto Result;

GetContainsWhereClause:
	select @SqlOperation =
		'like ' + @sq+@pct+@sq + '+' + @ValueFrom + '+' + @sq+@pct+@sq;
	goto Result;

GetDoesNotContainWhereClause:
	select @SqlOperation =
		'not like ' + @sq+@pct+@sq + '+' + @ValueFrom + '+' + @sq+@pct+@sq;
	goto Result;

GetStartsWithWhereClause:
	select @SqlOperation =
		'like ' + left( @ValueFrom, len( @ValueFrom ) - 1 ) + @pct+@sq; -- trim last ', replace with %'
	goto Result;

GetDoesNotStartWithWhereClause:
	select @SqlOperation =
		'not like ' + left( @ValueFrom, len( @ValueFrom ) - 1 ) + @pct+@sq; -- trim last ', replace with %'
	goto Result;

GetIsNullWhereClause:
	select @Result = 
		@LeftParentheses + ' ' +
		@TblAbrv + '.' + @ColumnName + ' ' +
		' is null ' +
		@RightParentheses + ' ' +
		@JointToken + ' ';
	goto BypassResult; 

GetNotIsNullWhereClause:
	select @Result = 
		@LeftParentheses + ' ' +
		@TblAbrv + '.' + @ColumnName + ' ' +
		' is not null ' +
		@RightParentheses + ' ' +
		@JointToken + ' ';
	goto BypassResult;
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- RESULTS
-----------------------------------------------------------------------------------------------------------------------------------------------------
Result:
	select @Result = 
		@LeftParentheses + ' ' +
		@TblAbrv + '.' + @ColumnName + ' ' +
		@SqlOperation + ' ' +
		@RightParentheses + ' ' +
		@JointToken + ' ';

BypassResult:
	
	return @Result;

end;

GO
GRANT EXECUTE ON  [dbo].[fnGetWhereClauseLineFromFilterElement] TO [GRCORP\BHarrison]
GO
GRANT EXECUTE ON  [dbo].[fnGetWhereClauseLineFromFilterElement] TO [GRCORP\jpugh]
GO
