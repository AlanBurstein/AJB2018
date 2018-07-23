SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




     --  select * from  [dbo].[compareBizTOAdmin]  where bp_contactid = 119026  order by bp_first

CREATE view [dbo].[compareBizTOAdmin] as 
SELECT
distinct  
	bp.contactid as bp_contactid, 
	bc.categoryname as bp_categoryname,
	bp.FirstName as bp_first,
	bp.LastName as bp_last,
	bv44.fieldvalue  AS bp_PAIDLOCODE ,
	bv43.fieldvalue  AS bp_Costcenter,
	cc.costcentername as CostCenterName,
	e.firstname as admin_first,
	e.lastname  as admin_last, 
	e.employeeid as admin_employeeid,
	cc.CostCenter as admincostcenter,

	case when bp.FirstName <> e.firstname then 'Does not match' end as FirstName_check,
	case when bp.LastName <> e.lastname then 'Does not match' end as LastName_check,
	case when bv43.fieldvalue <> cc.CostCenter then 'Does not match' end as CstCntr_check,
	case when bv43.fieldvalue = cc.CostCenter then cc.costcentername end as new,
	acc.costcentername as encccname
	
	
 FROM        
[emdb].[emdbuser].[BizPartner]bp
  left outer join emdbuser.bizcategory bc on bc.categoryid = bp.categoryid
  left outer join emdbuser.BizCategoryCustomFieldValue bv43 on bv43.categoryid = bp.categoryid 
                 and bv43.ContactId = bp.contactid and bv43.FieldId = 43
  left outer join emdbuser.BizCategoryCustomFieldValue bv44 on bv44.categoryid = bp.categoryid 
                 and bv44.ContactId = bp.contactid and bv44.FieldId = 44
                 
  left outer join chilhqpsql05.admin.corp.Employee e on e.employeeid = bv44.fieldvalue
  left outer join chilhqpsql05.admin.corp.costcenter cc on cc.CostCenterID = e.costcenterid
  left outer join chilhqpsql05.admin.corp.costcenter acc on convert(varchar(6),acc.CostCenter)  = ltrim(rtrim(convert(varchar(8),bv43.fieldvalue)))


where bp.categoryid = 37


and  bp.contactid not in  (119026, 119059, 115593, 143587, 122390)   
		


--and ( bp.contactid <> 119026 )   --in contacts twice - Jason Cocuzza
--or bp.contactid <> '117840'       -- Matthew Waters 
-- or bp.contactid <> '11559'      -- Lisa Napolitano - firs tname is elizabeth in ENC.
--143587 - Alex Matar - duplicate entry - termed employee
--122390 - Marcus Szczerbacki - duplicate entry - termed employee
--  )


--GO





GO
