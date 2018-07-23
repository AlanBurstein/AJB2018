SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE view [dbo].[vw_foreign_keys] 
as 
/************************************************************************************************ 
-- Description : get FK details for "create table" script 
-- Date 		Developer 		Issue# 		Description 
--------------- ------------------- ------------------------------------------------------------ 
-- 2016-09-26	petervandivier	DAT-3537	create view 
--*********************************************************************************************** 
-- testing purposes 
 
select top 1000 * 
from dbo.vw_foreign_keys; 
 
*/ 
 
with max_ordinal as ( 
	select 
		fk_id = fkc.constraint_object_id, 
		num_columns = count(*), 
		max_ordinal = max(fkc.constraint_column_id) 
	from sys.foreign_key_columns fkc 
	group by fkc.constraint_object_id 
),fk_columns as ( 
	select 
		fk_id = fkc.constraint_object_id, 
		fk_column_ordinal = fkc.constraint_column_id, 
		referencing_column_name =  [master].dbo.fn_quotename_sparse( referencing.name ), 
		referenced_column_name =  [master].dbo.fn_quotename_sparse( referenced.name ) 
	from sys.foreign_key_columns fkc 
	join sys.columns referencing 
		on referencing.[object_id] = fkc.parent_object_id 
		and referencing.column_id = fkc.constraint_column_id 
	join sys.columns referenced 
		on referenced.[object_id] = fkc.referenced_object_id 
		and referenced.column_id = fkc.referenced_column_id 
),foreign_key as ( 
	select 
		referencing_table_id = fk.parent_object_id, 
		referenced_table_id = fk.referenced_object_id, 
		fk_id = fk.[object_id], 
		fk_name = [master].dbo.fn_quotename_sparse( fk.name ), 
		fk.is_system_named, 
		fk.is_disabled, 
		add_constraint_name = 
			case fk.is_system_named 
				when 0 then 'constraint ' + [master].dbo.fn_quotename_sparse( fk.name ) 
				else '' 
			end, 
		on_delete = 
			case fk.delete_referential_action 
				when 0 then '' 
				else char(10)+char(9)+'on delete ' 
					+ lower(replace(fk.delete_referential_action_desc,char(95),' ')) 
			end, 
		on_update = 
			case fk.update_referential_action 
				when 0 then '' 
				else char(10)+char(9)+'on update ' 
					+ lower(replace(fk.update_referential_action_desc,char(95),' ')) 
			end 
	from sys.foreign_keys fk 
) 
select 
	fk.referencing_table_id, 
	fk.referenced_table_id, 
	fk.fk_id, 
	fk.fk_name, 
	mo.num_columns, 
	fk.is_disabled, -- perhaps also is_not_trusted, for "with nocheck addition" 
	alter_table = 
		'alter table ' + 
		[master].dbo.fn_quotename_sparse( object_schema_name( fk.referencing_table_id ) ) + '.' + 
		[master].dbo.fn_quotename_sparse( object_name( fk.referencing_table_id ) ) + 
		case fk.is_disabled 
			when 1 then ' with nocheck ' 
			else ' ' 
		end + 
		char(10) + 'add ', 
	fk_definition = 
		fk.add_constraint_name + 
-- placeholder for line break $optional 
		char(10) + 'foreign key ( ' + referencing.cols + ' ) ' + 
-- placeholder for line break $optional 
		char(10) + 'references ' + 
		[master].dbo.fn_quotename_sparse( object_schema_name( fk.referenced_table_id ) ) + '.' + 
		[master].dbo.fn_quotename_sparse( object_name( fk.referenced_table_id ) ) + 
		' ( ' + referenced.cols + ' ) ' + 
-- placeholder for line break $optional 
		fk.on_update + 
		fk.on_delete 
 
from foreign_key fk 
join max_ordinal mo on mo.fk_id = fk.fk_id 
cross apply ( 
	select 
		c.referencing_column_name + 
		case when c.fk_column_ordinal = mo.max_ordinal then '' else ', ' end 
	from fk_columns c 
	where c.fk_id = fk.fk_id 
	order by c.fk_column_ordinal 
	for xml path('') 
) referencing ( cols ) 
cross apply ( 
	select 
		c.referenced_column_name + 
		case when c.fk_column_ordinal = mo.max_ordinal then '' else ', ' end 
	from fk_columns c 
	where c.fk_id = fk.fk_id 
	order by c.fk_column_ordinal 
	for xml path('') 
) referenced ( cols ); 
 
GO
