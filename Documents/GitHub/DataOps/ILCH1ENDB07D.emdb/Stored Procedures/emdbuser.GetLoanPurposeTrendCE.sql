SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE              procedure [emdbuser].[GetLoanPurposeTrendCE]
	@loginUserid varchar(16),
	@snapshotUserid varchar(16),
	@roleID int,
	@forLoanAmount bit,
	@periodLength tinyint,
	@periodUnit varchar(10),
	@folderList text = null
as
	declare	@orgId int,
		@now smalldatetime,
		@cnt tinyint,
		@whereClause varchar(200),
		@cmd varchar(1200),
		@period varchar(4),
		@excludeCurrentLevel bit
	set nocount on	
	select	@now = getdate()
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
			--no such snapshot user qualifies
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
	--to generate purposePeriod table
	select	distinct LoanPurposeGroup,
			period,
			displayName
	into	#purposePeriod
	from	LoanPurpose m,
			#period p
	where	IncludeForTrend  = 1
	create table #trend
	(LoanPurposeGroup varchar(30), numFiles int, loanAmount money, displayName varchar(10), 
	 period tinyint)
	create table #tmp_trend
	(Guid varchar(38), LoanPurpose varchar(30), DateCompleted smalldatetime, loanAmount varchar(20))
	-- Create a temp table with the loan folders
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	if @periodUnit = 'week'
		select	@period = 'wk'
	else if @periodUnit = 'month'
		select	@period = 'mm'
	else if @periodUnit = 'quarter'
		select	@period = 'q'
	select	@cmd = 'insert into #tmp_trend
		select distinct s.Guid, s.LoanPurpose, s.DateCompleted, s.loanAmount
		from #summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
		     inner join #users u on LA.UserID = u.userid
		where ' + @whereClause
	exec	(@cmd)
	select	@cmd = 'insert into	#trend
		select	p.LoanPurposeGroup,
				count(*),
				sum(convert(money,loanAmount)),
				null,
				datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) + ''')
		from	#tmp_trend s inner join LoanPurpose p on s.LoanPurpose = p.LoanPurpose
		where	p.IncludeForTrend = 1
				and datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) + ''') >= 1
				and datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) 
				+ ''') <= ''' + convert(varchar,@periodLength) + '''' +
		' group by	p.LoanPurposeGroup, datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) + ''')'
	exec	(@cmd)
	insert into	#trend
	select	distinct LoanPurposeGroup, 0, 0, null, period
	from	#purposePeriod p
	where	period not in
			(select	period
			 from	#trend t
			 where	t.LoanPurposeGroup = p.LoanPurposeGroup)
	update	#trend
	set		#trend.displayName = p.displayName
	from	#purposePeriod p
	where	#trend.period = p.period
---select	LoanPurposeGroup,
--		numFiles,
--		loanAmount,
---		displayName
--from	#trend
--order by	LoanPurposeGroup, period desc	
------------------------------------------------------
--   MS: Added on AUG 21 2003 
	create table #trendNew
	(displayName varchar(30), "Purchase" real, "Refinance" real)
	if @forLoanAmount = 1
	 begin
		insert into	#trendNew (displayName, Purchase)
		select 	displayName,loanAmount		
		from #trend 
		where #trend.LoanPurposeGroup = 'Purchase'
		order by	 #trend.LoanPurposeGroup,  #trend.period desc	
		update	#trendNew
		set		#trendNew."Refinance" = p.loanAmount
		from	#trend p
		where	#trendNew.displayName= p.displayName and p.LoanPurposeGroup = 'Refinance'
	 end 
	else
	 begin
		insert into	#trendNew (displayName, Purchase)
		select 	displayName,numFiles		
		from #trend 
		where #trend.LoanPurposeGroup = 'Purchase'
		order by	 #trend.LoanPurposeGroup,  #trend.period desc	
		update	#trendNew
		set		#trendNew."Refinance" = p.numFiles
		from	#trend p
		where	#trendNew.displayName= p.displayName and p.LoanPurposeGroup = 'Refinance'
	end
	select	displayName, "Purchase", "Refinance"
	from	#trendNew
-- 
-------------------------------------------------------

GO
