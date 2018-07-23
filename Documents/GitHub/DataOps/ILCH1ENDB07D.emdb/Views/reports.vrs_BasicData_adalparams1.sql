SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [reports].[vrs_BasicData_adalparams1]
AS
--------------------------------------------------------------------------------
--
--  Developer:	 Andreas Zimmermann
--  Date:		 03/21/2012
--  Purpose:	 View For Remote Query 
--			 CHILHQSQLDB, ReportUser, Warehouse, emdb, 
--			 reports.rs_BasicData_adalparams1
--
--------------------------------------------------------------------------------
Select 	  ls.XrefID,
		  ld01._CX_FUNDDATE_1,
		  ld01._761,
		  ld01._748,
		  ln02._2,
		  ls01._19,
		  ls02._364,
		  ls03._CX_FINALOCODE_4,
		  ls05._4002,
		  ls05._CX_FINALLONAME,
		  ls10._1172,
		  ld01._2149,
		  case when _2149 is not null then 1 else 0 end as IsLocked,
		  case when _CX_FUNDDATE_1 is not null then 1 else 0 end as IsFunded,
		  case when _748 is not null and _748 <= getdate() then 1 else 0 end as IsClosed,
		  case when _19 = 'Purchase' and _2149 is null and _CX_PREAPPROVORDER_1 is not null and _CX_FUNDDATE_1 is null and _MS_STATUS in ( 'Started', 'File started' ) then 1 else 0 end as IsPrequalifiedLoan,
		  case when _19 = 'Purchase' then 1 else 0 end as IsPurchaseLoan,
		  case when _19 like '%refi%' then 1 else 0 end as IsRefinanceLoan,
		  case when _CX_JUMBO = 'Yes' then 1 else 0 end as IsJumboLoan,
		  case when _CX_SMARTTAX = 'CEMA' then 1 else 0 end as IsCEMALoan,
		  case when isnull( _CX_LPR_NEW_CON, 'N' ) = 'Y' then 1 else 0 end as IsNewConstructionLoan,
		  case when isnull( _CX_LPR_SHORT_SALE, 'N') = 'Y' then 1 else 0 end as IsShortSaleLoan,
		  case when _CX_APPRAISALREQ = 'No' then 0 else 1 end as IsAppraisalRequired,
		  0 as IsBrokeredLoan,
		  1 as IsUnderwrittenInHouse
from		  emdbuser.Loansummary ls
inner join  emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
inner join  emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
inner join  emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
inner join  emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
inner join  emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
inner join  emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
inner join  emdbuser.LOANXDB_s_10 ls10 on ls.XrefId = ls10.XrefId
inner join  emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId
inner join  emdbuser.LOANXDB_S_20 ls20 on ls.XrefId = ls20.XrefId
inner join  emdbuser.LOANXDB_S_26 ls26 on ls.XrefId = ls26.XrefId
where 	  ls.loanFolder not in ('(Archive)','(Trash)', 'Samples', 'GriOnline - Testing')

GO
