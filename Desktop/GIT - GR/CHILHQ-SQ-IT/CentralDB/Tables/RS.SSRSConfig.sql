CREATE TABLE [RS].[SSRSConfig]
(
[ServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InstanceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatabaseServerName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDefaultInstance] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PathName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatabaseName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatabaseLogonAccount] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DatabaseLogonTimeout] [smallint] NULL,
[DatabaseQueryTimeout] [smallint] NULL,
[ConnectionPoolSize] [smallint] NULL,
[IsInitialized] [bit] NULL,
[IsReportManagerEnabled] [bit] NULL,
[IsSharePointIntegrated] [bit] NULL,
[IsWebServiceEnabled] [bit] NULL,
[IsWindowsServiceEnabled] [bit] NULL,
[SecureConnectionLevel] [smallint] NULL,
[SendUsingSMTPServer] [bit] NULL,
[SMTPServer] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SenderEmailAddress] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnattendedExecutionAccount] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WindowsServiceIdentityActual] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAdded] [smalldatetime] NULL,
[RSCID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CI_SSRSConfig] ON [RS].[SSRSConfig] ([ServerName], [InstanceName], [DateAdded], [RSCID]) WITH (FILLFACTOR=85) ON [PRIMARY]
GO
