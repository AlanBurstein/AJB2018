IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\Secondary Marketing SQL SEC')
CREATE LOGIN [GRCORP\Secondary Marketing SQL SEC] FROM WINDOWS
GO
CREATE USER [GRCORP\Secondary Marketing SQL SEC] FOR LOGIN [GRCORP\Secondary Marketing SQL SEC]
GO
