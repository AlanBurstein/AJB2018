SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- UserAccessibleLoans provides a view of who has access rights (or better) rights to individual loans 
-- based on loan team membership and the user's directly assigned rights
create view [emdbuser].[UserAccessibleLoans]
as
	-- All loan associates automatically have read/write access (value = 1)
	select Guid, UserID from LoanAssociateUsers
	union
	-- Merge in the rights from the loan_rights table
	select Guid, UserID from loan_rights

GO
