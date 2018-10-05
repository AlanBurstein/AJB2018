SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [metadata].[usp_diskUsageByDB]
    @summary      BIT = 1,
    @dbDetails    BIT = 1,
    @tableDetails BIT = 1
/*

Important - These two global temp tables are available after the stored proc is run:
##dbSizeInfo
##tableSizeInfo

SELECT db.* FROM ##dbSizeInfo    AS db;
SELECT t.*  FROM ##tableSizeInfo AS t;
*/
AS 
BEGIN
SET NOCOUNT ON;

-- 1. Create and populate temp table (#dbSizeInfo) with DB file info
  BEGIN
    IF OBJECT_ID('tempdb..##dbSizeInfo')    IS NOT NULL DROP TABLE ##dbSizeInfo;
    IF OBJECT_ID('tempdb..##tableSizeInfo') IS NOT NULL DROP TABLE ##tableSizeInfo;
    
    SELECT TOP (0)
      db         = CAST('' AS VARCHAR(100)), 
    	typeDesc   = t.type_desc, 
      [size(MB)] = t.size/128.,
      t.data_space_id
    INTO   ##dbSizeInfo
    FROM   sys.database_files AS t;

    -- source: https://stackoverflow.com/questions/7892334/get-size-of-all-tables-in-database
    SELECT TOP (0)
       DbName        = CAST('' AS VARCHAR(100)),
       SchemaName    = s.name,
       TableName     = t.name,
       RowCounts     = p.rows,
       TotalSpaceKB  = SUM(a.total_pages)*8, 
       TotalSpaceMB  = CAST(ROUND(((SUM(a.total_pages)*8)/1024.00),2) AS DECIMAL(36,2)),
       UsedSpaceKB   = SUM(a.used_pages) * 8, 
       UsedSpaceMB   = CAST(ROUND(((SUM(a.used_pages)*8)/1024.00),2) AS DECIMAL(36,2)), 
       UnusedSpaceKB = (SUM(a.total_pages)-SUM(a.used_pages)) * 8,
       UnusedSpaceMB = CAST(ROUND(((SUM(a.total_pages)-SUM(a.used_pages))*8)/1024.00,2)
    		                 AS DECIMAL(36,2))
    INTO      ##tableSizeInfo
    FROM      sys.tables           AS t
    JOIN      sys.indexes          AS i ON  t.object_id = i.object_id
    JOIN      sys.partitions       AS p ON  i.object_id = p.OBJECT_ID 
                                        AND i.index_id  = p.index_id
    JOIN      sys.allocation_units AS a ON  p.partition_id = a.container_id
    LEFT JOIN sys.schemas          AS s ON  t.schema_id    = s.schema_id
    WHERE     t.Name NOT LIKE 'dt%' 
    AND       t.is_ms_shipped = 0
    AND       i.OBJECT_ID > 255 
    GROUP BY  t.Name, s.Name, p.Rows
    ORDER BY  s.Name, t.Name;

    DECLARE @sql NVARCHAR(4000) = '
      IF '+REPLICATE(@dbDetails|@summary,1)+'=1
      INSERT ##dbSizeInfo
      SELECT "?", typeDesc = type_desc, [size(MB)] = size/128., data_space_id
      FROM   ?.sys.database_files
      WHERE  state_desc = ''ONLINE'';

      IF '+REPLICATE(@tableDetails ,1)+'=1
      INSERT ##tableSizeInfo
      SELECT 
         DbName        = "?",
         SchemaName    = s.name,
         TableName     = t.name,
         RowCounts     = p.rows,
         TotalSpaceKB  = SUM(a.total_pages)*8, 
         TotalSpaceMB  = CAST(ROUND(((SUM(a.total_pages)*8)/1024.00),2) AS DECIMAL(36,2)),
         UsedSpaceKB   = SUM(a.used_pages) * 8, 
         UsedSpaceMB   = CAST(ROUND(((SUM(a.used_pages)*8)/1024.00),2) AS DECIMAL(36,2)), 
         UnusedSpaceKB = (SUM(a.total_pages)-SUM(a.used_pages)) * 8,
         UnusedSpaceMB = CAST(ROUND(((SUM(a.total_pages)-SUM(a.used_pages))*8)/1024.00,2)
      		                 AS DECIMAL(36,2))
      FROM      ?.sys.tables           AS t
      JOIN      ?.sys.indexes          AS i ON  t.object_id = i.object_id
      JOIN      ?.sys.partitions       AS p ON  i.object_id = p.OBJECT_ID 
                                            AND i.index_id  = p.index_id
      JOIN      ?.sys.allocation_units AS a ON  p.partition_id = a.container_id
      LEFT JOIN ?.sys.schemas          AS s ON  t.schema_id    = s.schema_id
      WHERE     t.Name NOT LIKE ''dt%'' 
      AND       t.is_ms_shipped = 0
      AND       i.OBJECT_ID > 255 
      GROUP BY  t.Name, s.Name, p.Rows;';

    EXEC sp_msForEachDB @command1=@sql;
  END;

PRINT @sql;
	  
-- 1. Summary output: size of ea. DB ranked
  IF @summary = 1
  SELECT 
    dbs.db,
    dbs.[TotalSize(MB)],
    rnk = ROW_NUMBER() OVER (ORDER BY dbs.[TotalSize(MB)] DESC)
  FROM
  (
    SELECT   db.db,[TotalSize(MB)] = SUM(db.[size(MB)])
    FROM     ##dbSizeInfo AS db
    GROUP BY db.db 
  ) AS dbs
  ORDER BY dbs.[TotalSize(MB)] DESC;

-- 2. DB Details output
  IF @dbDetails = 1
  SELECT 
    db.db,
    db.data_space_id,
    db.typeDesc,
    db.[size(MB)]
  FROM ##dbSizeInfo AS db
  ORDER BY db.db, data_space_id;

-- 3. DB Details output
  IF @tableDetails = 1
  SELECT 
    t.DbName,
    t.SchemaName,
    t.TableName,
    t.RowCounts,
    t.TotalSpaceKB,
    t.TotalSpaceMB,
    t.UsedSpaceKB,
    t.UsedSpaceMB,
    t.UnusedSpaceKB,
    t.UnusedSpaceMB 
  FROM ##tableSizeInfo AS t;
END
GO
