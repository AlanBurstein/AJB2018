SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [emdbuser].[FN_GetAclGroupUsers]
(
   @groupId INT
)
RETURNS TABLE
AS
return
   select UserID from AclGroupMembers
   where GroupID = @groupId	

GO
