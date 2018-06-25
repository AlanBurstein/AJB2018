SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [CLR].[RegexReplace] (@input [nvarchar] (4000), @pattern [nvarchar] (4000), @REPLACE [nvarchar] (4000), @mask [tinyint])
RETURNS [nvarchar] (4000)
WITH EXECUTE AS CALLER, 
RETURNS NULL ON NULL INPUT
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[RegexReplace]
GO
