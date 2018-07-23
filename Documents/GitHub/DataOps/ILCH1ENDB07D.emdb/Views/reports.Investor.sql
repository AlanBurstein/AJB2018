SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [reports].[Investor]
as
select
 distinct
	lockrate_2278
from 
emdbuser.LOANXDB_S_09 ls09
 where 
  lockrate_2278 not in  (
 
'Advancial', 
'Astoria Br', 
'Astoria BR', 
'Astoria Broker', 
'Astoria BROKER', 
'Bank of Internet', 
'Bank of Internet - Broker', 
'Bethpage', 
'Citizens Savings Bank', 
'Community National Bank', 
'ESSA Bank & Trust', 
'Flagstar B', 
'Flagstar Bank', 
'Flagstar Bank - Broker', 
'Flagstar Bank BROKER', 
'Flagstar Broker', 
'FLAGSTAR C', 
'FLAGSTAR CORRESPONDENT', 
'Hudson City', 
'Hudson City - Broker', 
'Hudson City- Broker', 
'ING BROKER', 
'Kinecta', 
'Kinecta Federal Credit Union', 
'LiveWell', 
'Patriot National Bank', 
'Penfed', 
'PenFed - Broker', 
'Ridgewood', 
'U.S. Bank Home Mortgage BROKER', 
'Union Bank', 
'Union Bank - Broker', 
'UnionBank', 
'UnionBank ', 
'UnionBank - Broker', 
'US BANk Broker', 
'US Bank Consumer Finance - Broker', 
'WELLS BROKER', 
'Wells Fargo Broker'
) 



GO
