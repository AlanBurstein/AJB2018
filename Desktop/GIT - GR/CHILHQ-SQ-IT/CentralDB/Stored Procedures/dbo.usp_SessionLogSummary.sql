SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[usp_SessionLogSummary]
AS
     BEGIN
         DECLARE @lrd DATETIME;
         DECLARE @srd DATETIME;
         SELECT @lrd = isnull(SessionDate, '1900-01-01')
         FROM [Inst].[SessionLogSummary];
         SET @lrd = isnull(@lrd, '1900-01-01');
         SET @srd = GETDATE();
         SELECT @lrd;
         SELECT @srd;
         INSERT INTO [Inst].[SessionLogSummary]
                SELECT [servername],
                       [Instance],
                       [databaseid],
                       [databasename],
                       [sessionloginname],
                       [ntusername],
                       [ntdomainname],
                       [hostname],
                       [applicationname],
                       [loginname],
                       CAST(DATEPART(YYYY, [EndTime]) AS VARCHAR)+'-'+CAST(DATEPART(mm, [EndTime]) AS VARCHAR)+'-'+CAST(DATEPART(dd, [EndTime]) AS VARCHAR)+' '+CAST(DATEPART(HH, [EndTime]) AS VARCHAR)+':00:00.000' AS [EndTime],
                       SUM(reads) AS Reads,
                       SUM(writes) AS Writes,
                       SUM(cpu) AS CPU,
                       SUM(duration) AS Duration,
                       SUM([LoginCount]) AS [LoginCount]
                FROM [Inst].[SessionLog]
                WHERE endtime BETWEEN @lrd AND @srd
                GROUP BY [servername],
                         [Instance],
                         [databaseid],
                         [databasename],
                         [sessionloginname],
                         [ntusername],
                         [ntdomainname],
                         [hostname],
                         [applicationname],
                         [loginname],
                         CAST(DATEPART(YYYY, [EndTime]) AS VARCHAR)+'-'+CAST(DATEPART(mm, [EndTime]) AS VARCHAR)+'-'+CAST(DATEPART(dd, [EndTime]) AS VARCHAR)+' '+CAST(DATEPART(HH, [EndTime]) AS VARCHAR)+':00:00.000';
         DELETE FROM [Inst].[SessionLog]
         WHERE endtime BETWEEN @lrd AND @srd;
     END;
GO
