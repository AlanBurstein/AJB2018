SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Hawley
-- Create date: 2012-10-17
-- Description:	Minimum data about customers since 2011
-- =============================================
CREATE PROCEDURE [reports].[RecentCustomers]
AS
select
	_36 as BorrFirstName,
	_37 as BorrLastName,
	_12 as PropCity,
	_14 as PropState,
	convert(bigint, _2) as LoanAmount,
	convert(date, _748) as ClosedDate,
	convert(date, _CX_FUNDDATE_1) as FundedDate
from emdbuser.LOANXDB_S_01 s1
join emdbuser.LOANXDB_S_02 s2 on s1.XrefId = s2.XrefId
join emdbuser.LOANXDB_N_02 n2 on s1.XrefId = n2.XrefId
join emdbuser.LOANXDB_D_01 d1 on s1.XrefId = d1.XrefId
join emdbuser.LOANXDB_S_04 s4 on s1.XRefID = s4.XrefId
where _LOANFOLDER not in ('(Trash)', 'Samples', 'Adverse Loans')
	and _CX_FUNDDATE_1 between '2011-01-01' and getdate()
GO
