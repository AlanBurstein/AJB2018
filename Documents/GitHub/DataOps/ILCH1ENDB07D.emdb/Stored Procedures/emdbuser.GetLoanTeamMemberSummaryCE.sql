SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [emdbuser].[GetLoanTeamMemberSummaryCE]
	@loginUserid varchar(16),
	@snapshotUserid varchar(16),
	@outerRoleID int,
	@roleID int, 
	@milestoneID varchar(38),
	@timeFrame varchar(20),
	@folderList text = null
as
	declare	@orgId int,
			@from smalldatetime,
			@to	smalldatetime,
			@processingOrder int,
			@completedOrder int,
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
	--to convert the time frame
	exec	ConvertTimeFrame @timeFrame, @from out, @to out
	--to create LOs table
	-- Create a temp table with the loan folders
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	create table #tmp
	(userid varchar(16), folderName varchar(80))
	insert into #tmp
	select UF.userid, UF.folderName
	from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
	create table #filteredLoanSummary
	(guid varchar(38), LoanAmount varchar(20), CurrentMilestoneName varchar(30), LoanOfficerProfit varchar(20), LoanBrokerProfit varchar(20), DateCompleted smalldatetime, CurrentCoreMilestoneName varchar(38))
	create table #guid_order
	(guid varchar(38), "Order" int)
	create table #preTmp_cur
	(loanAssociate varchar(16), guid varchar(38), LoanAmount varchar(20))
	if @roleID = -2
	begin
	insert into #filteredLoanSummary
	select distinct s.guid, s.LoanAmount, s.CurrentMilestoneName, s.LoanOfficerProfit, s.LoanBrokerProfit, s.DateCompleted, s.CurrentCoreMilestoneName
	from #summaryData s inner join LoanAssociates LA on s.guid = LA.guid
	     inner join #tmp UF on LA.UserID = UF.userid
	where s.loanFolder = UF.folderName
	end
	else
	begin
	insert into #filteredLoanSummary
	select distinct s.guid, s.LoanAmount, s.CurrentMilestoneName, s.LoanOfficerProfit, s.LoanBrokerProfit, s.DateCompleted, s.CurrentCoreMilestoneName
	from #summaryData s inner join LoanAssociates LA on s.guid = LA.guid
	     inner join #tmp UF on LA.UserID = UF.userid
	where s.loanFolder = UF.folderName and LA.roleID = @roleID
	end
	select	LM.loanAssociate,
			0 'NumFiles',
			convert(money,LoanAmount) 'LoanAmount'
	into	#tmp_cur
	from	#summaryData s inner join LoanMilestones LM on s.Guid = LM.guid, 
			Milestone M
	where	1 = 2
	if @milestoneID != '-1' AND @milestoneID != '-2' AND @milestoneID != '-3'
	begin
		insert into #guid_order	
		select distinct s.Guid, max(LA."order")
		from	#filteredLoanSummary s inner join LoanAssociates LA on s.guid = LA.guid
			, Milestone m, CustomMilestones CM
		where	LA.RoleID = @roleID
			and LA.UserID <> ''
			and s.CurrentCoreMilestoneName = m.Milestone
			and ProcessGroup <> 'Completed'
			and ((convert(varchar, m.milestoneID) = @milestoneID and s.CurrentMilestoneName = m.milestone) or (CM.Guid = @milestoneID and CM."Name"=s.CurrentMilestoneName))
		group by s.Guid
		insert into #preTmp_cur
		select distinct LA.UserID, s.Guid, s.LoanAmount
		from	#filteredLoanSummary s inner join #guid_order GO on s.guid = GO.guid 
			inner join LoanAssociates LA on GO.guid = LA.guid
		where	LA.RoleID = @roleID and (((LA."Order" is not NULL) and (GO."Order" = LA."Order")) or ((LA."Order" is NULL) and (GO."Order" is NULL)))
		insert into	#tmp_cur
		select	loanAssociate, count(*) 'NumFiles',
		isnull(sum(convert(money,LoanAmount)),0) 'LoanAmount'
		from	#preTmp_cur
		group by loanAssociate
	end
	if @milestoneID = '-3'
	begin
		insert into #guid_order	
		select distinct s.Guid, max(LA."order")
		from	#filteredLoanSummary s inner join LoanAssociates LA on s.guid = LA.guid
			, Milestone m
		where	LA.RoleID = @roleID
			and LA.UserID <> ''
			and s.CurrentCoreMilestoneName = m.Milestone
		group by s.Guid
		insert into #preTmp_cur
		select distinct LA.UserID, s.Guid, s.LoanAmount
		from	#filteredLoanSummary s inner join #guid_order GO on s.guid = GO.guid 
			inner join LoanAssociates LA on GO.guid = LA.guid
		where	LA.RoleID = @roleID and (((LA."Order" is not NULL) and (GO."Order" = LA."Order")) or ((LA."Order" is NULL) and (GO."Order" is NULL)))
		insert into	#tmp_cur
		select	loanAssociate, count(*) 'NumFiles',
		isnull(sum(convert(money,LoanAmount)),0) 'LoanAmount'
		from	#preTmp_cur
		group by loanAssociate
	end
	if @milestoneID = '-2'
	begin
		insert into #guid_order	
		select distinct s.Guid, max(LA."order")
		from	#filteredLoanSummary s inner join LoanAssociates LA on s.guid = LA.guid
			, Milestone m
		where	LA.RoleID = @roleID
			and LA.UserID <> ''
			and s.CurrentCoreMilestoneName = m.Milestone
			and ProcessGroup <> 'Completed'
		group by s.Guid
		insert into #preTmp_cur
		select distinct LA.UserID, s.Guid, s.LoanAmount
		from	#filteredLoanSummary s inner join #guid_order GO on s.guid = GO.guid 
			inner join LoanAssociates LA on GO.guid = LA.guid
		where	LA.RoleID = @roleID and (((LA."Order" is not NULL) and (GO."Order" = LA."Order")) or ((LA."Order" is NULL) and (GO."Order" is NULL)))
		insert into	#tmp_cur
		select	loanAssociate, count(*) 'NumFiles',
		isnull(sum(convert(money,LoanAmount)),0) 'LoanAmount'
		from	#preTmp_cur
		group by loanAssociate
	end
	if @milestoneID = '-1'
	begin
		insert into #guid_order	
		select distinct s.Guid, max(LA."order")
		from	#filteredLoanSummary s inner join LoanAssociates LA on s.guid = LA.guid
			, Milestone m, MilestoneTemplate MT
		where	LA.RoleID = @roleID
			and LA.UserID <> ''
			and s.CurrentCoreMilestoneName = m.Milestone
			and s.CurrentCoreMilestoneName not in ('Started', 'Completion')
			and ProcessGroup <> 'Completed'
			and LA.MilestoneID = MT.MilestoneID
		group by s.Guid
		insert into #preTmp_cur
		select distinct LA.UserID, s.Guid, s.LoanAmount
		from	#filteredLoanSummary s inner join #guid_order GO on s.guid = GO.guid 
			inner join LoanAssociates LA on GO.guid = LA.guid
		where	LA.RoleID = @roleID and (((LA."Order" is not NULL) and (GO."Order" = LA."Order")) or ((LA."Order" is NULL) and (GO."Order" is NULL)))
		insert into	#tmp_cur
		select	loanAssociate, count(*) 'NumFiles',
		isnull(sum(convert(money,LoanAmount)),0) 'LoanAmount'
		from	#preTmp_cur
		group by loanAssociate
	end
	--to get completed ones
	select	distinct LM.guid, LM.loanAssociate, s.LoanAmount, s.LoanOfficerProfit, s.LoanBrokerProfit
	into #tmpCompleteLM	
	from	#summaryData s inner join LoanMilestones LM on s.Guid = LM.guid,
		Milestone m
	where	CurrentCoreMilestoneName = Milestone and ProcessGroup = 'Completed'
		and datediff(d,@from,DateCompleted) >= 0 
		and datediff(d,DateCompleted,@to) >= 0 
	select	loanAssociate,
			count(*) 'NumFiles',
			isnull(sum(convert(money,LoanAmount)),0) 'LoanAmount',
			isnull(sum(convert(money,LoanOfficerProfit)),0) 'LoanOfficerProfit',
			isnull(sum(convert(money,LoanBrokerProfit)),0) 'LoanBrokerProfit'
	into	#tmp_timeframe
	from	#tmpCompleteLM
	group by loanAssociate
	select	Distinct c.loanAssociate,
			c.NumFiles '# of Files',
			c.LoanAmount 'Amount',
			isnull(f.NumFiles,0) 'Files Completed',
			isnull(f.LoanAmount,0) 'Amount Completed',
			isnull(f.LoanOfficerProfit,0) 'LoanOfficerProfit',
			isnull(f.LoanBrokerProfit,0) 'LoanBrokerProfit'
	from	#tmp_cur c left outer join #tmp_timeframe f
		on c.loanAssociate = f.loanAssociate
	order by	c.loanAssociate

GO
