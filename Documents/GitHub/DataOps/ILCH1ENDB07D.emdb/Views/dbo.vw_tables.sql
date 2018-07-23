SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE view [dbo].[vw_tables] 
as 
/************************************************************************************************ 
-- Description : get necessary table-grain info for "create table" script 
-- Date 		Developer 		Issue# 		Description 
--------------- ------------------- ------------------------------------------------------------ 
-- 2016-09-26	petervandivier	DAT-3536	create view 
--*********************************************************************************************** 
-- testing purposes 
 
select top 1000 * 
from dbo.vw_tables 
where is_ms_shipped = 0; 
 
*/ 
 
with columns_per_table as ( 
	select 
		table_id = c.[object_id], 
		number_of_columns = count( * ), 
		max_column_id = max( c.column_id ) 
	from sys.columns c 
	group by c.[object_id] 
),checks_per_table as ( 
	select 
		table_id = cc.parent_object_id, 
		num_checks = count( * ), 
		max_chk_oid = max( cc.[object_id] ) 
	from sys.check_constraints cc 
	group by cc.parent_object_id 
), foreign_keys_per_table as ( 
	select 
		table_id = fk.parent_object_id, 
		num_fks = count( * ), 
		max_fk_oid = max( fk.[object_id] ) 
	from sys.foreign_keys fk 
	group by fk.parent_object_id 
), indexes_per_table as ( 
	select 
		table_id = i.[object_id], 
		num_indexes = count( * ) , 
		max_idx_id = max( i.index_id ) 
	from sys.indexes i 
	where i.is_primary_key = 0 
	group by i.[object_id] 
) 
select 
	[schema_id] = o.[schema_id], 
	table_id = o.[object_id], 
	[schema_name] = [master].dbo.fn_quotename_sparse( s.name ), 
	table_name = [master].dbo.fn_quotename_sparse( o.name ), 
	cpt.number_of_columns, 
	cpt.max_column_id, 
	o.is_ms_shipped, 
	table_type = o.[type], 
	clustered_index_id = ci.ci_id, 
	--ci.ci_name, 
	primary_key_id = pk.[object_id], 
	has_pk_other_than_ci = case when ci.ci_id <> pk.[object_id] then 1 else 0 end, 
	num_checks = isnull( ck.num_checks, 0 ), 
	max_chk_oid = isnull( ck.max_chk_oid, 0 ), 
	num_fks = isnull( fk.num_fks, 0 ), 
	max_fk_oid = isnull( fk.max_fk_oid, 0 ), 
	num_indexes = isnull( idx.num_indexes, 0 ), 
	max_idx_id = isnull( idx.max_idx_id, 0 ) 
from sys.objects o 
join columns_per_table cpt on cpt.table_id = o.[object_id] 
left join checks_per_table ck on ck.table_id = o.[object_id] 
left join foreign_keys_per_table fk on fk.table_id = o.[object_id] 
left join indexes_per_table idx on idx.table_id = o.[object_id] 
left join sys.schemas s on s.[schema_id] = o.[schema_id] 
outer apply ( 
	select 
		ci_id = object_id( ci.name ), 
		ci_name = ci.name 
	from sys.indexes ci 
	where ci.type_desc = 'CLUSTERED' 
		and ci.[object_id] = o.[object_id] 
) ci 
left join sys.objects pk 
	on pk.parent_object_id = o.[object_id] 
	and pk.[type] = 'PK'; 
 
GO
