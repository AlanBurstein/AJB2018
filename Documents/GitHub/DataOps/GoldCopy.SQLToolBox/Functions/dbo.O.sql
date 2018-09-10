SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[O] (@L INT,@H INT,@N INT)
/*****************************************************************************************
Purpose:
 To allow developers to perform a DESCending sort against a CTE tally table without a sort
 in the execution plan (see below for more details). Given a set of natural numbers from 
 @L to @Hdbo.O(@L,@H,@N) returns the "finite opposite" of @N relative to the set. 
 
 Traditional opposite numbers (AKA additive inverse numbers) there are two numbers of 
 equal distance from 0; the higher number is a non-negative number and the lower number is
 the higher number times -1. Ex: the opposite of -10 is 10, the opposite of 4 is -4 and 
 the opposite of 0 is 0. With traditional opposite numbers zero (0) represents the median
 between each set of opposite numbers. For example, consider the set of numbers between 
 2 and -2: -2,-1,0,1,2... Here 0 is the median, consider 3 and -3: -3,-2,-1,0,1,2,3... 
 again the median is 0. The median between traditional opposites is always 0 because there
 an infinite number of positive and negative integers. With this is mind - traditional
 opposite numbers can be thought of as "infinite opposites". 

 A *Finite* opposite number exists when you define a low and high number. Consider a set
 of sequential numbers beginning with 6 through 10: (6,7,8,9,10); here the median is 8 and
 which means the "finite opposite" of 8 is 8, the finite opposite of 7 is 9 and the finite
 opposite of 6 is 10. With finite opposites the highest number is in the set is always the
 opposite of the lowest number, the second highest is the opposite of the second lowest, 
 etc.

Compatibility: 
 SQL Server 2005+

Syntax:
--===== Autonomous
 SELECT O.Op
 FROM dbo.O(@L,@H,@N) AS O;

--===== Against a table using APPLY
 SELECT t.col1, t.col2, t.col3, O.O
 FROM dbo.someTable t
 CROSS APPLY dbo.O(t.col1,t.col2,t.col3) O;

Parameters:
 @L = INT; The lower boundary of the set
 @H = INT; The upper boundary of the set
 @N = INT; The number to evaluate relative to the set beginning with @L & ending with @H

Returns:
 inline table valued function returns:
 Op = Int; The "Finite Opposite" of @N

Developer Notes: 
 When @L and @H are infinate opposites then the finite and infinate opposite values are 
 the same. The magic of the function is that there are no wrong numbers. @high does not 
 have to be lower than @low and @N does not have to be between @low and high.

Developer Notes:
 1. Returns NULL when @L, @H or @N are NULL.
 2. dbo.O is deterministic. For more deterministic functions see:
    https://msdn.microsoft.com/en-us/library/ms178091.aspx

Usage Examples:

--===== 1. <tile 1.,,>
 -- (1.1) <subtitle 1.1,,>
 <example code 1.1.,,s>;

 -- (1.2) <subtitle 1.2.,,>
 <example code 12..,,s>;

--===== 1. <tile 2.,,>
 -- (1.1) <subtitle,,>
 <example code 1,,s>;

---------------------------------------------------------------------------------------
Revision History: 
 Rev 00 - <YYYYMMDD> - <details> - <developer>
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN SELECT Op = @L+@H-@N;
GO
