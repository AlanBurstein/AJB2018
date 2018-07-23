SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Hawley
-- Create date: 2013-01-04
-- Description:	Splits a delimited list to a table of varchars
-- =============================================
-- Adapted from http://www.sqlservercentral.com/articles/Tally+Table/72993/
-- to support longer delimiters than just 1 character and handle nulls.
CREATE FUNCTION [reports].[SplitListToVarchar] 
(	
	@list varchar(8000), @delimiter varchar(10)
)
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN
(
	with e1 (n) as (
		select 1 union all select 1 union all select 1 union all
		select 1 union all select 1 union all select 1 union all
		select 1 union all select 1 union all select 1 union all
		select 1
	), -- 10^1 = 10
	e2(n) as (select 1 from e1 a cross join e1 b), -- 10^2 = 100
	e4(n) as (select 1 from e2 a cross join e2 b), -- 10^4 = 10000
	cteTally(n) as (
		-- Base CTE tally of every position from the first to the last of the input data
		select top (isnull(datalength(@list),0)) row_number() over (order by (select null)) from e4
	),
	cteStart(n) as (
		-- The first starting position, plus the position after each delimiter
		select 1 where @delimiter is not null union all
		select null where @delimiter is null union all  -- So the result is null
		select t.n + datalength(@delimiter) from cteTally t
		where @delimiter <> '' and
			substring(@list, t.n, datalength(@delimiter)) = @delimiter
	),
	cteLen(n,nl) as (
		-- Each element starting position and length, for use in substring
		select s.n,
			isnull(nullif(charindex(@delimiter,@list,s.n),0)-s.n,8000)
			-- If delimiter not found (last element) use max length,
			-- which substring will limit to the remaining element length
		from cteStart s
	)
	-- All of the element substrings
	select Value = substring(@list, l.n, l.nl) from cteLen l
)

GO
