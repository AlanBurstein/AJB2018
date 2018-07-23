SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [emdbuser].[RebuildUserLoans]
as
BEGIN
	-- Delete the old records for the loan
	delete from UserLoans 
	-- Create the new UserLoan records
	insert into UserLoans
		-- Get the loan associates referenced by User ID
		select la.UserID, xref.XRefID, la.AssociateGuid
		from LoanAssociates la
			inner join LoanXRef xref on la.Guid = xref.LoanGuid
		where la.UserID is not null
		union
		-- Get the loan associates references by Group ID
		select agm.UserID, xref.XRefID, la.AssociateGuid
		from LoanAssociates la
			inner join AclGroupMembers agm on agm.GroupID = la.GroupID
			inner join LoanXRef xref on la.Guid = xref.LoanGuid
		union
		-- Get the loan_rights
		select lr.userid, xref.XRefID, NULL
		from loan_rights lr
			inner join LoanXRef xref on lr.Guid = xref.LoanGuid
END

GO
