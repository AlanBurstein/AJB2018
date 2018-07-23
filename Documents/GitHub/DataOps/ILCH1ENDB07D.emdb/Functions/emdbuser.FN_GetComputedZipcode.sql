SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [emdbuser].[FN_GetComputedZipcode]
(
	@Zipcode varchar(5),
	@ZipcodeExt varchar(4),
	@CityName VARCHAR(64),
	@StateName VARCHAR(2)
)  
RETURNS VARCHAR(300)
AS
BEGIN
	RETURN @Zipcode + '_' + (CASE WHEN (COALESCE(@ZipcodeExt, '0') = '') THEN '0' ELSE @ZipcodeExt END) + '_' + @CityName  + '_' + @StateName
END

GO
