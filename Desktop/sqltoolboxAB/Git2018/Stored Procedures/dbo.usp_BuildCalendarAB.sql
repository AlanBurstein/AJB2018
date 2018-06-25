SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[usp_BuildCalendarAB]
(
  @startDate date = '19900101', 
  @endDate   date = '20291231',
  @Output    bit  = 1
)
AS
/****************************************************************************************
Purpose: 
 Creates a an auxillary calendar table beginning with @startDate & ending with @endDate.

Compatibility: 
 SQL Server 2008+

Syntax:
 Exec dbo.usp_BuildCalendarAB; -- for default values 
 Exec dbo.usp_BuildCalendarAB @startDate, @endDate;

Parameters:
 @Rows = Integer that defines the number of rows to create 

Developer Notes:
 1. Use a calendar table instead of a tally table for superior performance

Performance Notes:
(run the following with "Include actual index" turned on)

 EXEC dbo.usp_BuildCalendarAB; -- uses the default values 
 EXEC dbo.usp_BuildCalendarAB '20100101', '20251231', 1;

 -- Uses the Psuedo cluster
 SELECT * FROM dbo.CalendarAB ORDER BY SeqNbr ASC;  --(Scan on NC Unique Index)
 SELECT * FROM dbo.CalendarAB ORDER BY SeqNbr DESC; --(Scan on NC Unique Index)
 SELECT * FROM dbo.CalendarAB WHERE CalYearNbr = 2010; --(Seek on NC Unique Index)

 -- Note how the Check Constraint prevents the SQL Engine from even looking
 SELECT * FROM dbo.CalendarAB WHERE QuarterNbr IN(0,5)       OPTION(RECOMPILE);
 SELECT * FROM dbo.CalendarAB WHERE DayOfYearNbr  = 1000     OPTION(RECOMPILE);
 SELECT * FROM dbo.CalendarAB WHERE DayOfMonthNbr = 200      OPTION(RECOMPILE);
 SELECT * FROM dbo.CalendarAB WHERE DateID < 19800101        OPTION(RECOMPILE);
 SELECT * FROM dbo.CalendarAB WHERE DateValue < '1980-01-01' OPTION(RECOMPILE);

---------------------------------------------------------------------------------------
Revision History: 
 Rev 00 - 20160323 - Alan Burstein - Initial Development
 Rev 01 - 20180608 - Alan Burstein - Removed the fiscal year, now using rangeAB for
                                     the tally table. Fixed issue with end-of-month
****************************************************************************************/
BEGIN

-- (1) Drop and create and empty dbo.CalendarAB
----------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.CalendarAB') IS NOT NULL DROP TABLE dbo.CalendarAB;
CREATE TABLE dbo.CalendarAB
(
 SeqNbr            int         NOT NULL,
 DateID            int         NOT NULL,
 DateValue         date        NOT NULL,
 CalYearNbr        smallint    NOT NULL,
 DayOfYearNbr      smallint    NOT NULL,
 QuarterNbr        tinyint     NOT NULL,
 MonthNbr          tinyint     NOT NULL,
 MonthTxtFull      varchar(10) NOT NULL,
 MonthTxtShort     char(3)     NOT NULL,
 DayOfMonthNbr     tinyint     NOT NULL,
 WeekOfYearNbr     tinyint     NOT NULL,
 ISOWeekNbr        tinyint     NOT NULL,
 DayOfWeekNbr      tinyint     NOT NULL,
 DayOfWeekTxtFull  varchar(10) NOT NULL,
 DayOfWeekTxtShort char(3)     NOT NULL,
 MonthYearTxt      varchar(15) NOT NULL,
 YearQuarterTxt    varchar(8)  NOT NULL,
 IsLeapYear        bit         NOT NULL,
 IsWeekend         bit         NOT NULL,
 IsEndOfMonth      bit         NOT NULL
);

-- (2) Routine to populate the table
----------------------------------------------------------------------------------------
INSERT dbo.CalendarAB
SELECT * FROM dbo.getDimDateAB(@startDate, @endDate, 0);

DECLARE @SQL varchar(8000) =
'ALTER TABLE dbo.CalendarAB WITH CHECK '+CHAR(10)+
'ADD CONSTRAINT ck_CalendarAB__DateID '+CHAR(10)+'  CHECK'+
'(DateID >= '+REPLACE(CAST(@startDate AS varchar(10)),'-','')+' AND '+
'DateID <= '+REPLACE(CAST(@endDate AS varchar(10)),'-','')+');';
EXEC(@SQL);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__DateID;

