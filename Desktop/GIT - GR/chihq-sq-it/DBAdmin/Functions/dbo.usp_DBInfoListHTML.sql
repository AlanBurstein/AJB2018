SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE Function [dbo].[usp_DBInfoListHTML](@InstanceName VARCHAR(128))
returns nvarchar(max)
AS
     BEGIN
	 declare @output nvarchar(max) 
         -- SET NOCOUNT ON added to prevent extra result sets from
         -- interfering with SELECT statements.
	    /*
		declare @output nvarchar(max)
		select [dbo].[usp_DBInfoListHTML]( 'aws-sql-02p')
		
		, @output=@output -- 'GRCHILHQ-SQ-03'
		select @output
	    exec [dbo].[usp_DBInfo] 'GRCHILHQ-SQ-03','dbadmin'
	    
		
		*/

         --Instance info
	    set @output = '<TABLE WIDTH="100%">'
	    + '<TR><TH>Database</TH>'
	    + '<TH>Status</TH>' 
	    + '<TH>Owner</TH>'
	    + '<TH>Create Date</TH>'
	    + '<TH>Size MB</TH>'
	    + '<TH>Available Space MB</TH>'
	    +'<TH>Space Used MB</TH>'
	    +'<TH>Perc Free</TH>'
	    + '<TH>Application</TH>'
	    + '<TH>Purpose</TH>'
	    + '<TH>Comments</TH></TR>'

	    set @output = @output + replace(replace(isnull((
         SELECT --y.InstanceName,
                '<TR><TD>' +y.DBName+ '</TD>' +
                '<TD>' +y.DBStatus+ '</TD>' +
                '<TD>' +y.DBOwner+ '</TD>' +
               '<TD>' + cast(y.DBCreateDate as varchar(30))+ '</TD>' +
                '<TD>' +cast(y.DBSizeInMB as varchar(30))+ '</TD>' +
               '<TD>' + cast(y.DBSpaceAvailableInMB as varchar(30))+ '</TD>' +
                '<TD>' +cast(y.DBUsedSpaceInMB as varchar(30))+ '</TD>' +
                '<TD>' +cast(y.DBPctFreeSpace as varchar(30))+ '</TD>' +
  /*              ,y.DBDataSpaceUsageInMB,
                y.DBIndexSpaceUsageInMB,
                y.Collation,
                y.RecoveryModel,
                y.CompatibilityLevel,
                y.AutoShrink,
                y.AutoUpdateStatisticsEnabled,
                y.IsReadCommittedSnapshotOn,
                y.IsFullTextEnabled,
                y.BrokerEnabled,
                y.ReadOnly,
                y.IsDatabaseSnapshot,
                y.IsMirroringEnabled,
                y.MirroringPartnerInstance,
                y.MirroringStatus,
                y.[HasFileInCloud],
                y.MirroringSafetyLevel,
                y.ReplicationOptions,
                y.AvailabilityGroupName,
                y.NoOfTbls,
                y.NoOfViews,
                y.NoOfStoredProcs,
                y.NoOfUDFs,
                y.NoOfLogFiles,
                y.NoOfFileGroups,
                y.NoOfUsers,
                y.NoOfDBTriggers,
                y.DateAdded,
                y.[AutoClose],
                y.[HasMemoryOptimizedObjects],
                y.[MemoryAllocatedToMemoryOptimizedObjectsInKB],
                y.[MemoryUsedByMemoryOptimizedObjectsInKB],
                CASE
                    WHEN y.LastBackupDate = '1/1/0001 12:00:00 AM'
                    THEN 'No Full Backup Taken Yet'
                    ELSE y.LastBackupDate
                END AS FullBackup,
                CASE
                    WHEN y.LastDifferentialBackupDate = '1/1/0001 12:00:00 AM'
                    THEN 'No Diff Backup Taken Yet'
                    ELSE y.LastDifferentialBackupDate
                END AS DiffBackup,
                CASE
                    WHEN y.LastLogBackupDate = '1/1/0001 12:00:00 AM'nn
                    THEN 'No Log Backup Taken Yet'
                    ELSE y.LastLogBackupDate
                END AS LogBackup,
                CASE
                    WHEN y.LastGoodDBCCCheckDB = '1900-01-01 00:00:00.000'
                    THEN 'DBCC Not Run Yet'
                    ELSE y.LastGoodDBCCCheckDB
                END AS LastGoodDBCCCheckDB

   */      
			 '<TD>' +isnull(dbx.ApplID,'No Application')+ '</TD>' +
			 '<TD>' +isnull(dbx.Purpose,'No Purpose')+ '</TD>' +
			 '<TD>' +isnull(dbx.Comments,'No Comments')+ '</TD>' + '</TR>'
		  FROM
         (
             SELECT InstanceName,
                    MAX(DateAdded) AS Rundate
             FROM DB.DatabaseInfo
             GROUP BY InstanceName
         ) AS x
         INNER JOIN DB.DatabaseInfo AS y ON x.Rundate = y.DateAdded
                                            AND x.InstanceName = y.InstanceName
                                            AND y.InstanceName = @InstanceName
         left join DB.DatabaseInfoExt dbx on dbx.DBName = y.DBName
         --union all
	    --select '</TABLE>' ) 
	    for xml path('')),''),'&lt;','<'),'&gt;','>');
	   set @output = @output + '</TABLE>'
	   return @output;
	END;


GO
