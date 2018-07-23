SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--
--	Create View
--
CREATE VIEW [emdbuser].[vwLoanSummaryDAT_4848]
WITH SCHEMABINDING AS
select
guid as LoanGuid,
XRefID,
LoanNumber
from emdbuser.LoanSummaryDAT_4848
where isFalseLoan = 0
GO
CREATE UNIQUE CLUSTERED INDEX [IDXUC_vwLoanSummaryDAT_4848] ON [emdbuser].[vwLoanSummaryDAT_4848] ([LoanGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
