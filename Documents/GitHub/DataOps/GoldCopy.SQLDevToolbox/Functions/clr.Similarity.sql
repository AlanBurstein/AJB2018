SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [clr].[Similarity] (@input1 [nvarchar] (4000), @input2 [nvarchar] (4000), @method [tinyint], @containmentBias [float], @minScoreHint [float])
RETURNS [float]
WITH EXECUTE AS CALLER, 
RETURNS NULL ON NULL INPUT
EXTERNAL NAME [Microsoft.MasterDataServices.DataQuality].[Microsoft.MasterDataServices.DataQuality.SqlClr].[Similarity]
GO
