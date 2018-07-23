SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE view [dbo].[vw_columns] 
as 
/************************************************************************************************ 
-- Description : get column data for "create table" script 
-- Date 		Developer 		Issue# 		Description 
--------------- ------------------- ------------------------------------------------------------ 
-- 2016-09-26	petervandivier	DAT-3536	create view 
--*********************************************************************************************** 
-- testing purposes 
 
select top 1000 
	table_name = object_name( o.[object_id] ), 
	c.* 
from dbo.vw_columns c 
join sys.objects o on o.[object_id] = c.table_id 
where object_name( o.[object_id] ) like '%FooTestColumns%'; 
 
*/ 
 
select 
	[schema_id] = o.[schema_id], 
	table_id = o.[object_id], 
	c.column_id, 
	column_name = [master].dbo.fn_quotename_sparse( c.name ), 
	column_definition = 
		[master].dbo.fn_quotename_sparse( c.name ) + ' ' + 
		case c.is_computed 
			when 0 
				then t.name + 
					case 
						when c.user_type_id in (165,167,173,175,231,239) 
							then '('+replace(convert(varchar,c.max_length),'-1','max')+')' 
						when c.system_type_id in (106,108) 
							then '('+convert(varchar,c.[precision])+','+convert(varchar,c.scale)+')' 
						when c.system_type_id in (41,42,43) 
							then '('+convert(varchar,c.scale)+')' 
						else '' 
					end 
			when 1 then ' as ' + cc.[definition] + case cc.is_persisted when 1 then ' persisted' else '' end 
		end + 
		case 
			when c.collation_name is not null 
				and c.collation_name <> t.collation_name 
				then ' collate '+c.collation_name 
			else '' 
		end + 
		case c.is_nullable when 0 then ' not null' else '' end + 
		case c.is_identity 
			when 1 then ' identity('+convert(varchar,ic.seed_value)+','+convert(varchar,ic.increment_value)+')' 
			else '' 
		end, 
	default_definition = 
		case 
			when c.default_object_id = 0 or c.default_object_id is null then '' 
			else ( 
				case when dc.is_system_named = 0 then ' constraint ' + [master].dbo.fn_quotename_sparse( dc.name ) else '' end + 
				' default ' + dc.[definition] 
			) 
		end, 
	data_type = t.name, 
	data_type_size = 
		case 
			when c.system_type_id in (175,167,239,231,173,165) -- string & binary 
				then '('+replace(convert(varchar,c.max_length),'-1','max')+')' 
			when c.system_type_id in (106,108) -- float & real have asserted implicit precision 
				then '('+convert(varchar,c.[precision])+','+convert(varchar,c.scale)+')' 
			when c.system_type_id in (41,42,43) 
				then '('+convert(varchar,c.scale)+')' 
			else '' 
		end, 
	c.is_computed, 
	cc.is_persisted, 
	c.user_type_id, 
	c.is_nullable, 
	c.is_identity, 
	id_first_seed = ic.seed_value, 
	id_increment = ic.increment_value, 
	id_current_seed = ic.last_value, 
	c.default_object_id 
from sys.objects o 
join sys.columns c on c.[object_id] = o.[object_id] 
left join sys.computed_columns cc 
	on cc.[object_id] = o.[object_id] 
	and cc.column_id = c.column_id 
left join sys.types t 
	on t.system_type_id = c.system_type_id 
	and t.user_type_id = c.user_type_id 
left join sys.identity_columns ic 
	on ic.[object_id] = c.[object_id] 
	and ic.column_id = c.column_id 
left join sys.default_constraints dc on dc.[object_id] = c.default_object_id; 
 
GO
