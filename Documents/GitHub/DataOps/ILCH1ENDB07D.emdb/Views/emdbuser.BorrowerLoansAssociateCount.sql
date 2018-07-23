SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- BorrowerLoansAssociateCount provides the count of the associated borrowers for each loan 
Create View [emdbuser].[BorrowerLoansAssociateCount]
as
	select loanRefId, Count(*) as AssociatedCount
	from BorrowerLoans
	Group by loanRefId

GO
