SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [emdbuser].[FN_GetSecondaryLockComputedOptionValue]
(
	@OptionValue VARCHAR(256),
	@OptionType INT
)  
RETURNS VARCHAR(300)
AS
BEGIN
	RETURN  ((@OptionValue + '_') + CONVERT([varchar](20),@optionType,(0)))
END

GO
