IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\ORG_AlertNote_Prod')
CREATE LOGIN [GRCORP\ORG_AlertNote_Prod] FROM WINDOWS
GO
CREATE USER [GRCORP\ORG_AlertNote_Prod] FOR LOGIN [GRCORP\ORG_AlertNote_Prod]
GO
