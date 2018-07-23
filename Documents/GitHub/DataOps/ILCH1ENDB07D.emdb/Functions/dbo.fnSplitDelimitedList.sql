SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fnSplitDelimitedList] (

	@DelimitedList varchar( 8000 ),
	@Delimiter varchar( 10 )
	
)

	returns @ResultSet table (
		ColumnValue varchar( 1000 ) null
	)

as

/*

----------------------------------------------------------------------------------------------------------------------------------
	who	when		what
----------------------------------------------------------------------------------------------------------------------------------
	sethm	02/05/13	initial rev of function

*/

begin
	-- verify not an empty string
	set @DelimitedList = ltrim( rtrim( @DelimitedList ))
	if datalength( @DelimitedList ) = 0
		return
		
	-- verify something in string
	while charindex( @Delimiter, @DelimitedList ) > 0
	begin
		insert	@ResultSet ( ColumnValue )
		values	( left( @DelimitedList, charindex( @Delimiter, @DelimitedList ) - 1 ))
		
		set @DelimitedList = ltrim( rtrim( right( @DelimitedList, datalength( @DelimitedList ) - charindex( @Delimiter, @DelimitedList ) - datalength( @Delimiter ) + 1 )))
	end
	
	-- add last item
	insert	@ResultSet ( ColumnValue )
	values	( @DelimitedList )

	-- return results
	return	
end
GO
