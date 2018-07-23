SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE              procedure [emdbuser].[GetLoanTypeTrendCE]
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
	SELECT @excludeCurrentLevel = access 
	FROM Acl_Features_User
	WHERE userid = @loginUserid and featureID = 913
	if @excludeCurrentLevel is null
	begin
	SELECT @excludeCurrentLevel = access 
	FROM UserPersona UP inner join Acl_Features AF on AF.personaID = UP.personaID
	WHERE userid = @loginUserid and featureID = 913 and access = 1
	end
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
	--to generate typePeriod table
	select	distinct LoanType,
			period,
			displayName
	into	#typePeriod
	from	LoanType m,
			#period p
	create table #trend
	(LoanType varchar(30), numFiles int, loanAmount money, displayName varchar(10), 
	 period tinyint)
	create table #tmp_trend
	(Guid varchar(38), LoanType varchar(30), loanAmount varchar(20), DateCompleted smalldatetime)
	-- Create a temp table with the loan folders
	select * into #summaryData from FN_GetLoanSummary(@folderList)	
	if @periodUnit = 'week'
		select	@period = 'wk'
	else if @periodUnit = 'month'
		select	@period = 'mm'
	else if @periodUnit = 'quarter'
		select	@period = 'q'
	select	@cmd = 'insert into #tmp_trend
	select distinct s.Guid, LoanType, loanAmount, DateCompleted
	from	#summaryData s inner join LoanAssociates LA on s.Guid = LA.guid
	        inner join #users u on LA.UserID = u.userid
	where ' + @whereClause
	exec(@cmd)
	select	@cmd = 'insert into	#trend
		select	LoanType,
				count(*),
				sum(convert(money,loanAmount)),
				null,
				datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) + ''')
		from	#tmp_trend
		where	datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) + ''') >= 1
				and datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) 
				+ ''') <= ''' + convert(varchar,@periodLength) + '''' + 
		' group by	LoanType, datediff(' + @period + ',DateCompleted,''' + convert(varchar,@now) + ''')'
	exec	(@cmd)
	insert into	#trend
	select	distinct LoanType, 0, 0, null, period
	from	#typePeriod p
	where	period not in
			(select	period
			 from	#trend t
			 where	t.LoanType = p.LoanType)
	update	#trend
	set		#trend.displayName = p.displayName
	from	#typePeriod p
	where	#trend.period = p.period
---select	LoanType,
--		numFiles,
--		loanAmount,
---		displayName
--from	#trend
--order by	LoanType, period desc	
------------------------------------------------------
--   MS: Added on AUG 21 2003 
	create table #trendNew
	(displayName varchar(30), "Conventional" real, "FHA" real, "USDA-RHS" real,"Other" real, "VA" real )
	if @forLoanAmount = 1
	 begin
		insert into	#trendNew (displayName, Conventional)
		select 	displayName,loanAmount		
		from #trend 
		where #trend.LoanType = 'Conventional'
		order by	 #trend.LoanType,  #trend.period desc	
		update	#trendNew
		set		#trendNew."FHA" = p.loanAmount
		from	#trend p
		where	#trendNew.displayName= p.displayName and p.LoanType = 'FHA'
		update	#trendNew
		set		#trendNew."USDA-RHS" = p.loanAmount
		from	#trend p
		where	#trendNew.displayName=p.displayName and p.LoanType = 'USDA-RHS'
		--update	#trendNew
		--set		#trendNew.[HELOC] = p.loanAmount
		--from	#trend p
		--where	#trendNew.displayName=p.displayName and p.LoanType = 'HELOC'
		update	#trendNew
		set		#trendNew."Other" = p.loanAmount
		from	#trend p
		where	#trendNew.displayName=p.displayName and p.LoanType = 'Other'
		update	#trendNew
		set		#trendNew."VA" = p.loanAmount
		from	#trend p
		where	#trendNew.displayName=p.displayName and p.LoanType = 'VA'
	 end 
	else
	 begin
		insert into	#trendNew (displayName, Conventional)
		select 	displayName,numFiles		
		from #trend 
		where #trend.LoanType = 'Conventional'
		order by	 #trend.LoanType,  #trend.period desc	
		update	#trendNew
		set		#trendNew."FHA" = p.numFiles
		from	#trend p
		where	#trendNew.displayName= p.displayName and p.LoanType = 'FHA'
		update	#trendNew
		set		#trendNew."USDA-RHS" = p.numFiles
		from	#trend p
		where	#trendNew.displayName=p.displayName and p.LoanType = 'USDA-RHS'
		--update	#trendNew
		---set		#trendNew.[HELOC] = p.numFiles
		--from	#trend p
		--where	#trendNew.displayName=p.displayName and p.LoanType = 'HELOC'
		update	#trendNew
		set		#trendNew."Other" = p.numFiles
		from	#trend p
		where	#trendNew.displayName=p.displayName and p.LoanType = 'Other'
		update	#trendNew
		set		#trendNew."VA" = p.numFiles
		from	#trend p
		where	#trendNew.displayName=p.displayName and p.LoanType = 'VA'		
	end
	select	displayName, "Conventional", "FHA", "USDA-RHS", "Other", "VA"
	from	#trendNew
-- 
-------------------------------------------------------

GO
