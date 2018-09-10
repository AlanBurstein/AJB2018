SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [clr].[RegexIsValid] (@pattern [nvarchar] (4000))
RETURNS [bit]
WITH EXECUTE AS CALLER, 
RETURNS NULL ON NULL INPUT
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[RegexIsValid]
GO
