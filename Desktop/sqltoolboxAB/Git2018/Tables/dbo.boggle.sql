CREATE TABLE [dbo].[boggle]
(
[RN] [int] NOT NULL,
[seq] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [uq_cl__boggle] ON [dbo].[boggle] ([RN]) ON [PRIMARY]
GO
