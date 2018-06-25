SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [CLR].[NGrams] (@input [nvarchar] (4000), @n [tinyint]=3, @padSpace [bit]=False)
RETURNS TABLE (
[Sequence] [int] NULL,
[Token] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL)
WITH EXECUTE AS CALLER
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[NGrams]
GO
