SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [SQLCop].[test Wide Table]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://wiki.lessthandot.com/index.php/SQLCop_wide_table_check
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	Select  @Output = @Output + C.TABLE_SCHEMA + '.' + C.TABLE_NAME + Char(13) + Char(10)
	From    INFORMATION_SCHEMA.TABLES T
			INNER JOIN INFORMATION_SCHEMA.COLUMNS C
			  On  T.TABLE_NAME = C.TABLE_NAME
			  AND T.TABLE_SCHEMA = C.TABLE_SCHEMA
			  And T.TABLE_TYPE = 'BASE TABLE'
			INNER JOIN systypes S
				On C.DATA_TYPE = S.name
	WHERE   C.TABLE_SCHEMA <> 'tSQLt'
	GROUP BY C.TABLE_SCHEMA,C.TABLE_NAME
	HAVING SUM(ISNULL(NULLIF(CONVERT(BIGINT,S.Length), 8000), 0) + ISNULL(NULLIF(C.CHARACTER_MAXIMUM_LENGTH, 2147483647), 0)) > 8060
	ORDER BY C.TABLE_SCHEMA,C.TABLE_NAME

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://wiki.lessthandot.com/index.php/SQLCop_wide_table_check' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	
END;
GO
