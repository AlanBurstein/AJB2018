SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [emdbuser].[FN_GetOrgPath]
(
	@orgId int
)  
returns varchar(1000)
as
begin
	declare @parentID int
	declare @finalPath varchar(1000)
	declare @rootName varchar(32)
	declare @orgName varchar(32)
	declare @parentName varchar(32)
	select @parentID = parent, @orgName = org_name from "org_chart" where oid = @orgId
	select @rootName = 'root'
	if(@orgId <= 0)
	begin
		return @rootName
	end
	else
	begin
		set @finalPath = @orgName
		while(@parentID > 0)
		begin
			if not exists(select * from "org_chart" where oid = @parentID )
			begin
				return ''
			end
			select @parentName = org_name, @parentID = parent from "org_chart" where oid = @parentID
			set @finalPath = @parentName + '\' + @finalPath
		end;
		set @finalPath = @rootName + '\' + @finalPath 
		return @finalPath
	end
	return ''
end

GO
