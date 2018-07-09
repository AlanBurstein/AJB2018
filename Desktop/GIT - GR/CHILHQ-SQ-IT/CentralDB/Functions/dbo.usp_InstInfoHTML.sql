SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[usp_InstInfoHTML]
(
@InstanceName varchar(128)
)
returns nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- exec [dbo].[usp_InstInfo] 'GRCHILHQ-SQ-03'
	-- exec [dbo].[usp_InstInfoHTML] 'GRCHILHQ-SQ-03'

--Instance info
declare @output nvarchar(max);
set @output = (
SELECT '<TABLE WIDTH="100%"><TR><TD>Server</TD><TD>' + y.ServerName + '</TD></TR>' +
		'<TR><TD>Instance</TD><TD>' + y.InstanceName + '</TD></TR>' +
		'<TR><TD>IP Address</TD><TD>'	 +  y.IPAddress + '</TD></TR>' +
		'<TR><TD>Port</TD><TD>'	 + 	   y.Port  + '</TD></TR>' +
		'<TR><TD>Version</TD><TD>'	 + 	   y.SQLVersion + '</TD></TR>' + 
		'<TR><TD>Path Level</TD><TD>'	 + 	   y.SQLPatchLevel + '</TD></TR>' + 
		'<TR><TD>Edition</TD><TD>'	 + 	   y.SQLEdition + '</TD></TR>'  +
		'<TR><TD>Verion Number</TD><TD>'	 + 	   y.SQLVersionNo + '</TD></TR>' + 
		'<TR><TD>Collation</TD><TD>'	 + 	   y.Collation + '</TD></TR>' +  
		'<TR><TD>RootDirectory</TD><TD>'	 + 	   y.RootDirectory + '</TD></TR>' +  
           '<TR><TD>DefaultDataPath</TD><TD>'	 +        y.DefaultDataPath + '</TD></TR>' +  
		'<TR><TD>DefaultLogPath</TD><TD>'	 + 	   y.DefaultLogPath + '</TD></TR>' +  
		'<TR><TD>ErrorLogPath</TD><TD>'	 + 	   y.ErrorLogPath + '</TD></TR>' +  
		'<TR><TD>IsClustered</TD><TD>'	 + 	   cast(y.IsClustered as nvarchar(10)) + '</TD></TR>' +   
		'<TR><TD>IsSingleUser</TD><TD>'	 + 	   cast(y.IsSingleUser  as nvarchar(10)) + '</TD></TR>' +  
		--'<TR><TD>Instancer</TD><TD>'	 + 	   cast(y.IsAlwaysOnEnabled  as nvarchar(10)) + '</TD></TR>' +  
		'<TR><TD>TCPEnabled</TD><TD>'	 + 	   cast(y.TCPEnabled  as nvarchar(10)) + '</TD></TR>' +  
           '<TR><TD>NamedPipesEnabled</TD><TD>'	 +        cast(y.NamedPipesEnabled   as nvarchar(10)) + '</TD></TR></TABLE>' 
		--	   ,y.AlwaysOnStatus, y.MaxMemInMB, y.MinMemInMB, y.MaxDOP, y.NoOfUsrDBs, y.NoOfJobs, y.NoOfLnkSvrs, y.NoOfLogins, 
		--		  y.NoOfTriggers, y.NoOfAvailGrps, y.[AvailGrps], y.[IsXTPSupported], y.[FilFactor],  y.[ActiveNode], y.[ClusterNodeNames], y.DateAdded
FROM     (SELECT InstanceName, MAX(DateAdded) AS Rundate
                  FROM      Inst.InstanceInfo
                  GROUP BY InstanceName) AS x INNER JOIN
                  Inst.InstanceInfo AS y ON x.Rundate = y.DateAdded AND x.InstanceName = y.InstanceName AND y.InstanceName = @InstanceName
)

return @output
END






GO
