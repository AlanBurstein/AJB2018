SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [reports].[spGetCostCenterInfo]

	@DivisionName varchar( 100 )

as

/*

----------------------------------------------------------------------------------------------------------------------------------
	who	when		what
----------------------------------------------------------------------------------------------------------------------------------
	sethm	01/15/13	initial rev of proc


*/

begin

	set nocount on
	set transaction isolation level read uncommitted

	declare @ExcludeBranch table ( 	
		CostCenter int not null 
	)
	
	-- determine what to be excluding
	if @DivisionName = 'Online'
	begin
		insert	@ExcludeBranch ( CostCenter )
		select	CostCenter
		from	admin.corp.CostCenter
		where	Active = 1 and
			CostCenter <> 3003
	end
	else if @DivisionName = 'Direct'
	begin
		insert	@ExcludeBranch ( CostCenter )
		select	CostCenter
		from	admin.corp.CostCenter
		where	Active = 1 and
			CostCenterName not like '%direct%'
	end
	else if @DivisionName = 'Retail'
	begin
		insert	@ExcludeBranch ( CostCenter )
		select	CostCenter
		from	admin.corp.CostCenter
		where	Active = 1 and
			( CostCenterName like '%direct%' or CostCenter = 3003 )
	end
	
	-- return results
	select	0 as SortOrder, 0 as Branch, 'All' as CostCenterName

	union

	select	1 as SortOrder, CostCenter as Branch, CostCenterName
	from	admin.corp.costcenter
	where	Active = 1 and
		CostCenter not in (
			1109,	--4621 Retail
			9004,	--Administrative & General
			9007,   --Business Development
			8002,	--Closing
			2001,	--Direct
			2111,	--Direct - Scott Holmberg Pod
			2112,	--Direct - Tammy Holmberg Pod
			2010,	--Direct Administration
			9001,	--Executive Management
			9010,	--Facilities
			9002,	--Finance & Accounting
			9009,	--GRI Café
			9008,   --Human Resources 
			9999,	--Guaranteed Rate Insurance
			9006,	--Information Technology
			9011,	--Legal Services
			9003,	--Marketing
			1116,	--Newport Beach, CA
			9012,	--Operations Administration
			8003,	--Post-Closing
			9800,	--Ravenswood Title
			9005,	--Recruiting
			3002,	--Relocation
			7001,	--Secondary Marketing
			6001,	--Servicing
			9014,	--Software Development
			9015,	--Software Product Development
			8001,	--Underwriting
			9013	--Warehouse Funding
		)
		and CostCenter not in ( select CostCenter from @ExcludeBranch )
	order	by 1, CostCenterName

end
GO
