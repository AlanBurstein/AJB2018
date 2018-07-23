SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [reports].[spGetTitleCompanyReportSummaryByLoanOfficerAndTitleCompany2]  
 
 -- added declare to the below
  
   @UserName varchar( 100 )  ,
   @TitleCompanyName varchar( 100 ),
   @DivisionName varchar( 100 ),
   @CostCenter int,
   @LoanOfficerID int,
   @WarehouseName varchar( 100 ),
   @ChannelName varchar( 100 ) ,
   @StateName varchar( 1000 )  ,
   @LoanNumber varchar( 100 )  ,
   @FundedStartDate datetime  ,
   @FundedEndDate datetime ,
   @TitleOrderedStartDate datetime ,
   @TitleOrderedEndDate datetime ,
    @LoanPurposeName varchar( 100 )  
 
 
 --SET @TitleCompanyName = 'All'
 --SET @LoanOfficerID = 0
 --SET @CostCenter = 0
 --SET @DivisionName = 'All'
 --SET @WarehouseName = 'All'
 --SET @ChannelName = 'All'
 --SET @StateName = 'ALL'
 --SET @LoanNumber = NULL
 --SET @FundedStartDate = '2014-12-01'
 --SET @FundedEndDate = '2014-12-31'
 --SET @TitleOrderedStartDate = NULL
 --SET @TitleOrderedEndDate = NULL
 --SET @LoanPurposeName  = 'All'
 
--IF OBJECT_ID('tempdb..#EmployeeInfo') IS NOT NULL
--	drop table #EmployeeInfo
-- IF OBJECT_ID('tempdb..#LoanPurpose') IS NOT NULL
--	drop table #LoanPurpose
-- IF OBJECT_ID('tempdb..#TitleCompanyName') IS NOT NULL
--	drop table #TitleCompanyName
--IF OBJECT_ID('tempdb..#States') IS NOT NULL
--	drop table #States
-- IF OBJECT_ID('tempdb..#TitleCompanyInfo') IS NOT NULL
--	drop table #TitleCompanyInfo
--IF OBJECT_ID('tempdb..#ytdInfo') IS NOT NULL
--	drop table #ytdInfo
--IF OBJECT_ID('tempdb..#ytdResults') IS NOT NULL
--	drop table #ytdResults
-- IF OBJECT_ID('tempdb..#OfficeInfo') IS NOT NULL
--	drop table #OfficeInfo
-- IF OBJECT_ID('tempdb..#TitleCompanyMerge') IS NOT NULL
--	drop table #TitleCompanyMerge

	
  as  
  
/*  
  
----------------------------------------------------------------------------------------------------------------------------------  
 who when  what  
----------------------------------------------------------------------------------------------------------------------------------  
 sethm 11/29/13 initial rev of proc  
 sethm 02/17/14 added jroda to report
 mava 12-30-11 added jmavalankar to report and added fields EmployeeEmail, EmployeePhone,   
*/  
  
begin  
  
 set nocount on  
 set transaction isolation level read uncommitted  
   
 -- used for storing employees  
 create table #EmployeeInfo (   
  EmployeeID int not null,  
  EmployeeName varchar( 100 ) null,
  EmployeePhone varchar( 25) null, --added
  EmployeeEmail varchar(100) null --added
 )
 
 -- -- used for storing employees banch info --added  
 --create table #OfficeInfo (    --added  
 -- EmployeeID int not null,  --added  
 -- EmployeeStartDate date not null,  --added 
 -- EmployeeCity varchar( 100) null,--added  
 -- EmployeeState varchar(2) null--added  
 --)  --added  
 
   
 -- used for storing loan purpose options  
 create table #LoanPurpose (  
  LoanPurposeName varchar( 100 ) null  
 )  
  
