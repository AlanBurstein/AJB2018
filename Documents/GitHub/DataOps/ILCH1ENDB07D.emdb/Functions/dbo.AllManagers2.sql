SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[AllManagers2] (@empid varchar(20))							
	returns varchar(max)
AS
BEGIN
	declare @AllMgr varchar(max)
	
	SELECT @AllMgr = COALESCE(@AllMgr + ', ', '') + CAST(mgrlogin AS varchar(max))
	FROM  [chilhqpsql05].admin.corp.EmployeeAndAllManagers2  
	WHERE Empid = @empid  
				  
	return cast(@AllMgr AS varchar(max))
END
GO
