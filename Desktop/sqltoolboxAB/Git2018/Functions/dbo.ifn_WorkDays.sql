SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE FUNCTION [dbo].[ifn_WorkDays]
/***************************************************************************************
 Purpose:
 1.  Given any valid start date and end date, this function will calculate and return
     the number of workdays (Mon - Fri).
 2.  Given only a valid start date (end date has DEFAULT in it), this function will
     return a 1 if the start date is a weekday and a 0 if not a weekday.

 Notes:
 1.  Holidays are NOT considered.
 2.  Because of the way SQL Server calculates weeks and named days of the week, no
     special consideration for the value of DATEFIRST is given.  In other words, it
     doesn't matter what DATEFIRST is set to for this function.
 3.  If the input dates are in the incorrect order, they will be reversed prior to any
     calculations.
 4.  Only whole days are considered.  Times are NOT used.
 5.  The number of workdays INCLUDES both dates
 6.  Inputs may be literal representations of dates, datetime datatypes, numbers that
     represent the number of days since 1/1/1900 00:00:00.000, or anything else that can
     be implicitly converted to or already is a datetime datatype.
 7.  Undocumented: The DATEPART(dw,date) does not actually count weeks... It counts the
     transition to a Sunday regardless of the DATEFIRST setting.  In essence, it counts
     only whole weekends in any given date range.
 8.  This UDF does NOT create a tally table or sequence table to operate.  Not only is
     it set based, it is truly "tableless".

 Revisions:
 Rev 00 - 12/12/2004 - Jeff Moden   - Initial creation and test.
 Rev 01 - 12/12/2004 - Jeff Moden   - Load test, cleanup, document, release.
 Rev 02 - 12/26/2004 - Jeff Moden   - Return NULL if @StartDate is NULL or DEFAULT and
                                      modify to be insensitive to DATEFIRST settings.
 Rev 03 - 01/03/2017 - Luis Cazares - Change the function into an iTVF. Keep the functionality
*/
(
    @StartDate  datetime,
    @EndDate    datetime
)
RETURNS TABLE 
AS
RETURN
    SELECT    --Start with total number of days including weekends
                (DATEDIFF(dd,StartDate,EndDate)+1)

              --Subtact 2 days for each full weekend
               -(DATEDIFF(wk,StartDate,EndDate)*2)

              --If StartDate is a Sunday, Subtract 1
               -(CASE WHEN DATENAME(dw,StartDate) = 'Sunday'
                      THEN 1
                      ELSE 0
                  END)

              --If EndDate is a Saturday, Subtract 1
               -(CASE WHEN DATENAME(dw,EndDate) = 'Saturday'
                      THEN 1
                      ELSE 0
                  END) AS WorkDays
                
             FROM (SELECT DATEADD(dd,DATEDIFF(dd,0,MIN(adate)),0) AS StartDate, DATEADD(dd,DATEDIFF(dd,0,MAX(adate)),0) AS EndDate
                    FROM (VALUES(@StartDate),(@EndDate))x(adate)
                    WHERE @StartDate IS NOT NULL)y
GO