-- used for storing title company names added
   create table #TitleCompanyName (   -- added
  TitleCompanyName varchar( 100 ) null  -- added
 )  -- added
 
 
 -- used for storing states  
 create table #States (  
  StateName varchar( 100 ) null  
 )  
   
 -- create temp indexes  
 create index idx_1 on #EmployeeInfo ( EmployeeID )   
 create index idx_1 on #LoanPurpose ( LoanPurposeName )  
  
 -- declare misc variables  
 declare @TotalLoanUnits int  
 declare @TotalTitleTurnaroundTime int  
 declare @TotalTitleTurnaroundLoans money  
   
  -- determine whether user can view this report  
 if @UserName not in ( 'smueller', 'nejohnson', 'hgordon', 'dgorman', 'nathanasiou', 'johne', 'bcarrara', 'dmoran', 'jroda', 'jmavalankar' )  
 begin  
  return 0  
 end  
  
 -- fix loan number field  
 if ltrim( rtrim( isnull( @LoanNumber, '' ))) = ''  
 begin  
  set @LoanNumber = null  
 end  
  
 -- validate funded start and end dates  
 if @FundedStartDate is null or @FundedEndDate is null  
 begin  
  set @FundedStartDate = null  
  set @FundedEndDate = null  
 end  
   
 -- validate title ordered start and end dates  
 if @TitleOrderedStartDate is null or @TitleOrderedEndDate is null  
 begin  
  set @TitleOrderedStartDate = null  
  set @TitleOrderedEndDate = null
 end  
   
 -- determine employee info to include  
 if @LoanOfficerID <> 0  
 begin  
  insert #EmployeeInfo ( EmployeeID )  
  values ( @LoanOfficerID )  
 end  
 else if @CostCenter <> 0  
 begin  
  insert #EmployeeInfo ( EmployeeID )  
  select E.EmployeeID  
  from admin.corp.Employee E, admin.corp.CostCenter C  
  where C.CostCenter = @CostCenter and  
   E.CostCenterID = C.CostCenterID and  
   E.Active = 1  
 end  
 else if @DivisionName = 'Retail'  
 begin  
  insert #EmployeeInfo ( EmployeeID )  
  select E.EmployeeID  
  from admin.corp.Employee E, admin.corp.CostCenter C  
  where E.CostCenterID = C.CostCenterID and  
   ( C.CostCenterName not like '%direct%' or CostCenter <> 3003 ) and  
   E.Active = 1
 end  
 else if @DivisionName = 'Direct'  
 begin  
  insert #EmployeeInfo ( EmployeeID )  
  select E.EmployeeID  
  from admin.corp.Employee E, admin.corp.CostCenter C  
  where E.CostCenterID = C.CostCenterID and  
   C.CostCenterName like '%direct%' and  
   E.Active = 1
 end  
 else if @DivisionName = 'Online'  
 begin  
  insert #EmployeeInfo ( EmployeeID )  
  select E.EmployeeID  
  from admin.corp.Employee E, admin.corp.CostCenter C  
  where E.CostCenterID = C.CostCenterID and  
   C.CostCenter = 3003 and  
   E.Active = 1  
 end  
 else  
 begin  
  insert #EmployeeInfo ( EmployeeID )  
  select E.EmployeeID  
  from admin.corp.Employee E  
 end  
  
 -- get the employee name  
 update #EmployeeInfo  
 set EmployeeName = DisplayName  
 from #EmployeeInfo EI  
  inner join admin.corp.Employee E on EI.EmployeeID = E.EmployeeID
  
  -- get additional employee info added
  update #EmployeeInfo  
 set EmployeePhone = isnull(OfficePhone, ''), EmployeeEmail = Email  
 from #EmployeeInfo EI  
  inner join admin.corp.Employee E on EI.EmployeeID = E.EmployeeID  
  
  -- get more additional employee info (start date) and office info
  select E.employeeId as EmployeeID, cast(E.StartDate as date) as EmployeeStartDate, o.City as EmployeeCity, o.State as EmployeeState
 into #OfficeInfo
  from admin.corp.Employee E
  inner join admin.corp.Office O
  on O.officeId = e.officeId
  
 -- add loan purpose options  
 if @LoanPurposeName = 'All'  
 begin  
  insert #LoanPurpose ( LoanPurposeName ) values ( '' ), ( 'Cash-Out Refinance' ), ( 'ConstructionOnly' ), ( 'ConstructionToPerman' ),   
   ( 'NoCash-Out Refinance' ), ( 'Other' ), ( 'Purchase' )  
 end  
 else if @LoanPurposeName = 'Purchase'  
 begin  
  insert #LoanPurpose ( LoanPurposeName ) values ( 'Purchase' )  
 end  
 else if @LoanPurposeName = 'Refinance'  
 begin  
  insert #LoanPurpose ( LoanPurposeName ) values ( 'Cash-Out Refinance' ), ( 'NoCash-Out Refinance' )  
 end  
 else  
 begin  
  insert #LoanPurpose ( LoanPurposeName ) values ( '' ), ( 'ConstructionOnly' ), ( 'ConstructionToPerman' ), ( 'Other' )  
 end   
  
 -- determine which states to view  
 if @StateName = 'ALL'  
 begin  
  insert #States ( StateName )  
  select distinct _14 as StateName   
  from [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_01
  where _14 <> ''  
 end  
 else  
 begin  
  insert #States ( StateName )  
  select distinct ColumnValue  
  from dbo.fnSplitDelimitedList ( @StateName, ',' )  
 end 

 -- determine which title company names to view 
 if @TitleCompanyName = 'ALL'
 begin
	insert #TitleCompanyName (TitleCompanyName)
	select distinct TitleCompanyName as TitleCompanyName
	from [GRCHILHQ-SQ-03].LoanWarehouse.dbo.TitleCompanyMapping
	where TitleCompanyName <> ''
end
else
begin
insert #TitleCompanyName ( TitleCompanyName )
select distinct ColumnValue
from dbo.fnSplitDelimitedList ( @TitleCompanyName, ',' )
end

 -- determine ytd units and volume
 
 select E.EmployeeID, S.StateName, --isnull( T2.TitleCompanyName, '(blank)' ) as TitleCompanyName,  
  --cast( 0 as int ) as EmployeeLoanUnits,  
  sum( LS.TotalLoanAmount ) as LoanVolume,  
  --sum( case when _CX_TITLEORDER_1 is not null and _CX_TITLERCVD_1 is not null then 1 else 0 end ) as TitleTurnaroundLoans,  
  --sum( case when _CX_TITLEORDER_1 is not null and _CX_TITLERCVD_1 is not null then datediff( day, _CX_TITLEORDER_1, _CX_TITLERCVD_1 ) else 0 end ) as TitleTurnaroundTime,  
  count( * ) as LoanUnits   
 into #ytdInfo  
 from [GRCHILHQ-SQ-03].emdb.emdbuser.LoanSummary LS  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_D_01 D01 on LS.XRefID = D01.XRefID  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_01 S01 on LS.XRefID = S01.XRefID  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_02 S02 on LS.XRefID = S02.XRefID  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_03 S03 on LS.XRefID = S03.XRefID  
  inner join #EmployeeInfo E on E.EmployeeID = S03._CX_FINALOCODE_4  
  inner join #LoanPurpose LP on LP.LoanPurposeName = S01._19  
  inner join #States S on _14 = S.StateName
  inner join #OfficeInfo O on E.EmployeeID = O.EmployeeID 
  left outer join [GRCHILHQ-SQ-03].LoanWarehouse.dbo.TitleCompanyMapping T on S02._VEND_X398 = T.ABANumber and S01._VEND_X399 = T.AccountNumber  
  inner join #TitleCompanyName T2 on T2.TitleCompanyName = T.TitleCompanyName -- added
 where LS.LoanFolder not in ( 'Samples', '(Trash)', 'Archive' ) and   
  (   
   ( @FundedStartDate is not null and _CX_FUNDDATE_1 is not null and (YEAR(_CX_FUNDDATE_1) = YEAR(@FundedStartDate)) or  
   ( @FundedStartDate is null )  
  ) and      
 -- isnull( T.TitleCompanyName, '(blank)' ) = case when @TitleCompanyName = 'All' then isnull( T.TitleCompanyName, '(blank)' ) else @TitleCompanyName end and  
   _VEND_X200 = case when @WarehouseName = 'All' then _VEND_X200 else @WarehouseName end and  
  _2626 = case when @ChannelName = 'All' then _2626 else @ChannelName end and  
  LoanNumber = case when @LoanNumber is not null then @LoanNumber else LoanNumber end and  
  (   
   ( @TitleOrderedStartDate is not null and _CX_TITLEORDER_1 is not null and _CX_TITLEORDER_1 between @TitleOrderedStartDate and @TitleOrderedEndDate ) or  
   ( @TitleOrderedStartDate is null )  
  ))   
 group by E.EmployeeID, S.StateName, isnull( T2.TitleCompanyName, '(blank)' )  
  
 select EmployeeID, StateName, SUM(LoanVolume) as [YTD LoanVolume], SUM(LoanUnits) as [YTD LoanUnits]
 INTO #ytdResults
 from #ytdInfo group by EmployeeID, StateName ORDER BY EmployeeID
   
 -- get the results of the query  
 select E.EmployeeID, S.StateName, E.EmployeeName,O.EmployeeCity,O.EmployeeState, E.EmployeePhone, E.EmployeeEmail, O.EmployeeStartDate, isnull( T2.TitleCompanyName, '(blank)' ) as TitleCompanyName,  
  cast( 0 as int ) as EmployeeLoanUnits,  
  sum( LS.TotalLoanAmount ) as LoanVolume,
  yr.[YTD LoanUnits],
  yr.[YTD LoanVolume], 
  sum( case when _CX_TITLEORDER_1 is not null and _CX_TITLERCVD_1 is not null then 1 else 0 end ) as TitleTurnaroundLoans,  
  sum( case when _CX_TITLEORDER_1 is not null and _CX_TITLERCVD_1 is not null then datediff( day, _CX_TITLEORDER_1, _CX_TITLERCVD_1 ) else 0 end ) as TitleTurnaroundTime,  
  count( * ) as LoanUnits   
 into #TitleCompanyInfo  
 from [GRCHILHQ-SQ-03].emdb.emdbuser.LoanSummary LS  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_D_01 D01 on LS.XRefID = D01.XRefID  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_01 S01 on LS.XRefID = S01.XRefID  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_02 S02 on LS.XRefID = S02.XRefID  
  inner join [GRCHILHQ-SQ-03].emdb.emdbuser.LOANXDB_S_03 S03 on LS.XRefID = S03.XRefID  
  inner join #EmployeeInfo E on E.EmployeeID = S03._CX_FINALOCODE_4  
  inner join #LoanPurpose LP on LP.LoanPurposeName = S01._19  
  inner join #States S on _14 = S.StateName
  inner join #OfficeInfo O on E.EmployeeID = O.EmployeeID 
  left outer join [GRCHILHQ-SQ-03].LoanWarehouse.dbo.TitleCompanyMapping T on S02._VEND_X398 = T.ABANumber and S01._VEND_X399 = T.AccountNumber  
  inner join #TitleCompanyName T2 on T2.TitleCompanyName = T.TitleCompanyName -- added
  inner join #ytdResults yr ON yr.EmployeeID = E.EmployeeID and yr.StateName = S.StateName
 where LS.LoanFolder not in ( 'Samples', '(Trash)', 'Archive' ) and   
  (   
   ( @FundedStartDate is not null and _CX_FUNDDATE_1 is not null and _CX_FUNDDATE_1 between @FundedStartDate and @FundedEndDate ) or  
   ( @FundedStartDate is null )  
  ) and      
 -- isnull( T.TitleCompanyName, '(blank)' ) = case when @TitleCompanyName = 'All' then isnull( T.TitleCompanyName, '(blank)' ) else @TitleCompanyName end and  
   _VEND_X200 = case when @WarehouseName = 'All' then _VEND_X200 else @WarehouseName end and  
  _2626 = case when @ChannelName = 'All' then _2626 else @ChannelName end and  
  LoanNumber = case when @LoanNumber is not null then @LoanNumber else LoanNumber end and  
  (   
   ( @TitleOrderedStartDate is not null and _CX_TITLEORDER_1 is not null and _CX_TITLEORDER_1 between @TitleOrderedStartDate and @TitleOrderedEndDate ) or  
   ( @TitleOrderedStartDate is null )  
  )   
 group by E.EmployeeID, S.StateName, E.EmployeeName, O.EmployeeCity, O.EmployeeState, E.EmployeePhone, E.EmployeeEmail, O.EmployeeStartDate, isnull( T2.TitleCompanyName, '(blank)' ), yr.[YTD LoanUnits], yr.[YTD LoanVolume] 
 
 
 -- combine tile company names in to one field
 
  SELECT DISTINCT TOP 3000   
		a.EmployeeID, 
		a.StateName,        
      STUFF(
		(SELECT ', ' + TitleCompanyName
		FROM #TitleCompanyInfo
		WHERE EmployeeID = a.EmployeeID and StateName = a.StateName
			FOR XML PATH ('')),1,1,'') AS TitleCompanyNamesCombined	     
INTO #TitleCompanyMerge
FROM #TitleCompanyInfo a
JOIN #TitleCompanyInfo b ON b.EmployeeID = a.EmployeeID
GROUP BY a.EmployeeID, a.StateName, a.TitleCompanyName
ORDER BY a.EmployeeID
 
  
 -- get the total units  
 select @TotalLoanUnits = sum( LoanUnits ) from #TitleCompanyInfo  
   
 -- get the total title turnaround times and loan units  
 select @TotalTitleTurnaroundTime = sum( TitleTurnaroundTime ),  
  @TotalTitleTurnaroundLoans = sum( TitleTurnaroundLoans )  
 from #TitleCompanyInfo  
  
 -- update employee loan units  
 update #TitleCompanyInfo  
 set EmployeeLoanUnits = T2.EmployeeLoanUnits  
 from #TitleCompanyInfo T1,  
  (  
   select EmployeeID, sum( LoanUnits ) as EmployeeLoanUnits  
   from #TitleCompanyInfo  
   group by EmployeeID  
  ) T2  
 where T1.EmployeeID = T2.EmployeeID  
   
 -- and return the results  
 select tci.EmployeeID, EmployeeName, tci.StateName, EmployeeCity + ', ' + EmployeeState as [EmployeeLocation],EmployeeStartDate, EmployeePhone, EmployeeEmail, TitleCompanyName, LoanVolume, [YTD LoanVolume], LoanUnits,[YTD LoanUnits],  
  ( LoanUnits + 0.0 ) / ( EmployeeLoanUnits + 0.0 ) as EmployeePercentageOfTotal,   
  ( LoanUnits + 0.0 ) / ( @TotalLoanUnits + 0.0 ) as PercentageOfTotal,  
  case when TitleTurnaroundLoans > 0 then ( TitleTurnaroundTime + 0.0 ) / ( TitleTurnaroundLoans + 0.0 ) else 0 end as AverageTitleTurnaroundTime,  
  case when @TotalTitleTurnaroundLoans > 0 then ( @TotalTitleTurnaroundTime + 0.0 ) / ( @TotalTitleTurnaroundLoans + 0.0 ) else 0 end as TotalAverageTitleTurnaroundTime  
 from #TitleCompanyInfo tci
 --INNER JOIN #TitleCompanyMerge tcm ON tcm.EmployeeID = tci.EmployeeID  
 order by 2, 3  
   
 end   --comment out when testing
GO
