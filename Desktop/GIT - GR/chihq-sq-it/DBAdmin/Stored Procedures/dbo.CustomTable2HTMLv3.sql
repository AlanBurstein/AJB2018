SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CustomTable2HTMLv3] (
@TABLENAME  NVARCHAR(500),
@OUTPUT   NVARCHAR(MAX) OUTPUT,
@TBL_STYLE NVARCHAR(1024) = '',
@ALIGNMENT INT =0 )
AS
 
 
-- Author:        Ian Atkin (ian.atkin@ict.ox.ac.uk)
 
-- Description
--                      Stored Procedure to take an arbitraty temporary table and return
--                      the equivalent HTML string .
 
-- Version History
--                1.0 - v1 Release For Symantec Connect
--				  3.0 - v3 Release for Symantec connect. 
--						Table to be outputed both horizonally and vertically. IsNull used
--						on cell value output to prevent NULLs creaping into HTML string

  
-- @exec_str stores the dynamic SQL Query
-- @ParmDefinition stores the parameter definition for the dynamic SQL
DECLARE @exec_str  NVARCHAR(MAX)
DECLARE @ParmDefinition NVARCHAR(500)
 
 

IF @ALIGNMENT=0 
BEGIN
--We need to use Dynamic SQL at this point so we can expand the input table name parameter
SET @exec_str= N'
DECLARE @exec_str  NVARCHAR(MAX)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @DEBUG INT
SET @DEBUG=0

IF @DEBUG=1 Print ''Table2HTML -Horizontal alignment''
 
--Make a copy of the original table adding an indexing column. We need to add an index column to the table to facilitate sorting so we can maintain the
--original table order as we iterate through adding HTML tags to the table fields.
--New column called CustColHTML_ID (unlikely to be used by someone else!)
--
 
select CustColHTML_ID=0,* INTO #CustomTable2HTML FROM ' + @TABLENAME + '
IF @DEBUG=1 PRINT ''Created temporary custom table''

--Now alter the table to add the auto-incrementing index. This will facilitate row finding
DECLARE @COUNTER INT
SET @COUNTER=0
UPDATE #CustomTable2HTML SET @COUNTER = CustColHTML_ID=@COUNTER+1
IF @DEBUG=1 PRINT ''Added counter column to custom table''
 
-- @HTMLROWS will store all the rows in HTML format
-- @ROW will store each HTML row as fields on each row are iterated through
-- using dymamic SQL and a cursor
-- @FIELDS will store the header row for the HTML Table
 
