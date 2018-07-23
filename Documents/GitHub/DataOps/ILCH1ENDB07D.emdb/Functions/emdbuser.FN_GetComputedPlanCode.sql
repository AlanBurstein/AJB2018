SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ---------------------------------------------------------------------------------------------------------------
-- Name: FN_GetComputedPlanCode
-- Description: Fills the ComputedPlanCode column in PlanCodes table
---------------------------------------------
-- History:
-- 2014.05.28 SSAPRE  CREATED
---------------------------------------------------------------------------------------------------------------- */
CREATE FUNCTION [emdbuser].[FN_GetComputedPlanCode]
(
	@OrderType INT,
	@PlanCodeID VARCHAR(50),
	@PlanCode VARCHAR(50)
)  
RETURNS VARCHAR(300)
AS
BEGIN
	RETURN CONVERT(VARCHAR(20), @OrderType) + '_' + @PlanCodeID  + '_' + (CASE WHEN (COALESCE(@PlanCode, '0') = '') THEN '0' ELSE @PlanCode END)
END

GO
