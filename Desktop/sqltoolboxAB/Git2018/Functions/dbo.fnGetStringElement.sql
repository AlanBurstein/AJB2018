SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 Create Function [dbo].[fnGetStringElement] (
        @pString varchar(8000)
      , @pDelimiter char(1)
      , @pElement int)
Returns Table 
   With Schemabinding
     As
 Return

   With e1(n) 
     As ( --=== Create Ten 1s
 Select 1 Union All Select 1 Union All
 Select 1 Union All Select 1 Union All
 Select 1 Union All Select 1 Union All
 Select 1 Union All Select 1 Union All
 Select 1 Union All Select 1        --10
        )
      , e2(n) As (Select 1 From e1 a, e1 b)   -- 100
      , e3(n) As (Select 1 From e2 a, e2 b)   -- 10,000
      , cteTally (Number)
     As (
 Select Top (datalength(isnull(@pString, 0)))
        row_number() over(Order By (Select Null))
   From e3
        )
      , cteStart(n1)
     As (
 Select 1
  Union All
 Select t.Number + 1
   From cteTally t
  Where substring(@pString, t.Number, 1) = @pDelimiter), cteEnd (n1, l1)
     As (
 Select s.n1
      , coalesce(nullif(charindex(@pDelimiter, @pString, s.n1), 0) - s.n1, 8000)
   From cteStart s
        )
      , cteSplit   --==== Do the split
     As (
 Select row_number() over(Order By e.n1) As ItemNumber
      , substring(@pString, e.n1, e.l1) As Item
   From cteEnd e
        )
 Select ltrim(rtrim(Item)) As Item
   From cteSplit
  Where ItemNumber = @pElement;
GO
