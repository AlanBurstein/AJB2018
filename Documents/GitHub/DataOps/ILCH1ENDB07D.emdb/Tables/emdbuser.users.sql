CREATE TABLE [emdbuser].[users]
(
[userid] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[password] [varbinary] (255) NULL,
[last_name] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[persona] [int] NULL,
[org_id] [int] NULL,
[working_folder] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lo_license] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[data_services_opt] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_login] [datetime] NULL,
[cell_phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[chumid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nmlsOriginatorID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[enc_version] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nmlsExpirationDate] [datetime] NULL,
[emailSignature] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[employee_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inheritParentCompPlan] [bit] NULL,
[middle_name] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix_name] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstLastName] AS (((([First_Name]+' ')+case  when [middle_name] IS NULL OR [middle_name]='' then '' else [middle_name]+' ' end)+[Last_Name])+case  when [suffix_name] IS NULL OR [suffix_name]='' then '' else ' '+[suffix_name] end),
[UserName] AS (case  when [Last_Name]='' AND [First_Name]='' then '' else ((([Last_Name]+case  when [suffix_name] IS NULL OR [suffix_name]='' then '' else ' '+[suffix_name] end)+', ')+[First_Name])+case  when [middle_name] IS NULL OR [middle_name]='' then '' else ' '+[middle_name] end end)
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[users] ADD CONSTRAINT [PK__users__76CBA758] PRIMARY KEY CLUSTERED  ([userid]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_users_org_id] ON [emdbuser].[users] ([org_id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
