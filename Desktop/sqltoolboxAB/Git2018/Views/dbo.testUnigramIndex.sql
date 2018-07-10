SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[testUnigramIndex] WITH SCHEMABINDING AS
SELECT string     = t.string,
       stringId   = t.stringId, 
       itemIndex = N.n-1, 
       item      = SUBSTRING(t.string,N.n-1,1), 
       items     = LEN(LTRIM(RTRIM(t.string)))-LEN(REPLACE(t.string, ' ',''))
FROM dbo.tally N
CROSS JOIN dbo.test t 
WHERE N.n <= LEN(t.string) 
AND (N.n = 1 OR SUBSTRING(t.string,N.n-1,1) = ' ');
GO
CREATE UNIQUE CLUSTERED INDEX [cl_uq__dbo_testUnigramIndex] ON [dbo].[testUnigramIndex] ([stringId], [itemIndex]) ON [PRIMARY]
GO
