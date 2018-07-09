SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[usp_LongRunningQueryCleanup] (
@RetensionDays int = 30
)
AS
     BEGIN

	    DELETE FROM [Inst].[LongRunningQuery]
         WHERE rundate < getdate() - @RetensionDays;
     END;

GO
