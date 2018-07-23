SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [emdbuser].[SetGroupAccessToFolderResource]
	@groupId varchar(50),
	@filePath varchar(2048),
	@fileType int,
	@access tinyint
AS
BEGIN
	-- Get the file resource if it exists
	declare @fileId int
	select @fileId = FileID from FileResource 
	where FilePath = @filePath
		and FileType = @fileType
		and IsFolder = 1
		and IsNull(Owner, '') = ''
	-- If no matching record was found, create a new record
	if (@fileId is NULL)
	begin
		insert into FileResource (FilePath, FileType, IsFolder, Owner) 
			values (@filePath, @fileType, 1, '')
		select @fileId = @@identity
	end
	-- Assign the resource to the group
	if not exists (select * from AclGroupFileRef where GroupID = @groupID and FileID = @fileId)
	begin
		insert into AclGroupFileRef (GroupID, FileID, Inclusive, Access)
			values (@groupId, @fileId, 1, @access)
	end
END

GO
