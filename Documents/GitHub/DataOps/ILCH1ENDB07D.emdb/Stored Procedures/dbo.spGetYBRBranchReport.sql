SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [dbo].[spGetYBRBranchReport]

	@UserName varchar(max),
	@Branch int,
	@Options varchar(max),
	@FilterType varchar( 100 ) = 'all'

as

/*

-----------------------------------------------------------------------------------------------------------------------------
	who	when		what
-----------------------------------------------------------------------------------------------------------------------------
	sethm	??		initial rev of proc
	sethm	20130602	changed to use encompass personas

*/

begin

	set nocount on
	set transaction isolation level read uncommitted

	-- used to store active loans
	create table #ActiveLoans (
		XRefID int not null
	)

	-- declare misc variables
	declare @RegionID int
	declare @Region varchar( 100 )
	declare @CostCenterID int
	
	-- get a list of all employees 
	select EmployeeID, CostCenterID, UserLogin, EncompassLogin, DisplayName, ManagerID, SalesAssistiantID into #Employee from admin.corp.Employee 
	select * into #EmployeeAndAllManagers2 from chilhqpsql05.admin.corp.employeeandallmanagers2
	
	-- get a list of employees in a specified cost center
	select @CostCenterID = CostCenterID from admin.corp.CostCenter where CostCenter = @Branch
	select EmployeeID, UserLogin, EncompassLogin, DisplayName, SalesAssistiantID into #EmployeeCC from #Employee where CostCenterID = @CostCenterID

	-- get the region id
	select @RegionID = RegionID from admin.corp.CostCenter where CostCenterID = @CostCenterID
	select @Region = Region from admin.corp.Region where RegionID = @RegionID
	
	-- create some temp indexes
	create index IDX_1 on #Employee ( EmployeeID )
	create clustered index IDX_2 on #Employee ( DisplayName )
	create index IDX_3 on #Employee ( EncompassLogin )
	create index IDX_1 on #EmployeeCC ( EmployeeID )
	create clustered index IDX_2 on #EmployeeCC ( DisplayName )
	create index IDX_3 on #EmployeeCC ( EncompassLogin )
	create clustered index IDX_1 on #EmployeeAndAllManagers2 ( EmpID )

	if @FilterType = 'all'
	begin
		-- get active loans for specified employees
		insert	#ActiveLoans ( XRefID )
		select	distinct LS01.XRefID
		from	emdbuser.LOANXDB_S_01 LS01, emdbuser.LOANXDB_S_03 LS03, emdbuser.LOANXDB_S_08 LS08, emdbuser.LOANXDB_S_10 LS10,
			emdbuser.LOANXDB_D_01 LD01, emdbuser.LoanSummary LS, #EmployeeCC EC
		where	_1393 = 'Active Loan' and
			_420 <> 'Second Lien' and 
			_763 >= '2012-01-01' and -- est closing date 
			DateFunded is null and
			Address1 not like 'Prequal%' and
			LS.LoanFolder not in ( '(Archive)', '(Trash)', 'Closed Loans', 'Completed Loans', 'Samples', 'Adverse Loans') and
			LS.LoanFolder not like 'Adverse%' and
			LS01.XRefID = LS03.XRefID and
			LS01.XRefID = LS08.XRefID and
			LS01.XRefID = LS10.XRefID and
			LS01.XRefID = LS.XRefID and
			LS01.XRefID = LD01.XRefID and		
			(
				( ltrim( rtrim( LoanTeamMember_UserID_MortgageConsultant )) = EC.EncompassLogin )  or
				( ltrim( rtrim( LoanTeamMember_UserID_LoanCoordinator )) = EC.EncompassLogin ) or 
				( ltrim( rtrim( LoanTeamMember_UserID_LoanOfficer )) = EC.EncompassLogin ) or
				( ltrim( rtrim( _CX_FINALOCODE_4 )) = EC.EmployeeID )
			)
	end
	else
	begin
		-- get active loans for specified employees where loan originated within branch
		insert	#ActiveLoans ( XRefID )
		select	distinct LS01.XRefID
		from	emdbuser.LOANXDB_S_01 LS01, emdbuser.LOANXDB_S_03 LS03, emdbuser.LOANXDB_S_08 LS08, emdbuser.LOANXDB_S_10 LS10, 
			emdbuser.LOANXDB_D_01 LD01, emdbuser.LoanSummary LS, #EmployeeCC EC
		where	_1393 = 'Active Loan' and
			_420 <> 'Second Lien' and 
			_763 >= '2012-01-01' and -- est closing date 
			DateFunded is null and
			Address1 not like 'Prequal%' and
			LS.LoanFolder not in ( '(Archive)', '(Trash)', 'Closed Loans', 'Completed Loans', 'Samples', 'Adverse Loans') and
			LS.LoanFolder not like 'Adverse%' and
			LS01.XRefID = LS03.XRefID and
			LS01.XRefID = LS08.XRefID and
			LS01.XRefID = LS10.XRefID and
			LS01.XRefID = LS.XRefID and
			LS01.XRefID = LD01.XRefID and		
			(
				( ltrim( rtrim( LoanTeamMember_UserID_MortgageConsultant )) = EC.EncompassLogin )  or
				( ltrim( rtrim( LoanTeamMember_UserID_LoanCoordinator )) = EC.EncompassLogin ) or 
				( ltrim( rtrim( LoanTeamMember_UserID_LoanOfficer )) = EC.EncompassLogin ) or
				( ltrim( rtrim( _CX_FINALOCODE_4 )) = EC.EmployeeID )
			)
			and _CX_FINALOCODE_4 in ( select EmployeeID from #EmployeeCC )	
	end

	-- create an additional index
	create clustered index IDX_1 on #ActiveLoans ( XRefID )

	-- return the results	
	select distinct

		/*****************************/
		/* LOAN CRITERIA FOR THE YBR */
		/*****************************/

		_4002 as LastName,
		_4000 AS FirstName,
		_364 as LoanNumber,

		case	
			when _19  = 'Purchase' then 'Purchase' 
			when _19  = 'NoCash-Out Refinance' then 'NO C/O Refi'
			when _19  = 'Cash-Out Refinance' then 'C/O Refi'
		end as LoanPurpose, 

		case
			when _1041 = 'Condominium' then 'Condo'
			else _1041 
		end as PropertyType,

		case 
			when lockrate_2278 in ( 'Astoria Br', 'Astoria Broker', 'Bank of Internet', 'Bank of Internet - Broker', 'Flagstar B', 
				'Flagstar Bank', 'Flagstar Bank - Broker', 'Flagstar Bank BROKER', 'Flagstar Broker', 'FLAGSTAR C', 'FLAGSTAR CORRESPONDENT', 
				'Hudson City', 'Hudson City - Broker', 'Hudson City- Broker', 'ING BROKER', 'Kinecta', 'Kinecta Federal Credit Union', 
				'Penfed', 'PenFed - Broker', 'U.S. Bank Home Mortgage BROKER', 'Union Bank', 'Union Bank - Broker', 'UnionBank', 'UnionBank ', 
				'UnionBank - Broker', 'US BANk Broker', 'US Bank Consumer Finance - Broker', 'WELLS BROKER', 'Wells Fargo Broker' ) 
				then 'BRKR' + '-' + left( lockrate_2278, 15 )
			else left( lockrate_2278, 15 )
		end as Investor,
	
		LoanAmount,



		/***********/
		/* VP LANE */
		/***********/

		_745 as OriginationDate,

		-- lock date
		_761 as LockDate,
		case
			when  _761 is null and (_CX_APPRAISALRCVD_1 > '2001-01-01') and ( _CX_APPRORDERTRANS_10 > '2001-01-01') and (_19 <> 'Purchase') 
				then '#FFE4E1'
			when ( dbo.DateAddWeekDay( 2,_745 )) < getdate() and _761 is null 
				then '#FFFFCC'
		end as LockDateColor1,		
		case when _761 > ( dbo.DateAddWeekDay( 2, _745 )) then 'Red' end as LockDateColor2,

		-- sent to processing
		Log_MS_Date_Processing as SentToProcessing,
		case when ( dbo.DateAddWeekDay( 2, _745)) < getdate() and Log_MS_Date_Processing is null then '#FFFFCC' end as SentToProcessingColor1,
		case when Log_MS_Date_Processing > ( dbo.DateAddWeekDay( 2, _745 )) then 'Red' end as SentToProcessingColor2,


		/***********/
		/* MC LANE */
		/***********/

		-- application out
		_CX_APPSENT_1 as ApplicationOut,
		case when ( dbo.DateAddWeekDay( 1, Log_MS_Date_Processing )) < getdate() and _CX_APPSENT_1 is null then '#FFFFCC' end as ApplicationOutColor1,
		case when _CX_APPSENT_1 > ( dbo.DateAddWeekDay( 1,Log_MS_Date_Processing )) then 'Red' end as ApplicationOutColor2,	

		-- partial application received
		_CX_APPRCVD_1 as PartialApplicationReceived,
		case when ( dbo.DateAddWeekDay( 2,_CX_APPSENT_1 )) < getdate() and _CX_APPRCVD_1 is null then '#FFFFCC' end as PartialApplicationReceivedColor1,
		case when _CX_APPRCVD_1 > DateAdd( d, 2, _CX_APPSENT_1 ) then 'Red' end as PartialApplicationReceivedColor2,

		-- application package recieved
		_cx_apppakcomplete as ApplicationPackageReceived,
		case when ( dbo.DateAddWeekDay( 3, _CX_APPSENT_1 )) < getdate() and _cx_apppakcomplete is null then '#FFFFCC' end AS ApplicationPackageReceivedColor1,
		case when _cx_apppakcomplete > DateAdd( d, 3, _CX_APPSENT_1 ) then 'Red' end as ApplicationPackageReceivedColor2,

		-- appraisal ordered
		case when _CX_APPRAISALREQ = 'No' then 'N/A' else convert( varchar( 8 ), _CX_APPRORDERTRANS_10, 1 ) end as AppraisalOrdered,
		case when (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 is null ) or
			( _CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 is null ) then '#FFFFCC'
		end as AppraisalOrderedColor1,
		case when (_CX_APPRAISALREQ <> 'No' and _1172 <> 'FHA' and Log_MS_Date_Processing > '2001-01-01' and _CX_APPRORDERTRANS_10 > Log_MS_Date_Processing ) or
			( _CX_APPRAISALREQ <> 'No' and _1172 = 'FHA' and _CX_APPRCVD_1 > '2001-01-01' and _CX_APPRORDERTRANS_10 > _CX_APPRCVD_1 ) then 'Red'
		end as AppraisalOrderedColor2,

		-- appraisal reviewed
		case when _CX_APPRAISALREQ = 'No' then 'N/A' else convert( varchar( 8 ), _CX_APPRRECTRANS_10, 1 ) end as AppraisalReceived,
		case when _CX_APPRAISALREQ <> 'No' and ( dbo.DateAddWeekDay( 10, _CX_APPRORDERTRANS_10 )) < getdate() and _CX_APPRRECTRANS_10 is null then '#FFFFCC' end as AppraisalReceivedColor1,
		case when _CX_APPRAISALREQ <> 'No' and _CX_APPRRECTRANS_10 > ( dbo.DateAddWeekDay( 10, _CX_APPRORDERTRANS_10 )) then 'Red' end as AppraisalReceivedColor2, 

		-- title ordered
		_CX_TITLEORDER_1 as TitleOrdered,
		case when Log_MS_Date_Processing > '2001-01-01' AND _CX_TITLEORDER_1 IS NULL then '#FFFFCC' end as TitleOrderedColor1,
		case when _CX_TITLEORDER_1 > Log_MS_Date_Processing then 'Red' end as TitleOrderedColor2,

		-- uw submission
		_2298  as UWSubmission,
		case 
			-- when refi
			when ( _CX_APPRRECTRANS_10 > '2001-01-01' and _cx_apppakcomplete  > '2001-01-01' and 
				( dbo.DateAddWeekDay( 2, _CX_APPRRECTRANS_10 ) < getdate() and dbo.DateAddWeekDay( 2, _cx_apppakcomplete ) < getdate()) and 
				_19 like '%Refi%' and _2298 is null ) 
			or --when purchase
				(_cx_apppakcomplete  > '2001-01-01' and ( dbo.DateAddWeekDay( 1, _cx_apppakcomplete )) < getdate() and  
				_19 = 'Purchase' and _2298 is null ) 
			then '#FFFFCC'
		end as UWSubmissionColor1,
		case when (_2298 > ( dbo.DateAddWeekDay( 2, _CX_APPRRECTRANS_10 )) AND _19 like '%Refi%' ) or (_2298 > ( dbo.DateAddWeekDay( 1,_cx_apppakcomplete ))and
			_19  = 'Purchase' )
			then 'Red'
		end as UWSubmissionColor2,


		/***********/
		/* LC LANE */
		/***********/

		-- uw approval
		_2301 as UWApproval,	
		case when ( dbo.DateAddWeekDay( 5, _2298 )) < getdate() and _2301 is null then '#FFFFCC' end UWApprovalColor1,
		case when _2301 > ( dbo.DateAddWeekDay( 5,_2298 )) then 'Red' end as UWApprovalColor2,

		-- approval reviewed
		_cx_apprreviewed as ApprovalReviewed,
		case when ( dbo.DateAddWeekDay( 1, _2301 )) < getdate() and _cx_apprreviewed is null then '#FFFFCC' end as ApprovalReviewedColor1,
		case when _cx_apprreviewed > ( dbo.DateAddWeekDay( 1,_2301 )) then 'Red' end as ApprovalReviewedColor2,

		-- conditions submitted
		coalesce( ld04._CX_CONDITIONSUBMIT_5, ld04._CX_CONDITIONSUBMIT_4, ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,
			ld01._CX_CONDITIONSUBMIT_1 ) as ConditionsSubmitted,
		case when (( dbo.DateAddWeekDay( 2, _2301) < getdate()) and @Region = 'Online' and coalesce( ld04._CX_CONDITIONSUBMIT_5, ld04._CX_CONDITIONSUBMIT_4,
			ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2, ld01._CX_CONDITIONSUBMIT_1 ) is null ) or (( dbo.DateAddWeekDay( 4,_2301 ) < getdate()) and
			@Region <> 'Online' and coalesce( ld04._CX_CONDITIONSUBMIT_5, ld04._CX_CONDITIONSUBMIT_4, ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,
			ld01._CX_CONDITIONSUBMIT_1 ) is null ) then '#FFFFCC' end as ConditionsSubmittedColor1,
		case when ( coalesce( ld04._CX_CONDITIONSUBMIT_5, ld04._CX_CONDITIONSUBMIT_4, ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,
			ld01._CX_CONDITIONSUBMIT_1 ) > ( dbo.DateAddWeekDay( 2, _2301 ))and @Region =  'Online' ) or ( coalesce( ld04._CX_CONDITIONSUBMIT_5, 
			ld04._CX_CONDITIONSUBMIT_4, ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2, ld01._CX_CONDITIONSUBMIT_1 ) > 
			( dbo.DateAddWeekDay( 4, _2301 )) and @Region <> 'Online' ) then 'Red' end as ConditionsSubmittedColor2,
		
		-- uw ctc
		_2305 AS UWCTC,
		case when 
			(( dbo.DateAddWeekDay( 2, coalesce( ld04._CX_CONDITIONSUBMIT_5, ld04._CX_CONDITIONSUBMIT_4, ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,	
				ld01._CX_CONDITIONSUBMIT_1 )) < getdate()) and _2305 is null ) or
			(( dbo.DateAddWeekDay( -6, _CX_CONTINGE_1 ) < getdate() and _19 = 'Purchase' and _2305 is null )) or
			(( dbo.DateAddWeekDay( 10, getdate()) > _762 and _19  = 'Purchase' and _1811 = 'PrimaryResidence' and _2305 is null )) or
			(( dbo.DateAddWeekDay( 6,getdate()) > _762 and _19 like '%Refi%' and _1811 in ('SecondHome', 'Investor') and _2305 is null )) or
			(( dbo.DateAddWeekDay( 6,getdate()) > ( case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 end ) and _19  = 'Purchase' and _2305 is null ))
			then '#FFFFCC' end UWCTCColor1,
		case when 
			( _2305 > ( dbo.DateAddWeekDay( 2, coalesce( ld04._CX_CONDITIONSUBMIT_5, ld04._CX_CONDITIONSUBMIT_4, ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,
				ld01._CX_CONDITIONSUBMIT_1 )))) or
			(( _2305 < ( dbo.DateAddWeekDay( -6,_CX_CONTINGE_1 )) and _19 = 'Purchase' )) or
			(( _2305 < ( dbo.DateAddWeekDay( 10,_762 )) and _19  = 'Purchase' and _1811 = 'PrimaryResidence' )) or
			(( -2305 < ( dbo.DateAddWeekDay( 6,_762 )) and _19 like '%Refi%' and _1811 in ( 'SecondHome', 'Investor' )) or
			(( _2305 < ( dbo.DateAddWeekday( 6, ( case when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763 end ))) and _19  = 'Purchase' )))
			then 'Red' end as UWCTCColor2,

		-- estimated closing date
		case 
			when _748 > '2001-01-01' then _748
			when _CX_CLSSCHED_1 > _763 then _CX_CLSSCHED_1 else _763
		end as EstimatedClosingDate,

		-- lock expiration
		_762 as LockExpiration,

		-- lock days remaining
		datediff( d, getdate(), _762) as LockDaysRemaining,

		-- contingency
		_CX_CONTINGE_1 as Contingency,


		/*****************/
		/* EMPLOYEE INFO */
		/*****************/

		case 
			when	ltrim( rtrim( isnull( LoanTeamMember_Name_MortgageConsultant, '' ))) != '' then LoanTeamMember_Name_MortgageConsultant
			when	ltrim( rtrim( isnull( _CX_MCNAME_1, '' ))) != '' then _CX_MCNAME_1
			else	'none' 
		end as MCName,
		case 
			when	ltrim( rtrim( isnull( LoanTeamMember_Name_LoanCoordinator, '' ))) != '' then LoanTeamMember_Name_LoanCoordinator
			when	ltrim( rtrim( isnull( _CX_LCNAME_1, '' ))) != '' then _CX_LCNAME_1
			else	'none' 
		end as LCName,

		-- vp
		e.DisplayName AS VP,
		_CX_FINALOCODE_4 as PaidVPCode,


		/*****************/
		/* MISCELLANEOUS */
		/*****************/
		
		@Region as Region,

		-- previous milestone group
		case
			when ((_2303 > '2000-01-01' and 2301 is null ) or 
				( _CX_RESTRUCTUREDTI > '2001-01-01' and _cx_restdticomplete <> 'Y' ) or 
				( _CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y' )) then 'RESTRUCTURE – LTV, DTI or UW SUSPENSE'  
			when Log_MS_LastCompleted = 'Started' then 'Started'
			when ((Log_MS_LastCompleted  = 'Processing' and _CX_RESTRUCTUREDTI < '2001-01-01'  and  _CX_RESTRUCTURELTV < '2001-01-01') 
				or Log_MS_LastCompleted = 'App Fee Collected') then 'Processing'
			when Log_MS_LastCompleted = 'Assigned to UW' then 'Assigned to Underwriting Department'	
			when Log_MS_LastCompleted = 'Submittal' then 'Submitted to an Underwriter'
			when Log_MS_LastCompleted = 'UW Decision Expected' then 'Underwriting Decision Issued'
			when Log_MS_LastCompleted = 'Conditions Submitted to UW' then 'Conditions Submitted to UW'
			when Log_MS_LastCompleted = 'Approval' then 'Final Approval/CTC'
			when Log_MS_LastCompleted = 'Assign to Close' then 'Assigned to Closing'
			when Log_MS_LastCompleted = 'Doc Signing' then 'Doc Signing'
			else Log_MS_LastCompleted
		end as PreviousMilestoneGroup,
				
		-- milestone order
		case
			when (( _2303 > '2000-01-01' and 2301 is null ) or ( _CX_RESTRUCTUREDTI > '2001-01-01' and _cx_restdticomplete <> 'Y' ) or 
				( _CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y' )) then 11  ---UW SUSPENDED
			when Log_MS_LastCompleted = 'Started' then 1
			when (( Log_MS_LastCompleted  = 'Processing' and _CX_RESTRUCTUREDTI < '2001-01-01' and _CX_RESTRUCTURELTV < '2001-01-01' ) 
				or Log_MS_LastCompleted = 'App Fee Collected' ) then 2
			when Log_MS_LastCompleted = 'Assigned to UW' then 4
			when Log_MS_LastCompleted = 'Submittal' then 5
			when Log_MS_LastCompleted = 'UW Decision Expected' then 6
			when Log_MS_LastCompleted = 'Conditions Submitted to UW' then 7
			when Log_MS_LastCompleted = 'Approval' then 8
			when Log_MS_LastCompleted = 'Assign to Close' then 9
			when Log_MS_LastCompleted = 'Doc Signing' then 10
			else 2
		end as MilestoneOrder

	from	#ActiveLoans A 
		inner join emdbuser.LoanSummary ls on LS.XRefID = A.XRefID 
		inner join emdbuser.LOANXDB_S_01 ls01 on ls.XrefId = ls01.XrefId
		inner join emdbuser.LOANXDB_S_02 ls02 on ls.XrefId = ls02.XrefId
		inner join emdbuser.LOANXDB_S_03 ls03 on ls.XrefId = ls03.XrefId
		inner join emdbuser.LOANXDB_S_04 ls04 on ls.XrefId = ls04.XrefId
		inner join emdbuser.LOANXDB_S_05 ls05 on ls.XrefId = ls05.XrefId
		inner join emdbuser.LOANXDB_S_08 ls08 on ls.XrefId = ls08.XrefId
		inner join emdbuser.LOANXDB_S_09 ls09 on ls.XrefId = ls09.XrefId
		inner join emdbuser.LOANXDB_S_10 ls10 on ls.XrefId = ls10.XrefId
		inner join emdbuser.LOANXDB_D_01 ld01 on ls.XrefId = ld01.XrefId 
		inner join emdbuser.LOANXDB_D_02 ld02 on ls.XrefId = ld02.XrefId
		inner join emdbuser.LOANXDB_D_03 ld03 on ls.XrefId = ld03.XrefId
		inner join emdbuser.LOANXDB_D_04 ld04 on ls.XrefId = ld04.XrefId
		left outer join #Employee E on E.employeeID = ls03._CX_FINALOCODE_4
		left outer join #EmployeeCC EC on EC.EmployeeID = E.EmployeeID
		left outer join #EmployeeAndAllManagers2 dem on dem.empid = e.employeeId
		left outer join #Employee EMPMC on empMC.DisplayName  = rtrim(ltrim( _CX_MCNAME_1 ))
		left outer join #Employee EMPLC on empLC.DisplayName  = rtrim(ltrim( _CX_LCNAME_1 ))
		left outer join #Employee SA on sa.employeeid = empmc.salesassistiantid
		left outer join #Employee SB on sb.employeeid = emplc.salesassistiantid
		left outer join #Employee SC on sc.employeeid = e.salesassistiantid

	where 
		(
		
			( @Options = 'locked' and _761 >= '2001-01-01' and _762 > getdate()) or
			( @Options = 'expire' and _762 < getdate()) or
			( @Options = 'float' and  _761 is null ) or
			( @Options = 'all' and  _CX_FUNDDATE_1 is null ) or
			( @Options = 'purchase' and _19 = 'Purchase' ) or
			( @Options = 'refinance' and _19 <> 'Purchase' ) or
			( @Options = 'appNotReturned' and _CX_APPSENT_1 > '2001-01-01' and _CX_APPRCVD_1 IS null ) or
			( @Options = 'aprslNotReceived' and _CX_APPRORDERTRANS_10 > '2001-01-01' and _CX_APPRRECTRANS_10 is null ) or
			( @Options = 'expire3' and ( dbo.DateDiffWeekDay( getdate(), _762 ) < 16 )) or
			( @Options = 'expire2' and ( dbo.DateDiffWeekDay( getdate(), _762 ) < 11 )) or
			( @Options = 'expire1' and ( dbo.DateDiffWeekDay( getdate(), _762)< 6 )) or
			( @Options = 'notRedisclosed' and _761 > _3137 ) or
			( @Options = 'ctc' and _2305 >= '2001-01-01' and Log_MS_LastCompleted <> 'Assign to Close') or
			( @Options = 'UWapprvNotSubmit' and Log_MS_Date_UWDecisionExpected >= '2001-01-01' and 
				coalesce( ld04._CX_CONDITIONSUBMIT_5, ld04._CX_CONDITIONSUBMIT_4, ld04._CX_CONDITIONSUBMIT_3, ld04._CX_CONDITIONSUBMIT_2,
				ld01._CX_CONDITIONSUBMIT_1 ) is null ) or
			( @Options = 'DocSignNotfund' and _748 >= '2001-01-01' and _CX_FUNDDATE_1 is null ) or
			(
				( @Options = 'p2weeks' and _19 = 'Purchase' and ( dbo.DateDiffWeekDay( _CX_CLSSCHED_1, getdate()) < 11 )) and 
				( @Options = 'p2weeks' and _19 = 'Purchase' and ( dbo.DateDiffWeekDay( _763, getdate()) < 11 ))
			) or
			(
				( @Options = 'p1week' and _19 = 'Purchase' and ( dbo.DateDiffWeekDay( getdate(), _CX_CLSSCHED_1 ) < 6 )) or
				( @Options = 'p1week' and _19 = 'Purchase' and ( dbo.DateDiffWeekDay( getdate(), _763 ) < 6 ))
			) or
			(
				( @Options = 'notSubmittedUW' and ( dbo.DateAddWeekDay( 1, _CX_APPRRECTRANS_10 )) < getdate() 
					and (dbo.DateAddWeekDay(1,_cx_apppakcomplete)) < getdate() 
					and _761 is not null -- 761 is lock date								 
		                        AND _19 like '%Refi%' and _2298 is null ) -- _2298 is UW submit date 
			) or  
			( @Options = 'notSubmittedUW' and ( dbo.DateAddWeekDay( 1, _cx_apppakcomplete )) < getdate() and _19 = 'Purchase' and _2298 is null ) or
			( @Options = 'MCLane' and Log_MS_LastCompleted in ( 'Processing', 'Assigned to UW', 'Submittal' )) or
			( @Options = 'LCLane' and Log_MS_LastCompleted in ( 'UW Decision Expected', 'Conditions Submitted to UW', 'Assign to Close' )) or
			( @Options = 'MStarted' and Log_MS_LastCompleted = 'Started' ) or
			( @Options = 'MProcessing' and Log_MS_LastCompleted in ( 'Processing', 'App Fee Collected' )) or
			( @Options = 'MAssignedToUW' and Log_MS_LastCompleted = 'Assigned to UW' ) or
			( @Options = 'MSubmittal' and Log_MS_LastCompleted = 'Submittal' ) or
			( @Options = 'MUWExp' and Log_MS_LastCompleted = 'UW Decision Expected' ) or
			( @Options = 'MCondSubUW' and Log_MS_LastCompleted = 'Conditions Submitted to UW' ) or
			( @Options = 'MApproval' and Log_MS_LastCompleted = 'Approval' ) or
			( @Options = 'MAssignToClose' and Log_MS_LastCompleted = 'Assign to Close' ) or
			( @Options = 'MDocSigning' and Log_MS_LastCompleted = 'Doc Signing' ) or
			( @Options = 'ltv' and (( _2303 > '2000-01-01' and 2301 is null ) or ( _CX_RESTRUCTUREDTI > '2001-01-01' and _cx_restdticomplete <> 'Y' ) or 
				( _CX_RESTRUCTURELTV > '2001-01-01' and _cx_restltvcomplete <> 'Y' ))) or
			( @Options = 'contingency1' and ( dbo.DateDiffWeekDay( getdate(), _CX_CONTINGE_1 ) < 6 )) or
			( @Options = 'contingency2' and ( dbo.DateDiffWeekDay( getdate(), _CX_CONTINGE_1 ) < 13 )) or
			( @Options = 'LoansToDisclose' and (( Log_MS_Date_Processing > '2001-01-01') and _CX_APPSENT_1 is null )) or
			( @Options = 'CondoSubmitted' and _CX_UWCONDOSUB >= '2001-01-01' and _CX_UWCONDOAPPR is null ) or
			( @Options = 'CondoApproved' and _CX_UWCONDOAPPR >= '2001-01-01' ) or
			( @Options = '4506TOrdered' and _CX_4506TORDDTE >= '2001-01-01'	and _CX_4506TRECDDTE is null ) or
			( @Options = '4506TReceived' and _CX_4506TRECDDTE >= '2001-01-01' ) 

		) and 

		-- get users able to use YBR report
		( 
			( @UserName in ( e.Userlogin, empLC.userlogin, empmc.userlogin, sa.userlogin, sb.userlogin, sc.userlogin )) or -- VP, LC, MC, each SA 
			( @UserName in ( select SPLITVALUES from dbo.DelimitedListToVarcharTableVariable( dbo.AllManagers2( dem.empid ), ',' ))) or --MGR
			( @UserName in ( 'smueller','BMercer','dkalinofski','kwoodruff','amaloney','mowen','dmoran','amargin','frankc','mknopf', 
				'bconn','robs','mdye','nathanasiou','rjones','sstephen','slevitt','tgrimm','mpatterson',
				'smcors','ecconley','proos','mchaput','romahoney','rcorro','azimmermann', 'jmavalankar',
				'mhamer','tlangdon','tlangdon','egarner','cstackhouse','cmorgan','jpike','jkorabelnikov'))
		)
	

end




GO
