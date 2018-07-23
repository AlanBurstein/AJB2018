SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [emdbuser].[BizPartnerLastStartedLoans]
AS
	select BizPartnerLoans.ContactGuid, Max(BizPartnerLoans.LoanRefID) as LoanRefID, Max(LoanSummary.DateFileOpened) as DateFileOpened
	from BizPartnerLoans 
	inner join LoanSummary on BizPartnerLoans.LoanRefID = LoanSummary.XRefID 
	inner join 
		(select ContactGuid, Max(DateFileOpened) DateFileOpened from BizPartnerLoans 
			inner join LoanSummary on BizPartnerLoans.LoanRefID = LoanSummary.XRefID group by ContactGuid) MaxFileStarted 
		on BizPartnerLoans.ContactGuid = MaxFileStarted.ContactGuid
	where LoanSummary.DateFileOpened = MaxFileStarted.DateFileOpened
	group by BizPartnerLoans.ContactGuid

GO
