SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [samd].[isBlankOrNULL] (@string varchar(8000))
/*****************************************************************************************
-- Description : load data into the LoanWarehouse from EMDB

-- Date 		Developer Issue#  Description
----------- --------- ------- -----------------------------------------------------
 20171128   aburstein N/A     Can be used to replace repeated logic that is used frequently

Example (note included "quoted" column for readability):
 -- sample table
 declare @t table (someText varchar(10)); insert @t values('abc'),(''),(NULL),(' '),('   ');
 
 SELECT t.someText, quoted = '"'+t.someText+'"', bn.isBlankOrNull
 FROM @t t
 CROSS APPLY dbo.isBlankOrNull(t.someText) bn;
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT isBlankOrNull = CAST(ABS(SIGN(DATALENGTH(LTRIM(RTRIM(ISNULL(@string,'')))))-1) AS BIT);
GO
