SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Hawley
-- Create date: 2012-11-27
-- Description:	Essential details about condo loans
-- =============================================
CREATE PROCEDURE [reports].[CondoReview] 
	@zipcode varchar(10),
	@state varchar(100) = '',
	@city varchar(100) = '',
	@address varchar(100) = '',
	@project varchar(100) = ''
AS
	select
		ProjectName = _1298,
		PropStreet = _11,
		PropCity = _12,
		PropState = _14,
		PropZip = _15,
		PropType = _1553,
		PropUnits = convert(int, _ULDD_X176),
		AttachmentType = _ULDD_X177,
		ReviewType = _CX_UWCONDOREVTYP,
		ProjectTypeCode = _1012,
		CPMProjectID = _3050,
		ProjectStatus = case
			when _CX_UWCONDOAPPR is not null and _CX_UWCONDOSUS is not null then 'Both'
			when _CX_UWCONDOAPPR is not null then 'Approved'
			when _CX_UWCONDOSUS is not null then 'Declined'
			else ''
		end,
		ApprovedDate = convert(date, _CX_UWCONDOAPPR),
		DeclinedDate = convert(date, _CX_UWCONDOSUS),
		LastReviewer = _CX_UWCONDOREV,
		GeneralComments = _CX_CNDO_GENCMTS,
		ReasonDeclined = _CX_CNDO_RSNDECL,
		Litigation = _CX_CNDO_LIT,
		LitigationAccepted = _CX_CNDO_LITACPT,
		ReasonLitigationNotAccepted = _CX_CNDO_LITNOTACPT,
		PreviousLoans = _CX_CNDO_PREVLOAN
	from reports.CondoReviewFields
	where _1298 like '%' + @project + '%'
	and _11 like '%' + @address + '%'
	and _12 like '%' + @city + '%'
	and _14 like '%' + @state + '%'
	and _15 like @zipcode + '%';
GO
