IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\RMartinez')
CREATE LOGIN [GRCORP\RMartinez] FROM WINDOWS
GO
CREATE USER [GRCORP\rmartinez] FOR LOGIN [GRCORP\RMartinez] WITH DEFAULT_SCHEMA=[emdbuser]
GO
