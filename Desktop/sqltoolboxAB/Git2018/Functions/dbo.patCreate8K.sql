SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[patCreate8K]
(
  @pattern varchar(20),
  @minLen  smallint,  
	@maxLen  smallint,
  @padding varchar(1) -- char is better but forces a space when blank
)
returns table with schemabinding as return 
select
  reps    = n, 
  pattern = isnull(pad+replicate(p,nullif(n,0))+pad,'')
from (values (@pattern, isnull(@minLen,0), isnull(@maxLen,8000), isnull(@padding,'')))
  as v(p, mn, mx, pad)
cross apply
(
  select 0+mn  union all
  select position+mn
  from dbo.NGrams8k(replicate('0',mx-mn),1)
) iTally(n)
where (mn > -1 and mx >= mn) and n between mn and mx
union all
select null, null 
where not (@minLen > -1 and @maxLen >= @minLen)
GO
