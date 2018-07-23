IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'GRCORP\Tableau Users')
CREATE LOGIN [GRCORP\Tableau Users] FROM WINDOWS
GO
CREATE USER [GRCORP\Tableau Users] FOR LOGIN [GRCORP\Tableau Users]
GO
