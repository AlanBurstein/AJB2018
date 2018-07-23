SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [emdbuser].[BizPartnerLastCompletedLoans]
AS
	select BizPartnerLoans.ContactGuid, Max(BizPartnerLoans.LoanRefID) as LoanRefID, Max(LoanSummary.DateCompleted) as DateCompleted
	from BizPartnerLoans 
	inner join LoanSummary on BizPartnerLoans.LoanRefID = LoanSummary.XRefID 
	inner join 
		(select ContactGuid, Max(DateCompleted) DateCompleted from BizPartnerLoans inner join LoanSummary on BizPartnerLoans.LoanRefID = LoanSummary.XRefID group by ContactGuid) MaxFileCompleted 
		on BizPartnerLoans.ContactGuid = MaxFileCompleted.ContactGuid
	where LoanSummary.DateCompleted = MaxFileCompleted.DateCompleted	
	group by BizPartnerLoans.ContactGuid

GO
