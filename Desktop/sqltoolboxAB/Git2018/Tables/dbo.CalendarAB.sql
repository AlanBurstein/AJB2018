CREATE TABLE [dbo].[CalendarAB]
(
[SeqNbr] [int] NOT NULL,
[DateID] [int] NOT NULL,
[DateValue] [date] NOT NULL,
[CalYearNbr] [smallint] NOT NULL,
[DayOfYearNbr] [smallint] NOT NULL,
[QuarterNbr] [tinyint] NOT NULL,
[MonthNbr] [tinyint] NOT NULL,
[MonthTxtFull] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MonthTxtShort] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DayOfMonthNbr] [tinyint] NOT NULL,
[WeekOfYearNbr] [tinyint] NOT NULL,
[ISOWeekNbr] [tinyint] NOT NULL,
[DayOfWeekNbr] [tinyint] NOT NULL,
[DayOfWeekTxtFull] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DayOfWeekTxtShort] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MonthYearTxt] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[YearQuarterTxt] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsLeapYear] [bit] NOT NULL,
[IsWeekend] [bit] NOT NULL,
[IsEndOfMonth] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__DateID] CHECK (([DateID]>=(20100101) AND [DateID]<=(20251231)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__DateValue] CHECK (([DateValue]>='2010-01-01' AND [DateValue]<='2025-12-31'))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__DayOfMonthNbr] CHECK (([DayOfMonthNbr]>=(1) AND [DayOfMonthNbr]<=(31)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__DayOfWeekNbr] CHECK (([DayOfWeekNbr]>=(1) AND [DayOfWeekNbr]<=(7)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__DayOfYearNbr] CHECK (([DayOfYearNbr]>=(1) AND [DayOfYearNbr]<=(366)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__ISOWeekNbr] CHECK (([ISOWeekNbr]>=(1) AND [ISOWeekNbr]<=(54)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__MonthNbr] CHECK (([MonthNbr]>=(1) AND [MonthNbr]<=(12)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__QuarterNbr] CHECK (([QuarterNbr]>=(1) AND [QuarterNbr]<=(4)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [ck_CalendarAB__WeekOfYearNbr] CHECK (([WeekOfYearNbr]>=(1) AND [WeekOfYearNbr]<=(54)))
GO
ALTER TABLE [dbo].[CalendarAB] ADD CONSTRAINT [pk_CalendarAB] PRIMARY KEY CLUSTERED  ([SeqNbr]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc_poc__calandarAB__CalYearNbr_monthNbr] ON [dbo].[CalendarAB] ([CalYearNbr], [MonthNbr]) INCLUDE ([DateID], [DateValue], [DayOfMonthNbr], [DayOfWeekNbr], [DayOfWeekTxtFull], [DayOfWeekTxtShort], [DayOfYearNbr], [IsEndOfMonth], [IsLeapYear], [ISOWeekNbr], [IsWeekend], [MonthTxtFull], [MonthTxtShort], [MonthYearTxt], [QuarterNbr], [WeekOfYearNbr], [YearQuarterTxt]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_CalendarAB__DateValue] ON [dbo].[CalendarAB] ([DateValue], [IsWeekend]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [uq_CalendarAB__PseudoCluster_IsWeekend] ON [dbo].[CalendarAB] ([IsWeekend]) INCLUDE ([CalYearNbr], [DateID], [DateValue], [DayOfMonthNbr], [DayOfWeekNbr], [DayOfWeekTxtFull], [DayOfWeekTxtShort], [DayOfYearNbr], [IsEndOfMonth], [IsLeapYear], [ISOWeekNbr], [MonthNbr], [MonthTxtFull], [MonthTxtShort], [MonthYearTxt], [QuarterNbr], [WeekOfYearNbr], [YearQuarterTxt]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_CalendarAB__PseudoCluster] ON [dbo].[CalendarAB] ([SeqNbr]) INCLUDE ([CalYearNbr], [DateID], [DateValue], [DayOfMonthNbr], [DayOfWeekNbr], [DayOfWeekTxtFull], [DayOfWeekTxtShort], [DayOfYearNbr], [IsEndOfMonth], [IsLeapYear], [ISOWeekNbr], [IsWeekend], [MonthNbr], [MonthTxtFull], [MonthTxtShort], [MonthYearTxt], [QuarterNbr], [WeekOfYearNbr], [YearQuarterTxt]) ON [PRIMARY]
GO
