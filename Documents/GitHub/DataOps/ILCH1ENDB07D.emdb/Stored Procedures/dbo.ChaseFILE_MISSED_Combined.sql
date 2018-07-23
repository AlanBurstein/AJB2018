SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ChaseFILE_MISSED_Combined]  @loans as varchar(700) AS
SELECT 
'' as "Line",
'' as "SubLimit",
tlh_1_364 as "LoanNumber",
tlh_1_876 as "CorresLoanNumber",
replace(TLH_1_65,'-','') AS "SSN",
replace(TLH_1_37,',',' ') AS "BLAST",
replace(TLH_1_36,',',' ') AS "BFIRST",
replace(TLH_1_97,'-','') AS "CoSSN",
replace(TLH_1_69,',',' ') AS "CoBLAST", 
replace(TLH_1_68,',',' ') AS "CoBFIRST",
replace(TLH_1_11,',',' ') AS "ADDRESS",
TLH_1_12 AS "CITY",TLH_1_14 AS "STATE",
TLH_1_15 AS "ZIP", TLH_1_13 AS "COUNTY",
TLH_1_2 AS "NOTEAMOUNT",CONVERT(CHAR(10),
TLH_2_2,110)AS "DOB",
case
when len(casasrn_1_13)>2 then casasrn_1_13 
else mornet_1_4 end as "DUAPPROVENumber", 
TLH_1_2 AS "WAREHOUSEAMT",
TLH_1_356 AS "APPRAISEAMT",
TLH_1_4 AS "TERM",
CONVERT(decimal(18,5),TLH_1_873) AS "RATE",
CONVERT(CHAR(10),TLH_1_748,110)AS "MORTGAGEDATE",
CASE tlh_1_27   WHEN '1' THEN 'R'  WHEN '2' THEN 'C'  WHEN '3' THEN 'R'  ELSE 'P' END as "PURPOSE", 
TLH_1_353 AS "LTV",
TLH_1_976 AS "CLTV",
TLH_1_742 AS "DTI",
CASE TLH_1_1172  
WHEN '1' THEN    CASE      WHEN TLH_1_1172 >463000       THEN 'JUMB'        ELSE 'CONF'       END      
WHEN '2' THEN 'GOVT'     WHEN '3' THEN 'GOVT'    ELSE 'CONF' END AS "PRODUCT", 
TLH_1_420 AS "LIEN",
0 AS "BALLOON",
Case when tlh_1_1041 = '2' then '1FAM'
else case tlh_1_421  
when '1' then '1FAM'   
when '2' then '1FAM'  
when '3' then '2FAM'  
when '4' then 'COND'  
when '5' then 'COOP'  
ELSE '1FAM' end 
end as "Property_Type",
case tlh_1_190  
when '1' then 'O'  
when '2' then 'O'  
when '3' then 'N' end 
as "Occupancy_code",
ISNULL(TLH_2_84,'') AS "FICO",
ISNULL(TLH_2_102,0) AS "COFICO",
CONVERT(decimal(18,5),TLH_1_16) AS "UNITS",
cast(TLH_1_1051 as varchar) AS "MIN#", 
case tlh_1_899 
   when 'Suntrust' then 'SUNT'
   when 'Suntrust Correspondent' then 'SUNT'
  when 'ALS' then 'AUR'  
  when'GMAC Correspondent' then 'GMAC'  
  when 'Citimortgage Correspondent' then 'CITM'  
  when 'Countrywide' then 'BOFA'
  when 'BANK OF AMERICA CORRESPONDENT' then 'BOFA'   
  when 'Guaranteed Rate' then ''  
  when 'Chase Correspondent' then 'CHAS' 
  when 'Interfirst' then 'ABN'  
  when 'Wells Fargo Correspondent' then 'WELL'  
  when 'Wells Correspondent' then 'WELL'  
  when 'US Bank EZD' then 'USB'  
  when 'US Bank' then 'USB'  
  when 'US Bank - EZD' then 'USB' 
  when 'US Bank Correspondent' then 'USB'  
  when 'US Bank Correspondent - EZD' then 'USB'  
  when 'Franklin American Correspondent' then 'FRANK'  
  when 'Countrywide Correspondent' then 'BOFA'  
  when 'GRI - Freddie Mac - Central Mortgage 120787' then 'FHLM'
  when 'GRI - Freddie Mac - USB 589603' then 'FHLM' end 
  as "Investor_Code", 
