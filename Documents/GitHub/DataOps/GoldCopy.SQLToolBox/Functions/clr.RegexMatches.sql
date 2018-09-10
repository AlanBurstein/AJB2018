SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [clr].[RegexMatches] (@input [nvarchar] (4000), @pattern [nvarchar] (4000), @mask [tinyint]=0)
RETURNS TABLE (
[Sequence] [int] NULL,
[Token] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL)
WITH EXECUTE AS CALLER
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[RegexMatches]
GO