SET @SQL = 
'ALTER TABLE dbo.CalendarAB WITH CHECK '+CHAR(10)+
'  ADD CONSTRAINT ck_CalendarAB__DateValue'+CHAR(10)+'  CHECK'+
'(DateValue >= '''+CAST(@startDate AS varchar(10))+''' AND '+
'DateValue <= '''+CAST(@endDate AS varchar(10))+''');';
EXEC (@SQL);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__DateValue;

ALTER TABLE dbo.CalendarAB WITH CHECK
ADD CONSTRAINT ck_CalendarAB__DayOfYearNbr
CHECK (DayOfYearNbr BETWEEN 1 AND 366);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__DayOfYearNbr;

ALTER TABLE dbo.CalendarAB WITH CHECK
ADD CONSTRAINT ck_CalendarAB__QuarterNbr
CHECK (QuarterNbr BETWEEN 1 AND 4);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__QuarterNbr;

ALTER TABLE dbo.CalendarAB WITH CHECK
ADD CONSTRAINT ck_CalendarAB__MonthNbr
CHECK (MonthNbr BETWEEN 1 AND 12);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__MonthNbr;

ALTER TABLE dbo.CalendarAB WITH CHECK
ADD CONSTRAINT ck_CalendarAB__DayOfMonthNbr
CHECK (DayOfMonthNbr BETWEEN 1 AND 31);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__DayOfMonthNbr;

ALTER TABLE dbo.CalendarAB WITH CHECK
ADD CONSTRAINT ck_CalendarAB__WeekOfYearNbr
CHECK (WeekOfYearNbr BETWEEN 1 AND 54);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__WeekOfYearNbr;

ALTER TABLE dbo.CalendarAB WITH CHECK
ADD CONSTRAINT ck_CalendarAB__ISOWeekNbr
CHECK (ISOWeekNbr BETWEEN 1 AND 54);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__ISOWeekNbr;

ALTER TABLE dbo.CalendarAB WITH CHECK
ADD CONSTRAINT ck_CalendarAB__DayOfWeekNbr
CHECK (DayOfWeekNbr BETWEEN 1 AND 7);
ALTER TABLE dbo.CalendarAB CHECK CONSTRAINT ck_CalendarAB__DayOfWeekNbr;

-- (4) Add Indexes
----------------------------------------------------------------------------------------
;
-- Clustered Index Sorted by SeqNbr ASC
ALTER TABLE dbo.CalendarAB
  ADD CONSTRAINT pk_CalendarAB PRIMARY KEY CLUSTERED(SeqNbr ASC);
;
-- Psuedo clustered index:
-- Unique nonclustered index sorted by cluster key with all columns included
CREATE UNIQUE NONCLUSTERED INDEX uq_CalendarAB__PseudoCluster 
  ON dbo.CalendarAB (SeqNbr ASC)
  INCLUDE (DateID,DateValue,CalYearNbr,DayOfYearNbr,QuarterNbr,MonthNbr,MonthTxtFull,
       MonthTxtShort,DayOfMonthNbr,WeekOfYearNbr,ISOWeekNbr,DayOfWeekNbr,DayOfWeekTxtFull,
       DayOfWeekTxtShort,MonthYearTxt,YearQuarterTxt,IsLeapYear,IsWeekend,IsEndOfMonth);

-- Psuedo clustered index for filtering on workdays
CREATE NONCLUSTERED INDEX uq_CalendarAB__PseudoCluster_IsWeekend
  ON dbo.CalendarAB (IsWeekend)
  INCLUDE (DateID,DateValue,CalYearNbr,DayOfYearNbr,QuarterNbr,MonthNbr,MonthTxtFull,
    MonthTxtShort,DayOfMonthNbr,WeekOfYearNbr,ISOWeekNbr,DayOfWeekNbr,DayOfWeekTxtFull,
    DayOfWeekTxtShort,MonthYearTxt,YearQuarterTxt,IsLeapYear,IsEndOfMonth);

-- Index for joining on DateValue; including weekends for additional filter
CREATE UNIQUE NONCLUSTERED INDEX uq_CalendarAB__DateValue 
  ON dbo.CalendarAB(DateValue ASC, IsWeekend ASC);

-- (5) Output
----------------------------------------------------------------------------------------
IF @Output = 1 SELECT * FROM dbo.CalendarAB ORDER BY SeqNbr;
END;
GO
