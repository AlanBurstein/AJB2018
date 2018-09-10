SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dates].[isoWeekCalendarAB]
(
  @pStartDate DATETIME, --Must be between 1751-01-01 (inclusive) and 9999-01-01 (exclusive)
  @pEndDate   DATETIME  --Same as above and must be >= @pStartDate
)
/*****************************************************************************************
Purpose:
 Given a start and end date, create an on-the-fly ISO Week table for the whole years 
 involved as identified by the start and end date. See: https://goo.gl/rs3DVJ
 Important: See "Developer Notes 1." below for limits on dates.

Compatibility: 
 SQL Server 2005+, Azure SQL Database

Syntax:
--===== Autonomous
 SELECT 
   c.WeekStart,
   c.NextWeekStart,
   c.ISOYear,
   c.ISOMonth,
   c.ISOWeek,
   c.ISOWeekString,
   c.ISOWeekAlternate,
   c.ISOWeekOfMonth,
   c.Thursday
 FROM dates.isoWeekCalendarAB(@pStartDate, @pEndDate) c;

Parameters:
 @pStartDate = DATETIME; Must be between 1751-01-01 (inclusive) and 9999-01-01 (exclusive)
 @pEndDate   = DATETIME; Same as above and must be >= @pStartDate

Returns:

 Column Name        DataType Description
 ================== ======== =============================================================
 WeekStart          DATETIME The start date of the ISO Week. Will always be a MONDAY.
 NextWeekStart      DATETIME The start date of the next ISO Week. Will always be a MONDAY.
 ISOYear            SMALLINT The 4 digit year with a range of 1753 thru 9998.
 ISOMonth           TINYINT  1 - 12 Not in the ISO standard but follows the 
                             "Thursday Rule" for the start of the month.
 ISOWeek            TINYINT  1 - 52 for most years. 1 - 53 for "long" or "makeup" years. 
                             Same as intrinsic ISOWK.
 ISOWeekString      CHAR(7)  The "Basic" format of YYYYWww from section 4.1.4.3 of 
                             ISO 8601-1 (2016).
 ISOWeekAlternate   CHAR(8)  The "Extended" format of YYYY-Www from section 4.1.4.3 of 
                             ISO 8601-1 (2016).
 ISOWeekOfMonth     TINYINT  1 - 5 Not in the ISO standard but identifies the week number 
                             with respect to the ISOMonth.
 Thursday           DATETIME Sanity check for testing this function. Has no other 
                             significance.

Developer Notes and Credits:
 1. Requires rangeAB which can be found here: https://goo.gl/fL6beq
 2. The low value for any date must have a year >= 1753 and the high value for any date 
    must have a year <= 9998.
 3. Derived from an original concept created by "t-clausen.dk" at the following link:
    http://stackoverflow.com/questions/7330711/isoweek-in-sql-server-2005
 4. Functionality improved by Peter Larsson and Jeff Moden and explained in full by 
    Jeff Moden at the following link:http://www.sqlservercentral.com/articles/T-SQL/97910/

Usage Examples:
--===== Full DATETIME example
     -- Returns all weeks of whole years from 2010 thru 2019 by ISOWeek.
     -- Note that we only care about the year in each date/time.
     -- Subsecond return of 10 years to "Grid Results" (521 rows for this example)

 SELECT d.*
 FROM dates.isoWeekCalendarAB('2010-04-05 15:35:27.123','2019-06-07 09:25:18.997') d;

--===== Whole year example (years must be in single quotes if a literal).
  -- This particular code also returns the entire possible range of ISO Weeks that this
     function can generate 430,256 rows return to "Grid Results" in ~4-7 seconds.
  --Demonstration of the min and max limits of this function.

 SELECT d.*
 FROM dates.isoWeekCalendarAB('1753','9998') d; 
------------------------------------------------------------------------------------------
 REVISION HISTORY:

 Rev 00 - 20161030 - Jeff Moden
        - Initial creation and unit test to support the following forum post:
          http://www.sqlservercentral.com/Forums/Topic1830292-3412-1.aspx

 Rev 01 - 20180621 - Jeff Moden
        - Added the followng columns:
            ISOMonth         - Not in the ISO standard but follows the "Thursday Rule" for
                               the start of the month.
            ISOWeekString    - The "Basic" format of YYYYWww from section 4.1.4.3 of 
                               ISO 8601-1 (2016)
            ISOWeekAlternate - The "Extended" format of YYYY-Www from section 4.1.4.3 of 
                               ISO 8601-1 (2016)
            ISOWeekOfMonth   - Not in the ISO standard but identifies the week number with
                               respect to the ISOMonth.
        - Added PARAMETERS and RETURN sections to the flower box  
        - Long overdue modifications were made to support the following request:
          https://goo.gl/bCZSvE

 Rev 02 - 20180624 - Alan Burstein - Changed tally table function to range
*****************************************************************************************/
RETURNS TABLE WITH SCHEMABINDING AS RETURN 
WITH 
cteStartEndDates AS
( --=== Find the Monday for the first year involved (might be in the previous year)
     -- and the first Monday after the last year involved (might be in the next year)
 SELECT  
   StartDate = DATEADD(dd,DATEDIFF(dd,0,DATEADD(yy,DATEDIFF(yy, 0,@pStartDate),0))/7*7 ,0),
   EndDate   = DATEADD(dd,DATEDIFF(dd,0,DATEADD(yy,DATEDIFF(yy,-1,@pEndDate  ),0))/7*7+7,0)
),
cteAllDates AS
( --=== Build all the Monday/Thursday dates for the date range identified in the CTE above.
     -- We need the Thursday date to calculate the ISO Year.
 SELECT Monday   = DATEADD(dd,t.RN*7  ,dt.StartDate),
        Thursday = DATEADD(dd,t.RN*7+3,dt.StartDate)
 FROM cteStartEndDates dt
 CROSS APPLY dbo.rangeAB(0,DATEDIFF(dd,dt.StartDate,dt.EndDate)/7,1,0) t
),       
cteISOWeekCalendar AS
( --=== Create the ISO Week Calendar for the years involved by the input parameters and 
     -- some spillover.
 SELECT WeekStart      = ad.Monday,
        NextWeekStart  = DATEADD(dd,7,ad.Monday),
        ISOYear        = DATEPART(yy,ad.Thursday),
        ISOMonth       = DATEPART(mm,ad.Thursday),
        ISOWeek        = (DATEPART(dy,DATEADD(dd,DATEDIFF(
                            dd,'17530101',ad.Monday)/7*7,'17530104'))+6)/7,
        ad.Thursday
   FROM cteAllDates ad
)
--===== Return the ISO Week Calendar for the years involved by the input parameters 
    --without spillover.
 SELECT wc.WeekStart,      --DATETIME
        wc.NextWeekStart,  --DATETIME
        ISOYear          = CONVERT(SMALLINT,wc.ISOYear),
        ISOMonth         = CONVERT(TINYINT,wc.ISOMonth),
        ISOWeek          = CONVERT(TINYINT,wc.ISOWeek),
        ISOWeekString    = CONVERT(CHAR(7),DATENAME(yy,wc.Thursday)+'W'+
                             RIGHT(wc.ISOWeek+100,2)),
        ISOWeekAlternate = CONVERT(CHAR(8),DATENAME(yy,wc.Thursday)+
                             '-W'+RIGHT(wc.ISOWeek+100,2)),
        ISOWeekOfMonth   = CONVERT(TINYINT,(ROW_NUMBER() OVER 
                             (PARTITION BY ISOYear,ISOMonth ORDER BY ISOWeek)-1)%7+1),
        wc.Thursday      -- DATETIME - Sanity check for doubters that want to check the 
                            -- code, and they should!
 FROM cteISOWeekCalendar wc        --Final Filter:
 WHERE wc.ISOYear BETWEEN DATEPART(yy,@pStartDate) AND DATEPART(yy,@pEndDate);
GO
