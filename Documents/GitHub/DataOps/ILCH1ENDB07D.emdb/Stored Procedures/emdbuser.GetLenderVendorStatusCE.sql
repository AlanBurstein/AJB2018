SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [emdbuser].[GetLenderVendorStatusCE]
	@loginUserid varchar(16),
	@snapshotUserid varchar(16),
	@roleID int,
	@lvType varchar(30),
	@forLoanAmount bit,
	@timeFrame varchar(20),
	@folderList text = null
as
	declare	@orgId int,
		@from smalldatetime,
		@to	smalldatetime,
		@whereClause varchar(200),
		@cmd varchar(1200),
		@cnt tinyint,
		@excludeCurrentLevel bit
	set nocount on
	select	@orgId = org_id
	from	users
	where	userId = @loginUserid
	SELECT @excludeCurrentLevel = peerView 
	FROM users
	WHERE userid = @loginUserid
	if @loginUserid = 'admin'
		set @excludeCurrentLevel = 1
	if @excludeCurrentLevel = 1
		set @excludeCurrentLevel = 0
	else
	begin
		if @excludeCurrentLevel = 0
			set @excludeCurrentLevel = 1
	end
	if @excludeCurrentLevel is null
		set @excludeCurrentLevel = 1
	create table #users
	(userid varchar(16), folderName varchar(80))
	if @snapshotUserid is null
	begin
		insert into #users
		select UF.userid, UF.folderName
		from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
		select	@whereClause = ' (s.loanFolder = u.folderName) '
	end
	else
	begin
		insert into #users
		select UF.userid, UF.folderName
		from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
		select	@whereClause = ' (s.loanFolder = u.folderName) and LA.roleID =' + convert(varchar, @roleID)
	end
	--to convert the time frame
	exec	ConvertTimeFrame @timeFrame, @from out, @to out
	-- Create a temp table with the loan folders
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	create table #tmp_LM
	(Guid varchar(38))
	select @cmd = 'insert into #tmp_LM
		select distinct s.Guid
		from #summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
		     inner join #users u on LA.UserID = u.userid
		where ' + @whereClause
	exec	(@cmd)
	if @forLoanAmount = 1
		select	@cmd = 'select	top 10 ' + @lvType + ',' + @lvType + ',null,
				isnull(sum(convert(money,LoanAmount)),0) as LoanAmount
		from	#summaryData inner join #tmp_LM tLM on #summaryData.Guid = tLM.Guid
		where	CurrentCoreMilestoneName = ''Completion''
				and ' + @lvType + ' is not null
				and rtrim(' + @lvType + ') <> ''''
				and datediff(d,''' + convert(varchar,@from) + ''',DateCompleted) >= 0 
				and datediff(d,DateCompleted,''' + convert(varchar,@to) + ''') >= 0' +
		' group by	' + @lvType + '
		order by	sum(convert(money,LoanAmount)) desc'
	else
		select	@cmd = 'select	top 10 ' + @lvType + ',' + @lvType + ',null,
				count(*) as NumFiles
		from	#summaryData inner join #tmp_LM tLM on #summaryData.Guid = tLM.Guid
		where	CurrentCoreMilestoneName = ''Completion''
				and ' + @lvType + ' is not null
				and rtrim(' + @lvType + ') <> ''''
				and datediff(d,''' + convert(varchar,@from) + ''',DateCompleted) >= 0 
				and datediff(d,DateCompleted,''' + convert(varchar,@to) + ''') >= 0 ' +
		' group by	' + @lvType + '
		order by	count(*) desc'
	--exec	(@cmd)
	create table #LenvenStatus
	(Source varchar(100), Src varchar(100), abbrev varchar(3), numFilesOrdollarAmt real)		
	select	@cmd = 'Insert into #LenvenStatus ' + @cmd 
	exec	(@cmd)
	--to get abbreviations
	set	@cnt = 0
	update	#LenvenStatus
	set		abbrev = substring(Source,1,1)
	while(@cnt < 2)
	begin
		--to get to the next word
		update	#LenvenStatus
		set		Source = ltrim(substring(Source,isnull(nullif(charindex(' ',Source),0),31),30))
		update	#LenvenStatus
		set		abbrev = abbrev + substring(Source,1,1)
		set	@cnt = @cnt + 1
	end
	select	 abbrev 'abbrevSource',Src,
			numFilesOrdollarAmt
	from	#LenvenStatus

GO
