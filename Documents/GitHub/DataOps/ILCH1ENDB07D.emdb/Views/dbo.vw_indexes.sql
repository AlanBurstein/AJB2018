SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE view [dbo].[vw_indexes] 
as 
/************************************************************************************************ 
-- Description : define each index for the "create table" script 
-- Date 		Developer 		Issue# 		Description 
--------------- ------------------- ------------------------------------------------------------ 
-- 2016-09-27	petervandivier	DAT-3537	create view 
--*********************************************************************************************** 
-- testing purposes 
 
select top 1000 * 
from dbo.vw_indexes 
where table_id between 100 and 1993058135; 
 
*/ 
 
with idx as ( 
	select 
		table_id = i.[object_id], 
		i.index_id, 
		i.name, 
		type_desc = lower( i.type_desc ), 
		i.is_unique, 
		-- i.is_system_named -- where to find this for non-constraint indexes? 
		i.data_space_id, 
		i.is_primary_key, 
		i.is_unique_constraint, 
		i.is_disabled, 
		i.is_hypothetical, 
		i.has_filter, 
		i.filter_definition 
	from sys.indexes i 
	where i.[type] > 0 
		and i.is_primary_key = 0 
),idx_col as ( 
	select 
		table_id = ic.[object_id], 
		ic.column_id, 
		ic.index_id, 
		idx_col_ordinal = ic.index_column_id, 
		ic.is_descending_key, 
		ic.is_included_column, 
		column_name = [master].dbo.fn_quotename_sparse( c.name ) 
	from sys.index_columns ic 
	join sys.columns c 
		on c.[object_id] = ic.[object_id] 
		and c.column_id = ic.column_id 
),idx_col_agg as ( 
	select 
		table_id = ic.[object_id], 
		ic.index_id, 
		num_columns = count( * ) , 
		max_idx_col_id = max( ic.index_column_id ), 
		max_key_ordinal = max( ic.key_ordinal ), 
		num_included = sum( convert(tinyint,ic.is_included_column) ) 
	from sys.index_columns ic 
	group by 
		ic.[object_id], 
		ic.index_id 
),with_option_list as ( 
	select 
		unpvt.table_id, 
		unpvt.index_id, 
		unpvt.with_option, 
		unpvt.value, 
		default_config.default_value, 
		is_default = case when default_config.default_value = unpvt.value then 1 else 0 end, 
		with_command = default_config.with_command_placeholder + 
			case 
				when unpvt.with_option = 'fill_factor' then convert( varchar, unpvt.value ) 
				when unpvt.value = 1 then 'ON' 
				when unpvt.value = 0 then 'OFF' 
			end, 
		order_by = row_number() over ( 
			partition by 
				unpvt.table_id, 
				unpvt.index_id, 
				case when default_config.default_value = unpvt.value then 1 else 0 end 
			order by default_config.order_by 
		) 
	from ( select 
			table_id = i.[object_id], 
			i.index_id, 
			[ignore_dup_key] = convert( tinyint, i.[ignore_dup_key] ), 
			fill_factor = convert( tinyint, i.fill_factor % 100 ), 
			is_padded = convert( tinyint, i.is_padded ), 
			[allow_row_locks] = convert( tinyint, i.[allow_row_locks] ), 
			[allow_page_locks] = convert( tinyint, i.[allow_page_locks] ), 
			no_recompute = convert( tinyint, s.no_recompute ) 
		from sys.indexes i 
		left join sys.stats s 
			on s.[object_id] = i.[object_id] 
			and s.stats_id = i.index_id 
		--where i.name like '%idx%' 
	) idx unpivot ( 
		value for with_option in 
			([ignore_dup_key],fill_factor,is_padded,[allow_row_locks],[allow_page_locks],no_recompute) 
	) as unpvt 
	left join ( values 
		('is_padded',0,'pad_index = ',1), 
		('fill_factor',(select 
							value = convert(tinyint,value) % 100 
						from sys.configurations 
						where name = 'fill factor (%)'),'fillfactor = ',2), 
		('ignore_dup_key',0,'ignore_dup_key = ',3), 
		('allow_row_locks',1,'allow_row_locks = ',4), 
		('allow_page_locks',1,'allow_page_locks = ',5), 
		('no_recompute',0,'statistics_norecompute = ',6) 
	) default_config ( 
		with_option, 
		default_value, 
		with_command_placeholder, 
		order_by 
	) on default_config.with_option = unpvt.with_option 
), with_option_agg as ( 
	select 
		wol.table_id, 
		wol.index_id, 
		count_non_default_option = sum( abs( wol.is_default - 1 ) ), 
		max_non_default_option = max( abs( wol.is_default - 1 ) * order_by ) 
	from with_option_list wol 
	group by 
		wol.table_id, 
		wol.index_id 
) 
select 
	i.table_id, 
	i.index_id, 
	index_name = [master].dbo.fn_quotename_sparse( i.name ), 
	index_definition = 
		'create ' + case i.is_unique when 1 then 'unique ' else '' end + 
		i.type_desc + ' index ' + 
		[master].dbo.fn_quotename_sparse( i.name ) + ' ' + 
		char(10)+ 'on  ' + 
		[master].dbo.fn_quotename_sparse( object_schema_name( i.table_id ) ) + '.' + 
		[master].dbo.fn_quotename_sparse( object_name( i.table_id ) ) + 
		' ( ' + key_cols.list + ' ) ' + 
		case ica.num_included 
			when 0 then '' 
			else char(10) + 'include ( ' + incl_cols.list + ' ) ' 
		end + 
		case i.has_filter when 1 then char(10) + 'where ' + i.filter_definition else '' end + 
		isnull( char(10) + 'with ( ' + with_options.list + ' ) ', '' ) + 
		case ds.is_default when 1 then '' else char(10)+'on '+quotename(ds.name) collate database_default end + 
		';' 
from idx i 
join idx_col_agg ica 
	on ica.table_id = i.table_id 
	and ica.index_id = i.index_id 
cross apply ( 
	select 
		ic.column_name + 
		case ic.is_descending_key when 1 then ' desc' else '' end + 
		case ic.idx_col_ordinal 
			when ica.max_key_ordinal then '' 
			else ', ' 
		end 
	from idx_col ic 
	where ic.table_id = i.table_id 
		and ic.index_id = i.index_id 
		and ic.is_included_column = 0 
	order by ic.idx_col_ordinal asc 
	for xml path('') 
) key_cols ( list ) 
cross apply ( 
	select 
		ic.column_name + 
		case ic.idx_col_ordinal 
			when ica.max_idx_col_id then '' 
			else ', ' 
		end 
	from idx_col ic 
	where ic.table_id = i.table_id 
		and ic.index_id = i.index_id 
		and ic.is_included_column = 1 
	order by ic.idx_col_ordinal asc 
	for xml path('') 
) incl_cols ( list ) 
join with_option_agg woa 
	on woa.table_id = i.table_id 
	and woa.index_id = i.index_id 
outer apply ( 
	select 
		wol.with_command + 
		case 
			when wol.order_by = woa.max_non_default_option then ', ' 
			else '' 
		end 
	from with_option_list wol 
	where wol.is_default = 0 
		and wol.table_id = i.table_id 
		and wol.index_id = i.index_id 
	order by wol.order_by desc 
	for xml path('') 
) with_options ( list ) 
left join sys.data_spaces ds on ds.data_space_id = i.data_space_id 
 
GO
