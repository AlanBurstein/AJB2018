SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Create Function
CREATE FUNCTION [emdbuser].[FN_GetComputedBizCategoryFieldNumber]
(
	@CategoryId int,
	@FieldNumer int
)  
RETURNS VARCHAR(10)
AS
BEGIN
	RETURN CONVERT(varchar(5), @CategoryId) + '_' + CONVERT(varchar(5), @FieldNumer)
END

GO
