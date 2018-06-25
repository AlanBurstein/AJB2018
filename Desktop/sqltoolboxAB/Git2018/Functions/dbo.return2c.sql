SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[return2c]() returns table with schemabinding as return select two=2
GO
