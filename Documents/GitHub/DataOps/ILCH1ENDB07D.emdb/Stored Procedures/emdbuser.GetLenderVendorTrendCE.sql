SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [emdbuser].[GetLenderVendorTrendCE]
	@loginUserid varchar(16),
	@snapshotUserid varchar(16),
	@roleID int,
	@lvType varchar(30),
	@forLoanAmount bit,
	@periodLength tinyint,
	@periodUnit varchar(10),
	@folderList text = null
as
	declare	@orgId int,
		@now smalldatetime,
		@cnt tinyint,
		@dbDateUnit varchar(4),
		@whereClause varchar(200),
		@cmd varchar(1200),
		@excludeCurrentLevel bit
	set nocount on	
	set	@now = getdate()
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
		if @roleID < 0
			select	@whereClause = ' 1=2'
		else
		begin
		insert into #users
		select UF.userid, UF.folderName
		from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
		select	@whereClause = ' (s.loanFolder = u.folderName) and LA.roleID = ' + convert(varchar, @roleID) 
		end
	end
	--to generate period table
	select	*
	into	#period
	from	FN_GetPeriodTable(@now, @periodLength, @periodUnit)
	create table #trend
	(LenderVendor varchar(100), NumFiles int, LoanAmount money, 
	 period tinyint, displayName varchar(10))
	create table #tmp_LM
	(Guid varchar(38))
	create table #LenderVendor
	(LenderVendor varchar(100))	
	if @periodUnit = 'week'
		set	@dbDateUnit = 'wk'
	else if @periodUnit = 'month'
		set	@dbDateUnit = 'mm'
	else if @periodUnit = 'quarter'
		set	@dbDateUnit = 'q'
	-- Create a temp table with the loan folders
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	select @cmd = 'insert into #tmp_LM
		select distinct s.Guid
		from #summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
		     inner join #users u on LA.UserID = u.userid
		where ' + @whereClause
	exec	(@cmd)
	--to get top5 LenderVendors
	if @forLoanAmount = 1
	begin
		--by loan amount
		select	@cmd = 'insert into	#LenderVendor
		select top 5 ' + @lvType + '
		from	#summaryData inner join #tmp_LM tLM on #summaryData.Guid = tLM.Guid
		where	CurrentCoreMilestoneName = ''Completion''
				and ' + @lvType + ' is not null
				and rtrim(' + @lvType + ') <> ''''
				and datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + ''') >= 1
				and datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + ''') <= ' + convert(varchar,@periodLength) +
		' group by	' + @lvType + '
		order by	sum(convert(money,LoanAmount)) desc'
	end
	else	--by number of files
	begin
		--to get top5 LenderVendors
		select	@cmd = 'insert into	#LenderVendor
		select top 5 ' + @lvType + '
		from	#summaryData inner join #tmp_LM tLM on #summaryData.Guid = tLM.Guid
		where	CurrentCoreMilestoneName = ''Completion''
				and ' + @lvType + ' is not null 
				and rtrim(' + @lvType + ') <> ''''
				and datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + ''') >= 1
				and datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + ''') <= ' + convert(varchar,@periodLength) +
		' group by	' + @lvType + '
		order by	count(*) desc'
	end
	exec	(@cmd)
	select	@cnt = count(*)
	from	#LenderVendor
	if @cnt = 0
	begin
		select	l.LenderVendor,
				p.period,
				p.displayName
		from	#LenderVendor l,
				#period p
		where	1 = 2
		return
	end
	select	@cmd = 'insert into	#trend
	select	s.' + @lvType + ',
			isnull(count(*), 0),
			isnull(sum(convert(money,LoanAmount)), 0),
			datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + '''),
			null
	from	#summaryData s,
			#LenderVendor l
	where	s.' + @lvType + ' = l.LenderVendor
			and CurrentCoreMilestoneName = ''Completion''
			and datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + ''') >= 1
			and datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + ''') <= ' + convert(varchar,@periodLength) + '
	group by	s.' + @lvType + ', datediff(' + @dbDateUnit + ',DateCompleted,''' + convert(varchar,@now) + ''')'
	exec	(@cmd)
	--to create LenderVendorPeriod table
	select	l.LenderVendor,
			p.period,
			p.displayName
	into	#LenderVendorPeriod
	from	#LenderVendor l,
			#period p
	insert into	#trend
	select	LenderVendor, 0, 0, period, displayName
	from	#LenderVendorPeriod p
	where	period not in
			(select	period
			 from	#trend t
			 where	t.LenderVendor = p.LenderVendor)
	update	#trend
	set		#trend.displayName = p.displayName
	from	#LenderVendorPeriod p
	where	#trend.period = p.period
			and #trend.displayName is null
--	select	LenderVendor,
--			LoanAmount,
--			NumFiles,				
--			displayName
--		from	#trend
--		order by	LenderVendor, period desc
-- MS 23 Sep 2003 
--Added the following to return the format required by trends	
	create table #trendName
	(displayName varchar(100))  			
	declare	@LenvenName varchar(100)
	declare	@filter varchar(10)
	declare @count int
	select @Count =0		
	if @forLoanAmount = 1
			Select @filter = 'LoanAmount'
	else 
			Select @filter = 'NumFiles'			
	declare cur cursor
		for
			select Distinct LenderVendor from #trend where 
			Lendervendor is not null		
		for read only
		open cur
			fetch next from cur into @LenvenName
			while @@fetch_status = 0
			begin
				-- col needs to have some name you cannot leave it empty
				if @LenvenName = ''
				begin
					select @LenvenName = ' '	
				end 	
				select @cmd ='ALTER TABLE #trendName ADD ['+ @LenvenName+'] real NULL'
				exec (@cmd)
				if @Count = 0 
					Begin 
						select @cmd= 'insert into	#trendName (displayName, ['+@LenvenName+'])
								select 	displayName,'+@filter+'		
								from #trend 
								where #trend.LenderVendor = '''+ REPLACE(@LenvenName,'''','''''') +'''
								order by	 #trend.LenderVendor,  #trend.period desc'	
						exec (@cmd)		
						select @Count = 1
					end 
				else 
					begin					
						select @cmd ='update	#trendName
								set		#trendName.['+@LenvenName+'] = p.'+@filter+'
								from	#trend p
								where	#trendName.displayName= p.displayName and p.LenderVendor = '''+ REPLACE(@LenvenName,'''','''''') + ''''								
						exec (@cmd)		
					end 	
				fetch next from cur into @LenvenName
			end
		close cur
	deallocate cur
	select * from #trendName

GO
