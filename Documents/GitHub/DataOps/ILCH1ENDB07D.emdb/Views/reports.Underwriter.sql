SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [reports].[Underwriter]
as
select
 distinct
	_984
from 
emdb.emdbuser.LOANXDB_S_01
 where _984 not in 
 (
'BB&T Underwriter', 
'BB&T Unerwriter', 
'Chase Underwrite', 
'Essent Underwrit', 
'DU',
'G.E.', 
'GE - SUE ALVAREZ', 
'GE Melissa Allen', 
'GE Melissa L. Al', 
'GE PAUL LIETZ GE', 
'GE PAUL LIETZ', 
'GE Underwriter', 
'GE', 
'GE/PNC', 
'GE-OAKBROOK', 
'GE-OFF', 
'GMAC Underwriter', 
'ING Underwriter',
'ING',
'ING UNDERWRITE',
'INVESTOR',
'Lender Live Alli', 
'Lender Live Corr', 
'Lender Live UW', 
'Lender Live UW2', 
'Lender Live', 
'Lender LiveUW 2', 
'Lender LiveUW Al', 
'Lender LiveUW', 
'Lender LiveUW2', 
'LenderLive Under', 
'MGIC Underwriter', 
'MGIC', 
'MGIC-CITIBROKER',
'MetLife Underwri',
'RADIAN DIONNE LE', 
'Radian Underwrit', 
'RADIAN', 
'Radian', 
'RADIAND DIONNE L', 
'RMIC Underwriter', 
'RMIC', 
'UG Corp', 
'UG Underwriter', 
'United Guaranty', 
'US BANK BROKER', 
'US Bank Underwri', 
'US BANK', 
'UW Coordinator', 
'UW Group', 
'WELLS BROKER', 
'WELLS FARGO (BRO', 
'Wells Fargo Unde', 
'Wells Fargo', 
'WELLS'
) 

GO
