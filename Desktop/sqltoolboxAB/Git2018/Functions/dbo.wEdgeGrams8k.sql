SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[wEdgeGrams8k]
(
  @string   varchar(100),
  @leftMin  tinyint = 2,
  @rightMin tinyint = 3
)
returns table with schemabinding as return
SELECT
  leftRn     = x.rn, -- note: x.rn-1 = # of spaces
  leftStart  = 1,
  leftEnd    = x.pos,
  leftEdge   = SUBSTRING(@string, 1, x.pos),
  leftLegit  = case when x.rn > @leftMin then 1 else 0 end,
  rightRn    = s.dp-x.rn,
  rightStart = x.pos+1,
  rightEnd   = s.ln,
  rightEdge  = SUBSTRING(@string, x.pos+1, s.ln),
  rightLegit = case when s.dp-x.rn > @rightMin then 1 else 0 end
from (values (len(@string), len(@string)-len(replace(@string,' ',''))+1)) s(ln,dp) --l.rn
CROSS APPLY  (values (len(@string)-len(replace(@string,' ',''))+1)) l(rn)
CROSS APPLY  (
  SELECT position, row_number() over (order by position) from dbo.NGrams8k(@string,1)
  where token = ' '
  union all SELECT s.ln, rn where @string not like '% ') x(pos,rn);
GO
