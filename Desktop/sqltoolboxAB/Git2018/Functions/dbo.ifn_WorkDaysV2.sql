SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE FUNCTION [dbo].[ifn_WorkDaysV2]
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
 Rev 00 - 12/12/2004 - Jeff Moden    - Initial creation and test.
 Rev 01 - 12/12/2004 - Jeff Moden    - Load test, cleanup, document, release.
 Rev 02 - 12/26/2004 - Jeff Moden    - Return NULL if @StartDate is NULL or DEFAULT and
                                       modify to be insensitive to DATEFIRST settings.
 Rev 03 - 01/03/2017 - Luis Cazares  - Change the function into an iTVF. Keep the functionality
 Rev 04 - 06/08/2018 - Alan Burstein - 1. Moved NULL parameter filering from subquery "x" to the
                                          WHERE clause to remove a filter from the execution plan.
                                       2. Updated function to return a NULL if either @startDate
                                          OR @enddate are NULL. 
                                       3. Added SCHEMABINDING
*/
(
    @startDate  datetime,
    @endDate    datetime
)
RETURNS TABLE WITH SCHEMABINDING AS RETURN
SELECT workDays = 
    -- If @startDate or @endDate are NULL then rerturn a NULL
  CASE WHEN DATEDIFF(dd, @startDate, @endDate) IS NOT NULL THEN
     (DATEDIFF(dd, startDate, endDate) + 1) --Start with total days including weekends
    -(DATEDIFF(wk, startDate, endDate) * 2) --Subtact 2 days for each full weekend

    -- Subtract 1 when startDate is Sunday and Substract 1 when endDate is Sunday: 
    -(CASE WHEN DATENAME(dw, startDate) = 'Sunday'   THEN 1 ELSE 0 END)
    -(CASE WHEN DATENAME(dw, endDate)   = 'Saturday' THEN 1 ELSE 0 END)
  END
FROM 
(
  SELECT StartDate = DATEADD(dd, DATEDIFF(dd,0,MIN(adate)), 0),
         EndDate   = DATEADD(dd, DATEDIFF(dd,0,MAX(adate)), 0)
  FROM (VALUES(@startDate),(@endDate)) x(adate))y
GO
