SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		peter vandivier
-- Create date: 2015-10-27
-- Description:	function to change FieldId to column name
-- =============================================
/* CHANGES
who					when			what
petervandivier		2015-10-28		add replace( , ' ', '' ). switch from '_' to '.' find in @fieldid substring()
*/
CREATE function [dbo].[fnFieldIdToColumnName] 
(
	@FieldId sysname
)
returns sysname
as
begin

	declare 
		@Result sysname,
		@NoFirstUnderscore bit ;

	select @NoFirstUnderscore = 
		case 
			when left( @FieldId, 15 ) = 'LoanTeamMember.' then 1
			when left( @FieldId, 9 ) = 'LOCKRATE.' then 1
			when left( @FieldId, 7 ) = 'LOG.MS.' then 1
			when left( @FieldId, 4 ) = 'UWC.' then 1
			when left( @FieldId, 10 ) = 'LOCKRATE3.' then 1
			when @FieldId in ( 'CurrentTeamMember', 'MS.LOCKDAYS', 'PreviousTeamMember' ) then 1
			else 0 end ;

	select @Result = 
		case @NoFirstUnderscore when 1 then '' else '_' end + 
		replace( replace( @FieldId, '.', '_' ), ' ', '' ) ;

	return @Result ;

end ;

GO
GRANT EXECUTE ON  [dbo].[fnFieldIdToColumnName] TO [GRCORP\BHarrison]
GO
GRANT EXECUTE ON  [dbo].[fnFieldIdToColumnName] TO [GRCORP\jpugh]
GO
GRANT EXECUTE ON  [dbo].[fnFieldIdToColumnName] TO [GRCORP\NEJohnson]
GO
