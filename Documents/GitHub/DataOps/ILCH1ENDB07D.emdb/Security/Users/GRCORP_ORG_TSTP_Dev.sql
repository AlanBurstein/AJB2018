IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\ORG_TSTP_Dev')
CREATE LOGIN [GRCORP\ORG_TSTP_Dev] FROM WINDOWS
GO
CREATE USER [GRCORP\ORG_TSTP_Dev] FOR LOGIN [GRCORP\ORG_TSTP_Dev]
GO