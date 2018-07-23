SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [emdbuser].[GetAllPipelineStatusCE]
	@loginUserid varchar(16),
	@folderList text = null,
	@snapshotUserid varchar(16),
	@roleID int
as
	declare	@orgId int,
		@LPRate real,
		@PSRate real,
		@SARate real,
		@ACRate real,
		@now smalldatetime,
		@cnt real,
		@amt money,
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
	create table #tmp
	(userid varchar(16), folderName varchar(80))
	insert into #tmp
	select UF.userid, UF.folderName
	from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
	-- Create a temp table with the loan folders
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	create table #selectedLoans
	(Guid varchar(38), LoanAmount varchar(20), CurrentCoreMilestoneName varchar(30))
	if @roleID = -2
	begin
		insert into #selectedLoans 
		select distinct s.Guid, LoanAmount, CurrentCoreMilestoneName 
		from #summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
		     inner join #tmp UF on LA.UserID = UF.userid
		where s.loanFolder = UF.folderName
	end
	else
	begin
	insert into #selectedLoans 
	select distinct s.Guid, LoanAmount, CurrentCoreMilestoneName 
	from #summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
	     inner join #tmp UF on LA.UserID = UF.userid
	where s.loanFolder = UF.folderName and LA.roleID = @roleID
	end
	create table #tmp_status
	(MilestoneGroup varchar(30), MilestoneGroupOrder tinyint, LoanAmount money, "Number of Files" int)
	insert into	#tmp_status
	select distinct	MilestoneGroup,
			null,
			isnull(sum(convert(money,LoanAmount)),0),
			count(*) 'Number of Files'
	from	#selectedLoans s inner join Milestone m on s.CurrentCoreMilestoneName = m.Milestone
	where	MilestoneGroup <> 'Completed'
	group by	MilestoneGroup
	update	#tmp_status
	set		MilestoneGroupOrder = m.MilestoneGroupOrder
	from	Milestone m
	where	#tmp_status.MilestoneGroup = m.MilestoneGroup
	insert into	#tmp_status
	select	distinct MilestoneGroup, MilestoneGroupOrder, 0, 0
	from	Milestone
	where	MilestoneGroup <> 'Completed'
			and MilestoneGroup not in
			(select	MilestoneGroup
			 from	#tmp_status)
	--to caluculate forecast
	select	@now = getdate()
	select	@LPRate = LPRate,
			@PSRate = PSRate,
			@SARate = SARate,
			@ACRate = ACRate
	from	FN_GetConversionRate(@now, @folderList)
	create table #closingRate
	(MilestoneGroup varchar(30), Rate real)
	insert into #closingRate
	values	('Leads', @LPRate * @PSRate * @SARate * @ACRate)
	insert into #closingRate
	values	('Awaiting Submittal', @PSRate * @SARate * @ACRate)
	insert into #closingRate
	values	('Awaiting Approval', @SARate * @ACRate)
	insert into #closingRate
	values	('Awaiting Completion', @ACRate)
	insert into	#tmp_status
	select	'temp',
			100,
			isnull(sum(convert(money, LoanAmount)),0) * min(r.Rate),
			count(*) * min(r.Rate)
	from	#selectedLoans s inner join 
			Milestone m on s.CurrentCoreMilestoneName = m.Milestone,
			#closingRate r
	where	m.MilestoneGroup <> 'Completed'
			and m.MilestoneGroup = r.MilestoneGroup
	group by	m.MilestoneGroup
	insert into	#tmp_status
	select	'Pipeline Forecast',
			100,
			isnull(sum(LoanAmount),0),
			isnull(sum("Number of Files"),0)
	from	#tmp_status
	where	MilestoneGroup = 'temp'
	delete	#tmp_status
	where	MilestoneGroup = 'temp'
	select	MilestoneGroup,
			LoanAmount,
			"Number of Files"
	from	#tmp_status
	order by	MilestoneGroupOrder

GO
