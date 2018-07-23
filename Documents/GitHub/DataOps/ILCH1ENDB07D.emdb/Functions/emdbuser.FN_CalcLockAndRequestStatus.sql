SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Create FN_CalcLockAndRequestStatus
CREATE function [emdbuser].[FN_CalcLockAndRequestStatus]
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
	if @lockIsCancelled = 'Y'
		set @rateStatus = 'Cancelled';
	else if @lockExpirationDate IS NULL
		set @rateStatus = 'NotLocked';
	else if datediff(day,getdate(),@lockExpirationDate) >= 0
		set @rateStatus = 'Locked';
	else
		set @rateStatus = 'Expired';
	if @lockRequestPending = 'Y'
		begin
		if @rateStatus = 'Cancelled'
			set @rateStatus = 'NotLocked';
		if @relockRequestPending = 'Y'
			-- set @rateStatus = @rateStatus + '-Relock';
			declare @dummy bit;  -- noop
		else if @lockExtensionRequestPending = 'Y'
			set @rateStatus = @rateStatus + '-Extension';
		else if @lockCancellationRequestPending = 'Y'
			set @rateStatus = @rateStatus + '-Cancellation';
		set @rateStatus = @rateStatus + '-Request';
		end
	else
		begin
		if @rateStatus <> 'Cancelled'
			set @rateStatus = @rateStatus + '-NoRequest';
		end
	return @rateStatus;
end

GO
