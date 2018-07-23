SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[spGetSelectFromEncXml]
	@EncReportFile xml,
	@User varchar( 100 ),
	@ReportName varchar( 100 )
as
/* who				when			what
petervandivier		2015-10-30		load parser as standalone proc
petervandivier		2015-10-31		" ;" to ";". add linebreak to @ErrMsg. Add find AuditTrial.* fields for raiserror()
									had to move text var declare block to top to keep @lb in scope
									moved current "print set" after the raiserror() to keep it visible
									convert final print to varchar from nvarchar to double length in print window before trunc from 4k to 8k
									add @SessionProperties predicate
petervandivier		2015-11-02		add @user & @ReportName params to assist when the team is running the parser at the same time as another person
									add clustered index on ##tables ( xPath )
									add raiserror() for Alert.* fields
petervandivier		2015-11-03		add text placehold output to select clause for Alert.* and AuditTrail.*

*/
begin
	set concat_null_yields_null on;
	set nocount on;

	declare @ReportObjXml xml;
	select @ReportObjXml = @EncReportFile;
	--select @ReportObjXml

	select @User = isnull( @User, replace( user_name(), 'GRCORP', '' ) );
	select @ReportName = isnull( @ReportName, 'unknown report run by ' + @User + ' at time ' + convert( varchar, convert( time, getdate(), 126 ) ) );


	if object_id( N'tempdb..##EncRprtObjReport' ) is not null drop table ##EncRprtObjReport;
	if object_id( N'tempdb..##EncRprtObjFields' ) is not null drop table ##EncRprtObjFields;
	if object_id( N'tempdb..##EncRprtObjFilters' ) is not null drop table ##EncRprtObjFilters;
	if object_id( N'tempdb..##EncRprtObjFolders' ) is not null drop table ##EncRprtObjFolders;
	if object_id( N'tempdb..##LoanXdbTblAbrv' ) is not null drop table ##LoanXdbTblAbrv;

	select 
		TblAbrv = lower( substring( TABLE_NAME, 9, 1 ) ) + substring( TABLE_NAME, 11, 2 ),
		TABLE_NAME 
	into ##LoanXdbTblAbrv
	from INFORMATION_SCHEMA.TABLES 
	where TABLE_NAME like 'loanxdb[_]%';

			/************************/
			/*	Begin XML Parsing	*/
			/*	declare/init vars	*/
			/************************/

	declare 
		@ReportNodeX xml,
		@MsAttribute_Any char( 1 ),
		@MsNodeElementCount int,
		@FolderListAttribute_Option varchar( 255 ),
		@FolderListNodeElementCount int,
		@ReportObjTotalColOutputCount int,
		@ReportObjNonXlColOutputCount int,
		@ErrMsg varchar( 4000 ) = '',
		@ErrCount int = 0;

