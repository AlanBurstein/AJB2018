IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\ORG_OAP_PROD')
CREATE LOGIN [GRCORP\ORG_OAP_PROD] FROM WINDOWS
GO
CREATE USER [GRCORP\ORG_OAP_PROD] FOR LOGIN [GRCORP\ORG_OAP_PROD]
GO
