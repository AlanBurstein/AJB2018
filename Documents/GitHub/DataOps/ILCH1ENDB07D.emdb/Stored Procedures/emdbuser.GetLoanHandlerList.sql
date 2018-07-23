SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [emdbuser].[GetLoanHandlerList]
	@userId varchar(16),
	@persona varchar(16)
as
	declare	@orgId int,
			@lastName varchar(64),
			@firstName varchar(64),
			@intPersona int,
			@excludeCurrentLevel bit
	set nocount on
	select	@orgId = org_id,
		@lastName = last_name,
		@firstName = first_name,
		@intPersona = persona,
		@excludeCurrentLevel = (case when (persona & 8) = 8 then 0 else 1 end)
	from	users
	where	userid= @userId
	select	userid,
			last_name,
			first_name,
			persona
	into	#tmp
	from	users
	where	1 = 2
	insert into	#tmp
	select	*
	from	FN_GetLoanHandlerAndGroupWithSelf(@orgId, @persona, @excludeCurrentLevel, @userId)
	select	*
	from	#tmp
	order by	userid

GO
