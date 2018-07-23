SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- UserLoanAccessRights provides a view of who has rights to individual loans based on loan team membership
-- and the user's directly assigned rights
create view [emdbuser].[UserLoanAccessRights]
as
	select Guid, UserID, Max(rights) as rights
	from
	(
		-- All loan associates automatically have read/write access (value = 1)
		select Guid, UserID, 1 as rights from LoanAssociateUsers
		union
		-- Merge in the rights from the loan_rights table
		select Guid, UserID, rights from loan_rights
	) rights_tbl
	group by Guid, UserID	

GO
