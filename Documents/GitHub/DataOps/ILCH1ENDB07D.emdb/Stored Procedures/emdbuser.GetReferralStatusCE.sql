SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [emdbuser].[GetReferralStatusCE]
	@loginUserid varchar(16),
	@snapshotUserid varchar(16),
	@roleID int,
	@timeFrame varchar(20),
	@folderList text = null
as
	declare	@from smalldatetime,
		@to	smalldatetime,
		@cnt tinyint,
		@orgId int,
		@excludeCurrentLevel bit
	set nocount on
	--to convert the time frame
	exec	ConvertTimeFrame @timeFrame, @from out, @to out
	create table #referral
	(ReferralSource varchar(100), RefSrc varchar(100), abbrev varchar(3), numFiles int)
	create table #tmp_referral
	(ReferralSource varchar(100), Guid varchar(100))
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
	-- Create a temp table with the loan summary data
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	if @snapshotUserid is null
	begin
		--for all loan handlers underneath the login user
		insert into #users
		select UF.userid, UF.folderName
		from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
		insert into #tmp_referral
		select distinct ReferralSource, s.Guid
		from	#summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
			inner join #users u on LA.UserID = u.userid
		where	s.loanFolder = u.folderName
			and datediff(d,@from,DateFileOpened) >= 0
			and datediff(d,DateFileOpened,@to) >= 0
			and rtrim(isnull(ReferralSource,'')) <> ''
		group by	ReferralSource, s.Guid
	end
	else
	begin
		insert into #users
		select UF.userid, UF.folderName
		from FN_GetFilteredUserFolderList(@orgId, @excludeCurrentLevel, @loginUserid, @snapshotUserid) UF
		insert into #tmp_referral
		select distinct ReferralSource, s.Guid
		from	#summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
			inner join #users u on LA.UserID = u.userid
		where	s.loanFolder = u.folderName
			and LA.roleID = @roleId
			and datediff(d,@from,DateFileOpened) >= 0
			and datediff(d,DateFileOpened,@to) >= 0
			and rtrim(isnull(ReferralSource,'')) <> ''
		group by	ReferralSource, s.Guid
	end
	insert into #referral
	select distinct top 10 ReferralSource,
		ReferralSource,
		null,
		count(*) 'NumFiles'
	from	#tmp_referral
	group by	ReferralSource
	order by	count(*) desc
	--to get abbreviations
	set	@cnt = 0
	update	#referral
	set		abbrev = substring(ReferralSource,1,1)
	while(@cnt < 2)
	begin
		--to get to the next word
		update	#referral
		set		ReferralSource = ltrim(substring(ReferralSource,isnull(nullif(charindex(' ',ReferralSource),0),31),30))
		update	#referral
		set		abbrev = abbrev + substring(ReferralSource,1,1)
		set	@cnt = @cnt + 1
	end
	select	 abbrev 'abbrevRefSrc',RefSrc,
			numFiles
	from	#referral

GO