case tlh_1_899  
when 'Guaranteed Rate' then ''   else     cast(tlh_1_888 as text) end 
as "Inv_Commit_number", 
case tlh_1_899  
when 'Guaranteed Rate' then ''   else     tlh_1_870  end 
as "Inv_Commit_Price", 
case tlh_1_899  when 'Guaranteed Rate' then ''   else      CONVERT(CHAR(10),
dateadd(day,8,CONVERT(CHAR(10),TLH_1_868,110)),110) End as "Inv_Commit_Expire_Date", 
replace(VOR_1_4,',',' ') AS "CURRADDRESS",
VOR_1_6 AS "CURRCITY",
VOR_1_7 AS "CURRSTATE",
VOR_1_8 AS "CURRZIP",
tlh_1_364 AS "WIRECOMMENTS",
replace(tlh_1_411,',',' ') as "Payee1_name", 
tlh_1_412 as "payee1_address",
tlh_1_413 as "payee1_City",
tlh_1_1174 as "payee1_State",
tlh_1_414  as "payee1_Zip",
replace(tlh_1_501,',',' ') AS "PAYEEBANK",
case  when Len(grate_1_3)>2 then str('03') else str('01') end AS "FUNDINGTYPE",
cast(tlh_1_502 as text) as "payee1_accountnum", 
cast(tlh_1_503 as text) as "Payee1_ABAnum",
case ltrim(rtrim(TLH_1_489)) when '' then '' else TLH_1_489 end 
AS "FUNDINGAMT",
'' as "payee1_instruction1",
'' as "payee1_instruction2",
GRATE_1_3 AS "CHECK",case  when Len(grate_1_3)>2 then CONVERT(CHAR(10),TLH_1_1211,110) else '' end 
AS "CHECKDATE",
Case TLH_1_608
  when '3' then 'ARM' else 'Fixed' end as "AmortizationType",   ----Added 10-15-2009---
case mornet_1_67   
when 'F' then 'FULL'  
when 'L' then 'NO DOC'  
when 'O' then 'NO DOC'  
when 'A' then 'LIMITED'  
when 'R' then 'LIMITED'  
when 'T' then 'FULL'  
when 'D' then 'NO DOC' 
when 'C' then 'NO DOC'  
when 'S' then 'FULL'  
when 'P' then 'FULL'  
when 'G' then 'NO DOC'  
when 'Q' then 'FULL'  
when 'E' then 'LIMITED'  
when 'N' then 'NO DOC' 
else 'FULL' end 
as "Doc_Type",
tlh_1_2 as "CurrentUPB",   ----Added 10-15-2009---
 case   when len(tlh_1_232)>1 then 'Y'  else 'N' end as "MI",
 Convert(CHAR(10),dateadd(m, datediff(m, 0, dateadd(month, 2, tlh_1_506)), 0),110) as "FirstDue",
 Convert(CHAR(10),dateadd(month,-1,dateadd(year,tlh_1_4/12,dateadd(m, datediff(m, 0, dateadd(month, 2, tlh_1_506)), 0))),110)
 AS "MATURITY", 
'' as "PrePayMnths",
'' as "PrePayDesc",
case ltrim(rtrim(tlh_1_136)) when '' then '' else tlh_1_136 end 
as "SalePrice",
tlh_1_417 as "ClsAgentPhone", 
case   when len(tlh_1_69)>2 then 2 else 1 end as "NumbBorr",
tlh_2_1 as "ProgramDesc", 
Case tlh_1_481 
when '1' then 'None' 
else  '1,' + CAST( isnull(cast(TLH_1_230 as float) ,0) + isnull(cast(TLH_1_231 as float),0) + isnull(cast(TLH_1_232 as float),0) as varchar) end
as "impound", 
isnull(cast(tlh_1_736 as float),0)*12 as "AnnualIncome",
case tlh_1_424  when 'N' then ''  else '120' end as "IOPeriod",
TLH_1_804 as "AppraisalType",
case voe_1_15 when 'Y' then 'Y' else 'N'  end as "SelfEmp",0 as "AVM",
'' as "LienType",

Case
when left(tlh_1_863,1)='F' then 'FHA'
when left(tlh_1_863,1)='V' then 'VA'
else 'CONV' end  as "ProgramCode",

'' as "LPMI",tlh_1_492 as "agencyPrg" 
from sqlprod53.dbo.bors left join sqlprod53.dbo.loanprograms on sqlprod53.dbo.bors.tlh_1_863 = sqlprod53.dbo.loanprograms.grate 
where sqlprod53.dbo.bors.tlh_1_500 ='Chase'
 and filename like '%.1' and Len(Grate_1_3)>1 and tlh_1_364 in (@loans)


 Union All

