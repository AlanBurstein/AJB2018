SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [emdbuser].[BorrowerLastStartedLoans]
AS
	select BorrowerLoans.ContactGuid, Max(BorrowerLoans.LoanRefID) as LoanRefID, Max(LoanSummary.DateFileOpened) as DateFileOpened
	from BorrowerLoans 
	inner join LoanSummary on BorrowerLoans.LoanRefID = LoanSummary.XRefID 
	inner join 
		(select ContactGuid, Max(DateFileOpened) DateFileOpened from BorrowerLoans 
			inner join LoanSummary on BorrowerLoans.LoanRefID = LoanSummary.XRefID group by ContactGuid) MaxFileStarted 
		on BorrowerLoans.ContactGuid = MaxFileStarted.ContactGuid
	where LoanSummary.DateFileOpened = MaxFileStarted.DateFileOpened
	group by BorrowerLoans.ContactGuid

GO
