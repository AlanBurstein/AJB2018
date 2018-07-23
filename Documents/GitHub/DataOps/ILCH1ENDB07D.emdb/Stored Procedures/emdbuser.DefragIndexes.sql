SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [emdbuser].[DefragIndexes]
	@tableName sysname = null
AS
BEGIN
	set nocount on
	-- Generate the cursor to loop over all indexes
	declare idxcursor cursor fast_forward read_only for
		select so.id, so.name, si.indid, si.name from sysobjects so inner join sysindexes si on so.id = si.id
	 where OBJECTPROPERTY(so.id, N'IsUserTable') = 1 
		and si.keycnt > 0
		and si.first is not null
		and ((@tableName is NULL) or (@tableName = so.name))
	 order by so.name, si.indid
	declare @tblId int
	declare @tblName sysname
	declare @idxId int
	declare @idxName sysname
	open idxcursor
	fetch next from idxcursor into @tblId, @tblName, @idxId, @idxName
	while @@fetch_status = 0
	begin
		-- This IF statement ensures the table is in the current user's schema
		if exists (select 1 from sysobjects where id = object_id(@tblName))
		begin
			-- Defrag the index
			print 'Defragmenting ' + @tblName + '.' + @idxName
			dbcc indexdefrag (0, @tblId, @idxId)
		end
		-- Move to the next index
		fetch next from idxcursor into @tblId, @tblName, @idxId, @idxName
	end
	close idxcursor
	deallocate idxcursor
END

GO
