SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ---------------------------------------------------------------------------------------------------------------
-- Name: FN_GetComputedCountyLimit
-- Description: Fills the ComputedCountyLimit column in CountyLimit  table
---------------------------------------------
-- History:
-- 2014.06.20 SSAPRE  CREATED
---------------------------------------------------------------------------------------------------------------- */
CREATE FUNCTION [emdbuser].[FN_GetComputedCountyLimit]
(
	@SOACode VARCHAR(20),
	@StateAbb VARCHAR(10),
	@CountyName VARCHAR(50)
)  
RETURNS VARCHAR(300)
AS
BEGIN
	RETURN  @SOACode + '_' + @StateAbb + '_' + @CountyName
END

GO
