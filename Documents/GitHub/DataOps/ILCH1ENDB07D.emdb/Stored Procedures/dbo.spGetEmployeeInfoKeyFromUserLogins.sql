SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spGetEmployeeInfoKeyFromUserLogins]
@UserLogin varchar(max)
AS
BEGIN
	--***********************************************************
	-- CREATED BY: RCorro
	-- CREATED DATE: 03/23/2015
	-- PURPOSE: Get EmployeeInfoKeys for comma delimited list of UserLogins
	-- Modification: Name			Date		Change
	--***********************************************************
	SELECT EmployeeInfoKey 
	FROM loanwarehouse.dbo.dimEmployeeInfo 
	WHERE UserLogin IN (SELECT SPLITVALUES FROM dbo.DelimitedListToVarcharTableVariable(@UserLogin, ','))
END
GO
