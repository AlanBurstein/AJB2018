SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [emdbuser].[GetPipelineTrendCE]
	@loginUserid varchar(16),
	@snapshotUserid varchar(16),
	@roleID int,
	@periodLength tinyint,
	@periodUnit varchar(10),
	@folderList text = null
as
	declare	@orgId int,
		@now smalldatetime,
		@cnt tinyint,
		@cmd varchar(1200),
		@whereClause varchar(200),
		@curPrevGrp varchar(30),
		@prevPrevGrp varchar(30),
		@curGrpOrder tinyint,
		@unitAbbrev varchar(2),
		@excludeCurrentLevel bit
	set nocount on	
	set @now = getdate()
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
		select	@whereClause = ' and (s.loanFolder = u.folderName) '
	end
	else
	begin
		if @roleID < 0
			--no such snapshot user qualifies
			select	@whereClause = ' and 1=2'
		else
		begin
		insert into #users
		select UF.userid, UF.folderName
		from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
		select	@whereClause = ' and (s.loanFolder = u.folderName) and LA.roleID =' + convert(varchar, @roleID)
		end
	end
	--to generate period table
	select	*
	into	#period
	from	FN_GetPeriodTable(@now, @periodLength, @periodUnit)
	--to generate milestonePeriod table
	select	distinct PrevMilestoneGroup,
			period,
			displayName,
			0 MilestoneGroupOrder
	into	#milestonePeriod
	from	Milestone m,
			#period p
	where	PrevMilestoneGroup is not null
	update	#milestonePeriod
	set		MilestoneGroupOrder = 
			(select	max(m.MilestoneGroupOrder)
			 from	Milestone m
			 where	m.PrevMilestoneGroup = #milestonePeriod.PrevMilestoneGroup)
	create table #trend
	(PrevMilestoneGroup varchar(30), aveDays real, displayName varchar(10), 
	 period tinyint, MilestoneGroupOrder tinyint)
	if @periodUnit = 'week'
		select	@unitAbbrev = 'wk'
	else if @periodUnit = 'month'
		select	@unitAbbrev = 'mm'
	else if @periodUnit = 'quarter'
		select	@unitAbbrev = 'q'
	select	@curPrevGrp = min(PrevMilestoneGroup)
	from	Milestone
	-- Create a temp table with the loan summary data
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	while(@curPrevGrp <> '')
	begin
		select	@curGrpOrder = max(MilestoneGroupOrder)
		from	Milestone
		where	PrevMilestoneGroup = @curPrevGrp
		select	@cmd = 'insert into	#trend
		select	''' + @curPrevGrp + ''',
				avg(convert(real,datediff(d,' + PrevDateFieldName + ',' + DateFieldName + '))),
				null,
				datediff(' + @unitAbbrev + ',' + DateFieldName + ',''' + convert(varchar,@now) + '''),
				' + convert(varchar,@curGrpOrder) + '
		from	#summaryData s inner join LoanAssociates LA on s.Guid = LA.guid inner join #users u on LA.UserID = u.userid, 
				Milestone m
		where	CurrentCoreMilestoneName = M.Milestone
				and m.MilestoneGroupOrder >= ' + convert(varchar,@curGrpOrder) + '
				--and LA.MilestoneID = convert(varchar, m.MilestoneId) 
				and datediff(' + @unitAbbrev + ',' + DateFieldName + ',''' + convert(varchar,@now) + ''') >= 1
				and datediff(' + @unitAbbrev + ',' + DateFieldName + ',''' + convert(varchar,@now) + ''') <= ' + convert(varchar,@periodLength) +
				@whereClause + '
		group by	datediff(' + @unitAbbrev + ',' + DateFieldName + ',''' + convert(varchar,@now) + ''')'
		from	Milestone
		where	PrevMilestoneGroup = @curPrevGrp
		exec	(@cmd)
		select	@prevPrevGrp = @curPrevGrp
		select	@curPrevGrp = ''
		select	@curPrevGrp = min(PrevMilestoneGroup)
		from	Milestone
		where	PrevMilestoneGroup > @prevPrevGrp
	end
	insert into	#trend
	select	distinct PrevMilestoneGroup, 0, null, period, MilestoneGroupOrder
	from	#milestonePeriod p
	where	period not in
			(select	period
			 from	#trend t
			 where	t.PrevMilestoneGroup = p.PrevMilestoneGroup)
	update	#trend
	set		#trend.displayName = p.displayName
	from	#milestonePeriod p
	where	#trend.period = p.period
	update	#trend
	set		MilestoneGroupOrder = m.MilestoneGroupOrder
	from	Milestone m
	where	#trend.PrevMilestoneGroup = m.PrevMilestoneGroup
--   MS: Added on AUG 21 2003 
	create table #trendNew
	(displayName varchar(30), Leads real, "Awaiting Submittal" real, "Awaiting Approval" real, "Awaiting Completion" real )
	insert into	#trendNew (displayName, Leads)
	select 	displayName,aveDays		
	from #trend 
	where #trend.PrevMilestoneGroup = 'Leads'
	order by	 #trend.MilestoneGroupOrder,  #trend.period desc	
	update	#trendNew
	set		#trendNew."Awaiting Submittal" = p.aveDays
	from	#trend p
	where	#trendNew.displayName= p.displayName and p.PrevMilestoneGroup = 'Awaiting Submittal'
	update	#trendNew
	set		#trendNew."Awaiting Approval" = p.aveDays
	from	#trend p
	where	#trendNew.displayName=p.displayName and p.PrevMilestoneGroup = 'Awaiting Approval'
	update	#trendNew
	set		#trendNew."Awaiting Completion" = p.aveDays
	from	#trend p
	where	#trendNew.displayName=p.displayName and p.PrevMilestoneGroup = 'Awaiting Completion'
	select	displayName, Leads, "Awaiting Submittal", "Awaiting Approval", "Awaiting Completion"
	from	#trendNew
-- 
-------------------------------------------------------

GO