DECLARE @HTMLROWS NVARCHAR(MAX) DECLARE @FIELDS NVARCHAR(MAX)
SET @HTMLROWS='''' DECLARE @ROW NVARCHAR(MAX)
 
-- Create the first HTML row for the table (the table header). Ignore our indexing column!

SELECT @FIELDS=COALESCE(@FIELDS, '' '','''')+''<td>'' + name + ''</td>''
FROM tempdb.sys.Columns
WHERE object_id=object_id(''tempdb..#CustomTable2HTML'')
AND name not like ''CustColHTML_ID''
SET @FIELDS=@FIELDS + ''</tr>''
IF @DEBUG=1 PRINT ''table fields: '' + @FIELDS

 
-- @ColumnName stores the column name as found by the table cursor
-- @maxrows is a count of the rows in the table, and @rownum is for marking the
-- ''current'' row whilst processing
 
DECLARE @ColumnName  NVARCHAR(500)
DECLARE @maxrows INT
DECLARE @rownum INT

 
--Find row count of our temporary table
SELECT @maxrows=count(*) FROM  #CustomTable2HTML
 

--Create a cursor which will look through all the column names specified in the temporary table
--but exclude the index column we added (CustColHTML_ID)
DECLARE col CURSOR FOR
SELECT name FROM tempdb.sys.Columns
WHERE object_id=object_id(''tempdb..#CustomTable2HTML'')
AND name not like ''CustColHTML_ID''
ORDER BY column_id ASC
 
--For each row, generate dymanic SQL which requests the each column name in turn by
--iterating through a cursor
SET @rowNum=1
SET @ParmDefinition=N''@ROWOUT NVARCHAR(MAX) OUTPUT,@rowNum_IN INT''
 
While @rowNum <= @maxrows
BEGIN
  SET @HTMLROWS=@HTMLROWS + ''<tr>''
  OPEN col
  FETCH NEXT FROM col INTO @ColumnName
  IF @DEBUG=1 Print ''@ColumnName: '' + @ColumnName
  WHILE @@FETCH_STATUS=0
    BEGIN
      --Get nth row from table
      --SET @exec_str=''SELECT @ROWOUT=(select top 1 ['' + @ColumnName + ''] from (select top '' + cast(@rownum as varchar) + '' * from #CustomTable2HTML order by CustColHTML_ID ASC) xxx order by CustColHTML_ID DESC)''
      SET @exec_str=''SELECT @ROWOUT=(select ['' + @ColumnName + ''] from #CustomTable2HTML where CustColHTML_ID=@rowNum_IN)''
      IF @DEBUG=1 PRINT ''@exec_str: '' + @exec_str  
	  EXEC      sp_executesql
                  @exec_str,
                  @ParmDefinition,
                  @ROWOUT=@ROW OUTPUT,
            @rowNum_IN=@rownum
 
      IF @DEBUG=1 SELECT @ROW as ''@Row''

      SET @HTMLROWS =@HTMLROWS +  ''<td>'' + IsNull(@ROW,'''') + ''</td>''
      FETCH NEXT FROM col INTO @ColumnName
    END
  CLOSE col
  SET @rowNum=@rowNum +1
  SET @HTMLROWS=@HTMLROWS + ''</tr>''
END
 
SET @OUTPUT=''''
IF @maxrows>0
SET @OUTPUT= ''<table ' + @TBL_STYLE + '>'' + @FIELDS + @HTMLROWS + ''</table>''
 
DEALLOCATE col
'
END
ELSE
BEGIN
--This is the SQL String for table columns to be aligned on the vertical
--So we select a table column, and then iterate through all the rows for that column, this forming
--one row of our html table.

SET @exec_str= N'
DECLARE @exec_str  NVARCHAR(MAX)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @DEBUG INT
SET @DEBUG=0

IF @DEBUG=1 Print ''Table2HTML -Vertical alignment''

--Make a copy of the original table adding an indexing column. We need to add an index column to the table to facilitate sorting so we can maintain the
--original table order as we iterate through adding HTML tags to the table fields.
--New column called CustColHTML_ID (unlikely to be used by someone else!)
--
 
select CustColHTML_ID=0,* INTO #CustomTable2HTML FROM ' + @TABLENAME + '

IF @DEBUG=1 PRINT ''CustomTable2HTMLv2: Modfied temporary table'' 

--Now alter the table to add the auto-incrementing index. This will facilitate row finding
DECLARE @COUNTER INT
SET @COUNTER=0
UPDATE #CustomTable2HTML SET @COUNTER = CustColHTML_ID=@COUNTER+1
 
-- @HTMLROWS will store all the rows in HTML format
-- @ROW will store each HTML row as fields on each row are iterated through
-- using dymamic SQL and a cursor
 
DECLARE @HTMLROWS NVARCHAR(MAX) 
DECLARE @ROW NVARCHAR(MAX)

SET @HTMLROWS='''' 
 
 
-- @ColumnName stores the column name as found by the table cursor
-- @maxrows is a count of the rows in the table

DECLARE @ColumnName  NVARCHAR(500)
DECLARE @maxrows INT
 
--Find row count of our temporary table
--This is used here purely to see if we have any data to output
SELECT @maxrows=count(*) FROM  #CustomTable2HTML
 
--Create a cursor which will iterate through all the column names in the temporary table
--(excepting the one we added above)

DECLARE col CURSOR FOR
SELECT name FROM tempdb.sys.Columns
WHERE object_id=object_id(''tempdb..#CustomTable2HTML'')
AND name not like ''CustColHTML_ID''
ORDER BY column_id ASC
 
--For each **HTML** row, we need to for each iterate through each table column as the outer loop.
--Once the column name is identified, we use Coalesc to combine all the column values into a single string.

SET @ParmDefinition=N''@COLOUT NVARCHAR(MAX) OUTPUT''
 
OPEN col
FETCH NEXT FROM col INTO @ColumnName
WHILE @@FETCH_STATUS=0
  BEGIN

   --Using current column name, grab all column values and combine into an HTML cell string using COALESCE
     SET @ROW=''''
     SET @exec_str='' SELECT @COLOUT=COALESCE(@COLOUT + ''''</td>'''','''''''') + ''''<td>'''' + Cast(IsNull(['' + @ColumnName + ''],'''''''') as nvarchar(max))  from  #CustomTable2HTML ''
     IF @DEBUG=1 PRINT ''@exec_str: '' + @exec_str
   EXEC      sp_executesql
             @exec_str,
             @ParmDefinition,
             @COLOUT=@ROW OUTPUT
 
   SET @HTMLROWS =@HTMLROWS +  ''<tr>'' + ''<td>'' + @ColumnName + ''</td>''  + @ROW + ''</tr>''
   IF @DEBUG=1 SELECT @ROW as ''Current Row''
   IF @DEBUG=1 SELECT @HTMLROWS as ''HTML so far..''

  FETCH NEXT FROM col INTO @ColumnName
  END
CLOSE col


SET @OUTPUT=''''
IF @maxrows>0
SET @OUTPUT= ''<table ' + @TBL_STYLE + '>'' + @HTMLROWS + ''</table>''
 
DEALLOCATE col
'
END


 
DECLARE @ParamDefinition nvarchar(max)
SET @ParamDefinition=N'@OUTPUT NVARCHAR(MAX) OUTPUT'



--Execute Dynamic SQL. HTML table is stored in @OUTPUT which is passed back up (as it's
--a parameter to this SP)
EXEC sp_executesql @exec_str,
@ParamDefinition,
@OUTPUT=@OUTPUT OUTPUT

RETURN 1
GO
