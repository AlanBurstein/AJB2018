IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\pseegers')
CREATE LOGIN [GRCORP\pseegers] FROM WINDOWS
GO
CREATE USER [GRCORP\pseegers] FOR LOGIN [GRCORP\pseegers]
GO
