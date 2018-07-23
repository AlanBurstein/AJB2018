SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE view [dbo].[vw_create_table_script] 
as 
/************************************************************************************************ 
-- Description : one line for each table with a corresponding script to re-create it with all constraints & indexes 
-- Date 		Developer 		Issue# 		Description 
--------------- ------------------- ------------------------------------------------------------ 
-- 2016-09-28	petervandivier	DAT-3537	create view 
--*********************************************************************************************** 
-- testing purposes 
 
select top 1000 * 
from dbo.vw_create_table_script cts; 
*/ 
 
select 
	t.[schema_id], 
	t.table_id, 
	t.[schema_name], 
	t.table_name, 
	t.number_of_columns, 
	t.max_column_id, 
	t.is_ms_shipped, 
	t.table_type, 
	t.clustered_index_id, 
	t.primary_key_id, 
	t.has_pk_other_than_ci, 
	create_table_command = 
-- do this better... 
-- http://sqlblog.com/blogs/rob_farley/archive/2010/04/15/handling-special-characters-with-for-xml-path.aspx 
		replace( 
		replace( 
			'create table ' 
			+ t.[schema_name] + '.' + t.table_name + ' ( ' 
			+ isnull( char(10) + char(9) + pk.pk_definition collate database_default + ', ', '' ) 
			+ char(10) + char(9) + col.list 
			+ isnull( char(10) + char(9) + chk.checks, '' ) 
			+ char(10) + ');' + char(10) + char(10) + 'go' + char(10) + char(10) 
			+ isnull( fk.fks + char(10) + char(10) + 'go' + char(10) + char(10), '' ) 
			+ isnull( idx.idxs + char(10) + char(10) + 'go' + char(10), '' ) 
		, '&gt;', '>' ) 
		, '&lt;', '<' ) 
from dbo.vw_tables t 
left join dbo.vw_primary_key pk on pk.table_id = t.table_id 
cross apply ( 
	select 
		vc.column_definition + 
		case vc.column_id 
			when t.max_column_id then '' 
			else ', '+ char(10) + char(9) 
		end 
	from dbo.vw_columns vc 
	where vc.table_id = t.table_id 
	order by vc.column_id asc 
	for xml path('') 
) col ( list ) 
outer apply ( 
	select 
		vcc.chk_add_name + vcc.chk_definition + 
		case vcc.chk_id 
			when t.max_chk_oid then '' 
			else ', '+char(10)+char(9) 
		end 
	from dbo.vw_check_constraints vcc 
	where vcc.table_id = t.table_id 
	order by vcc.chk_id asc 
	for xml path('') 
) chk ( checks ) 
outer apply ( 
	select 
		vfk.alter_table + vfk.fk_definition + 
		case vfk.fk_id 
			when t.max_fk_oid then ';' 
			else ';'+char(10)+char(10) 
		end 
	from dbo.vw_foreign_keys vfk 
	where vfk.referencing_table_id = t.table_id 
	order by t.max_fk_oid asc 
	for xml path('') 
) fk ( fks ) 
outer apply ( 
	select 
		vi.index_definition + 
		case vi.index_id 
			when t.max_idx_id then char(10)+'go'+char(10) 
			else char(10)+char(10) 
		end 
	from dbo.vw_indexes vi 
	where vi.table_id = t.table_id 
	order by vi.index_id asc 
	for xml path('') 
) idx ( idxs ) 
where t.table_type in (N'U') 
	and t.is_ms_shipped = 0; 
 
GO
