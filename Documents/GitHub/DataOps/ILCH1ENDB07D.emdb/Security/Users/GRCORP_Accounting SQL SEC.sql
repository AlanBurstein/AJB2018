IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\Accounting SQL SEC')
CREATE LOGIN [GRCORP\Accounting SQL SEC] FROM WINDOWS
GO
CREATE USER [GRCORP\Accounting SQL SEC] FOR LOGIN [GRCORP\Accounting SQL SEC]
GO