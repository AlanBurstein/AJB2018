SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [emdbuser].[BorrowerLastCompletedLoans]
AS
	select BorrowerLoans.ContactGuid, Max(BorrowerLoans.LoanRefID) as LoanRefID, Max(LoanSummary.DateCompleted) as DateCompleted
	from BorrowerLoans 
	inner join LoanSummary on BorrowerLoans.LoanRefID = LoanSummary.XRefID 
	inner join 
		(select ContactGuid, Max(DateCompleted) DateCompleted from BorrowerLoans 
			inner join LoanSummary on BorrowerLoans.LoanRefID = LoanSummary.XRefID group by ContactGuid) MaxFileCompleted 
		on BorrowerLoans.ContactGuid = MaxFileCompleted.ContactGuid
	where LoanSummary.DateCompleted = MaxFileCompleted.DateCompleted	
	group by BorrowerLoans.ContactGuid

GO
