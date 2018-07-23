SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE    FUNCTION [secmktg].[LoanStatus-2]
(
@SubmittedDate datetime,
@ApprovedDate datetime,
@SuspendedDate datetime,
@OrigDate datetime,
@LockDate datetime,
@ExpDate datetime,
@ClosedDate datetime,
@FundedDate datetime,
@PurchaseDate datetime,
@AdverseDate datetime,
@Today datetime
)
RETURNS varchar(50)
AS
BEGIN
declare @Return varchar(30)
select @return = case 
when @PurchaseDate is not null then 'Purchased'
when @FundedDate is not null then 'Funded'
when @ClosedDate is not null then 'Closed'
when datediff(d,@Today,@ExpDate)<0 then 'Expired'
when @ApprovedDate is not null and datediff(d,@Today,@ExpDate)>=0 then 'Active - Approved'
when @ApprovedDate is null and datediff(d,@Today,@ExpDate)>=0 then 'Active - Not Approved'
when @SubmittedDate is not null and @ApprovedDate is not null then 'Submitted - Approved'
when @SubmittedDate is not null and @SuspendedDate is not null then 'Submitted - Suspended'
when @SubmittedDate is not null and @ApprovedDate is null then 'Submitted'
when datediff(d,@Today,@ExpDate) is null then 'Float'
when @AdverseDate is not null then 'Adversed'
else '?'
end

return @return
end






GO