SELECT 
'' as "Line",
'' as "SubLimit",
_364 as "LoanNumber",
_2288 as "CorresLoanNumber",
replace(_65,'-','') AS "SSN",
replace(_37,',',' ') AS "BLAST",
replace(_36,',',' ') AS "BFIRST",
replace(_97,'-','') AS "CoSSN",
replace(_69,',',' ') AS "CoBLAST",
replace(_68,',',' ') AS "CoBFIRST",
replace(_11,',',' ') AS "ADDRESS",  
 _12 AS "CITY",_14 AS "STATE",
 _15 AS "ZIP", _13 AS "COUNTY",
 CONVERT(decimal(18,5),_2) AS "NOTEAMOUNT",
 CONVERT(CHAR(10),_1402,110)AS "DOB",_du_lp_id as "DUAPPROVENumber",
 CONVERT(decimal(18,5),_2) AS "WAREHOUSEAMT",
  CONVERT(varchar,_356) AS "APPRAISEAMT",
  CONVERT(varchar,_4) AS "TERM",
 _3 AS "RATE",
 CONVERT(CHAR(10),_748,110)AS "MORTGAGEDATE",
 _CX_FUNDCHASEPURP_3 as "PURPOSE", 
 convert(varchar,_353) AS "LTV",
 convert(varchar,_976) AS "CLTV",
 CONVERT( varchar,_742) AS "DTI",
 _CX_FUNDCHASEPROD_3 AS "PRODUCT",
 CONVERT(smallint,CASE _420 WHEN 'First Lien' THEN '1' WHEN 'Second Lie' THEN '2'  Else '1' End) as "LIEN", 
0 AS "BALLOON",
 _CX_FUNDCHASEPROP_3 as "Property_Type",
 _CX_FUNDCHASEOCC_3 as "Occupancy_code",
 _67 AS "FICO",cast(ISNULL(_60,0) as int) AS "COFICO",
 _16 AS "UNITS",
 cast(_1051 as varchar) AS "MIN#",
 CASE _2278   
   when 'Suntrust' then 'SUNT'
   when 'Suntrust Correspondent' then 'SUNT'
   when 'ALS' then 'AUR' 
   when'GMAC Correspondent' then 'GMAC'  
   when 'Citimortgage Correspondent' then 'CITM'  
   when 'Countrywide' then 'BOFA'
   when 'BANK OF AMERICA CORRESPONDENT' then 'BOFA'   
   when 'Guaranteed Rate' then ''  
   when 'Chase Correspondent' then 'CHAS'  
   when 'Interfirst' then 'ABN' 
   when 'Wells Fargo Correspondent' then 'WELL'  
   when 'Wells Correspondent' then 'WELL' 
   when 'US Bank EZD' then 'USB'  
   when 'US Bank' then 'USB'  
   when 'US Bank - EZD' then 'USB'  
   when 'US Bank Correspondent' then 'USB'  
   when 'US Bank Correspondent - EZD' then 'USB'  
   when 'Franklin American Correspondent' then 'FRANK'  
   when 'Countrywide Correspondent' then 'BOFA'  
   when 'GRI - Freddie Mac - Central Mortgage 120787' then 'FHLM' 
  when 'GRI - Freddie Mac - USB 589603' then 'FHLM'
  end as "Investor_Code",
  case _2278  when 'Guaranteed Rate' then ''   else     cast(_2288 as text) end as "Inv_Commit_number",
  case _2278  when 'Guaranteed Rate' then ''   else     convert(varchar,_2274)  end as "Inv_Commit_Price",
  case _2278  when 'Guaranteed Rate' then ''   else      CONVERT(CHAR(10),_2222,110) End as "Inv_Commit_Expire_Date", 
 replace(_FR0104,',',' ') AS "CURRADDRESS",
 _FR0106 AS "CURRCITY",
 _FR0107 AS "CURRSTATE",
 _FR0108 AS "CURRZIP",
 _364 AS "WIRECOMMENTS",
 replace(_411,',',' ') as "Payee1_name",
 _412 as "payee1_address",
 _413 as "payee1_City",
 _1174 as "payee1_State",
 _414  as "payee1_Zip",
 replace(_2003,',',' ') AS "PAYEEBANK", 
 case  when Len(_2000)>2 then str('03') else str('01') end AS "FUNDINGTYPE",
 cast(_vend_x399 as text) as "payee1_accountnum",cast(_vend_x398 as text) as "Payee1_ABAnum",
 convert(varchar,_1990) AS "FUNDINGAMT", 
 '' as "payee1_instruction1",
 '' as "payee1_instruction2",
 _2000 AS "CHECK",
 case  when Len(_2000)>2 then CONVERT(CHAR(10),_CX_FUNDDATE_1,110) else '' end AS "CHECKDATE",
Case _608
  when 'AdjustableRate' then 'ARM' else 'Fixed' end as "AmortizationType",   ----Added 10-15-2009---

 _CX_FUNDCHASEDOC_3 as "Doc_Type",
