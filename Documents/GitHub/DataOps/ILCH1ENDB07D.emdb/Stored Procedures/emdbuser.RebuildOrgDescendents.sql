SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [emdbuser].[RebuildOrgDescendents]
as
	-- Rebuild the org_chart's depth values to ensure they're up-to-date
	update org_chart set depth = -1
	-- Start by setting the top-level org to depth 0
	update org_chart set depth = 0 where parent = oid
	-- Set up the depth column for all records in the table
	declare @depth int
	select @depth = 0
	while exists (select 1 from org_chart where depth = @depth)
	begin
		update org_chart set depth = @depth + 1 where parent in (select oid from org_chart where depth = @depth) and parent <> oid
		select @depth = @depth + 1
	end
	-- Clear the existing depenencies
	delete from org_descendents
	-- Get the maximum depth of the items in the org_chart
	select @depth = max(depth) - 1 from org_chart
	while @depth >= 0
	begin
		-- First add the immediate children of the orgs at the current depth
		insert into org_descendents select oc.parent, oc.oid from org_chart oc where oc.depth = @depth + 1
		-- Add the records for the children's descendents
		insert into org_descendents 
			select oc.oid, dep.descendent from org_chart oc, org_descendents dep, org_chart op 
			where dep.oid = op.oid
			      and op.parent = oc.oid
			      and op.parent <> dep.oid
			      and oc.depth = @depth
		-- Decrement the depth to move up the table
		set @depth = @depth - 1
	end

GO
