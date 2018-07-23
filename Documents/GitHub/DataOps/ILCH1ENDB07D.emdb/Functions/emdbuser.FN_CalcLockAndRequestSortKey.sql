SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Create FN_CalcLockAndRequestSortKey
CREATE function [emdbuser].[FN_CalcLockAndRequestSortKey]
(
	@lockRequestPending varchar(1),
	@lockExpirationDate smalldatetime,
	@lockExtensionRequestPending varchar(1),
	@lockCancellationRequestPending varchar(1),
	@lockIsCancelled varchar(1),
	@relockRequestPending varchar(1)
)  
returns varchar(255)
as
begin
	declare @rateStatus varchar(255);
	set @rateStatus = [emdbuser].FN_CalcLockAndRequestStatus(@lockRequestPending, @lockExpirationDate,
		@lockExtensionRequestPending, @lockCancellationRequestPending, @lockIsCancelled, @relockRequestPending);
	if @rateStatus = 'NotLocked-Request'
		set @rateStatus = 'C..NotLocked-Request';
	else if @rateStatus = 'Expired-NoRequest'
		set @rateStatus = ('B.'+CONVERT([varchar](8),@lockExpirationDate,112))+'.Expired-NoRequest';
	else if @rateStatus = 'Expired-Request'
		set @rateStatus = ('B.'+CONVERT([varchar](8),@lockExpirationDate,112))+'.Expired-Request';
	else if @rateStatus = 'Locked-NoRequest'
		set @rateStatus = ('A.'+CONVERT([varchar](8),isnull(@lockExpirationDate,getdate()),(112)))+'.Locked-NoRequest';
	else if @rateStatus = 'Locked-Extension-Request'
		set @rateStatus = ('A.'+CONVERT([varchar](8),isnull(@lockExpirationDate,getdate()),(112)))+'.Locked-Extension-Request';
	else if @rateStatus = 'Locked-Cancellation-Request'
		set @rateStatus = ('A.'+CONVERT([varchar](8),isnull(@lockExpirationDate,getdate()),(112)))+'.Locked-Cancellation-Request';
	else if @rateStatus = 'Cancelled'
		set @rateStatus = ('D.'+CONVERT([varchar](8),isnull(@lockExpirationDate,getdate()),(112)))+'.Cancelled';
	else
		set @rateStatus = 'E..NotLocked-NoRequest';
	return @rateStatus;
end

GO
