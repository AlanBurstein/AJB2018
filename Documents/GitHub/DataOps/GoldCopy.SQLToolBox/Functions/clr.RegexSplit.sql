SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [clr].[RegexSplit] (@input [nvarchar] (4000), @splitPattern [nvarchar] (4000), @tokenPattern [nvarchar] (4000), @mask [tinyint])
RETURNS TABLE (
[Sequence] [int] NULL,
[Token] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsValid] [bit] NULL)
WITH EXECUTE AS CALLER
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[RegexSplitWithCheck]
GO
