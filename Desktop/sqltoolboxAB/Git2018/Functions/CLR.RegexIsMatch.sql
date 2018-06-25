SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [CLR].[RegexIsMatch] (@input [nvarchar] (4000), @pattern [nvarchar] (4000), @mask [tinyint])
RETURNS [bit]
WITH EXECUTE AS CALLER, 
RETURNS NULL ON NULL INPUT
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[RegexIsMatch]
GO
