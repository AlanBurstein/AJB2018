CREATE TABLE [dbo].[Sample_Table]
(
[Incident] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order_Num] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Shift] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Member] [varchar] (101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Mem_ID] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nc_sample_table] ON [dbo].[Sample_Table] ([Location], [Order_Num]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [cl_sample_table] ON [dbo].[Sample_Table] ([Team_Mem_ID]) ON [PRIMARY]
GO
