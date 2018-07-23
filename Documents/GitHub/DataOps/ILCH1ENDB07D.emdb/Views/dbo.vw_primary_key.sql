SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE view [dbo].[vw_primary_key] 
as 
/************************************************************************************************ 
-- Description : view grain of primary key 
-- Date 		Developer 		Issue# 		Description 
--------------- ------------------- ------------------------------------------------------------ 
-- 2016-09-26	petervandivier	DAT-3537	create view 
--*********************************************************************************************** 
-- testing purposes 
 
select top 1000 * 
from dbo.vw_primary_key; 
 
*/ 
 
with num_columns as ( 
	select 
		pk_id = kc.[object_id],
		num_columns = count( * ),
		max_key_ordinal = max(ic.key_ordinal)  
	from sys.key_constraints kc
	join sys.indexes i 
		on i.[object_id] = kc.parent_object_id 
		and i.is_primary_key = 1 
		and kc.[type] = 'PK'
	join sys.index_columns ic 
		on i.[object_id] = ic.[object_id] 
		and i.index_id = ic.index_id
	group by kc.[object_id]
),primary_key as ( 
	select 
		pk_id = kc.[object_id], 
		pk_name = 
			case kc.is_system_named 
				when 1 then '' 
				else [master].dbo.fn_quotename_sparse( kc.name )+' ' 
			end, 
		table_id = kc.parent_object_id, 
		kc.is_system_named, 
		nc.max_key_ordinal, 
		cluster_desc = lower( i.type_desc ) 
	from sys.key_constraints kc 
	join num_columns nc on nc.pk_id = kc.[object_id] 
	join sys.indexes i 
		on i.[object_id] = kc.parent_object_id 
		and i.is_primary_key = 1 
	where kc.[type] = N'PK' 
) 
--select * from primary_key 
,ct_pk_cols as ( 
	select 
		table_id = kc.parent_object_id, 
		i.index_id, 
		pk_id = kc.[object_id], 
		cluster_type_id = i.[type], 
		cluster_description = lower( i.type_desc ), 
		ic.column_id, 
		ic.key_ordinal, 
		ic.is_descending_key, 
		column_name = [master].dbo.fn_quotename_sparse( c.name ) 
	from sys.key_constraints kc 
	left join sys.indexes i 
		on i.[object_id] = kc.[parent_object_id] 
		and i.index_id = kc.unique_index_id 
	left join sys.index_columns ic 
		on ic.[object_id] = i.[object_id] 
		and ic.index_id = i.index_id 
	left join sys.columns c 
		on c.[object_id] = ic.[object_id] 
		and c.column_id = ic.column_id 
	where i.is_primary_key = 1 
) 
select 
	pk.table_id, 
	pk_definition = 
		case pk.is_system_named 
			when 0 then 'constraint ' + pk.pk_name + ' ' 
			else '' 
		end 
		+ 'primary key ' + lower( pk.cluster_desc ) + ' ( ' + pk_def.pk_def + ' ) ' 
from primary_key pk 
outer apply ( 
	select 
		cpc.column_name + 
		case cpc.is_descending_key when 1 then ' desc' else '' end + 
		case when cpc.key_ordinal = pk.max_key_ordinal then '' else ', ' end 
	from ct_pk_cols cpc 
	where cpc.table_id = pk.table_id 
	order by cpc.key_ordinal asc 
	for xml path('') 
) pk_def ( pk_def ); 
 
GO
