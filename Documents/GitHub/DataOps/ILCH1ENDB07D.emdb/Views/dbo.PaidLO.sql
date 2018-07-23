SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[PaidLO] as 
select
  ls.XrefId,
  _364 as LoanNumber,
 
  case 
	when isnull(_CX_PAIDLOCODE_3,'') <> ''  then _CX_PAIDLOCODE_3
	when  isnull(_CX_FINALOCODE_4,'') <> '' then _CX_FINALOCODE_4
	else _CX_LOCODE_1
  end  as PaidLOCode

  from
emdb.emdbuser.Loansummary ls
--inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
inner join emdb.emdbuser.LOANXDB_s_10 ls10 on ls.XrefId = ls10.XrefId




GO
