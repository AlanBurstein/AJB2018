SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[triangleNumber] 
WITH SCHEMABINDING AS 
SELECT N, triangled = CAST(t.N AS BIGINT)*(t.N+1)/2 FROM dbo.tally t;
GO
CREATE UNIQUE CLUSTERED INDEX [cl_uq__dbo_traingelNumber_N] ON [dbo].[triangleNumber] ([N]) ON [PRIMARY]
GO
