SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE view [dbo].[vw_check_constraints] 
as 
/************************************************************************************************ 
-- Description : define check constraints for "create table" script 
-- Date 		Developer 		Issue# 		Description 
--------------- ------------------- ------------------------------------------------------------ 
-- 2016-09-26	petervandivier	DAT-3537	create view 
--*********************************************************************************************** 
-- testing purposes 
 
select top 1000 * 
from dbo.vw_check_constraints; 
 
select * from sys.check_constraints 
*/ 
 
select 
	chk_id = ck.[object_id], 
	table_id = ck.parent_object_id, 
	chk_name = [master].dbo.fn_quotename_sparse( ck.name ), 
	ck_column_id = ck.parent_column_id, 
	ck.is_not_trusted, 
	alter_table = 
		'alter table ' + [master].dbo.fn_quotename_sparse( object_schema_name( ck.parent_object_id ) ) + '.' + 
		[master].dbo.fn_quotename_sparse( object_name( ck.parent_object_id ) ) + 
	case ck.is_disabled 
		when 1 then ' with nocheck ' 
		else ' ' 
	end + 
	char(10) + 'add ', 
	chk_add_name = 
		case ck.is_system_named 
			when 0 then 'constraint ' + [master].dbo.fn_quotename_sparse( ck.name ) + ' ' 
			else '' 
		end, 
	chk_definition = 'check ' + ck.[definition] 
from sys.check_constraints ck; 
 
GO
