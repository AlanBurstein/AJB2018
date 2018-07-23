SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [emdbuser].[GetOrgChart_SettingsSyncSql](
	@filter nvarchar(4000),
	@delimiter char(1)
)
AS
BEGIN
	declare @delimitedList varchar(1000)
	declare @offset int
	declare @delimiterIndex int
	declare @nextItem varchar(256)
	select @offset = 1
	declare @rawSql nvarchar(4000)
	if not exists (select * from sysobjects where id = object_id(N'[orgchart_tempTable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	create table orgchart_tempTable
	(
		orgPath varchar(1000)
	)
	End
	else
	begin
		delete orgchart_tempTable
	end
	declare @itemList table
	(
		orgPath varchar(1000)
	)
	set @rawSql = 'Select distinct orgPath from (' + @filter + ') as table1'
	insert into orgchart_tempTable
	execute sp_executeSql @rawSql
	declare orgPathCursor cursor for
		select orgPath from orgchart_tempTable order by orgPath
	open orgPathCursor
	fetch next from orgPathCursor into @delimitedList
	while @@fetch_status = 0
	begin
	declare @currentPath varchar(1000)
	set @currentPath = ''
	--Loop over the delimited text until you reach the end
	while @offset <= datalength(@delimitedList)
	begin
		select @delimiterIndex = charindex(@delimiter, @delimitedList, @offset)
		if (@delimiterIndex = 0)
		begin
			-- No more delimiters found, so take the rest of the text
			select @nextItem = substring(@delimitedList, @offset, datalength(@delimitedList) - @offset + 1)
			select @offset = datalength(@delimitedList) + 1
		end
		else
		begin
			-- Take the text up to the next delimiter
			select @nextItem = substring(@delimitedList, @offset, @delimiterIndex - @offset)
			select @offset = @delimiterIndex + 1
		end
		select @nextItem = ltrim(rtrim(@nextItem))
		if @currentPath = ''
		begin
			set @currentPath = @nextItem
		end
		else
		begin
			set @currentPath = @currentPath + @delimiter + @nextItem
		end
		-- Only add it if non-empty
		if not exists (select * from @itemList where orgPath = @currentPath)
		begin
			insert into @itemList values (@currentPath)
		end
	end
	set @offset =1 
	fetch next from orgPathCursor into @delimitedList
	end
	close orgPathCursor
	deallocate orgPathCursor
	drop table orgchart_tempTable
	select * from org_chart where orgPath in (select distinct orgPath from @itemList) order by orgPath
END

GO
