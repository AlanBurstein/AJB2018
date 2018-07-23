SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [dbo].[LOLessThanThree]
as 
select
	MO,
	costcenter,
	sum(lessthan3) as lt3
from(
		select 
		loanofficerid,
		loanofficername,
		c.costcenter,

		MONTH(_CX_FUNDDATE_1) as mo,
		COUNT(loanamount) as Units,
		Sum(LoanAmount) as Volume,
		Case when COUNT(loanamount) < 3 then 1 else 0 end as 'Lessthan3'

		from  
		emdb.emdbuser.loansummary ls
		left join emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId
		left outer join chilhqpsql05.admin.corp.Employee e on e.userlogin = ls.loanofficerid
		--left outer join chilhqpsql05.admin.dbo.org org on org.employeeid = e.employeeid
		left outer join chilhqpsql05.admin.corp.costcenter c on c.costcenterid = e.costcenterid
		where ld01._CX_FUNDDATE_1 > '2012-01-01'  -- between '2012-01-01' and '2012-01-31'

		Group by
		MONTH(_CX_FUNDDATE_1), 
		c.costcenter,
		loanofficerid,
		loanofficername)
as temp3

group by  mo, costcenter


GO
