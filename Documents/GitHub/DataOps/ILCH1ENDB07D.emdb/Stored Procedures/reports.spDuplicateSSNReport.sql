SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:			Robert Corro
-- Create date:	10/31/2016
-- Description:	Making Stored Procedure of Select to get Duplicate SSN
-- Change:		4/14/2017 SCM - Replaced the OR,OR,OR with an in list. 14 sec to 3 seconds
-- =============================================
CREATE PROCEDURE [reports].[spDuplicateSSNReport] @SSN VARCHAR(50)
AS
     BEGIN
         SET NOCOUNT ON;
         SELECT s02._364 AS [Loan #],
                s05._4002 AS [Borrower Last Name],
                s01._11 AS [Subject Property Street],
                s02._12 AS [Subject Property City],
                s03._15 AS [Subject Property Zip],
                s04._LOANFOLDER AS [Loan Folder Name],
                s01._317 AS [Loan Officer Name],
                n02._2 AS [Total Loan Amt (w/ MIP/FF)],
                d01._CX_FUNDDATE_1 AS [FUNDED DATE],
                s02._CX_UWINVTOUW AS [Final Investor to underwrite file to],
                s05._4006 AS [Co-Borrower Last Name],
                s02._2574 AS [Underwriter Name],
                s16._cx_mi_drop_01 AS [MI Type],
                n01._353 AS [LTV],
                n02._356 AS [Appraised Value]
         FROM emdbuser.LoanSummary ls WITH (NOLOCK)
              INNER JOIN emdbuser.LOANXDB_S_01 s01 WITH (NOLOCK) ON ls.XRefID = s01.XrefId
              INNER JOIN emdbuser.LOANXDB_S_02 s02 WITH (NOLOCK) ON ls.XRefID = s02.XrefId
              INNER JOIN emdbuser.LOANXDB_S_03 s03 WITH (NOLOCK) ON ls.XRefID = s03.XrefId
              INNER JOIN emdbuser.LOANXDB_S_04 s04 WITH (NOLOCK) ON ls.XRefID = s04.XrefId
              INNER JOIN emdbuser.LOANXDB_S_05 s05 WITH (NOLOCK) ON ls.XRefID = s05.XrefId
              INNER JOIN emdbuser.LOANXDB_S_10 s10 WITH (NOLOCK) ON ls.XRefID = s10.XrefId
              INNER JOIN emdbuser.LOANXDB_S_16 s16 WITH (NOLOCK) ON ls.XRefID = s16.XrefId
              INNER JOIN emdbuser.LOANXDB_D_01 d01 WITH (NOLOCK) ON ls.XRefID = d01.XrefId
              INNER JOIN emdbuser.LOANXDB_N_01 n01 WITH (NOLOCK) ON ls.XRefID = n01.XrefId
              INNER JOIN emdbuser.LOANXDB_N_02 n02 WITH (NOLOCK) ON ls.XRefID = n02.XrefId
         WHERE ls.xrefid IN
         (
             SELECT DISTINCT
                    xrefid
             FROM [emdbuser].[LOANXDB_S_01] s01
             WHERE s01._97 = @SSN
             UNION
             SELECT DISTINCT
                    xrefid
             FROM [emdbuser].[LOANXDB_S_03] s03
             WHERE s03._65 = @SSN
             UNION
             SELECT DISTINCT
                    xrefid
             FROM [emdbuser].[LOANXDB_S_10] s10
             WHERE s10._65_P2 = @SSN
         )
               --All Folders Except Trash
               AND s04._LOANFOLDER <> '(Trash)';
     END;
GO
