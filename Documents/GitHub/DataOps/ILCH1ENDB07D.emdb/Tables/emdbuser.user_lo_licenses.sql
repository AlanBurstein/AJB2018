CREATE TABLE [emdbuser].[user_lo_licenses]
(
[userid] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[enabled] [bit] NOT NULL,
[license] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expirationDate] [datetime] NULL,
[issueDate] [smalldatetime] NULL,
[startDate] [smalldatetime] NULL,
[status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[statusDate] [smalldatetime] NULL,
[lastCheckedDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [emdbuser].[user_lo_licenses] ADD CONSTRAINT [PK_user_lo_licenses] PRIMARY KEY CLUSTERED  ([userid], [state]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_GRI_user_lo_licenses_state_userid_enabled_license] ON [emdbuser].[user_lo_licenses] ([state]) INCLUDE ([enabled], [license], [userid]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
