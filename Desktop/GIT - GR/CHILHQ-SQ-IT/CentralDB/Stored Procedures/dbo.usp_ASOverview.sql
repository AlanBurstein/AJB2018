SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ASOverview]
(
@Environment Varchar(128),
@ASVersion varchar(128)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--Parsing values into table
Select Item
into #Environ_List
From
dbo.DelimitedSplit8K(@Environment,',')

Select Item
into #SQL_Name_List
From
dbo.DelimitedSplit8K(@ASVersion,',')


--Serverinfo View
Select z.InstanceName, z.ASVersion, z.ASPatchLevel, z.IsSPUpToDateOnAS,z.ASEdition, z.NoOfDBs, v.Environment from (
select  y.* from(
select InstanceName, Max(DateAdded) as Rundate 
from [CentralDB].[AS].[SSASInfo]
Group BY InstanceName) x
Join [CentralDB].[AS].[SSASInfo] y ON x.Rundate = y.DateAdded and X.InstanceName = y.InstanceName) z
inner join(
select Distinct ServerName, InstanceName, Environment, Description, BusinessOwner from  [CentralDB].[Svr].[ServerList]) v ON Z.InstanceName = V.InstanceName
inner join #Environ_List as EnvironList on v.Environment = EnvironList.item
inner join #SQL_Name_List as SQLList on Z.ASVersion = SQLList.item
Order by InstanceName
END


GO
