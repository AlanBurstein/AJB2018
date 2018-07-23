SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 procedure [emdbuser].[GetCommissionStatusCE]
	@loginUserid varchar(16),
	@snapshotUserid varchar(16),
	@timeFrame varchar(20),
	@roleID int,
	@stage varchar(30),
	@folderList text = null
as
	declare	@from smalldatetime,
		@to	smalldatetime,
		@orgId int,
		@cmd varchar(1200),
		@whereClause varchar(1200),
		@excludeCurrentLevel bit
	set nocount on
	--to convert the time frame
	exec	ConvertTimeFrame @timeFrame, @from out, @to out
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
	select * into #summaryData from FN_GetLoanSummary(@folderList)
	create table #tmp_LM (Guid varchar(38))
	select @cmd = 'insert into #tmp_LM
		select distinct s.Guid
		from #summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
		     inner join #users u on LA.UserID = u.userid
		where ' + @whereClause
	exec (@cmd)
	if @stage = 'Completion'
	begin
		select distinct isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'') 'Borrower', 
				isnull(nullif(rtrim(LoanAmount),''),0) 'Loan Amount',
				isnull(nullif(rtrim(LOCommissionByLoan),''),0) '% of Loan',
				isnull(nullif(rtrim(LOCommissionByProfit),''),0) '% of Profit',
				isnull(nullif(rtrim(LOAdditionalCommission),''),0) 'Additional $',
				isnull(nullif(rtrim(LoanOfficerProfit),''),0) 'Commission',
				convert(varchar,DateCompleted,101) 'Completion Date'
		from	#summaryData s, #tmp_LM LM
		where	CurrentCoreMilestoneName = @stage
				and s.Guid = LM.Guid
				and datediff(d,@from, DateCompleted) >= 0
				and datediff(d,DateCompleted, @to) >= 0
		order by	isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'')
	end
	else if @stage = 'Funding'
	begin
		select distinct	isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'') 'Borrower', 
				isnull(nullif(rtrim(LoanAmount),''),0) 'Loan Amount',
				isnull(nullif(rtrim(LOCommissionByLoan),''),0) '% of Loan',
				isnull(nullif(rtrim(LOCommissionByProfit),''),0) '% of Profit',
				isnull(nullif(rtrim(LOAdditionalCommission),''),0) 'Additional $',
				isnull(nullif(rtrim(LoanOfficerProfit),''),0) 'Commission',
				isnull(convert(varchar,DateOfEstimatedCompletion,101),'') 'Completion Date'
		from	#summaryData s inner join #tmp_LM LM on s.Guid = LM.Guid
		where	CurrentCoreMilestoneName in ('Funding','Completion')
				and datediff(d,@from, DateFunded) >= 0
				and datediff(d,DateFunded, @to) >= 0
		order by	isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'')
	end
	else if @stage = 'Docs Signing'
	begin
		select distinct	isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'') 'Borrower', 
				isnull(nullif(rtrim(LoanAmount),''),0) 'Loan Amount',
				isnull(nullif(rtrim(LOCommissionByLoan),''),0) '% of Loan',
				isnull(nullif(rtrim(LOCommissionByProfit),''),0) '% of Profit',
				isnull(nullif(rtrim(LOAdditionalCommission),''),0) 'Additional $',
				isnull(nullif(rtrim(LoanOfficerProfit),''),0) 'Commission',
				isnull(convert(varchar,DateOfEstimatedCompletion,101),'') 'Completion Date'
		from	#summaryData s inner join #tmp_LM LM on s.Guid = LM.Guid
		where	CurrentCoreMilestoneName in ('Docs Signing','Funding','Completion')
				and datediff(d,@from, DateDocsSigned) >= 0
				and datediff(d,DateDocsSigned, @to) >= 0
		order by	isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'')
	end
	else if @stage = 'Approval'
	begin
		select distinct	isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'') 'Borrower', 
				isnull(nullif(rtrim(LoanAmount),''),0) 'Loan Amount',
				isnull(nullif(rtrim(LOCommissionByLoan),''),0) '% of Loan',
				isnull(nullif(rtrim(LOCommissionByProfit),''),0) '% of Profit',
				isnull(nullif(rtrim(LOAdditionalCommission),''),0) 'Additional $',
				isnull(nullif(rtrim(LoanOfficerProfit),''),0) 'Commission',
				isnull(convert(varchar,DateOfEstimatedCompletion,101),'') 'Completion Date'
		from	#summaryData s inner join #tmp_LM LM on s.Guid = LM.Guid
		where	CurrentCoreMilestoneName in ('Approval','Docs Signing','Funding','Completion')
				and datediff(d,@from, DateApprovalReceived) >= 0
				and datediff(d,DateApprovalReceived, @to) >= 0
		order by	isnull(BorrowerFirstName,'') + isnull(' ' + BorrowerLastName,'')
	end

GO
