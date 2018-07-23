SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-------- ==========================================================================================
-------- Author:		Shelley Pollack		
-------- create date:	Jun 29,2011
-------- Description:	Accepts a character-delimited string of values.
-------- 				Returns a table variable, containing one row for each value in the string that was passed in.
-------- 				Values are split according to the character supplied for the @Delimiter variable.
-------- 				Values are converted to --integer-- data type and stored in the returned table.
-------- ==========================================================================================
Create  FUNCTION [reports].[DelimitedListToVarcharTableVariable]
(
	@DelimitedList nvarchar(max),
	@Delimiter varchar(1)
)
RETURNS @tbl table(SplitValues nvarchar(max))
 
AS

 
BEGIN
	DECLARE @DelimiterPos int
	-- Find the first comma
	SET @DelimiterPos = PATINDEX( '%,%', @DelimitedList)
	
	-- If a delimiter was found, @DelimiterPos will be > 0.
	WHILE @DelimiterPos > 0
		BEGIN
			-- Insert the value between the start of the string and the first delimiter, into the table variable.
			INSERT INTO @tbl(SplitValues) SELECT CAST(LTRIM(RTRIM((SUBSTRING(@DelimitedList, 1, @DelimiterPos -1)))) AS nvarchar(max))
			
			-- Trim the string of the first value and delimiter.
			SET @DelimitedList = SUBSTRING(@DelimitedList, @DelimiterPos +1, LEN(@DelimitedList) - @DelimiterPos)
			
			-- Look for the next delimiter in the string.
			SET @DelimiterPos = PATINDEX( '%,%', @DelimitedList)
		END

-- Ensure the last / only value in the @DelimitedList string gets inserted into the table variable.
	INSERT INTO @Tbl(SplitValues) SELECT CAST(LTRIM(RTRIM((@DelimitedList))) AS nvarchar(max))
	RETURN
END;

GO
