SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[lockdate]
as

select
    ls.xrefid,
	ls.loannumber,
	CASE WHEN _CX_SECORIGLOCK_16 < _2149 then _CX_SECORIGLOCK_16 else _2149 end as origlockdate,
	_CX_SECORIGLOCK_16,
	_2149,
	_761
from 
emdb.emdbuser.loansummary ls
inner join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
inner join emdb.emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId 

GO
