SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [CLR].[RegexMask] (@cultureInvariant [bit], @explicitCapture [bit], @ignoreCase [bit], @ignorePatternWhiteSpace [bit], @multiline [bit], @rightToLeft [bit], @singleLine [bit])
RETURNS [tinyint]
WITH EXECUTE AS CALLER, 
RETURNS NULL ON NULL INPUT
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[RegexMask]
GO
