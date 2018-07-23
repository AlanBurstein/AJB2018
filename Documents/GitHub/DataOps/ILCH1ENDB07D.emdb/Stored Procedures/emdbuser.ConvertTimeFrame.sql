SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [emdbuser].[ConvertTimeFrame]
	@timeFrame varchar(20),
	@from	smalldatetime out,
	@to	smalldatetime out
as
	declare	@now smalldatetime
	set nocount on
	select	@now = getdate()
	if @timeFrame = 'CurrentWeek'
	begin
		select	@from = dateadd(dw, 1-datepart(dw,@now), @now),
				@to = @now
	end
	else if @timeFrame = 'CurrentMonth'
	begin
		select	@from = convert(varchar,datepart(m,@now)) + '/1/' + datename(yy, @now),
				@to = @now
	end
	else if @timeFrame = 'CurrentYear'
	begin
		select	@from = '1/1/' + datename(yy, @now),
				@to = @now
	end
	else if @timeFrame = 'PreviousWeek'
	begin
		select	@from = dateadd(dw, -6-datepart(dw,@now), @now),
				@to = dateadd(dw, -datepart(dw,@now), @now)
	end
	else if @timeFrame = 'PreviousMonth'
	begin
		if datepart(m,@now) = 1
			select	@from = '12/1/' + convert(varchar,datepart(yy, @now)-1),
					@to = dateadd(d,-1,'1/1/' + datename(yy, @now))
		else
			select	@from = convert(varchar,datepart(m,@now)-1) + '/1/' + datename(yy, @now),
					@to = dateadd(d,-1,convert(varchar,datepart(m,@now)) + '/1/' + datename(yy, @now))
	end
	else if @timeFrame = 'PreviousYear'
	begin
		select	@from = '1/1/' + convert(varchar,datepart(yy, @now)-1),
				@to = '12/31/' + convert(varchar,datepart(yy, @now)-1)
	end
	else if @timeFrame like 'Last%'
	begin
		declare	@days smallint
		select	@timeFrame = substring(@timeFrame, 5, 15)
		select	@days = convert(smallint,substring(@timeFrame, 1, charindex('Days',@timeFrame)-1))
		select	@from = dateadd(d,1-@days,@now),
				@to = @now
	end

GO