_2 as "CurrentUPB",  ----Added 10-15-2009---
 case   when len(_232)>1 then 'Y'  else 'N' end as "MI",
 CONVERT(CHAR(10),_682,110) as "FirstDue", 
 CONVERT(CHAR(10),_78,110) AS "MATURITY",
 '' as "PrePayMnths",
 '' as "PrePayDesc",
 CONVERT(varchar,_136) as "SalePrice",
_689 as "Margin",----Added 10-15-2009---
_247 + _3 as "MaxRate",----Added 10-15-2009---
_1699 as "Floor",----Added 10-15-2009---
_697 as "1stCap",----Added 10-15-2009---
_695 as "AdjCap",----Added 10-15-2009---
Convert(char(10),dateadd(month, _696, _682),110)as "RateAdj",----Added 10-15-2009---
Convert(char(10),dateadd(month, _696 + 1, _682),110)as "PmtAdj",----Added 10-15-2009---
_694 as "FreqofAdj",----Added 10-15-2009---
'' as "SubordlienAmt",----Added 10-15-2009---
_688 as "Index",----Added 10-15-2009---

 _417 as "ClsAgentPhone",
_1401 as "ProgDesc",
'1001963' as "Orgid",
'' as "SecureType",
'' as "MtgBenfit",
'' as "OrigTrustee",
 case   when len(_69)>2 then 2 else 1 end as "NumbBorr",
'' as "MtgHist",
 _1401 as "ProgramDesc", 
 Case _2961 when 'Waived' then 'None' else '1,' + CAST( isnull(cast(_230 as float) ,0) + isnull(cast(_231 as float),0) + isnull(cast(_232 as float),0) as varchar) end as "impound",
_739 - _1724 as "TIPmt",  ----Added 10-15-2009---
 isnull(cast(_1389 as float),0)*12 as "AnnualIncome",
_l248 as "PMICo",----Added 10-15-2009---
_1807 as "PMICov",----Added 10-15-2009---
_696 as "FixedPeriod",----Added 10-15-2009---
_694 as "adjfreq", ----Added 10-15-2009---
 CONVERT(varchar,_1177) as "IOPeriod",
 _2356 as "AppraisalType",
 CONVERT(CHAR(10),_682,110)as "Intpdthru", ----Added 10-15-2009---
_4 as "OrigAmort",----Added 10-15-2009---
'' as "NegAmortLim",----Added 10-15-2009---
_FE0115 as "SelfEmp",----Added 10-15-2009---
0 as "firsttime",----Added 10-15-2009---
''as "Times30",----Added 10-15-2009---
''as "Times60",----Added 10-15-2009---
''as "Times90",----Added 10-15-2009---
''as "Times120",----Added 10-15-2009---
''as "Times150",----Added 10-15-2009---
''as "Times180",----Added 10-15-2009---
'' as "Bankrupt",----Added 10-15-2009---
'' as "bkdischrg",----Added 10-15-2009---
'' as "Foreclshist",----Added 10-15-2009---
0 as "AVM",
'' as "LienType",
'' as "ResIncome",----Added 10-15-2009---
''as "foreign",----Added 10-15-2009---
''as "SenLienBal",----Added 10-15-2009---
Case
when left(_1130,1)='F' then 'FHA'
when left(_1130,1)='V' then 'VA'
else 'CONV' end  as "ProgramCode",

 '' as "LPMI",
 _CX_AUSSOURCE_2 as "agencyPrg" 
 FROM "grchilhq-en-01".emdb.emdbuser.Loansummary ls
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId   
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_N_03 ln03 on ls.XrefId = ln03.XrefId
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId   
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId  
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId  
 inner join "grchilhq-en-01".emdb.emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId  
 WHERE         (LTRIM(RTRIM(_VEND_X200)) NOT LIKE '') 
 AND (_VEND_X200 IS NOT NULL) 
 AND _VEND_X200='Chase' 
and Len(_2000)>1 and _364 in (@loans)

INSERT INTO Chase_Sent 
select 
tlh_1_364 as loan, 
tlh_1_748 as closed, 
tlh_1_1211 as funded,
case tlh_1_506 
  when '' then '1/1/1900'
  else tlh_1_506
end as wire_date,
tlh_1_500 as warehouse, 
1 as sent, 
getdate() as date_sent,
1 as active,
tlh_1_37 as LastName 
from sqlprod53.dbo.bors 
left join sqlprod53.dbo.loanprograms on sqlprod53.dbo.bors.tlh_1_863 = sqlprod53.dbo.loanprograms.grate 
where sqlprod53.dbo.bors.tlh_1_500 ='Chase' 
and filename like '%.1' and Len(Grate_1_3)>1 and tlh_1_364 in (@loans)
and (TLH_1_364 NOT IN (SELECT Loan FROM Chase_Sent))



GO
