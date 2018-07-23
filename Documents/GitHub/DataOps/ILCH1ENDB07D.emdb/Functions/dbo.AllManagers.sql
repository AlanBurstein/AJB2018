SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	CREATE       function [dbo].[AllManagers] (@empid varchar(20))
							
				returns varchar(255)
				as
				begin
				 declare @AllMgr varchar(255)
				 SELECT @AllMgr = COALESCE(@AllMgr + ', ', '') +
				   CAST(mgrlogin AS varchar)
				   FROM  [chilhqpsql05].admin.corp.EmployeeAndManager_rawdata 
				   WHERE empid = @empid  
				  
			 
				 return (@AllMgr)
				end
GO
