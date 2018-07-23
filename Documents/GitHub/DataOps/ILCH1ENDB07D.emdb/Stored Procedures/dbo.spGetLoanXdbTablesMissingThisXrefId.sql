SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[spGetLoanXdbTablesMissingThisXrefId]
	@XrefId int
/*
exec dbo.spGetLoanXdbTablesMissingThisXrefId @XrefId = 7673120;
*/
as
/* who				when			what
petervandivier		2015-12-22	cursor to return the cross ref tables missing this loan - why did the LWH etl fail at #dimLoan on this LoanId
*/
begin
	set nocount on;
	set tran isolation level read uncommitted;
	
	declare 
		@Sql nvarchar( max ) = '',
		@Name sysname,
		@XrefChar varchar( 10 );

	set @XrefId = 7673120;

	select @XrefChar = convert( varchar( 10 ), @XrefId );

	if object_id( N'tempdb..#LoanXdbList' ) is not null drop table #LoanXdbList;

	create table #LoanXdbList ( name sysname not null unique );

	insert #LoanXdbList ( name )
	select name
	from sys.tables t
	where [schema_id] = schema_id( N'emdbuser' ) and 
		name like 'LoanXDB%' and 
		name <> 'LoanXDBFieldList'
	order by name;

	declare crsLoanDdbSeek cursor for
		select name from #LoanXdbList;

	open crsLoanDdbSeek;

	fetch next from crsLoanDdbSeek into @name;

	while @@fetch_status = 0
	begin

		set @Sql = 
	'if exists ( select 1 from emdbuser.' + @name + ' where XrefId = ' + @XrefChar + ' )
	delete from #LoanXdbList 
	where name = '''  + @name + ''';';

		exec sp_executesql @Sql;

		fetch next from crsLoanDdbSeek into @name;
	end;

	close crsLoanDdbSeek;

	deallocate crsLoanDdbSeek;

	select 
		name as TablesMissingFrom
	from #LoanXdbList
	union 
	select convert( sysname, @XrefChar );

	return 0;
end;

GO
