IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\ORG_Polaris')
CREATE LOGIN [GRCORP\ORG_Polaris] FROM WINDOWS
GO
CREATE USER [GRCORP\ORG_Polaris] FOR LOGIN [GRCORP\ORG_Polaris]
GO
