SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--
--	Create View
--
CREATE VIEW [emdbuser].[vwLoanSummary]
WITH SCHEMABINDING AS
select
guid as LoanGuid,
LoanNumber,
XRefID
from emdbuser.LoanSummary
where isFalseLoan = 0
GO
CREATE UNIQUE CLUSTERED INDEX [IDXUC_vwLoanSummary] ON [emdbuser].[vwLoanSummary] ([LoanGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
