SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [reports].[Cls_Calndr]
	@startdate DateTime,
	@type varchar(50)
AS
BEGIN
	IF @type='confirmed'
	BEGIN	--Confirmed Type
		--exec corp.Cls_Calndr_Cmb @startdate
		SELECT ls.loanfolder AS [Filename]
			,ls.BorrowerFirstName AS TLH_1_36
			,ls.BorrowerLastName AS TLH_1_37
			,ld01._CX_CLSSCHED_1 AS GRATE_1_44
			,ls.[State] AS TLH_1_14
			,ls01._cust63fv AS TLH_1_862
			,ls.Investor AS TLH_1_1264
			,CASE ls.LoanPurpose 
				WHEN 'Purchase' THEN '1' 
				WHEN 'ConstructionToPermanent' THEN '2' 
				WHEN 'ConstructionOnly' THEN '3' 
				WHEN 'Cash-Out Refinance' THEN '4' 
				WHEN 'NoCash-Out Refinance' THEN '4' 
				WHEN 'Other' THEN '5' 
			END AS TLH_1_19
			,ls.LoanNumber AS TLH_1_364
			,ld01._748 AS TLH_1_748
			,ls.TitleVendor AS TLH_1_411
			,ls01._1855 AS TLH_1_815
			,ISNULL(ls02._2626,'') AS TLH_1_816
			,ls02._2574 AS TLH_1_984
			,ld03._CX_CLSPKGTITLE AS [PkgTitleDate]
			,ld01._1997 AS [FundsSentDate]
			,CAST(ln02._2 as Decimal(23,2)) AS [Loan] 
		FROM emdbuser.Loansummary ls 
			INNER JOIN emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId  
			INNER JOIN emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId 
			INNER JOIN emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId 
			INNER JOIN emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId 
			INNER JOIN emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId 
			INNER JOIN emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
			INNER JOIN emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
		WHERE (ls01._1855 <> 'SARA GRUBER' OR ls01._1855 <> 'APRIL KRAMPOTICH' ) 
			AND ld01._748 = @startdate 
			AND ld01._763 IS NOT NULL 
			AND (ls02._CX_BROKERCODE_1 IS NULL or ltrim(rtrim(ls02._CX_BROKERCODE_1))='')
	END		--Confirmed Type
	ELSE IF @type='pending'
	BEGIN	--Pending Type
	--	--exec corp.Cls_Calndr_Pending_Cmb @startdate
		SELECT ls.loanfolder AS [Filename]
			,ls.BorrowerFirstName AS TLH_1_36
			,ls.BorrowerLastName AS TLH_1_37
			,ld01._CX_CLSSCHED_1 AS GRATE_1_44
			,ls.[State] AS TLH_1_14
			,ls01._cust63fv AS TLH_1_862
			,ls.Investor AS TLH_1_1264
			,CASE ls.LoanPurpose 
				WHEN 'Purchase' THEN '1' 
				WHEN 'ConstructionToPermanent' THEN '2' 
				WHEN 'ConstructionOnly' THEN '3' 
				WHEN 'Cash-Out Refinance' THEN '4' 
				WHEN 'NoCash-Out Refinance' THEN '4' 
				WHEN 'Other' THEN '5' 
			END AS TLH_1_19
			,ls.LoanNumber AS TLH_1_364
			,ld01._748 AS TLH_1_748
			,ls.TitleVendor AS TLH_1_411
			,ls01._1855 AS TLH_1_815
			,ISNULL(ls02._2626,'') AS TLH_1_816
			,ls02._2574 AS TLH_1_984
			,ld03._CX_CLSPKGTITLE AS [PkgTitleDate]
			,ld01._1997 AS [FundsSentDate]
			,CAST(ln02._2 as Decimal(23,2)) AS [Loan] 
		FROM emdbuser.Loansummary ls 
			INNER JOIN emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId  
			INNER JOIN emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId 
			INNER JOIN emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId 
			INNER JOIN emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId 
			INNER JOIN emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId 
			INNER JOIN emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
			INNER JOIN emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
		WHERE (ls01._1855 <> 'SARA GRUBER' OR ls01._1855 <> 'APRIL KRAMPOTICH' ) 
			AND ld01._748  IS NULL 
			AND ld01._763 = @startdate 
			AND (ls02._CX_BROKERCODE_1 IS NULL or LTRIM(RTRIM(ls02._CX_BROKERCODE_1))='') 
	END		--Pending Type
	ELSE IF @type='scheduled'
	BEGIN	--Scheduled Type
		--exec corp.Cls_Calndr_Scheduled_Cmb @startdate
		SELECT ls.loanfolder AS [Filename]
			,ls.BorrowerFirstName AS TLH_1_36
			,ls.BorrowerLastName AS TLH_1_37
			,ld01._CX_CLSSCHED_1 AS GRATE_1_44
			,ls.[State] AS TLH_1_14
			,ls01._cust63fv AS TLH_1_862
			,ls.Investor AS TLH_1_1264
			,CASE ls.LoanPurpose 
				WHEN 'Purchase' THEN '1' 
				WHEN 'ConstructionToPermanent' THEN '2' 
				WHEN 'ConstructionOnly' THEN '3' 
				WHEN 'Cash-Out Refinance' THEN '4' 
				WHEN 'NoCash-Out Refinance' THEN '4' 
				WHEN 'Other' THEN '5' 
			END AS TLH_1_19
			,ls.LoanNumber AS TLH_1_364
			,ld01._748 AS TLH_1_748
			,ls.TitleVendor AS TLH_1_411
			,ls01._1855 AS TLH_1_815
			,ISNULL(ls02._2626,'') AS TLH_1_816
			,ls02._2574 AS TLH_1_984
			,ld03._CX_CLSPKGTITLE AS [PkgTitleDate]
			,ld01._1997 AS [FundsSentDate]
			,CAST(ln02._2 as Decimal(23,2)) AS [Loan] 
		FROM emdbuser.Loansummary ls 
			inner join emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
			inner join emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId 
			inner join emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId 
			inner join emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId 
			inner join emdbuser.LOANXDB_N_01 ln01 on ls.XrefId = ln01.XrefId 
			inner join emdbuser.LOANXDB_N_02 ln02 on ls.XrefId = ln02.XrefId 
			inner join emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
		WHERE ld01._CX_clssched_1 = @startdate AND
			(ls02._CX_BROKERCODE_1 IS NULL OR ltrim(rtrim(ls02._CX_BROKERCODE_1))='') 		
	END		--Scheduled Type
END
GO
