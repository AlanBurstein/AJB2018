SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[MissingCOSTCTR] as 
select

ls.loannumber,
ls03._CX_FINALOCODE_4,
_CX_PAIDLOCODE_3,
ls10._cx_locode_1,
_cx_locstcntr,

ls.LoanOfficerId,
_745,

log_ms_lastcompleted,
ae.encompasslogin,
ae.displayname,
--LoanTeamMember_UserID_LoanCoordinator,
--LoanTeamMember_UserID_MortgageConsultant
costcenter,
costcentername


from emdbuser.loansummary ls
	inner join emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
	inner join emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
	inner join emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
	inner join emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
	inner join emdb.emdbuser.LOANXDB_S_08 ls08 on ls.XrefId = ls08.XrefId
	inner join emdb.emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
	inner join emdb.emdbuser.LOANXDB_S_06 ls06 on ls.XrefId = ls06.XrefId
	inner join emdb.emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId
	inner join emdb.emdbuser.LOANXDB_d_01 ld01 on ls.XrefId = ld01.XrefId
	left outer join chilhqpsql05.admin.corp.Employee ae on ae.employeeID = ls03._CX_FINALOCODE_4
	left outer join  chilhqpsql05.admin.corp.costcenter cc on cc.costcenterid = ae.costcenterid 
--where  ls03._CX_FINALOCODE_4 <> ls10._cx_locode_1

where
loanFolder not in ('(Archive)','(Trash)', 'Samples') 
and _11 not like 'PREq%'
and
 --_745 >= '2012-03-01' 
 DateFileOpened >= '2012-01-01'               --_735 is app date
and (_CX_PAIDLOCODE_3 < '0'    or _cx_locstcntr < '0')  -- cost center not added until jan or feb.




--Select top 5
--order by _cx_locstcntr,_CX_FINALOCODE_4, loanofficerid	
--	e.displayName,
	
--	e.employeeid,
--	e.titleid,
--	encompasslogin
	
-- from admin.corp.employee e 
--	left outer join admin.corp.title t on t.titleid = e.titleid
--	left outer join admin.corp.costcenter c on c.costcenterid = e.costcenterid
	
--displayName		employeeid		titleid		encompasslogin
--Jason Jesudoss	109				4				jjesudoss
--Kasey Marty			111			54				kaseym
--Stephen Romano	114				134				sromano
--Mike Ward		130				296				mward
--Olimpia 
GO
