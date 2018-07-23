SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [emdbuser].[SetUserAccessToFeature]
	@userId varchar(16),
	@featureId int,
	@access tinyint
AS
BEGIN
	-- Check the user's access based on the personas
	declare @groupAccess tinyint
	select @groupAccess = max(access) 
	from Acl_Features aclf
		inner join UserPersona usp on aclf.personaID = usp.personaID
	where aclf.featureID = @featureId 
		and usp.UserID = @userId
	-- Insert a record into the user access table, but only if one doesn't already exist
	if (@groupAccess <> @access) and 
		not exists (select * from Acl_Features_User where featureID = @featureId and userID = @userId)
		insert into Acl_Features_User (userID, featureID, access) values (@userId, @featureID, @access)
END

GO
