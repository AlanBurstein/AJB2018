SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnLoanXDBFieldListColumnExistsInEMDB]
(
	@ColumnName nvarchar(255),
	@TableName nvarchar(255),
	@Pair int
)
RETURNS bit
BEGIN
	--***********************************************************************************
	-- Created By:	Robert Corro
	-- Create Date:	12/21/2016
	-- Description:	This function checks to see if the column name and table exists in 
	-- the emdb database when it is added to the emdbuser.LOANXDBFieldlist.  The function
	-- is employed as on Constraint on the emdbuser.LOANXDBFieldlist table in the
	-- emdb database.
	--
	-- Modified By		Modified Date	Modification Description
	--------------		-------------	------------------------
	--
	--***********************************************************************************
	DECLARE @TableColumn nvarchar(255)
	--DECLARE @ColumnName nvarchar(255)
	--DECLARE @TableName nvarchar(255)
	--DECLARE @Pair int

	--SET @ColumnName = 'FR0104'
	--SET @TableName = 'LOANXDB_S_10'
	--SET @Pair = 2
	--***********************************************************************************
	--Check for conditions where a leading underscore does not need to be added to 
	--the column name
	--***********************************************************************************
	IF LEFT(@ColumnName, 4) = 'UWC.'
		--OR LEFT(@ColumnName, 3) = 'MS.'
		OR LEFT(@ColumnName, 4) = 'Log.'
		OR LEFT(@ColumnName, 8) = 'LOCKRATE'
		OR LEFT(@ColumnName, 15) = 'LoanTeamMember.'
		OR @ColumnName = 'PreviousTeamMember'
		OR @ColumnName = 'CurrentTeamMember'
		OR @ColumnName = 'MS.LOCKDAYS'
	BEGIN
		SET @TableColumn = @ColumnName
	END
	ELSE
	BEGIN
		--Add Leading Underscore to Column Name
		SET @TableColumn = STUFF(@ColumnName, 1, 0, '_')
	END

	--***********************************************************************************
	-- If a Field has a Pair value of 2 a trailing string of "_P2" is appended to the 
	-- field name.
	--***********************************************************************************
	If @Pair = 2
	BEGIN
		SET @TableColumn = @TableColumn + '_P2'
	END 

	--***********************************************************************************
	--Covert "." (Periods) to Underscores
	--***********************************************************************************
	SET @TableColumn = REPLACE(@TableColumn, '.', '_')

	--***********************************************************************************
	--Remove Spaces from FieldId
	--***********************************************************************************
	SET @TableColumn = REPLACE(@TableColumn, ' ', '')

	--SELECT @TableColumn

	IF EXISTS (SELECT *
			FROM sys.columns c
			INNER JOIN sys.objects o ON c.object_id = o.object_id
			AND o.type = 'U'
			WHERE o.name = @TableName
			AND c.name = @TableColumn)
		BEGIN
			return 1
		END

	return 0

END 
GO