-- text vars	
	declare 
		@SqlQuery nvarchar( max ) = '',
		@lb nchar( 1 ) = char( 10 ),
		@tab nchar( 1 ) = char( 9 ),
		@sq nchar( 1 ) = char( 39 ), -- single quote
		@dq nchar( 2 ) = char( 39 ) + char( 39 ), -- 2x single quote
		@PrefixText varchar( max ) = '',
		@SessionProperties nvarchar( max ) = '',
		@SelectClause nvarchar( max ) = '',
		@FromClause nvarchar( max ) = '',
		@WhereClause nvarchar( max ) = '';

		/****************/
		/*	Report Node	*/
		/****************/
	declare 
		@ReportNodeCount int = ( select count( n.query('.') ) from @ReportObjXml.nodes('/ReportSettings/Report') as f( n ) ) ,
		@ReportNodeElementCount int = ( select count( n.query('.') ) from @ReportObjXml.nodes('/ReportSettings/Report/*') as f( n ) );

	if @ReportNodeCount <> 1 or @ReportNodeElementCount <> 18
	begin
		select 
			@ErrMsg += 'This report has a nonstandard display configuration. Please review' + @lb,
			@ErrCount += 1;
	end;

	select 
		[Version] = n.value('(./Version/@value)[1]','varchar(100)'),
		ReportFor = n.value('(./ReportFor/@value)[1]','varchar(100)'),
		ReportType = n.value('(./ReportType/@value)[1]','varchar(100)'),
		FileStage = n.value('(./FileStage/@value)[1]','varchar(100)'),
		TimeFrame = n.value('(./TimeFrame/@value)[1]','varchar(100)'),
		DateFrom = n.value('(./DateFrom/@value)[1]','varchar(100)'),
		DateTo = n.value('(./DateTo/@value)[1]','varchar(100)'),
		PaperSize = n.value('(./PaperSize/@value)[1]','varchar(100)'),
		PaperOrientation = n.value('(./PaperOrientation/@value)[1]','varchar(100)'),
		TopMargin = n.value('(./TopMargin/@value)[1]','varchar(100)'),
		BottomMargin = n.value('(./BottomMargin/@value)[1]','varchar(100)'),
		LeftMargin = n.value('(./LeftMargin/@value)[1]','varchar(100)'),
		RightMargin = n.value('(./RightMargin/@value)[1]','varchar(100)'),
		UseFieldInDB = n.value('(./UseFieldInDB/@value)[1]','varchar(100)'),
		UseFilterFieldInDB = n.value('(./UseFilterFieldInDB/@value)[1]','varchar(100)'),
		RelatedLoanFilterSource = n.value('(./RelatedLoanFilterSource/@value)[1]','varchar(100)'),
		RelatedLoanFieldSource = n.value('(./RelatedLoanFieldSource/@value)[1]','varchar(100)'),
		ForTPO = n.value('(./ForTPO/@value)[1]','varchar(100)')
	into ##EncRprtObjReport
	from @ReportObjXml.nodes('/ReportSettings/Report') as f( n );

		/********************/
		/*	FieldList Node	*/
		/********************/
	select 
		xPath =			row_number() over (order by (select 1)),
		[desc] =		n.value('@desc','varchar(255)'),
		id =			n.value('@id','varchar(255)'),
		sorting =		n.value('@sorting','varchar(255)'),
		summary =		n.value('@summary','varchar(255)'),
		[decimal] =		n.value('@decimal','varchar(255)'),
		comortgagor =	n.value('@comortgagor','varchar(255)'),
		criterion =		n.value('@criterion','varchar(255)'),
		IsNonUseable =	cast( null as varchar( 100 ) ),
		isexcelfield =	n.value('@isexcelfield','varchar(255)'),
		excelformula =	n.value('@excelformula','varchar(255)'),
		FieldXml =		n.query('.')
	into ##EncRprtObjFields
	from @ReportObjXml.nodes('/ReportSettings/FieldList/Field') as f( n );

	update ##EncRprtObjFields set 
		IsNonUseable = case
							when id like 'AuditTrail.%' then 'AuditTrail'
							when id like 'Alert.%' then 'Alert'
						end;

	exec sp_executesql N'create clustered index idx_A on ##EncRprtObjFields( xPath );';

	if exists( select * 
				from ##EncRprtObjFields 
				where id like 'AuditTrail.%' or 
					criterion like 'AuditTrail.%' )
	begin
		select 
			@ErrMsg += 'This report attempts to access the audit trail, which is not available on 03. You may need to address this with the user.' + @lb,
			@ErrCount += 1;;
	end;

	if exists( select * 
				from ##EncRprtObjFields 
				where id like 'Alert.%' or 
					criterion like 'Alert.%' )
	begin
		select 
			@ErrMsg += 'This report attempts to access an embedded Loan Status Alert, which is not available in the database. You may need to address this with the user.' + @lb,
			@ErrCount += 1;;
	end;

		/********************/
		/*	FilterList Node	*/
		/********************/
	select 
		xPath =				row_number() over (order by (select 1)),
		FieldID =			n.value('@FieldID','varchar(255)'),
		[description] =		n.value('@Description','varchar(255)'),
		FieldType =			n.value('@FieldType','varchar(255)'),
		Operators =			n.value('@Operators','varchar(255)'),
		valueFrom =			n.value('@ValueFrom','varchar(255)'),
		valueTo =			n.value('@ValueTo','varchar(255)'),
		JointToken =		n.value('@JointToken','varchar(255)'),
		LeftParentheses =	n.value('@LeftParentheses','varchar(255)'),
		RightParentheses =	n.value('@RightParentheses','varchar(255)'),
		CriterionName =		n.value('@CriterionName','varchar(255)'),
		FilerXml =			n.query('.')
	into ##EncRprtObjFilters
	from @ReportObjXml.nodes('/ReportSettings/FilterList/Filter') as f( n ); 

	exec sp_executesql N'create clustered index idx_A on ##EncRprtObjFilters( xPath );';

		/********************/
		/*	Milestones Node	*/
		/********************/
	select @MsAttribute_Any = n.value('@value','char(1)') from @ReportObjXml.nodes('/ReportSettings/Milestones/Any') as f( n );
	select @MsNodeElementCount = count( n.query('.') ) from @ReportObjXml.nodes('/ReportSettings/Milestones/Any') as f( n )

	if @MsAttribute_Any <> 'Y' or @MsNodeElementCount <> 1
	begin
		select 
			@ErrMsg += 'This report has non-standard milestone filters. Please review.' + @lb,
			@ErrCount += 1;
	end; 

		/********************/
		/*	FolderList Node	*/
		/********************/
	select @FolderListAttribute_Option = n.value('@Option','varchar(255)') from @ReportObjXml.nodes('/ReportSettings/FolderList') as f( n );
	select @FolderListNodeElementCount = count( n.query('.') ) from @ReportObjXml.nodes('/ReportSettings/FolderList') as f( n );
	/*---------------+------------------------------------------+
	|     Option     |           GUI selected bullet            |
	+----------------+------------------------------------------+
	| AllExceptTrash | All loan folders.                        |
	| Active         | All loan folders except Archive folders. |
	| Selected       | Select loan folders manually .           |
	+----------------+-----------------------------------------*/

	if @FolderListAttribute_Option = 'Selected'
	begin
		select 
			Folder = sn.value('@name','varchar(255)') 
		into ##EncRprtObjFolders
		from @ReportObjXml.nodes('/ReportSettings/FolderList') as f( n ) 
		cross apply @ReportObjXml.nodes('/ReportSettings/FolderList/Folder') as sf( sn ); 
	end;


		/********************/
		/*	End XML Parsing	*/
		/*	Begin SQL Logic	*/
		/********************/
	set concat_null_yields_null off;
	select 
		@ReportObjTotalColOutputCount = count( * ),
		@ReportObjNonXlColOutputCount = sum( case isexcelfield when 'false' then 1 else 0 end )
	from ##EncRprtObjFields;

	select 
		@PrefixText = 
			'/* who			when			what' + @lb +
			'  ' + @User + @tab + @tab + convert( varchar, convert( date, getdate(), 126 ) ) + @tab +  @tab + 'auto-parsed select stmt for ' + @ReportName + @lb +
			'*/' + @lb,
		@SessionProperties =
			'set nocount on;' + @lb +
			'set tran isolation level read uncommitted;' + @lb + @lb;

		/********************/
		/*	select clause	*/
		/********************/
	set @SelectClause = 'select ' + @lb;

	with MaxXpath as ( select Num = max( xPath ) from ##EncRprtObjFields )
	select @SelectClause +=
		@tab + quotename( f.[Desc] ) + ' = ' + 
		case 
			when isexcelfield = 'false' and IsNonUseable is null then TblAbrv.TblAbrv + '.' + dbo.fnFieldIdToColumnName( fl.FieldID ) 
			when isexcelfield = 'true' then '''' + excelformula + ''''
			when IsNonUseable is not null then '''' + f.id + ''''
			else '' + 'UnknownFieldType' + ''
			end +
		case xPath when ( select Num from MaxXpath ) then '' + @lb else ',' + @lb end
	from ##EncRprtObjFields f
	left outer join emdb.emdbuser.LoanXDBFieldList fl on 
		fl.FieldID = f.id and
		isnull( nullif( fl.Pair, 0 ), 1 ) = f.comortgagor 
	left outer join ##LoanXdbTblAbrv TblAbrv on TblAbrv.TABLE_NAME = fl.TableName 
	order by f.xPath;
	--print @SelectClause

		/****************/
		/*	From clause	*/
		/****************/
	set @FromClause = 'from emdb.emdbuser.LoanSummary ls ' + @lb;

	with AllFields as
	(
		select FieldId = id from ##EncRprtObjFields where isexcelfield <> 'true'
		union
		select FieldId from ##EncRprtObjFilters 
	),dTblList as
	(
		select distinct
			abrv.TblAbrv,
			fl.TableName 
		from AllFields af
		join emdb.emdbuser.LoanXDBFieldList fl on 
			fl.FieldID = af.FieldID and
			isnull( nullif( fl.Pair, 0 ), 1 ) = 1 
		join ##LoanXdbTblAbrv abrv on abrv.TABLE_NAME = fl.TableName 
	)
	select @FromClause +=
		'join emdb.emdbuser.' + dt.TableName + ' ' + dt.TblAbrv + ' on ' + dt.TblAbrv + '.XrefId = ls.XrefId ' + @lb
	from dTblList dt
	order by dt.TableName;

		/********************/
		/*	Where clause	*/
		/********************/
	set @WhereClause = 'where ' + @lb;

	select @WhereClause +=
		@tab + 
		dbo.fnGetWhereClauseLineFromFilterElement
		(
			f.FieldType,
			f.LeftParentheses,
			abrv.TblAbrv,
			dbo.fnFieldIdToColumnName( fl.FieldID ),
			f.Operators,
			f.valueFrom,
			f.valueTo,
			f.RightParentheses,
			f.JointToken
		)
		+ @lb
	from ##EncRprtObjFilters f
	left outer join emdb.emdbuser.LoanXDBFieldList fl on 
		fl.FieldID = f.FieldID and
		isnull( nullif( fl.Pair, 0 ), 1 ) = 1 
	left outer join ##LoanXdbTblAbrv abrv on abrv.TABLE_NAME = fl.TableName 
	order by f.xPath;

		/************************************************/
		/*	LOG CURRENT USER IN ##TABLES FOR SHARED USE	*/
		/************************************************/
	insert ##EncRprtObjReport ( [Version], ReportType, ReportFor ) select '0', @ReportName, @User;
	insert ##EncRprtObjFields ( xPath, [desc], id ) select '0', @ReportName, @User;
	insert ##EncRprtObjFilters ( xPath, [description], FieldID ) select '0', @ReportName, @User;
	if object_id( N'tempdb..##EncRprtObjFolders' ) is not null insert ##EncRprtObjFolders ( Folder ) select '!' + '_' + '0' + '_' + @ReportName + '_' + @User;

	if datalength( @SelectClause ) > 4000 
		select @ErrMsg += 'Select clause has been truncated due to too many user columns.' + @lb,
			@ErrCount += 1;
	if datalength( @FromClause ) > 4000 
		select @ErrMsg += 'From clause has been truncated.' + @lb,
			@ErrCount += 1;
	if datalength( @WhereClause ) > 4000 
		select @ErrMsg += 'Where clause has been truncated due to too many user criteria.' + @lb,
			@ErrCount += 1;


	if @ErrMsg <> '' 
	begin
	Error:
		raiserror( @ErrMsg, 11, -1 );

	end;
	
	print @PrefixText;
	print @SessionProperties;
	print isnull( convert( varchar( max ), @SelectClause ), 'ERROR - Select' );
	print isnull( convert( varchar( max ), @FromClause ), 'ERROR - From' );
	print isnull( convert( varchar( max ), @WhereClause ), 'ERROR - Where' );

	select @SqlQuery =
		@PrefixText +
		@SessionProperties +
		isnull( convert( varchar( max ), @SelectClause ), 'ERROR - Select' ) +
		isnull( convert( varchar( max ), @FromClause ), 'ERROR - From' ) +
		isnull( convert( varchar( max ), @WhereClause ), 'ERROR - Where' );	

	select
		ErrMsg =	nullif( @ErrMsg, '' ),
		ErrCount =	@ErrCount,
		SqlQuery =	@SqlQuery;

	return 0;
end;



/*

exec dbo.spGetSelectFromEncXml 
	@EncReportFile = convert( xml, '' );
*/

GO
GRANT EXECUTE ON  [dbo].[spGetSelectFromEncXml] TO [GRCORP\BHarrison]
GO
GRANT EXECUTE ON  [dbo].[spGetSelectFromEncXml] TO [GRCORP\jpugh]
GO
