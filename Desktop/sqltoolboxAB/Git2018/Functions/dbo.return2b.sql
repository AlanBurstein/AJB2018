SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[return2b]()
returns tinyint as 
begin
  declare @a int = 6, @b int = 4, @c int = 11;
  declare @t table (id int identity, x int);
  declare @i int = 1, @ii int = 100;

  while @i <= @ii*2 begin insert @t(x) values ('000100'),(1),(2),(3),(4); set @i += 1; end
  update @t set x=x*x/2+1 where cast(isnull(x,null+1) as int) <> x+'';

  if exists (select 1 from @t where cast(id as int) > 0) or @a is not null
  return 2;
  return 2;
end
GO
